# Project Requirements — `projectrequirements.md`

This is the contract. If something isn't in here, it isn't in v1.

## Functional requirements

Grouped by page/feature. Each FR has an ID, a description, and acceptance criteria (AC).

### Global / layout

**FR-G01 — Site shell**
- Persistent header (logo, nav: About · Sample · Blog · Work With Me, "Buy the Book" CTA)
- Persistent footer (copyright, social links, legal links, newsletter mini-form)
- All pages have unique `<title>`, meta description, canonical URL, OG/Twitter cards
- **AC:** Each page passes `pnpm next build` with no metadata warnings; OG preview validates on opengraph.xyz.

**FR-G02 — Mobile-first responsive**
- Base styles target 375px viewport; scale up to 768 / 1024 / 1440 breakpoints
- No horizontal scroll at any breakpoint
- Touch targets ≥ 44×44 px
- **AC:** Lighthouse mobile ≥ 95 on Performance, Accessibility, Best Practices, SEO.

**FR-G03 — Accessibility (WCAG 2.1 AA)**
- Color contrast ≥ 4.5:1 for body text
- All images have `alt`; decorative images use `alt=""`
- Keyboard navigation reaches every interactive element in logical order
- Visible focus rings (use Tailwind `focus-visible:` defaults)
- Forms have explicit labels (not placeholder-only)
- **AC:** axe-core CLI clean on every page; manual keyboard pass on `/` and `/sample`.

**FR-G04 — SEO**
- `sitemap.xml` auto-generated at build
- `robots.txt` allows all (except `/api/*`)
- Structured data: `Book` schema on `/`, `Person` schema on `/about`, `Article` on each blog post
- **AC:** Google Rich Results Test passes for `/` and one blog post.

**FR-G05 — Analytics**
- Plausible script loaded (privacy-first, no cookie banner)
- Custom events listed in `businessplan.md` fire on the expected actions
- **AC:** Each event visible in Plausible dashboard after manual test.

**FR-G06 — Legal pages**
- `/privacy`, `/terms`, `/refund` exist with Termly-generated content tailored to AU + global
- Linked from footer
- **AC:** All three links resolve; content is not Lorem Ipsum.

### Landing page (`/`)

**FR-L01 — Hero section**
- Book cover image (responsive, lazy-loaded below the fold, eager for hero)
- H1 with book title; H2 with sub-headline (positioning line)
- Primary CTA: "Buy the Book" → scrolls to BuyBox
- Secondary CTA: "Read a Chapter" → `/sample`
- Author byline ("by Aditi Kumar")
- **AC:** Renders correctly with book cover from `/web/content/book.ts`; CTAs functional.

**FR-L02 — Buy box**
- Format toggle: Ebook / Paperback / Audiobook
- Ebook → Lemon Squeezy hosted checkout (price from `book.ts`)
- Paperback → Amazon URL (from `book.ts`)
- Audiobook → "Coming Soon — join waitlist" form (Kit, tag `audiobook-waitlist`)
- Price displayed for each format
- One-line trust statement ("Secure checkout · Instant download · Apple Pay & Google Pay")
- **AC:** Each format's CTA routes to the correct destination; price matches `book.ts`.

**FR-L03 — Social proof strip**
- 3 testimonials (placeholder names + quotes acceptable for v1; replace pre-launch)
- Amazon star rating + review count if available
- **AC:** Renders 3 cards on mobile (vertical) and desktop (horizontal).

**FR-L04 — Author bio strip**
- Headshot + 2-3 paragraph bio
- "More about Aditi →" link to `/about`
- **AC:** Photo loads optimised (next/image, AVIF/WebP).

**FR-L05 — "Work with me" overview**
- 4 cards: Mentorship · Courses (waitlist) · Speaking · Retreats
- Each card → respective page
- **AC:** All four links resolve.

**FR-L06 — Newsletter CTA**
- Email field + submit
- On submit → POST `/api/subscribe` → Kit form
- Success state: "Check your inbox to confirm"
- Error state: inline error message
- Honeypot field for spam protection
- **AC:** Real submission creates a Kit subscriber tagged `newsletter`.

### Sample chapter (`/sample`)

**FR-S01 — Sample chapter content**
- MDX rendering of one chapter
- Typography optimised for reading (max-width ~65ch, 18px base, 1.6 line-height)
- Sticky "Buy the Book" CTA at top + bottom of page
- **AC:** Page renders without layout shift; reading at 375px is comfortable.

**FR-S02 — End-of-chapter conversion block**
- "Liked this? Get the full book." → BuyBox (anchor or duplicate)
- "Or get the next chapter free →" → email opt-in (lead magnet tag in Kit)
- **AC:** Email opt-in tags subscriber `lead-magnet-sample`.

### About (`/about`)

**FR-A01 — Author bio**
- Long-form bio (5–10 paragraphs)
- 2-3 photos (headshot + lifestyle/marketing image)
- Press/media mentions (if any; otherwise hide section)
- Speaking topics list
- "Work with me" CTAs at bottom
- **AC:** Renders all bio content from `/web/content/about.mdx`.

### Mentorship (`/mentorship`)

**FR-M01 — Offer description**
- What it is (1:1 mentorship in conscious living / less-is-more philosophy)
- Who it's for / who it's not for
- Format (session count, cadence, async support)
- **No public pricing** in v1 (qualification before quote)
- **AC:** Page reads as a qualification page, not a sales page.

