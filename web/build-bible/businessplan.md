# Business Plan — `businessplan.md`

## Author & brand positioning

**Aditi Kumar** is the author of *The Art of Doing Less and Living More* (Amazon KDP, launched 30 March 2026). Her brand sits at the intersection of **spiritual self-help** and **conscious living** — practical, grounded, non-dogmatic. The voice is calm, direct, and free of wellness-industry hype.

**Positioning statement.**

> For high-achievers who suspect that hustle is costing them more than it pays, Aditi Kumar teaches the art of subtraction — doing less so you can live more. Unlike productivity gurus who optimise for output, Aditi optimises for presence.

**Authority pillars** (the four things the brand stands for):
1. **Subtraction over addition** — less, not more
2. **Presence over performance** — quality of attention, not quantity of output
3. **Practice over theory** — small daily acts, not life overhauls
4. **Permission over prescription** — no guru pedestal

These pillars set the editorial line for the blog, the copy tone, the offers list, and the topics Aditi will speak on publicly.

## Why a direct site (not just Amazon)

| | Amazon KDP | Direct (this site) |
|---|---|---|
| Ebook royalty | ~35% on <$2.99 / >$9.99, 70% in the $2.99–$9.99 band (with delivery fee deducted) | ~93% after Lemon Squeezy fees (5% + 50c) |
| Customer email | **You don't get it** | You own it |
| Upsell to courses/mentorship | Forbidden | Native |
| Brand experience | Generic listing | Owned |
| SEO surface for authority | None | High |
| Reader → audience conversion | ~0% | Designed for it |

Amazon stays — it's discovery and social proof. But Amazon is rented land. The site is owned land.

## Revenue streams

Ranked by margin and proximity to launch:

### 1. Book sales — direct (live at launch)
- **Ebook**: PDF + EPUB bundle, instant download via signed link
- **Paperback**: routes to Amazon at v1; Lulu Direct POD in v2
- Direct ebook price set **≥** Amazon ebook price (Amazon price-matches downward and tanks KDP royalty if undercut)

### 2. Lead magnet → mailing list (live at launch)
- **"7-Day Less Is More" email mini-course** — free, auto-sequence in Kit
- Captures top-of-funnel; primes for paid offers
- Target: 100 subscribers/mo by month 3 (currently 20)

### 3. 1:1 Mentorship (live at launch as inquiry form)
- High-touch, high-margin
- Application form → Aditi qualifies → call → quote
- Suggested tiers: single session ($250–$500), 3-month container ($2.5k–$7.5k)
- No public pricing on v1 (qualification first)

### 4. Speaking, events, retreats (live at launch as inquiry form)
- Same inquiry form with dropdown: Speaking / Workshop / Retreat collab / Podcast
- Captures interest; Aditi quotes case-by-case

### 5. Courses — waitlist at launch, live by v2
- "The Art of Doing Less" — companion course to the book ($297–$497 launch price)
- Self-paced + 4 live group calls
- Built on Kajabi / Podia / Lemon Squeezy (decision in v2)

### 6. Community subscription — v2
- "The Circle" — paid private community ($9–$19/mo)
- Lemon Squeezy subscription product
- Monthly live practice + member-only essays

### 7. Retreat deposits — v2/v3
- $100 refundable hold via Lemon Squeezy
- Qualifies leads + forecasts demand before booking venue

## Unit economics (illustrative)

Assumptions: $9.99 ebook direct, $14.99 ebook paperback equivalent on Amazon, $19.99 paperback, ~40% of buyers choose direct ebook after seeing the option.

| Stream | Price | Net per sale | Volume/mo (month 3 target) | Net/mo |
|---|---:|---:|---:|---:|
| Direct ebook | $9.99 | ~$9.00 | 40 | $360 |
| Amazon ebook royalty | $14.99 | ~$10.40 (70%) | 30 | $312 |
| Paperback (Amazon) | $19.99 | ~$3–5 (KDP) | 15 | $60 |
| Mentorship | $500 avg | ~$475 (after Stripe) | 2 | $950 |
| Speaking/event | $1,500 avg | ~$1,425 | 0.5 | $712 |
| **Total month 3** | | | | **~$2,400** |
| **Total month 12 (4–6x)** | | | | **~$10–15k/mo** |

Numbers are illustrative; the model lives or dies on **email list growth** and **mentorship conversion**.

