# Frontend Guidelines — `frontend.md`

How the site looks, feels, and behaves on screen. Mobile-first, accessibility-first, content-first.

## Design philosophy

The book's title is *The Art of Doing Less and Living More*. The site must embody that. Three rules:

1. **Subtract before adding.** Whitespace is a feature. No decorative ornaments.
2. **Type does the heavy lifting.** Typography hierarchy carries the design — not gradients, shadows, or icons.
3. **One bold thing per screen.** A single colour accent or a single image — never both fighting for attention.

The aesthetic is **minimalist with bold colour pops sampled from the book cover**. Think: a quiet room with one painting on the wall.

## Design tokens

Defined as CSS custom properties in `styles/globals.css` and consumed by Tailwind's `@theme` block. Change once, propagates everywhere.

### Colour (placeholders — sample from final book cover)

```css
:root {
  /* Neutrals — the quiet room */
  --color-paper:        #FAF8F4;   /* page background, warm off-white */
  --color-ink:          #1A1A1A;   /* body text */
  --color-ink-muted:    #5A5A5A;   /* secondary text, captions */
  --color-line:         #E6E2DA;   /* dividers, borders */

  /* Accent — the painting on the wall (sample from cover) */
  --color-accent:       #C75D2C;   /* PLACEHOLDER — replace once cover received */
  --color-accent-ink:   #FFFFFF;   /* text on accent */
  --color-accent-soft:  #F4E6DD;   /* tinted backgrounds (10% accent) */

  /* States */
  --color-success:      #2F7D5C;
  --color-error:        #B43A2A;
  --color-focus:        var(--color-accent);
}
```

**Accent palette rule.** Sample 2 colours from the book cover. Use the dominant warm/saturated one as `--color-accent`. Use the secondary as `--color-accent-soft` (or compute by mixing accent with paper at 90/10).

Contrast check before commit: all body text on `--color-paper` must hit ≥ 4.5:1. Use Tailwind's `text-ink` class; never use `text-ink-muted` for body copy < 18px.

### Typography

Two typefaces. No more.

| Role | Family | Weights | Source |
|---|---|---|---|
| **Display & body** | `Fraunces` (variable serif) | 300–900 | Google Fonts via `next/font` |
| **UI / micro** | `Inter` (variable sans) | 400–700 | Google Fonts via `next/font` |

Why Fraunces: warm, slightly literary, scales beautifully from 14px to 64px. Why Inter: neutral UI workhorse for buttons, labels, forms.

**Type scale (mobile → desktop):**

| Token | Mobile | Desktop | Use |
|---|---:|---:|---|
| `text-display` | 40px / 1.05 | 64px / 1.05 | Hero H1 only |
| `text-h1` | 32px / 1.15 | 44px / 1.15 | Page H1 |
| `text-h2` | 24px / 1.2 | 32px / 1.2 | Section heads |
| `text-h3` | 20px / 1.3 | 24px / 1.3 | Subsections |
| `text-body-lg` | 18px / 1.6 | 18px / 1.6 | Reading body (sample chapter, blog) |
| `text-body` | 16px / 1.55 | 17px / 1.55 | Default body |
| `text-small` | 14px / 1.4 | 14px / 1.4 | Captions, metadata |
| `text-eyebrow` | 12px / 1.2 uppercase letter-spacing 0.08em | same | Section labels |

**Reading width**: long-form content (sample chapter, blog, about, legal) is constrained to `max-w-prose` (~65ch). Marketing sections may go wider.

**Hyphenation**: enable `hyphens: auto` on long-form prose blocks. Disable on headings.

### Spacing

Use Tailwind's default 4px scale. Common section rhythm:

- Hero vertical padding: `py-16 md:py-24 lg:py-32`
- Standard section: `py-12 md:py-20`
- Tight section (e.g. CTA strip): `py-8 md:py-12`
- Container horizontal padding: `px-5 md:px-8 lg:px-12`

### Radii

- `rounded-sm` (4px) — inputs, small cards
- `rounded-lg` (12px) — buttons, primary cards
- `rounded-2xl` (16px) — book cover frame, hero image
- `rounded-full` — pills, avatar

### Shadows

Minimal. Only on the BuyBox and BookCover (subtle lift).

- `shadow-soft`: `0 2px 12px rgba(26,26,26,0.06)` (book cover at rest)
- `shadow-lift`: `0 8px 24px rgba(26,26,26,0.10)` (book cover hover / BuyBox)

