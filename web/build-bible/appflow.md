# App Flow — `appflow.md`

User journeys from arrival to outcome. Each flow lists steps, state transitions, edge cases, and the analytics event fired.

The site has **one main outcome** (sell the book) and **four secondary outcomes** (capture email, route mentorship inquiry, route speaking inquiry, capture course/audiobook waitlist).

## Flow 1 — Cold visitor → newsletter subscriber

**Trigger:** Visitor lands on `/` from Google, Amazon author page, social share, or direct.

```
[Landing page loaded]
        │ → analytics: pageview
        │
        ▼
[Scrolls past hero to author bio]
        │
        ▼
[Sees "Get the newsletter" CTA in footer or inline section]
        │ → analytics: view_newsletter_cta (optional)
        │
        ▼
[Enters email → submits]
        │ → analytics: submit_newsletter
        │ → POST /api/subscribe { email, tag: 'newsletter' }
        │
        ▼
[Kit creates subscriber + sends double-opt-in email]
        │
        ▼
[Form shows "Check your inbox to confirm"]
        │ → analytics: signup_newsletter
        │
        ▼
[Visitor confirms email in Kit]
        │
        ▼
[Kit sends welcome email — written in Aditi's voice]
        │
        ▼
[Subscriber starts receiving Sunday essays]
```

**Edge cases:**
- Email already exists in Kit → API returns success; user sees same confirmation. No duplicate emails sent.
- Network error mid-submit → inline error "Something went wrong. Please try again." Submit button re-enabled. Form values preserved.
- Honeypot field filled (bot) → server returns 200 silently; no Kit call. Form shows success state.
- User on slow 3G → button shows loading state for up to 8s; if no response, timeout error.

---

## Flow 2 — Cold visitor → ebook buyer → reader

The conversion event. This is the path that justifies the entire build.

```
[Landing page loaded]
        │ → analytics: pageview
        │
        ▼
[Visitor reads hero + sees book cover]
        │
        ▼
[Clicks "Buy the book" CTA in hero] ──or── [Scrolls to BuyBox]
        │
        ▼
[BuyBox: format toggle defaults to "Ebook"]
        │ → analytics: view_buybox
        │
        ▼
[Clicks "Buy ebook — $9.99"]
        │ → analytics: click_buy_ebook
        │ → POST /api/checkout { format: 'ebook' }
        │
        ▼
[Server returns Lemon Squeezy hosted checkout URL]
        │ → window.location.href = url
        │
        ▼
[Lemon Squeezy checkout page]
        │   - email field
        │   - card / Apple Pay / Google Pay
        │   - tax calculated by region (MoR)
        │
        ▼
[Buyer completes payment]
        │
        ▼
[Lemon Squeezy redirects buyer to /thank-you?order={id}]
        │ → analytics: purchase_complete (client-side; server side via webhook)
        │
        ▼ (parallel)
[Lemon Squeezy POSTs /api/webhooks/lemonsqueezy]
        │
        ▼
[Webhook handler:
   verifies HMAC,
   confirms order_created + ebook variant,
   mints JWT download token (24h TTL, 3 uses),
   writes to Vercel KV,
   sends Resend email "Your ebook is ready" with signed link,
   adds buyer to Kit with tag 'buyer-ebook',
   returns 200]
        │
        ▼
[Buyer receives email within 60s]
        │
        ▼
[Buyer clicks download link]
        │ → analytics: click_download_link (UTM-tagged)
        │
        ▼
[GET /api/download/[token]]
        │
        ▼
[Server: verify JWT → look up KV → increment uses → stream PDF from Blob]
        │
        ▼
[Browser downloads ebook.pdf]
```

**Edge cases:**

| Case | Behaviour |
|---|---|
| Buyer abandons Lemon Squeezy checkout | No webhook fires. No record. Site is unaware. |
| Buyer pays but webhook fails (network blip) | Lemon Squeezy retries. Idempotency key prevents double-email. |
| Buyer doesn't receive download email | Manual fulfilment: Aditi resends from Lemon Squeezy dashboard or emails attachment directly. |
| Buyer clicks download link after 24h | `410 Gone`. Page shows "This link has expired — contact hello@..." |
| Buyer clicks download link 4th time | `410 Gone`. Page shows "Download limit reached — contact hello@..." |
| Buyer's email goes to spam | Aditi's domain has SPF + DKIM + DMARC set up (Resend onboarding checklist). |
| Buyer pays but ebook file not yet uploaded to Blob | Webhook still sends email; download link returns `500`. **Pre-launch check:** confirm file exists before announcing. |
| Buyer is in a region where the ebook is not allowed (rare) | Lemon Squeezy blocks at checkout. Not our concern. |
| Webhook signature verification fails | Return 401. Log + Sentry alert. No token minted. |