**FR-M02 — Inquiry form**
- Fields: name, email, phone (optional), context (textarea: "What brings you here?")
- POST `/api/inquiry` with `type: 'mentorship'`
- Resend email to Aditi + Kit tag `inquiry-mentorship`
- Success state: "Thanks — Aditi will be in touch within 48 hours"
- **AC:** Submission delivers email to Aditi within 30s.

### Speaking / Events / Retreats (`/speaking`)

**FR-SP01 — Single inquiry page**
- Type dropdown: Speaking · Workshop · Retreat collab · Podcast
- Fields: name, email, organisation, date/timeframe, budget range (optional), message
- POST `/api/inquiry` with selected `type`
- Resend email to Aditi + Kit tag `inquiry-{type}`
- **AC:** Each type creates a correctly tagged inquiry.

### Courses (`/courses`)

**FR-C01 — Waitlist landing**
- "Course coming soon" copy
- Hint at content (the philosophy → practice arc)
- Email opt-in → Kit form, tag `course-waitlist`
- Optional: $X founder pricing teaser
- **AC:** Submission creates tagged subscriber.

### Audiobook (`/audiobook`)

**FR-AB01 — Waitlist landing**
- "Audiobook in production"
- Email opt-in → Kit form, tag `audiobook-waitlist`
- Optional: 60s read-aloud sample (defer if not available)
- **AC:** Submission creates tagged subscriber.

### Blog (`/blog`)

**FR-B01 — Blog index**
- Reverse-chronological list of MDX posts in `/web/content/blog/`
- Each card: title, date, reading time, excerpt
- **AC:** New MDX file in `/blog/` appears on index after rebuild.

**FR-B02 — Blog post**
- `[slug]` route renders MDX
- Reading typography matches `/sample`
- Sidebar/end CTA: newsletter signup
- Share buttons (Twitter/X, LinkedIn, copy link)
- **AC:** At least one seed post lives in `/content/blog/` and renders correctly.

### Commerce API

**FR-CO01 — Checkout creation**
- `POST /api/checkout` body: `{ format: 'ebook', variant_id?: string }`
- Server constructs Lemon Squeezy checkout URL with `variant_id`, returns `{ url }`
- Client redirects to URL
- **AC:** Returned URL opens valid Lemon Squeezy hosted checkout.

**FR-CO02 — Webhook handler**
- `POST /api/webhooks/lemonsqueezy`
- Verifies HMAC signature against `LEMONSQUEEZY_WEBHOOK_SECRET`
- On `order_created` event for ebook product: generate signed download token (JWT, 24h TTL, 3-use cap), store in Vercel KV, send Resend email with `https://domain.com/api/download/[token]` link
- Idempotent (handle webhook retries)
- **AC:** Test purchase in Lemon Squeezy test mode triggers email within 30s.

**FR-CO03 — Signed download endpoint**
- `GET /api/download/[token]`
- Verifies JWT signature, checks KV for use count + expiry
- Streams file from Vercel Blob with `Content-Disposition: attachment`
- Increments use count; rejects after 3 uses or after 24h
- **AC:** First 3 hits in 24h succeed; 4th hit returns 410 Gone; hits after expiry return 410.

**FR-CO04 — Subscribe endpoint**
- `POST /api/subscribe` body: `{ email: string, tag?: string }`
- Validates email; rate-limited (1/sec per IP via Vercel middleware)
- Calls Kit API to add subscriber with tag
- **AC:** Real submission creates Kit subscriber with correct tag.

**FR-CO05 — Inquiry endpoint**
- `POST /api/inquiry` body: `{ name, email, type, message, ...optional }`
- Sends Resend email to `INQUIRY_NOTIFICATION_EMAIL`
- Adds Kit subscriber with `inquiry-{type}` tag
- **AC:** Aditi receives email; Kit subscriber created.

## Non-functional requirements

| ID | Requirement | Target |
|---|---|---|
| NFR-01 | Lighthouse Performance (mobile) | ≥ 95 |
| NFR-02 | Lighthouse Accessibility | ≥ 95 |
| NFR-03 | Lighthouse Best Practices | ≥ 95 |
| NFR-04 | Lighthouse SEO | ≥ 95 |
| NFR-05 | LCP (mobile, 3G Slow) | < 2.5s |
| NFR-06 | CLS | < 0.1 |
| NFR-07 | INP | < 200ms |
| NFR-08 | Total JS shipped to `/` | < 100kb gzipped |
| NFR-09 | Webhook handler p95 latency | < 1s |
| NFR-10 | Privacy: no third-party tracking cookies | 0 |
| NFR-11 | Uptime SLA (Vercel hosted) | 99.9% |

## Out of scope for v1 (explicit)

- User accounts / login / dashboard
- Reviews/comments
- Search
- Multi-language
- Dark mode
- Animation library
- Custom CMS (use MDX in-repo)
- Affiliate tracking
- Discount codes
- Cart (single-item checkouts only)
- Cross-sell / upsell pages
- Storybook
- E2E test suite (only smoke test on `/api/checkout`)
- Performance budgets enforced in CI (manual Lighthouse check only)
- Custom 404 design (Next.js default is fine for v1)

## Acceptance for "v1 launched"

See **Definition of Done** in `planning.md`. The site is launched when every checkbox there is ticked.