## 12-month revenue scenarios

| Scenario | List size M12 | Mentorship clients/mo M12 | Monthly revenue M12 |
|---|---:|---:|---:|
| Low | 500 | 1 | $3–5k |
| Mid | 2,000 | 3 | $10–15k |
| High | 5,000 | 6 + course launch | $25–40k |

The "High" scenario requires the Q3 course launch to land. v1 must not block that — hence courses waitlist live at launch.

## Funnel

```
COLD VISITOR (Google/Amazon/social)
        │
        ▼
LANDING PAGE  ─── reads hero, sees book ───┐
        │                                  │
        ▼                                  ▼
EMAIL OPT-IN (lead magnet)         DIRECT BUY (Lemon Squeezy)
        │                                  │
        ▼                                  ▼
7-DAY MINI-COURSE                  DOWNLOAD + RECEIPT
        │                                  │
        ▼                                  │
NEWSLETTER (weekly)  ◄─────────────────────┘
        │
        ├──► MENTORSHIP INQUIRY  →  $$$
        ├──► COURSE WAITLIST  →  COURSE LAUNCH (v2)
        ├──► SPEAKING/RETREAT INQUIRY  →  $$$
        └──► COMMUNITY SUBSCRIPTION (v2)  →  recurring $$$
```

**Key conversion events to instrument in Plausible:**
- `signup_newsletter` (any source)
- `signup_lead_magnet`
- `click_buy_ebook`
- `purchase_complete` (server-side via webhook)
- `submit_mentorship_inquiry`
- `submit_speaking_inquiry`
- `signup_course_waitlist`
- `signup_audiobook_waitlist`
- `click_buy_amazon_paperback` (outbound)
- `download_sample_chapter`

## Five creative funnel levers

These are the highest-leverage things to add beyond the obvious "Buy Now" button. Build the top two for v1, the rest in v1.5+.

1. **"7-Day Less Is More" email mini-course** *(v1)* — A free 7-day auto-sequence delivered via Kit. Each day: one short essay + one tiny practice. Highest-ROI lead magnet for self-help readers because it gives a taste of the book's promise without spoilers. CTA on every email: buy the book.

2. **Free guided audio meditation** *(v1)* — 5-minute MP3 gated behind email. Doubles as a teaser for the audiobook. Hosted on Vercel Blob; protected by simple email-gate.

3. **Pay-what-you-want sample chapter PDF** *(v1.5)* — Friction-free, captures both email and payment-intent signal. Anyone who pays even $1 is a high-quality lead.

4. **Annual "Stillness Retreat" deposit waitlist** *(v2)* — $100 refundable hold via Lemon Squeezy. Qualifies serious leads and lets Aditi forecast demand before booking a venue.

5. **Private Circle community** *(v2)* — $9–$19/mo subscription. Recurring revenue floor + deepens authority through ongoing presence. Hosted on Circle.so or Geneva initially; integrate billing via Lemon Squeezy.

## Brand voice rules (excerpted; see `systemprompts.md` for prompts)

- Calm, grounded, direct. **No hype, no "transform your life", no "10x", no "hack".**
- No medical/therapeutic claims (Aditi is not a therapist).
- No income or outcome guarantees (especially for courses).
- Plain language over jargon. If a yoga/Sanskrit term is used, explain it.
- Reader is treated as a peer, not a student.

## Competitive landscape (briefly)

Authors in adjacent space — used as positioning reference, not imitation:

- **Mark Manson** (*Subtle Art*) — direct sales engine + course. Tone is harder-edged than Aditi's.
- **Jay Shetty** — speaker/author with full ecosystem. Production-heavy; Aditi's lane is more intimate.
- **Yung Pueblo** — poetry-led, mailing list focused. Closer adjacent positioning.
- **Cal Newport** — academic credibility, book-led funnel. Closer to Aditi's "less, not more" angle.

The opening differentiator for Aditi: **subtraction over optimisation**. Most of the space is selling "do more, better". She's selling "do less, deeper".

## What we're explicitly NOT doing

- Selling to a "wellness industrial complex" audience (essential oils, crystals). Voice is grounded, not woo.
- Competing on Amazon SEO/ads. The site is the moat; Amazon is the storefront.
- Building a personal brand on TikTok aesthetics. Site visuals = book aesthetics.
- Promising outcomes. Inviting practice.
