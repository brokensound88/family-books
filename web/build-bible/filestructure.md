# File Structure — `filestructure.md`

The full `/web` tree. Anything not in here doesn't exist in v1.

## Top-level

```
/web
├── app/                       # Next.js App Router
├── components/                # React components
├── content/                   # Source content (MDX + book metadata)
├── lib/                       # Server + shared utilities
├── emails/                    # react-email templates
├── public/                    # Static assets
├── styles/                    # Global CSS (Tailwind entry)
├── middleware.ts              # Rate limiting + bot filtering
├── next.config.mjs
├── tailwind.config.ts
├── postcss.config.mjs
├── tsconfig.json
├── package.json
├── pnpm-lock.yaml
├── .env.local.example
├── .gitignore
├── .eslintrc.json
├── .prettierrc
├── README.md
└── build-bible/               # ← you are here
```

## `app/` — App Router

```
app/
├── layout.tsx                 # Root layout: html/body, fonts, analytics, header, footer
├── globals.css                # Tailwind directives + CSS variable design tokens
├── icon.svg
├── apple-icon.png
├── opengraph-image.tsx        # Default OG (regenerated per route below)
├── robots.ts                  # Generates /robots.txt
├── sitemap.ts                 # Generates /sitemap.xml
├── not-found.tsx              # 404
│
├── (marketing)/               # Route group — shares marketing layout
│   ├── layout.tsx             #   Marketing-specific shell (header style, etc.)
│   ├── page.tsx               # /            — landing
│   ├── sample/
│   │   ├── page.tsx           # /sample      — sample chapter renderer
│   │   └── opengraph-image.tsx
│   ├── about/
│   │   ├── page.tsx           # /about
│   │   └── opengraph-image.tsx
│   ├── mentorship/
│   │   └── page.tsx           # /mentorship
│   ├── speaking/
│   │   └── page.tsx           # /speaking
│   ├── courses/
│   │   └── page.tsx           # /courses     — waitlist
│   ├── audiobook/
│   │   └── page.tsx           # /audiobook   — waitlist
│   ├── privacy/
│   │   └── page.tsx
│   ├── terms/
│   │   └── page.tsx
│   ├── refund/
│   │   └── page.tsx
│   └── thank-you/
│       └── page.tsx           # /thank-you   — post-purchase confirmation
│
├── blog/
│   ├── page.tsx               # /blog        — index
│   ├── [slug]/
│   │   ├── page.tsx           # /blog/[slug]
│   │   └── opengraph-image.tsx
│   └── rss.xml/
│       └── route.ts           # /blog/rss.xml (defer to v1.5; stub returns 200 + empty feed in v1)
│
└── api/                       # Route handlers (server)
    ├── checkout/
    │   └── route.ts           # POST — creates Lemon Squeezy hosted checkout URL
    ├── webhooks/
    │   └── lemonsqueezy/
    │       └── route.ts       # POST — Lemon Squeezy webhook receiver
    ├── download/
    │   └── [token]/
    │       └── route.ts       # GET — streams ebook for valid token
    ├── subscribe/
    │   └── route.ts           # POST — newsletter / waitlist signups
    └── inquiry/
        └── route.ts           # POST — mentorship / speaking / etc.
```

### Route group convention

`(marketing)` is a Next.js route group — the parens mean it doesn't add to the URL path. Use it to share a layout among all marketing pages without polluting URLs. Keep `blog/` outside the group so blog pages can have a distinct layout in v1.5 if needed.

## `components/`

