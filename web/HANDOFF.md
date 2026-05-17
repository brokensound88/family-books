# HANDOFF — Read This First

**For:** The next Claude Code session (and you, the human, before kicking it off).
**Purpose:** Explain what happened, why these files are in the "wrong" repo, and exactly how to pick up where the previous session left off.

---

## TL;DR

1. The previous Claude session built a complete **build bible** (10 markdown docs) for Aditi Kumar's author landing site.
2. **No code was scaffolded yet.** The bible is the contract; the build comes next.
3. Those docs were created in the **wrong repo** (`brokensound88/family-books`) because the previous session was locked to it and physically couldn't access `brokensound88/Aditi-Website`.
4. The human is moving the files into `Aditi-Website` manually.
5. **Your job (next Claude):** scaffold the Next.js project in `Aditi-Website` per the bible, then ship the 24-hour MVP.

---

## What happened (the repo confusion)

The previous Claude session ran inside **Claude Code on the web**, a managed remote execution environment. Each web session is **pinned to a single GitHub repo at creation time** — the binding cannot be changed mid-session.

That session was provisioned against `brokensound88/family-books`. The user pasted `https://github.com/brokensound88/Aditi-Website.git` in the first message intending to work there, but:

- The working directory was `/home/user/family-books` (cloned at container start)
- The GitHub MCP tools were hard-restricted to `brokensound88/family-books` only
- Any call targeting `Aditi-Website` would have been denied by the harness

The user chose to proceed in `family-books` on a fresh branch (`claude/aditi-landing-page`) so the work wasn't lost, planning to move the files into `Aditi-Website` manually afterward.

**Lesson for next session:** When the user kicks off the new session on their MacBook, it must be started **with `brokensound88/Aditi-Website` as the target repo** so you have direct GitHub access. If you're reading this and you're in the wrong repo, stop and tell the user.

---

## What's in this folder

The previous session created `/web/` with one README and one `build-bible/` subfolder containing 9 docs:

```
/web/
├── README.md                          # Bible index + quick facts + status checklist
├── HANDOFF.md                         # ← you are here
└── build-bible/
    ├── planning.md                    # 24h hour-by-hour timeline + risk register
    ├── businessplan.md                # Revenue model, positioning, funnel
    ├── projectrequirements.md         # FRs/NFRs + acceptance criteria
    ├── techstack.md                   # Locked stack (Next 15, Tailwind, shadcn, Lemon Squeezy, Kit, Resend, Vercel)
    ├── filestructure.md               # Full /web tree + naming conventions
    ├── frontend.md                    # Design tokens, components, a11y, perf budget
    ├── backend.md                     # API routes, webhooks, token design, secrets
    ├── appflow.md                     # 9 user journeys with edge cases
    └── systemprompts.md               # Voice rules, banned words, AI prompt templates
```

These docs are **self-contained**. They reference each other by relative path, they don't reference anything outside `/web/`, and they don't mention `family-books`. You can drop the entire `/web/` folder into any repo and it works.

---

## What was decided (do not re-litigate)

The user already chose between alternatives. The bible reflects these choices. **Don't re-open these decisions** unless the user explicitly asks.

| Decision | Choice | Where it's documented |
|---|---|---|
| Framework | Next.js 15 (App Router) + TypeScript | `techstack.md` |
| Styling | Tailwind v4 + shadcn/ui | `techstack.md`, `frontend.md` |
| Payments | **Lemon Squeezy (Merchant of Record)** — not Stripe direct | `techstack.md`, `backend.md`, `businessplan.md` |
| Email marketing | **Kit (ConvertKit)** — migrating from Stan Store | `techstack.md`, `backend.md` |
| Transactional email | Resend + react-email | `techstack.md`, `backend.md` |
| Hosting | Vercel (project root = `/web`) | `techstack.md` |
| Blog | MDX in-repo (Sanity deferred to v1.5) | `techstack.md`, `filestructure.md` |
| Ebook delivery | Signed JWT, 24h TTL, 3-use cap, files on Vercel Blob | `backend.md` |
| Paperback (v1) | Routes to Amazon link; Lulu POD deferred to v2 | `businessplan.md`, `appflow.md` |
| Audiobook (v1) | "Coming Soon" + Kit waitlist | `projectrequirements.md` |
| Tax compliance | Outsourced to Lemon Squeezy (MoR handles VAT/GST globally) | `businessplan.md`, `techstack.md` |
| Analytics | Plausible (no cookie banner) | `techstack.md` |
| Legal pages | Termly-generated Privacy / Terms / Refund | `techstack.md`, `projectrequirements.md` |

---

## Project context (for the next session)

- **Book:** *The Art of Doing Less and Living More* by Aditi Kumar
- **Genre:** Spiritual self-help / non-fiction
- **Status:** Live on Amazon KDP since 30 March 2026 (ebook + paperback). Audiobook in production.
- **Primary markets:** Australia + USA, sells globally.
- **Current email list:** 20 subscribers in Stan Store (to migrate to Kit).
- **Existing brand assets:** Aditi has book cover, author headshot, marketing images.
- **Site goal:** Direct ebook sales (better margin than KDP) + authority positioning + funnel to mentorship / courses (waitlist) / speaking / events / retreats / community.
- **Launch timeline:** 24 hours from kickoff (aggressive — MVP scope is ruthless; see `planning.md`).

---

## Migration steps (when moving from `family-books` to `Aditi-Website`)

If you're the user reading this on your MacBook:

