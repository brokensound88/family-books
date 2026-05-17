# System Prompts — `systemprompts.md`

Voice rules and AI prompt templates for any generated content on the site. The brand voice is Aditi's. AI is a draft assistant; Aditi is the final editor.

## Brand voice (the meta-rules)

The voice across the entire site is **calm, grounded, direct**. Aditi is a peer to the reader, not a guru.

### Voice attributes

- **Calm**: pace is unhurried; no exclamation marks except in rare emotional moments.
- **Grounded**: rooted in lived practice, not theory. Reference small specifics over grand abstractions.
- **Direct**: gets to the point. No throat-clearing. No "in this article we will explore..."
- **Warm**: addresses the reader as someone Aditi knows.
- **Specific**: "5-minute breath practice" beats "powerful technique".
- **Honest**: admits limits, complexity, uncertainty.
- **Quietly confident**: doesn't need to convince anyone.

### Voice anti-patterns (these are bans, not suggestions)

**Words/phrases never used:**

| Banned | Why |
|---|---|
| transform / transformation | Hype |
| unlock / unleash | Hype |
| 10x / next-level / level up | Bro-tech |
| hack / life hack | Reductive |
| secret(s) | Manipulative framing |
| crush it / smash / dominate | Aggressive |
| game-changer / paradigm shift | Cliché |
| journey (overused as filler) | Cliché |
| transcend / transcendence | Spiritual bypass |
| manifest / manifestation | Misleading |
| vibrations / frequency / energy work | Pseudoscience |
| anxiety / depression (clinical use) | Medical claim risk |
| heal / cure / treatment / therapy | Medical claim |
| guaranteed / proven results | Claims risk |

**Structural anti-patterns:**

