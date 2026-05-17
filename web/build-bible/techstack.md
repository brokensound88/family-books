# Tech Stack — `techstack.md`

The stack is locked. Changes mid-build require updating this file first.

## Locked stack

| Layer | Choice | Version | Why this, not the alternative |
|---|---|---|---|
| **Framework** | Next.js (App Router) | 15.x | Extends naturally to courses/community later; great SEO via SSG + selective ISR; MDX-native blog; mature serverless integration on Vercel. **Rejected:** Astro (would need migration when courses launch); SvelteKit (smaller ecosystem for the integrations we need). |
| **Language** | TypeScript | 5.x | Type safety on payment/webhook code is non-negotiable. |
| **Runtime** | Node | 20.x LTS | Vercel default; matches local dev. |
| **Package manager** | pnpm | 9.x | Faster installs, strict dep resolution, smaller node_modules. |
| **Styling** | Tailwind CSS | v4 | Mobile-first defaults; zero-runtime; pairs with shadcn. **Rejected:** CSS-in-JS (slower); CSS modules (verbose for v1 speed). |
| **UI primitives** | shadcn/ui | latest | Owned-source components on Radix primitives; no runtime UI library lock-in. **Rejected:** Chakra/MUI (heavier, opinionated theming). |
| **Icons** | lucide-react | latest | shadcn-friendly; tree-shakeable. |
| **Fonts** | next/font (self-hosted Google) | — | Zero CLS; no third-party request. Choices in `frontend.md`. |
| **Blog content** | MDX in repo | via `@next/mdx` | Zero infra. **Rejected:** Sanity / Contentful for v1 (defer to v1.5 if Aditi posts weekly). |
| **Forms (client)** | Native HTML + React Server Actions | — | No need for react-hook-form / zod-form-data in v1; payloads are tiny. |
| **Validation** | zod | 3.x | Validates API request bodies + env vars. |
| **Payments** | Lemon Squeezy | API v1 | Merchant of Record — handles VAT/GST/sales tax globally. ~5% + 50c. Apple Pay & Google Pay supported. **Rejected:** Stripe direct (Aditi would need to register/remit tax in dozens of jurisdictions — part-time accounting job). Stripe stays available for migration in v2 if volume justifies. |
| **Email — marketing** | Kit (ConvertKit) | API v3 | Built for authors; free <10k subs; sequences, broadcasts, tags. Imports Stan Store CSV. **Rejected:** Mailchimp (less author-friendly); Substack (locks content). |
| **Email — transactional** | Resend + react-email | latest | Modern API; react-email templates type-safe. Used for download links, inquiry confirmations, receipt fallback. **Rejected:** SendGrid/Postmark (overkill for v1 volume). |
| **File storage** | Vercel Blob | — | Native to deployment; signed URLs supported. **Rejected:** S3/R2 (extra account, extra IAM). Re-evaluate at v1.5 if storage costs grow. |
| **Key-value store** | Vercel KV (Upstash Redis) | — | Stores download tokens + use counts. Free tier sufficient for v1. |
| **Rate limiting** | `@upstash/ratelimit` | latest | Pairs with Vercel KV; one-line middleware. |
| **Auth (token signing)** | `jose` | latest | JWT for download tokens. No user auth in v1. |
| **Hosting** | Vercel | — | First-party for Next.js; Edge + serverless; built-in preview deploys per PR; project root = `/web`. **Rejected:** Cloudflare Pages (less Next.js parity in v1 timeframe). |
| **DNS** | Cloudflare (recommended) or Vercel-managed | — | Fast propagation; free. |
| **Analytics** | Plausible (cloud) | — | Privacy-first, no cookies, no consent banner needed. ~$9/mo. **Rejected:** GA4 (cookie banner friction + heavier script). |
| **Error monitoring** | Sentry (free tier) | latest | Optional for v1; nice-to-have. Enable if time permits. |
| **Legal pages** | Termly (generator) | — | $0–10/mo. Generates Privacy / Terms / Refund tailored to AU + global. |
| **Image optimisation** | next/image | built-in | Vercel-native; AVIF/WebP; lazy-load default. |
| **OG images** | `@vercel/og` | built-in | Edge function generates per-page OG images at request time. |
| **CI** | GitHub Actions (lint + typecheck) | — | One workflow: `pnpm install && pnpm lint && pnpm typecheck && pnpm build`. |
| **Code quality** | ESLint (Next config) + Prettier | latest | Defaults, no custom rules in v1. |
| **Testing** | Playwright (smoke test only) | latest | One test: hits `/api/checkout` and verifies a Lemon Squeezy URL is returned. **Skipped:** Unit tests (not enough surface area to justify v1 cost). |

## Stack diagram