```
components/
├── ui/                        # shadcn primitives (do not hand-edit beyond styling)
│   ├── button.tsx
│   ├── input.tsx
│   ├── textarea.tsx
│   ├── select.tsx
│   ├── label.tsx
│   ├── card.tsx
│   ├── separator.tsx
│   ├── toast.tsx
│   └── toaster.tsx
│
├── marketing/                 # Page-section components
│   ├── Header.tsx
│   ├── Footer.tsx
│   ├── Hero.tsx
│   ├── BookCover.tsx          # Responsive cover image with subtle 3D tilt (CSS only)
│   ├── BuyBox.tsx             # Format toggle + CTAs (uses FormatToggle inside)
│   ├── FormatToggle.tsx
│   ├── TestimonialStrip.tsx
│   ├── AuthorBioStrip.tsx     # Short bio (landing)
│   ├── AuthorBioLong.tsx      # Long bio (about page)
│   ├── OfferGrid.tsx          # 4 "work with me" cards (landing)
│   ├── OfferCard.tsx
│   ├── NewsletterCTA.tsx      # Email-only inline form
│   ├── LeadMagnetCTA.tsx      # 7-day mini-course opt-in (variant of NewsletterCTA)
│   ├── InquiryForm.tsx        # Mentorship + speaking shared form (props decide tags + recipient)
│   ├── WaitlistForm.tsx       # Courses + audiobook waitlist (variant of NewsletterCTA)
│   ├── SocialLinks.tsx
│   └── ChapterEndCTA.tsx      # Post-sample-chapter conversion block
│
├── blog/
│   ├── BlogCard.tsx
│   ├── BlogHeader.tsx
│   └── PostBody.tsx           # MDX wrapper with prose styles
│
└── shared/
    ├── Container.tsx          # Max-width wrapper with responsive padding
    ├── Section.tsx            # Vertical spacing + optional bg
    ├── Eyebrow.tsx            # Small uppercase label above headings
    └── Prose.tsx              # Typography wrapper for long-form text
```

## `content/`

```
content/
├── book.ts                    # CANONICAL book metadata — single source of truth
├── about.mdx                  # Long-form bio
├── sample-chapter.mdx         # The sample chapter shown at /sample
├── testimonials.ts            # Testimonial array (replace placeholders pre-launch)
├── offers.ts                  # Offer metadata for OfferGrid (title, blurb, href)
├── faq.ts                     # FAQ items (used on landing optional section)
└── blog/
    ├── 2026-05-17-why-i-wrote-this-book.mdx
    └── _template.mdx          # Frontmatter scaffold for new posts
```

### `content/book.ts` — the single source of truth

Every component, OG image, schema markup, and webhook reads from here. **Never hardcode** book metadata anywhere else.

```ts
// content/book.ts (example shape — actual values set during scaffolding)
export const book = {
  title: 'The Art of Doing Less and Living More',
  subtitle: '',
  author: 'Aditi Kumar',
  isbn13: '978-...',
  publishedOn: '2026-03-30',
  cover: '/book-cover.jpg',
  description: '...',          // 200-char marketing description
  longDescription: '...',      // 800-char description for OG / schema
  formats: {
    ebook: {
      price: '9.99',
      currency: 'USD',
      variantId: process.env.LEMONSQUEEZY_EBOOK_VARIANT_ID,
    },
    paperback: {
      price: '19.99',
      currency: 'USD',
      amazonUrl: 'https://www.amazon.com/dp/...',
    },
    audiobook: {
      available: false,
      waitlistTag: 'audiobook-waitlist',
    },
  },
  retailers: {
    amazon: 'https://www.amazon.com/dp/...',
    kindle: 'https://www.amazon.com/dp/...',
  },
} as const
```

## `lib/`

```
lib/
├── lemonsqueezy.ts            # API client + checkout URL builder + webhook signature verify
├── kit.ts                     # Kit API client (subscribe, tag)
├── resend.ts                  # Resend client + send helpers
├── download-tokens.ts         # JWT mint + verify + KV use-count helpers
├── kv.ts                      # Vercel KV client wrapper
├── blob.ts                    # Vercel Blob client wrapper (signed URL helpers)
├── seo.ts                     # `generateMetadata` helpers, JSON-LD builders
├── analytics.ts               # Plausible event helpers (client + server)
├── env.ts                     # zod-validated env var loader
├── rate-limit.ts              # Upstash ratelimit factory
├── utils.ts                   # cn() + small helpers (shadcn-style)
└── tags.ts                    # All Kit tag string constants (avoid string drift)
```

### `lib/env.ts` — fail fast

Validates all required env vars on startup. If something's missing, dev/server boot fails loudly. No silent runtime failures inside webhooks.

### `lib/tags.ts` — Kit tag constants

```ts
export const KIT_TAGS = {
  NEWSLETTER: 'newsletter',
  LEAD_MAGNET_SAMPLE: 'lead-magnet-sample',
  LEAD_MAGNET_7DAY: 'lead-magnet-7day',
  AUDIOBOOK_WAITLIST: 'audiobook-waitlist',
  COURSE_WAITLIST: 'course-waitlist',
  INQUIRY_MENTORSHIP: 'inquiry-mentorship',
  INQUIRY_SPEAKING: 'inquiry-speaking',
  INQUIRY_WORKSHOP: 'inquiry-workshop',
  INQUIRY_RETREAT: 'inquiry-retreat',
  INQUIRY_PODCAST: 'inquiry-podcast',
  BUYER_EBOOK: 'buyer-ebook',
} as const
```