- No "In this post, we'll cover..." intros. Open with the thing itself.
- No bullet-point salads. Use prose for ideas; bullets only for genuine lists.
- No emoji unless used very sparingly in casual newsletter contexts.
- No "BTW" / "FWIW" / overly casual internet shorthand.
- No "**bold the keywords**" SEO style. Bold only what matters for the reader.
- No invented statistics ("studies show 87% of people...").
- No fake urgency ("limited time only!").
- No "as I always say" / "I always tell my clients" (Aditi doesn't have clients yet at this scale).

### What replaces what

| Instead of | Use |
|---|---|
| "Transform your life" | "Make small, repeatable changes" |
| "Unlock your potential" | "Notice what's already there" |
| "Discover the secret to..." | "Try this: ..." |
| "Powerful techniques" | "Simple practices" |
| "Game-changer" | (delete the sentence; if something is, the reader will know) |
| "Join 1000s of seekers" | "If this resonates, the newsletter goes out on Sundays" |
| "On your spiritual journey" | "In your practice" or "In the everyday" |
| "Healing trauma" | (avoid; Aditi is not a therapist. Refer out.) |

## Hard guardrails (do not cross)

1. **No medical claims.** The site cannot say or imply that the book, mentorship, or any practice treats, prevents, or cures any condition.
2. **No income guarantees.** Especially for courses or mentorship: never imply a financial outcome.
3. **No religious endorsement.** The work draws from yoga/Vedantic traditions but isn't religious. Frame practices as secular tools.
4. **No invented quotes / testimonials.** If a testimonial is on the site, a real person said it. Placeholder testimonials must be clearly labelled in source files and replaced before launch.
5. **No invented credentials.** Aditi's bio mentions only verifiable facts.
6. **No AI-generated images of Aditi.** Use real photos.

## Page-by-page voice direction

### Landing `/`
- **Hero H1**: book title, large.
- **Hero subtitle**: one positioning line — what the book promises, in 12–18 words, no hype.
- **Hero supporting line**: one sentence about who it's for.
- **Section heads**: short, declarative. "What this book gives you" not "What you'll discover".
- **CTAs**: verbs. "Buy the book." "Read a chapter." "Get the newsletter."

### `/sample`
- Aditi's actual writing. **AI never generates sample chapter content.** Use the real chapter file.

### `/about`
- First-person ("I"). Aditi telling her own story.
- Specifics over generics. Where she studied, who she's learned from, what she practises, what she doesn't do anymore.
- A clear "what I do / what I don't do" near the end (sets boundaries).

### `/mentorship`
- Qualification page, not a sales page.
- "Who this is for" + "Who this is not for" — both honest.
- No public pricing.

### `/speaking`
- Bullet list of topics (this is a legitimate list).
- Speaker reel / video embed if available; otherwise a short paragraph.
- Inquiry form below.

### Blog
- Sunday-letter format. 600–1,200 words. Short paragraphs. One idea per post.
- Open with a specific moment ("This morning..." / "A reader emailed me asking..."). Not a hook headline.
- End with a quiet invitation, not a hard CTA.

### Transactional emails
- Warm, brief, useful. No marketing.
- "Your book is ready. Click here. The link works for 24 hours and 3 downloads."

## AI prompt templates

These are the prompts to use with Claude or another LLM when drafting site copy. Always treat output as a draft. Aditi edits everything before it ships.

### Template 1 — Hero copy variants

```
You are drafting hero copy for the landing page of "The Art of Doing Less and Living More" by Aditi Kumar — a spiritual self-help non-fiction book.

Voice: calm, grounded, direct. Aditi is a peer to the reader, not a guru. Avoid these words: transform, unlock, 10x, hack, secret, journey, manifest, heal, cure, transcend.

Write 5 variants of a hero subtitle. Each variant is one sentence, 12–18 words. Each variant makes a specific promise about what the book offers, framed as subtraction rather than addition.

Output as a numbered list. Do not explain or apologise.
```

### Template 2 — Book blurb / description

```
Draft a 200-character book description and an 800-character long description for "The Art of Doing Less and Living More" by Aditi Kumar.

Genre: spiritual self-help non-fiction.
Audience: high-achievers who suspect that hustle is costing them more than it pays.
Core promise: practical subtraction — small, repeatable acts of doing less.
Voice: calm, grounded, direct. Peer to peer. No hype.

Banned words: transform, unlock, secret, hack, manifest, heal, journey, transcend, game-changer.

The 200-char version is the elevator pitch. The 800-char version expands with one specific example of a practice from the book and one specific benefit (not a guarantee).

Return both, labelled "SHORT" and "LONG".
```

### Template 3 — Testimonial elicitation email (to early readers)

```
Draft an email from Aditi to an early reader of "The Art of Doing Less and Living More". The goal is to ask for a short testimonial we can use on the new website.

Tone: warm, specific, direct. Not "I'm launching something HUGE!!" — more "I'm building a site for the book; would you write a few sentences?"

Include:
- A 1-sentence reminder of the recent connection.
- A clear ask: 2–3 sentences they'd be happy to have on a public site, with their first name and city.
- An offer to write a draft for them to edit if easier.
- A deadline (1 week) framed as a soft nudge, not pressure.
- A genuine sign-off (no "Cheers!").

Output the email body only.
```

### Template 4 — Blog seed post in Aditi's voice

```
Draft a Sunday-letter blog post in Aditi Kumar's voice. Aditi is the author of "The Art of Doing Less and Living More" — spiritual self-help, conscious living, subtraction-as-practice.

Voice: calm, grounded, direct, warm. Peer to peer. First-person ("I"). Short paragraphs.

Banned words: transform, unlock, secret, hack, manifest, heal, journey, transcend, game-changer, level up.

Structure:
1. Open with a specific moment (this morning / yesterday / a reader's email / a memory). 1–2 short paragraphs.
2. Name the idea or tension that moment surfaces. 1 paragraph.
3. Explore it gently with one example from practice or daily life. 2–3 paragraphs.
4. Offer a small invitation — not a directive. 1 paragraph.
5. Sign off with a single sentence.

Total: 600–900 words.

Topic for this post: {{TOPIC}}

Output the post only. No title — I'll write that.
```

### Template 5 — Social share copy

```
Write 5 short pieces of social copy for a post about Aditi Kumar's book "The Art of Doing Less and Living More".

Voice: calm, grounded, direct. No hype. No emoji except optionally one neutral one (like 🌿 or ◾). No exclamation marks unless emotionally warranted.

Formats:
1. A 240-character tweet that opens with a quote-style line from the book's voice.
2. A 240-character tweet that asks a quiet question.
3. A 600-character LinkedIn opener that sounds professional but warm.
4. A 220-character Instagram caption.
5. A 280-character Threads post.

Output as a numbered list with labels.
```

### Template 6 — Transactional email body (download ready)

```
Write a transactional email body for a buyer who just purchased the ebook "The Art of Doing Less and Living More".

Voice: warm, brief, useful. Aditi as a real person, not a brand.

Must include:
- Greeting using their first name (variable: {{firstName}})
- Confirmation of the order (one short sentence)
- A clear instruction: the link is below; it works for 24 hours and 3 downloads.
- A single short line of gratitude that doesn't gush.
- A signature: "Aditi"
- Below the signature: a small note offering the newsletter (1 short sentence).

Banned words: amazing, awesome, exciting, thrilled, can't wait.

Output the email body only, in plain text. The download URL placeholder is {{downloadUrl}}. Expiry is {{expiresAt}}.
```

### Template 7 — Inquiry acknowledgement email

```
Write an acknowledgement email sent when someone submits an inquiry form (mentorship, speaking, workshop, retreat, or podcast).

The inquirer's name is {{firstName}}. The inquiry type is {{type}}.

Voice: warm, brief, direct. No marketing.

Must:
- Thank them simply (not effusively).
- Confirm Aditi will read it and respond within {{responseTime}} (default 48 hours for mentorship, 5 business days for speaking).
- Set realistic expectations (Aditi reads everything personally; sometimes the queue is long).
- Sign off: "Aditi".

Banned: thrilled, excited, can't wait, awesome.

Output the email body only.
```

### Template 8 — FAQ entries

```
Draft FAQ entries for the landing page of "The Art of Doing Less and Living More" by Aditi Kumar.

Voice: calm, grounded, direct. Aditi answering as herself.

Generate 6 Q&A pairs. The Qs should be the real questions a reader on the fence might have — not softball self-promotion. The As should be short (2–4 sentences) and honest.

Required Qs:
1. Who is this book for?
2. Who is it not for?
3. What's the difference between the ebook and paperback?
4. Why buy direct instead of on Amazon?
5. Is there an audiobook?
6. Can I work with Aditi 1:1?

Banned words: transform, unlock, secret, hack, manifest, heal, journey, transcend.

Output as a markdown list with bold Qs.
```

### Template 9 — 7-day mini-course sequence (v1.5 lead magnet)

```
Draft a 7-email sequence for "The 7-Day Less Is More mini-course" — a free email opt-in delivered via Kit.

Voice: Aditi's. Calm, grounded, direct. Peer to peer. First-person.

Each email:
- Subject line: a specific noun phrase, not a question. ≤ 50 characters.
- Body: 200–400 words.
- Each email contains: (a) one short essay on a single practice of subtraction, (b) one tiny action to try today (≤ 2 minutes), (c) a soft tie back to the book.
- The 7th email ends with a clear, gentle CTA to buy the book.

Themes (one per day):
1. The cost of more
2. One thing at a time
3. The 5-minute pause
4. Subtraction as boundary
5. Doing less in conversation
6. The unfinished list
7. Living more

Banned words: transform, unlock, secret, hack, manifest, heal, transcend, game-changer.

Output each email with: SUBJECT, then BODY.
```

## How to use these prompts

1. Copy the relevant template.
2. Replace `{{variables}}` with actuals.
3. Run through Claude / GPT.
4. **Aditi reads, edits, approves** before anything ships.
5. If a draft has a banned word, regenerate or edit it out. Don't ship with banned words.

## Where final approved copy lives

- Hero, BuyBox, OfferGrid copy → in component files directly (`/web/components/marketing/*.tsx`) — short enough to inline.
- Long-form copy (about page, sample chapter, blog posts) → MDX in `/web/content/`.
- Book metadata (title, blurb, description) → `/web/content/book.ts`.
- FAQ entries → `/web/content/faq.ts`.
- Email templates → `/web/emails/*.tsx`.

**Single source of truth.** If two places say different things about the book, `/web/content/book.ts` wins.
