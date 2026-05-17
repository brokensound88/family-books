# Backend Structure — `backend.md`

The site is mostly static. The backend exists for four jobs:

1. **Create checkout URLs** for Lemon Squeezy.
2. **Receive purchase webhooks** and deliver downloads.
3. **Capture leads** (newsletter, waitlists, inquiries) into Kit and Resend.
4. **Stream ebook files** behind a signed, expiring, use-capped token.

No database in v1. No user auth. State lives in Vercel KV (download tokens + use counts).

## API surface

All routes live under `/web/app/api/`. Method + body shapes:

| Route | Method | Auth | Purpose |
|---|---|---|---|
| `/api/checkout` | POST | none (rate-limited) | Returns a Lemon Squeezy hosted-checkout URL for the requested format. |
| `/api/webhooks/lemonsqueezy` | POST | HMAC sig | Mints download token, stores in KV, emails buyer via Resend. |
| `/api/download/[token]` | GET | token | Streams ebook from Vercel Blob; enforces TTL + use cap. |
| `/api/subscribe` | POST | none (rate-limited) | Adds email to Kit form with specified tag. |
| `/api/inquiry` | POST | none (rate-limited) | Emails Aditi via Resend + tags lead in Kit. |

## Webhook flow (the critical path)

```
 Buyer clicks "Buy ebook" on /
        │
        ▼
 Client POSTs /api/checkout { format: 'ebook' }
        │
        ▼
 Server builds Lemon Squeezy checkout URL using:
   - LEMONSQUEEZY_STORE_ID
   - LEMONSQUEEZY_EBOOK_VARIANT_ID
   - checkout_data.email (prefill if known)
   - checkout_data.custom = { source: 'site' }
        │
        ▼
 Server returns { url } → client window.location = url
        │
        ▼
 Buyer pays on Lemon Squeezy hosted checkout
        │
        ▼
 Lemon Squeezy fires POST /api/webhooks/lemonsqueezy
   with X-Signature header (HMAC SHA256)
        │
        ▼
 Server:
   1. Verifies HMAC against LEMONSQUEEZY_WEBHOOK_SECRET
   2. Checks event_name === 'order_created'
   3. Confirms order contains ebook variant
   4. Mints JWT token: { orderId, email, exp: now + 24h, maxUses: 3 }
   5. Stores in Vercel KV:
        key:   `dl:${tokenId}`
        value: { uses: 0, max: 3, exp: 24h-from-now, orderId, email }
        ttl:   24h
   6. Sends Resend email (DownloadReady.tsx) with:
        link = `https://{domain}/api/download/${signedToken}`
        expiresAt = ISO timestamp
   7. (parallel) Adds buyer to Kit with tag `buyer-ebook`
   8. Returns 200 OK to Lemon Squeezy
        │
        ▼
 Buyer clicks the link in their email
        │
        ▼
 GET /api/download/[token]
   1. Verify JWT signature + expiry
   2. Look up tokenId in KV
   3. If uses >= 3 → 410 Gone
   4. Increment uses (atomic)
   5. Stream ebook PDF from Vercel Blob with:
        Content-Type: application/pdf
        Content-Disposition: attachment; filename="..."
   6. Log purchase event (Plausible server-side event optional)
```

### Idempotency

Lemon Squeezy retries webhooks on non-2xx responses. The handler must be safe to receive the same event multiple times:

- Use the event's `meta.event_id` (or `data.id` for orders) as an idempotency key.
- Before minting a new token, check `idem:${event_id}` in KV.
- If exists → return 200 immediately (already processed).
- If new → mint, store, set `idem:${event_id}` with 7-day TTL, return 200.

This prevents double-emailing buyers if the webhook is re-fired.

### Signature verification

Lemon Squeezy signs webhooks with HMAC-SHA256:

```ts
import crypto from 'node:crypto'