## `emails/`

```
emails/
├── DownloadReady.tsx          # "Your ebook is ready" with signed link
├── InquiryReceived.tsx        # Sent to Aditi when a form is submitted
├── InquiryAck.tsx             # Sent to inquirer acknowledging submission
└── _components/
    ├── Layout.tsx
    └── Button.tsx
```

react-email templates render to HTML at send time. Local preview via `pnpm email`.

## `public/`

```
public/
├── book-cover.jpg             # High-res book cover (replace at H1)
├── book-cover@2x.jpg
├── author-headshot.jpg
├── og/
│   ├── default.jpg            # Fallback OG (auto-overridden by per-route opengraph-image)
│   └── (others as needed)
├── icons/                     # Favicons, app icons
├── .well-known/
│   └── apple-developer-merchantid-domain-association   # Apple Pay verification (Lemon Squeezy provides)
├── manifest.webmanifest
└── favicon.ico
```

## `styles/`

```
styles/
└── globals.css                # Tailwind directives + CSS custom properties for design tokens
```

Design tokens live as CSS custom properties (`--color-ink`, `--color-paper`, `--color-accent`, etc.) defined in `:root` and consumed by Tailwind's `@theme` block. Single source — change one variable, the whole site updates.

## `middleware.ts`

Lives at the project root.

```ts
// Rate-limits /api/* to prevent abuse:
//   /api/subscribe   → 5/min/IP
//   /api/inquiry     → 5/min/IP
//   /api/checkout    → 10/min/IP
//   /api/download    → 30/min/IP (high to allow chunked downloads)
// Webhook routes are excluded (verified by HMAC instead).
```

## Import aliases

`tsconfig.json` paths:

```json
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./*"],
      "@/components/*": ["./components/*"],
      "@/lib/*": ["./lib/*"],
      "@/content/*": ["./content/*"],
      "@/emails/*": ["./emails/*"]
    }
  }
}
```

Always use aliases. Never `../../../`.

## Naming conventions

- **Files**: kebab-case for routes (`page.tsx`, `[slug]/page.tsx`); PascalCase for components (`Hero.tsx`, `BuyBox.tsx`).
- **Folders**: kebab-case (`build-bible/`, `lead-magnet/`).
- **MDX files**: `YYYY-MM-DD-slug.mdx` for blog posts; descriptive name for one-offs (`about.mdx`).
- **Server-only files**: end with `.server.ts` OR import `server-only` at top.
- **Env vars**: SCREAMING_SNAKE_CASE; `NEXT_PUBLIC_` prefix only if absolutely needed in the browser.
- **Kit tags**: kebab-case, prefixed by category (`inquiry-`, `lead-magnet-`, `buyer-`).
- **Lemon Squeezy variants**: stored in env, not hardcoded.

## Where things go (cheat sheet)

| What | Where |
|---|---|
| Book title change | `content/book.ts` |
| New blog post | `content/blog/YYYY-MM-DD-slug.mdx` |
| New "work with me" offer | `content/offers.ts` + new route under `app/(marketing)/[slug]/` |
| New API endpoint | `app/api/[name]/route.ts` |
| New shadcn component | `pnpm dlx shadcn@latest add [name]` → drops into `components/ui/` |
| Page metadata change | The page's `generateMetadata` (use helpers from `lib/seo.ts`) |
| New email template | `emails/[Name].tsx`, send via `lib/resend.ts` helper |
| New Kit tag | Add constant to `lib/tags.ts`, reference everywhere by import |
| Brand color change | CSS variables in `styles/globals.css` |

## What does NOT live in `/web`

- iOS app (lives in `/FamilyBooks` at repo root — unrelated)
- Old planning docs (lives in `/Build Bible` at repo root — unrelated, do not reuse)
- Ebook PDF/EPUB files (uploaded to Vercel Blob, not committed)
- Author headshot raw files (committed to `public/` only after compression)
- Secrets (only in `.env.local` and Vercel project env)
