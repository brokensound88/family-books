# Plan of Attack — `planning.md`

## Vision

Ship a mobile-first marketing & commerce site for Aditi Kumar within **24 hours of kickoff**, so she stops bleeding margin to Amazon and starts owning her audience. The site must do three jobs, in order:

1. **Sell the book direct** (ebook via Stripe-style checkout, paperback via Amazon for v1).
2. **Establish authority** in the spiritual self-help / conscious living space.
3. **Funnel readers** into higher-tier offers (1:1 mentorship, courses waitlist, speaking, events, retreats, community).

Everything in this bible bends toward those three jobs. If a feature doesn't serve them, it gets cut.

## Success criteria

### v1 (within 24h)
- Live on a custom domain over HTTPS
- Lighthouse mobile ≥ 95 across Performance, Accessibility, Best Practices, SEO
- One successful end-to-end test purchase in Lemon Squeezy **test mode** (checkout → webhook → signed download email arrives → link delivers ebook → link expires after 24h)
- One real newsletter signup → tagged subscriber in Kit
- One real inquiry form submission → email delivered to Aditi via Resend
- Mobile breakpoint (375px) renders without horizontal scroll on every page
- Legal pages (Privacy, Terms, Refund) live and linked from footer

### v1.5 (week 2)
- Lemon Squeezy live mode + first real sale
- 7-Day "Less Is More" email mini-course sequence live in Kit
- Sample chapter PDF download (PWYW) wired up
- Blog populated with 3 posts
- Plausible analytics goals configured

### v2 (month 2–3)
- Audiobook integrated (streaming sample + buy)
- Paperback POD via Lulu Direct (replace Amazon route)
- Paid Circle community (Lemon Squeezy subscription)
- Course #1 launched
- Retreat deposit waitlist live

## 24-hour timeline

Hours are wall-clock from "kickoff". Built for one builder + Aditi on standby for assets/decisions.

| Hour | Builder (engineering) | Aditi (parallel) | Checkpoint |
|---|---|---|---|
| H0 | Scaffold Next.js 15, push first commit | Submit Lemon Squeezy store for approval; buy domain | Repo deployed to Vercel preview |
| H1 | Tailwind + shadcn/ui setup; base layout; design tokens stub | Upload book cover (high-res), headshot, marketing images to a shared folder | Empty site renders on preview URL |
| H2–H4 | Hero, BookCover, BuyBox, FormatToggle, Testimonials, AuthorBio components | Provide ebook PDF/EPUB file; confirm direct ebook + paperback prices | Landing page visually complete (mock data) |
| H5–H7 | Real content wired: copy, images, testimonials (placeholder if needed); responsive QA | Draft hero copy + book blurb (or approve AI draft from `systemprompts.md`) | Landing page final on mobile + desktop |
| H8–H10 | `/sample` page (MDX), `/about`, `/mentorship`, `/speaking`, `/courses` (waitlist), `/audiobook` (waitlist) | Provide sample chapter text; mentorship offer details | All marketing pages live on preview |
| H11–H13 | API routes: `/api/subscribe` → Kit, `/api/inquiry` → Resend, `/api/checkout` → Lemon Squeezy | Create Kit account; import Stan Store CSV; create forms; share API key | Newsletter + inquiry forms functional |
| H14–H16 | Webhook handler: `/api/webhooks/lemonsqueezy` → mint download token → send email via Resend (react-email template) | Lemon Squeezy approval (hopefully back by now); set up Apple Pay domain verification file | Test purchase succeeds end-to-end in test mode |
| H17–H18 | `/api/download/[token]` with 24h TTL, 3-download cap, signed JWT | — | Download flow verified |
| H19–H20 | `/blog` (MDX) with 1 seed post; OG image generation; sitemap; robots.txt | Approve final copy across all pages | SEO + blog ready |
| H21 | Legal pages (Termly-generated Privacy, Terms, Refund) | Set up Plausible account; share site ID | Footer complete |
| H22 | DNS cutover to custom domain; Apple Pay domain verification deploy | On standby for DNS confirmation | Production domain live |
| H23 | Final QA: Lighthouse, mobile pass, real card test if Lemon Squeezy approved | Test purchase from her own device | Green light |
| H24 | Announce: email blast to existing 20 + social posts | — | **Launched** |

If Lemon Squeezy approval is still pending at H22, ship with paperback (Amazon link) + email capture only, and flip ebook checkout on the moment approval lands.

## MVP cut line