---

## Flow 3 — Cold visitor → paperback buyer (via Amazon)

v1 routes paperback to Amazon. Simpler, no fulfilment.

```
[Landing page → BuyBox]
        │
        ▼
[Buyer toggles to "Paperback"]
        │ → analytics: view_buybox_paperback
        │
        ▼
[Clicks "Buy on Amazon — $19.99"]
        │ → analytics: click_buy_amazon_paperback (outbound)
        │
        ▼
[New tab opens → Amazon product page]
        │
        ▼
[Buyer purchases on Amazon]
        │
        ▼ (we are blind to this)
[Aditi receives KDP royalty 60 days later]
```

**Edge cases:** None we control. Amazon handles it all. We just track the click.

---

## Flow 4 — Visitor → sample chapter → conversion

```
[Visitor lands on /]
        │
        ▼
[Clicks "Read a chapter" in hero]
        │ → analytics: click_read_sample
        │
        ▼
[/sample page loads]
        │ → analytics: pageview /sample
        │   - sticky "Buy the book" CTA visible at top + bottom
        │
        ▼
[Visitor reads chapter (~5 min average)]
        │ → analytics: time_on_page (Plausible duration)
        │
        ▼
[Reaches end → ChapterEndCTA visible]
        │   Two options shown:
        │     A) "Get the full book" → BuyBox / Lemon Squeezy checkout
        │     B) "Get the next chapter free" → email opt-in (lead magnet)
        │
        ├─── Branch A: clicks "Get the full book"
        │           │
        │           ▼
        │     [Goes to BuyBox] → Flow 2 from there
        │
        └─── Branch B: enters email for next chapter
                    │ → analytics: submit_lead_magnet_sample
                    │ → POST /api/subscribe { email, tag: 'lead-magnet-sample' }
                    │
                    ▼
              [Kit sends auto-email with next chapter PDF + book CTA]
                    │
                    ▼
              [Subscriber enters newsletter sequence]
```

**Edge cases:**
- User opens `/sample` directly from search → flow starts at the read step; both CTAs work identically.
- User scrolls fast / bounces → no signal except pageview. That's fine.

---

## Flow 5 — Visitor → mentorship inquiry

```
[Visitor lands on /]
        │
        ▼
[Clicks "Mentorship" in OfferGrid or nav]
        │
        ▼
[/mentorship page: offer description + inquiry form]
        │ → analytics: pageview /mentorship
        │
        ▼
[Visitor reads, decides to inquire]
        │
        ▼
[Fills form: name, email, phone?, "What brings you here?"]
        │ → submits
        │ → analytics: submit_mentorship_inquiry
        │ → POST /api/inquiry { type: 'mentorship', ... }
        │
        ▼
[Server:
   sends Resend email to Aditi (InquiryReceived template),
   sends Resend ack email to inquirer (InquiryAck template),
   adds inquirer to Kit with tag 'inquiry-mentorship']
        │
        ▼
[Form replaced with "Thanks. Aditi will be in touch within 48 hours."]
        │
        ▼ (out of band)
[Aditi reads inquiry → emails / calls to schedule discovery call]
```

**Edge cases:**
- Aditi misses the email → it's also in Kit tagged for follow-up.
- Inquirer submits twice → both emails arrive; Kit dedupes by email. Aditi handles.
- Spam submission (bot) → honeypot catches most; rate limit catches the rest.

---

## Flow 6 — Visitor → speaking / event / retreat / podcast inquiry

Same as Flow 5, with a different page (`/speaking`) and a `type` dropdown that sets the Kit tag and email subject.

```
[Visitor → /speaking]
        │
        ▼
[Form: type (dropdown), name, email, organisation, date, budget?, message]
        │ → submits
        │ → POST /api/inquiry { type: 'speaking' | 'workshop' | 'retreat' | 'podcast', ... }
        │
        ▼
[Aditi receives tagged email; inquirer gets tagged ack + Kit tag]
```

---

## Flow 7 — Visitor → course waitlist