```
                         ┌─────────────────────────────────┐
   Visitor (mobile) ─►   │  Vercel Edge (Next.js 15)        │
                         │   • Static pages (SSG)           │
                         │   • Sample chapter (MDX)         │
                         │   • Blog (MDX)                   │
                         │   • API routes (Node)            │
                         └────────┬─────────────────────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        │                         │                         │
        ▼                         ▼                         ▼
  ┌───────────┐           ┌────────────┐            ┌──────────────┐
  │ Lemon     │           │ Kit (ESP)  │            │ Resend       │
  │ Squeezy   │           │            │            │ (transac)    │
  │           │           │ • forms    │            │ • download   │
  │ • hosted  │           │ • sequence │            │ • inquiry    │
  │   checkout│           │ • tags     │            │   notify     │
  │ • webhook │           └────────────┘            └──────────────┘
  └─────┬─────┘
        │ webhook (HMAC verified)
        ▼
  ┌───────────┐           ┌────────────┐
  │ Vercel    │  read     │ Vercel     │
  │ KV (Redis)│ ◄──────── │ Blob       │
  │  • tokens │           │ • ebook.pdf│
  │  • counts │           └────────────┘
  └───────────┘
```

## Integration credentials checklist

These all need to exist in `.env.local` (dev) and Vercel project env vars (prod) before launch. Public vars are prefixed `NEXT_PUBLIC_`.

### Lemon Squeezy
- `LEMONSQUEEZY_API_KEY` — server-only, from dashboard → Settings → API
- `LEMONSQUEEZY_STORE_ID` — numeric, from store URL
- `LEMONSQUEEZY_WEBHOOK_SECRET` — set when creating the webhook
- `LEMONSQUEEZY_EBOOK_VARIANT_ID` — variant ID of the ebook product
- `NEXT_PUBLIC_LEMONSQUEEZY_STORE_SLUG` — used to build hosted checkout URLs

### Kit (ConvertKit)
- `KIT_API_KEY` — server-only
- `KIT_API_SECRET` — server-only, needed for tagging
- `KIT_FORM_ID_NEWSLETTER` — main newsletter form
- `KIT_FORM_ID_LEAD_MAGNET` — 7-day mini-course (created in v1.5; placeholder in v1)
- `KIT_TAG_*` — string tags applied per signup source (see `backend.md`)

### Resend
- `RESEND_API_KEY` — server-only
- `RESEND_FROM` — verified sender, e.g. `hello@aditikumar.com`
- `INQUIRY_NOTIFICATION_EMAIL` — Aditi's inbox

### Vercel KV
- `KV_URL`, `KV_REST_API_URL`, `KV_REST_API_TOKEN`, `KV_REST_API_READ_ONLY_TOKEN` — auto-injected by Vercel KV integration

### Vercel Blob
- `BLOB_READ_WRITE_TOKEN` — auto-injected

### Download tokens
- `DOWNLOAD_TOKEN_SECRET` — random 32+ byte string for JWT signing
- `DOWNLOAD_TTL_HOURS` — default `24`
- `DOWNLOAD_MAX_USES` — default `3`

### Plausible
- `NEXT_PUBLIC_PLAUSIBLE_DOMAIN` — e.g. `aditikumar.com`

### Sentry (optional)
- `SENTRY_DSN`, `SENTRY_AUTH_TOKEN`

## Local dev setup

```bash
# from /web
pnpm install
cp .env.local.example .env.local      # then fill in values
pnpm dev                                # http://localhost:3000

# common scripts
pnpm lint
pnpm typecheck
pnpm build
pnpm test                               # Playwright smoke
```

Node 20 LTS. pnpm 9. If you don't have pnpm: `npm i -g pnpm`.

## Build & deploy pipeline

- **Preview**: every push to a non-main branch deploys a Vercel preview URL.
- **Production**: pushes to `main` deploy to production (after the bible-only PR is merged in, future work goes through PRs).
- **Project root**: set Vercel "Root Directory" to `web/`.
- **Build command**: `pnpm build` (Vercel auto-detects).
- **Install command**: `pnpm install --frozen-lockfile`.
- **Output**: `.next` (Vercel default).
- **Cron / scheduled functions**: none in v1.

## Things explicitly NOT in the stack (and won't be added in v1)

- Redux / Zustand / Jotai (no client state need)
- Framer Motion / GSAP (no animation requirement)
- react-hook-form (native forms are fine)
- Prisma / Drizzle (no DB in v1)
- Auth.js / Clerk (no user accounts in v1)
- Storybook
- Jest / Vitest unit tests
- A monorepo tool (Turborepo / Nx) — `/web` is the only project
- A linter beyond `next lint` defaults
- Husky / lint-staged (CI handles it)

## Migration paths (for future reference)

| When | What changes |
|---|---|
| Volume justifies it (~$10k+ direct sales / mo) | Migrate from Lemon Squeezy MoR to Stripe direct + accountant for tax. |
| Aditi posts >2/week | MDX → Sanity headless CMS; add `/web/cms/` adapter layer. |
| Audiobook ships | Add audio player component + Vercel Blob audio hosting + sample MP3. |
| Paperback POD goes direct | Add Lulu Direct API integration; replace Amazon link in BuyBox. |
| Course platform launches | Add Kajabi / Podia embed OR build native via Mux + Lemon Squeezy subscriptions. |
| Community launches | Lemon Squeezy subscription product + Circle.so / Geneva integration via webhook. |

Each migration touches isolated surface area — designed in.