No drop shadows on text. No coloured glows.

## Breakpoints (mobile-first)

| Token | Min width | Target |
|---|---:|---|
| (default) | 375 | Mobile portrait — primary design target |
| `sm` | 640 | Large phones / small tablets |
| `md` | 768 | Tablet portrait |
| `lg` | 1024 | Tablet landscape / small laptop |
| `xl` | 1280 | Desktop |
| `2xl` | 1536 | Wide desktop |

**Design and build at 375px first.** Test every component there before scaling up.

## Component inventory

All components live in `/web/components/` (see `filestructure.md` for the tree). This is the v1 component set.

### `Hero`
- Stacked on mobile: cover image top, title + subtitle + CTAs below.
- 2-col on `lg`: cover left, content right.
- Single primary CTA above the fold; secondary "Read a chapter" below.
- Subtle vertical motion on the book cover via CSS-only `transform` (no JS animation library).

### `BookCover`
- Responsive `<img>` (`next/image`, `priority` when in hero).
- Soft frame (`rounded-2xl`, `shadow-soft → shadow-lift` on hover).
- Maintains aspect ratio of the source file (don't crop).
- `alt` must include book title.

### `BuyBox`
- Stuck near the top of the landing fold on mobile.
- Toggle: Ebook / Paperback / Audiobook (Audiobook locks to waitlist).
- Active state shows price + primary CTA below.
- Trust line: "Secure checkout · Instant download · Apple Pay & Google Pay".
- Reuse anywhere on the page (sticky bottom-of-screen variant for `/sample`).

### `FormatToggle`
- Pill-group control.
- Accessible: implemented with `role="radiogroup"`; each pill is a `role="radio"` with `aria-checked`.
- Keyboard: arrow keys to switch.

### `TestimonialStrip`
- 3 quote cards. Static (no carousel in v1).
- Each card: quote, attribution, role/context, optional photo.
- Stack vertical on mobile, 3-col on `md+`.

### `AuthorBioStrip` / `AuthorBioLong`
- Strip: 1 photo + 2–3 short paragraphs + link to `/about`.
- Long: 3+ photos + 5–10 paragraphs, press logos strip if available.

### `OfferGrid` + `OfferCard`
- 4 cards: Mentorship / Courses (waitlist) / Speaking / Retreats.
- Each card: small eyebrow, title, 1-line description, CTA arrow.
- Stack on mobile, 2x2 on `sm`, 4-across on `lg`.

### `NewsletterCTA`
- Inline email-only form.
- Two variants:
  - **Standalone**: 2-line copy + form.
  - **Inline strip** (footer): single-line layout.
- Success state replaces the form ("Check your inbox to confirm").
- Error state shows inline message.

### `LeadMagnetCTA`
- Variant of NewsletterCTA with stronger framing: "Get the 7-day Less Is More mini-course — free".
- Lives on `/sample` end + scattered on blog posts.

### `InquiryForm`
- Shared between `/mentorship` and `/speaking`.
- Props: `type` (mentorship | speaking | workshop | retreat | podcast), shown fields.
- Fields: name, email, organisation (speaking only), date/timeframe (speaking only), budget range (speaking only, optional), message.
- Submit → `/api/inquiry`.

### `WaitlistForm`
- Variant of NewsletterCTA used on `/courses` and `/audiobook`.

### `ChapterEndCTA`
- Lives at the bottom of `/sample`.
- Two stacked CTAs: "Buy the full book" (anchor to BuyBox) + "Get the next chapter free" (LeadMagnetCTA).

### `Header`
- Logo (wordmark, not icon) left.
- Nav center on `md+`, hamburger drawer on mobile.
- Primary CTA right ("Buy the Book"). Always visible.
- Sticky on scroll; subtle background blur after 100px scroll.

### `Footer`
- 4 columns on `md+`, stacked on mobile.
- Cols: brand+tagline / nav links / legal links / newsletter mini-form.
- Bottom strip: copyright + social icons.

## Microcopy voice (excerpted; full rules in `systemprompts.md`)

- **Calm, grounded, direct.** Plain language over jargon.
- **No hype words.** Banned: *transform*, *unlock*, *10x*, *hack*, *secret*, *crush it*, *level up*, *next-level*.
- **No medical/therapeutic claims.** Banned: *heal*, *cure*, *therapy*, *treatment*, *anxiety relief* (clinical), *depression relief* (clinical).
- **No income or outcome guarantees.** Especially for courses/mentorship.
- **Reader = peer.** "You and I" framing. Not "students" or "clients".
- **Specific over generic.** "5-minute breath practice" beats "powerful technique".

### Microcopy examples

| Component | ✅ Good | ❌ Bad |
|---|---|---|
| Hero CTA | "Buy the book" | "Get instant access now!" |
| Newsletter | "One short essay every Sunday. Unsubscribe anytime." | "Join 1000s of seekers transforming their lives!" |
| Inquiry success | "Thanks. Aditi will be in touch within 48 hours." | "🎉 Awesome! You're on the list!" |
| Sample CTA | "Read the first chapter" | "Try a free taste of mind-blowing wisdom" |
| Audiobook waitlist | "I'll email you when it's ready." | "Be the first to experience the audiobook revolution!" |

## Accessibility

Non-negotiable. The book is about presence — the site can't exclude readers.

- **Semantic HTML first.** `<button>` not `<div onClick>`. `<nav>`, `<main>`, `<article>`, `<aside>`, `<footer>`. One `<h1>` per page.
- **Colour contrast ≥ 4.5:1** for body, ≥ 3:1 for large text. Verify with axe before deploy.
- **Keyboard navigation**: every interactive element reachable; focus order matches reading order; visible focus ring (use `focus-visible:` with `outline` not `box-shadow` for shadcn defaults).
- **Skip link**: "Skip to main content" as first focusable element.
- **Forms**: every input has a `<label>`; errors announced via `aria-live="polite"`; required fields marked semantically (`aria-required`) and visually (`*`).
- **Images**: meaningful `alt`; decorative gets `alt=""`; book cover alt = `"Cover of {{book.title}} by {{book.author}}"`.
- **Motion**: respect `prefers-reduced-motion`. Disable any non-essential transforms.
- **Heading hierarchy**: no skipping levels.
- **Lang attribute**: `<html lang="en">`.

## Images

- All images via `next/image`.
- Source format: high-res JPG or PNG; Next will serve AVIF → WebP → original.
- Hero / above-the-fold images: `priority` prop set.
- Below-the-fold: default lazy-load.
- Sizes attribute: always set. Example: `sizes="(min-width: 1024px) 480px, 80vw"`.
- Book cover stored as `/public/book-cover.jpg` at 2x natural display size (e.g. 800×1200 if display is 400×600).

## Fonts

- Loaded via `next/font/google` in `app/layout.tsx`. Zero CLS. Self-hosted automatically.
- Subset to Latin only for v1 (smaller bundle).
- `display: swap` ensures text never blocks paint.

```ts
// app/layout.tsx
import { Fraunces, Inter } from 'next/font/google'

const fraunces = Fraunces({ subsets: ['latin'], variable: '--font-display' })
const inter = Inter({ subsets: ['latin'], variable: '--font-ui' })
```

## Performance budget

| Metric | Target |
|---|---:|
| LCP (mobile, Slow 3G) | < 2.5s |
| INP | < 200ms |
| CLS | < 0.1 |
| Total JS on `/` (gzipped) | < 100kb |
| Total CSS on `/` (gzipped) | < 30kb |
| Largest image on `/` | < 150kb after Next optimisation |

Practical rules to hit these:

- Default to Server Components. Use `'use client'` only on interactive forms/toggles.
- No client-side data fetching for static content.
- Inline critical CSS (Tailwind v4 does this).
- Defer Plausible script (it's already tiny + async).
- Don't import full icon libraries — destructure individual icons from `lucide-react`.

## Loading & empty states

- **Form submit**: button enters loading state (`aria-busy="true"`, spinner inside button), disabled until response.
- **Form success**: replace form with confirmation text (focus moves to the confirmation for screen readers).
- **Form error**: inline error below the field; preserve user input; don't clear the form.
- **404**: clean type-only page, "Page not found", link home + to blog.

## Dark mode

**Deferred to v1.5.** Don't ship a half-baked theme switcher. The bright off-white aesthetic is intentional and on-brand.

## QA checklist before push

1. Lighthouse mobile run — all 4 scores ≥ 95.
2. Resize browser to 375px — no horizontal scroll on any page.
3. Tab through every interactive element on `/` and `/sample` — focus visible, logical order.
4. axe-core scan via DevTools — zero violations.
5. Every form submits successfully + handles error gracefully (kill network in DevTools to test).
6. Book cover, headshot, OG images present and not 404.
7. View source on `/` — `<title>`, meta description, OG tags all correct.