### Ships in v1
- Landing page (hero, book cover, buy box, social proof strip, author bio strip, "work with me" overview, newsletter CTA)
- Sample chapter page (MDX, single chapter)
- About page (full bio + photos)
- Mentorship page (offer + inquiry form)
- Speaking/Events/Retreats page (single inquiry form, dropdown for type)
- Courses page (waitlist form, Kit tag)
- Audiobook page (waitlist form, Kit tag)
- Blog index + one seed post
- Ebook checkout via Lemon Squeezy **hosted** checkout (no embedded overlay yet)
- Paperback → Amazon redirect
- Signed download email delivery
- Legal pages (Privacy, Terms, Refund)
- OG images, sitemap, robots.txt
- Plausible analytics

### Defers to v1.5+
- Embedded Lemon.js overlay checkout (use hosted in v1)
- Sanity CMS (MDX in v1)
- Multi-post blog UI polish + categories + RSS
- Testimonials carousel (use static strip in v1)
- MDX syntax highlighting / table of contents
- Dark mode
- i18n
- Paperback POD via Lulu / BookVault
- Affiliate program
- `/thank-you` upsell page after purchase
- Per-purchase PDF watermarking
- Audiobook embedded player
- Paid Circle community subscription product
- Retreat deposit checkout

### Hard cuts (won't build in v1, won't promise in v1.5)
- Custom design system (use shadcn defaults reskinned with 2 brand colors)
- Animation library (Framer Motion etc.)
- Storybook
- E2E test suite (Playwright smoke test on `/api/checkout` only)
- Headless CMS
- Auth / user accounts
- Reviews/comments system
- Search

## Risk register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Lemon Squeezy store approval takes 24–72h | High | Blocks all direct sales | **Submit at H0**. If not approved by H22, ship paperback-only + email capture; flip ebook on later. |
| DNS propagation delays | Medium | No custom domain at launch | Buy domain at H0; configure Vercel DNS at H0; use Cloudflare for fast propagation. Fall back to `*.vercel.app` if needed. |
| Apple Pay domain verification fails | Medium | One-click checkout missing | Upload verification file during H22 DNS cutover; test before announcing. |
| Amazon price-matches a lower direct price → KDP royalty tanks | High | Lost royalty on Amazon | **Price direct ≥ Amazon price**. Add bundle bonus (free meditation MP3) to justify direct purchase. |
| Missing or incorrect book asset rights | Low | Legal exposure | Confirm Aditi owns book cover & headshot rights before deploy. |
| GDPR / AU Privacy Act non-compliance | Medium | Fines, reputational | Termly-generated Privacy + cookie notice; Plausible (no cookies) avoids consent banner. |
| Ebook piracy via shared download links | Medium | Lost sales | 24h TTL + 3-download cap + signed JWT. Watermark deferred to v1.5. |
| Builder hits a 4am wall during 24h sprint | High | Quality drop | Hard checkpoints at H8, H16, H22; ship a paperback-only version at H22 if behind. |
| Kit double opt-in blocks purchaser email delivery | Medium | Buyer doesn't get download link | Send download via **Resend transactional** (not Kit). Kit is marketing only. |
| Lemon Squeezy webhook signature mismatch | Low | Failed downloads | Verify signature on every webhook; log + alert on failure; manual fulfillment fallback. |
| Aditi unavailable for asset/copy decisions | Medium | Stalled build | Use AI-generated drafts from `systemprompts.md` as placeholders; she approves async. |

## Operating principles for this sprint

- **Don't gold-plate.** shadcn defaults > custom design. Hosted checkout > embedded overlay. MDX > CMS. Static > dynamic.
- **One source of truth.** Book metadata (title, price, ISBN, cover, retailer URLs) lives in `/web/content/book.ts`. Don't hardcode anywhere else.
- **Marketing email ≠ transactional email.** Kit for newsletters/sequences. Resend for receipts/download links. Never mix.
- **Mobile first, always.** Build at 375px, then scale up. Desktop is the second-class citizen.
- **No medical/therapeutic claims, no income guarantees.** Voice rules live in `systemprompts.md`.
- **Direct ebook price ≥ Amazon ebook price.** Always.

## Definition of Done (v1)

The site is "done" when:

- [ ] Production URL resolves over HTTPS on the custom domain
- [ ] Every page in `projectrequirements.md` is live and passes mobile QA at 375px
- [ ] A test card purchase completes the full loop (checkout → webhook → email → download → expire)
- [ ] Newsletter form creates a tagged Kit subscriber
- [ ] Inquiry form delivers email to Aditi within 30s
- [ ] All four footer legal links resolve to populated pages
- [ ] Lighthouse mobile ≥ 95 on `/`
- [ ] Plausible is recording pageviews
- [ ] Aditi has personally completed a test purchase from her phone

Then — and only then — announce.