function verifyLemonSqueezySignature(rawBody: string, signature: string, secret: string) {
  const expected = crypto.createHmac('sha256', secret).update(rawBody).digest('hex')
  return crypto.timingSafeEqual(Buffer.from(expected), Buffer.from(signature))
}
```

Important: read the **raw** request body before parsing JSON. Next.js App Router gives you `await req.text()` for this.

## `/api/checkout` contract

**Request:**
```ts
POST /api/checkout
Content-Type: application/json
{
  "format": "ebook",                  // only "ebook" supported in v1 (paperback bypasses to Amazon)
  "email"?: "user@example.com"        // optional prefill
}
```

**Response (200):**
```ts
{ "url": "https://aditikumar.lemonsqueezy.com/checkout/buy/..." }
```

**Errors:** `400` invalid body, `429` rate-limited, `500` Lemon Squeezy API failure (logged to Sentry).

## `/api/subscribe` contract

**Request:**
```ts
POST /api/subscribe
{
  "email": "user@example.com",
  "tag": "newsletter" | "course-waitlist" | "audiobook-waitlist" | "lead-magnet-sample" | ...,
  "honeypot"?: ""                     // if non-empty, return 200 silently (bot)
}
```

**Response:** `200 { ok: true }` (always — even on honeypot trip, to not leak bot detection).

**Behaviour:** Calls Kit API to subscribe email to `KIT_FORM_ID_NEWSLETTER` + applies the supplied tag (must be one of the constants in `lib/tags.ts`). Validates tag against allowlist; unknown tags rejected.

## `/api/inquiry` contract

**Request:**
```ts
POST /api/inquiry
{
  "type": "mentorship" | "speaking" | "workshop" | "retreat" | "podcast",
  "name": string,
  "email": string,
  "message": string,
  "organisation"?: string,            // speaking variants only
  "timeframe"?: string,                // speaking variants only
  "budget"?: string,                   // speaking variants only
  "honeypot"?: ""
}
```

**Response:** `200 { ok: true }`.

**Behaviour:**
1. Validate body with zod schema (per-type).
2. Send Resend email to `INQUIRY_NOTIFICATION_EMAIL` using `InquiryReceived.tsx` template.
3. Send Resend acknowledgement email to inquirer using `InquiryAck.tsx`.
4. Add subscriber to Kit with tag `inquiry-{type}`.
5. Return 200.

## `/api/download/[token]` contract

**Request:**
```
GET /api/download/eyJhbGciOi...
```

**Response:**
- `200` + binary stream + `Content-Disposition: attachment` if valid.
- `401` if signature invalid.
- `410 Gone` if expired or use cap reached.
- `404` if token not found in KV.

**Headers:**
```
Content-Type: application/pdf  (or application/epub+zip)
Content-Disposition: attachment; filename="art-of-doing-less.pdf"
Cache-Control: no-store
```

## Token design

JWT signed with `DOWNLOAD_TOKEN_SECRET` using HS256:

```ts
{
  "tid": "ord_abc123_pdf",   // tokenId (unique per order × format)
  "ord": "ord_abc123",        // Lemon Squeezy order ID
  "fmt": "pdf",                // file format
  "iat": 1715900000,
  "exp": 1715986400            // iat + 24h
}
```

KV record (TTL = 24h):
```ts
{
  key: "dl:ord_abc123_pdf",
  value: {
    uses: 0,
    max: 3,
    email: "buyer@example.com",
    orderId: "ord_abc123",
    issuedAt: 1715900000,
    expiresAt: 1715986400
  }
}
```

Atomic increment uses Upstash `INCR` to avoid races on rapid re-downloads.

## Rate limiting (`middleware.ts`)

Upstash ratelimit, fixed window per IP:

| Route prefix | Limit |
|---|---|
| `/api/subscribe` | 5 / minute |
| `/api/inquiry` | 5 / minute |
| `/api/checkout` | 10 / minute |
| `/api/download` | 30 / minute (high to allow chunked download retries) |
| `/api/webhooks/*` | **excluded** (verified by HMAC instead) |

Exceeded → `429` + `Retry-After` header.

## Secrets matrix

| Variable | Where | Notes |
|---|---|---|
| `LEMONSQUEEZY_API_KEY` | Server only | Bearer token; rotate quarterly |
| `LEMONSQUEEZY_STORE_ID` | Server only | numeric |
| `LEMONSQUEEZY_WEBHOOK_SECRET` | Server only | Set at webhook creation |
| `LEMONSQUEEZY_EBOOK_VARIANT_ID` | Server only | per-product |
| `NEXT_PUBLIC_LEMONSQUEEZY_STORE_SLUG` | Client OK | URL builder |
| `KIT_API_KEY` | Server only | |
| `KIT_API_SECRET` | Server only | tagging |
| `KIT_FORM_ID_*` | Server only | numeric form IDs |
| `RESEND_API_KEY` | Server only | |
| `RESEND_FROM` | Server only | verified sender |
| `INQUIRY_NOTIFICATION_EMAIL` | Server only | Aditi's inbox |
| `DOWNLOAD_TOKEN_SECRET` | Server only | min 32 random bytes |
| `KV_*` | Server only | injected by Vercel KV integration |
| `BLOB_READ_WRITE_TOKEN` | Server only | injected by Vercel Blob |
| `NEXT_PUBLIC_PLAUSIBLE_DOMAIN` | Client OK | |
| `SENTRY_DSN` | Both | client + server |
| `UPSTASH_REDIS_REST_URL` | Server only | for ratelimit (often same as KV) |
| `UPSTASH_REDIS_REST_TOKEN` | Server only | |

All loaded via `lib/env.ts` (zod-validated). Missing required vars = boot failure.

## Logging

- All API routes log structured JSON: `{ route, status, duration_ms, request_id }`.
- Errors include `error.message` + `error.stack` (truncated).
- No PII in logs (no email addresses, no message bodies).
- Vercel collects automatically. Sentry captures unhandled exceptions if enabled.
- Webhook failures: log `event_id`, signature-verification result, and final status code.

## Error handling rules

- **Webhooks**: never throw to Lemon Squeezy. Catch, log, return 500 only if retrying could help; otherwise 200 + alert.
- **Outbound APIs (Kit, Resend, Lemon Squeezy)**: implement single retry with exponential backoff (250ms, 1s).
- **Email send failure on download delivery**: log + alert; do **not** fail the webhook. The buyer can be manually emailed.
- **Validation failures**: return 400 with `{ error: "field error" }`. No stack traces in responses.
- **Rate-limit hits**: 429 with `Retry-After`. No body.

## Manual fulfilment fallback

If the webhook chain fails for any reason, Aditi must be able to manually deliver:

1. Lemon Squeezy dashboard shows the order + email.
2. Aditi clicks "Download Link" in a small admin page at `/admin/fulfil?orderId=...` (deferred to v1.5).
3. **v1 fallback**: Aditi emails the buyer the ebook directly as an attachment. Crude, but unblocks day-one.

Document this in the launch runbook.

## Performance targets

| Endpoint | p95 |
|---|---:|
| `/api/checkout` | < 600ms |
| `/api/subscribe` | < 600ms |
| `/api/inquiry` | < 1s (two API calls) |
| `/api/webhooks/lemonsqueezy` | < 1s |
| `/api/download/[token]` (TTFB) | < 400ms |

## What we're NOT building in the backend (v1)

- User accounts / login
- Cart with multiple items
- Refund processing (handled in Lemon Squeezy dashboard manually)
- Affiliate tracking
- Discount codes (Lemon Squeezy supports natively if needed — no code change required)
- Tax calculation (Lemon Squeezy is MoR — handled)
- Customer support inbox / ticketing (use Aditi's email)
- Admin dashboard
- Audit log
- Background job queue
- Webhook to external CRM beyond Kit

## Future-proofing notes

- All Kit calls go through `lib/kit.ts`. To swap ESP later, change one file.
- All Lemon Squeezy calls go through `lib/lemonsqueezy.ts`. To migrate to Stripe direct in v2, change one file (and webhook signature verification).
- Token design is provider-agnostic — works if delivery moves off Vercel Blob to S3/R2.
- KV usage is shallow — easy to swap to a real DB (Supabase) when needed.