```
[Visitor → /courses (or sees "Course coming soon" card on /)]
        │ → analytics: pageview /courses
        │
        ▼
[Reads teaser copy]
        │
        ▼
[Enters email → submits]
        │ → analytics: signup_course_waitlist
        │ → POST /api/subscribe { email, tag: 'course-waitlist' }
        │
        ▼
[Kit tags + double opt-in (kept on for marketing list)]
        │
        ▼
[Subscriber receives newsletter + course launch announcement when ready]
```

---

## Flow 8 — Visitor → audiobook waitlist

Identical to Flow 7 with tag `audiobook-waitlist`.

---

## Flow 9 — Returning subscriber → blog → re-engage

```
[Subscriber receives Sunday newsletter with link to new blog post]
        │
        ▼
[Clicks link → /blog/[slug]]
        │ → analytics: pageview /blog/[slug]
        │
        ▼
[Reads post]
        │
        ▼
[End-of-post CTA: usually book purchase or course waitlist or mentorship]
        │
        ▼
[Re-enters one of the above flows depending on CTA]
```

---

## State machine reference

The site is largely stateless on the client. The few stateful interactions:

### Form (NewsletterCTA / InquiryForm / WaitlistForm)

```
        ┌─────────┐
        │  idle   │
        └────┬────┘
             │ user submits
             ▼
        ┌─────────┐         400/500
        │ loading │ ─────────────────────┐
        └────┬────┘                      │
             │ 200                       │
             ▼                           ▼
        ┌─────────┐                 ┌─────────┐
        │ success │                 │  error  │
        └─────────┘                 └────┬────┘
                                         │ user fixes + resubmits
                                         ▼
                                    (back to loading)
```

- `idle`: form visible, fields editable.
- `loading`: button shows spinner, `aria-busy="true"`, fields disabled.
- `success`: form replaced with confirmation paragraph; focus moves to confirmation.
- `error`: inline error message, fields editable, submit re-enabled.

### BuyBox FormatToggle

```
    ┌──────┐    user taps    ┌────────────┐    user taps    ┌──────────────┐
    │ EBOOK│ ◄────────────► │  PAPERBACK │ ◄────────────► │   AUDIOBOOK  │
    │ CTA: │                 │ CTA: open  │                 │ CTA: open    │
    │ buy  │                 │ Amazon link│                 │ waitlist form│
    └──────┘                 └────────────┘                 └──────────────┘
```

Toggle is a `radiogroup`. Arrow keys cycle. Selected state is local React state — no URL param, no persistence.

### Download token lifecycle (server)

```
[token minted by webhook]
   uses=0, exp=now+24h
        │
        ▼
[first GET /api/download/[token]]
   → INCR uses → 1 → 200 + stream file
        │
        ▼
[second GET]
   → INCR uses → 2 → 200 + stream file
        │
        ▼
[third GET]
   → INCR uses → 3 → 200 + stream file
        │
        ▼
[fourth GET]
   → INCR uses → 4 → exceeds max → 410 Gone
        │
        ▼
[at exp]
   → KV record expires (Upstash TTL)
        │
        ▼
[any further GET → 404 (token not found) → friendly message]
```

---

## Failure modes & user-visible behaviour

| Failure | What the user sees | What Aditi sees |
|---|---|---|
| Lemon Squeezy down | Checkout button still works — Lemon Squeezy page handles its own downtime | Lemon Squeezy status page; webhook retries when back |
| Kit API down | Form still shows success (we don't block user on Kit) | Server error log; manually retry subscriber sync next day |
| Resend down | Form still shows success; webhook returns 200 but email queued internally | Sentry alert; Aditi manually emails buyer |
| Vercel KV down | Webhook can't mint token → 500 → Lemon Squeezy retries | Sentry alert; rare event |
| Vercel Blob down | Download endpoint returns 503 with retry message | Sentry alert |
| DNS issue | Site unreachable | Vercel + domain registrar status; rollback to `*.vercel.app` URL |

---

## Out of scope flows (v1)

- **Refunds**: handled in Lemon Squeezy dashboard manually. No `/api/refund` endpoint.
- **Account login**: no user accounts.
- **Re-download from account page**: user must email Aditi if links expired.
- **Switching formats post-purchase**: not supported. New purchase required.
- **Gift purchases**: not supported. Buyer must use buyer's email.
- **Bulk orders**: handled via `/speaking` inquiry (type: workshop) for now.