```bash
# 1. Clone Aditi-Website locally
git clone https://github.com/brokensound88/Aditi-Website.git
cd Aditi-Website

# 2. Copy /web/ from the family-books branch into Aditi-Website root
#    (assuming you've already pulled the claude/aditi-landing-page branch
#    of family-books into a sibling directory)
cp -R ../family-books/web ./web

# 3. Commit + push
git checkout -b aditi-landing-page
git add web/
git commit -m "Import build bible from family-books session"
git push -u origin aditi-landing-page

# 4. Start your new Claude Code session pointed at Aditi-Website
#    and tell it: "Read /web/HANDOFF.md and continue from Phase B."
```

If the structure of `Aditi-Website` already has files at the root, you can either:
- **Option A** (recommended): Keep everything under `/web/` so the bible paths stay intact. Set Vercel's "Root Directory" to `web`.
- **Option B**: Move the contents of `/web/` to the repo root. You'll need to update relative links in the bible docs (`web/README.md` → `README.md`, etc.). More work, slightly cleaner URLs in the repo.

The bible was written assuming **Option A**.

---

## Next Claude session — your starting prompt

When the user kicks off Claude Code in `Aditi-Website` on their MacBook, here's the bootstrap they should send (or you can suggest it):

> Read `/web/HANDOFF.md` and `/web/build-bible/planning.md` first. We're at Phase B — the bible is done and approved; you're scaffolding the Next.js 15 project per the spec. Start with H0–H1 of the 24-hour timeline in `planning.md`.
>
> Before you write code, confirm with me: (1) Lemon Squeezy store status (submitted/approved?), (2) domain status (purchased/DNS pointed?), (3) asset upload status (book cover, headshot, ebook PDF). These have lead times and block launch.

---

## Phase plan (where we are)

| Phase | Status | What |
|---|---|---|
| **A — Bible** | ✅ Done (previous session) | 10 markdown docs in `/web/build-bible/` + `/web/README.md` + this handoff |
| **B — Scaffold** | ⏳ Next | `pnpm create next-app` in `/web/`, install Tailwind + shadcn + MDX, wire env vars, set up Vercel project. Do not write feature code yet — get the dev server running first. |
| **C — 24h MVP** | ⏳ After B | Build the landing + sample + about + mentorship + speaking + courses (waitlist) + audiobook (waitlist) + blog (1 seed post) + legal pages. Wire Lemon Squeezy checkout, webhook → Resend email, Kit signup. Deploy to Vercel + custom domain. Full timeline in `planning.md`. |
| **D — v1.5** | Later | Embedded checkout, Sanity CMS, multi-post blog, testimonials carousel, lead magnet (7-day mini-course), PWYW sample PDF. |
| **E — v2** | Later | Audiobook integration, Lulu Direct POD, paid Circle community, first course launch, retreat deposits. |

---

## Action items the human needs to do (in parallel with Phase B)

These have lead times that the 24h sprint can't absorb. Start them **before** Phase B code:

- [ ] **Submit Lemon Squeezy store for approval** — review is 24–72h. This is the single biggest launch blocker.
- [ ] **Buy domain** — suggestions: `aditikumar.com`, `aditikumarauthor.com`, `theartofdoingless.com`. Point at Vercel.
- [ ] **Create Kit (ConvertKit) account** — free <10k subs. Create the main newsletter form and grab its ID.
- [ ] **Export 20 subscribers from Stan Store** as CSV; import into Kit.
- [ ] **Upload assets** to a shared location: high-res book cover (PNG/JPG), author headshot, marketing images, ebook PDF (and EPUB if available).
- [ ] **Confirm direct sale prices**: ebook + paperback. Direct ebook price must be **≥** Amazon ebook price (KDP price-matches downward and tanks royalty if undercut).
- [ ] **Set up Resend account** + verify sender domain (SPF/DKIM/DMARC). 24h DNS propagation.
- [ ] **Set up Plausible account** for the domain.
- [ ] **Generate legal pages** in Termly (Privacy, Terms, Refund — AU + global jurisdiction).

The full credentials checklist is in `techstack.md` → "Integration credentials checklist".

---

## Things the next Claude must NOT do

- **Do not work in `family-books`.** If you find yourself in that repo, stop and confirm with the user.
- **Do not re-debate the locked decisions** in the table above. The user already chose.
- **Do not scaffold Stripe direct integration** — payments go through Lemon Squeezy.
- **Do not skip the bible.** If you're tempted to start coding without reading `planning.md`, `techstack.md`, `filestructure.md`, and `backend.md` first — read them. The whole point of this folder existing is to save you from re-asking questions the user already answered.
- **Do not invent testimonials, fake quotes, or AI-generated photos of Aditi.** See `systemprompts.md` → Hard guardrails.
- **Do not use any banned word** from `systemprompts.md` in user-facing copy (transform, unlock, hack, secret, journey, manifest, transcend, heal, cure, etc.).
- **Do not push to `main` directly.** Use feature branches and PRs from Phase B onward.

---

## Provenance

- **Created by:** Claude Code session on the web, May 2026
- **Original branch:** `claude/aditi-landing-page` in `brokensound88/family-books`
- **Intended destination:** `brokensound88/Aditi-Website`
- **Build bible commit:** see git log; single commit titled "Add build bible for Aditi Kumar author landing site"
- **No code written.** Markdown only. Safe to drop anywhere.

If anything in the bible looks wrong, outdated, or contradicts something the user just told you in the new session: **the user's live answer wins**, but update the relevant bible doc in the same PR so it stays the source of truth.
