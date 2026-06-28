# Plan — "Series" concept + in-series navigation + similar posts

**Goal:** group posts into named **series** (e.g. *Agentic Governance* 01, 02, 03…; *Agentic Foundations* 01, 02…). On each post, show **First / Previous / Next** within its series at the bottom, plus a **Similar/Related posts** block that prefers same-series and topically-related posts.

**Stack facts (verified):** Astro content collections; posts in `src/content/blog/*.md`; schema in `src/content.config.ts`; post page `src/pages/blog/[...slug].astro` (renders `layouts/BlogPost.astro` + `components/RelatedPosts.astro`). Deploy: GitHub Actions → Cloudflare Pages (repo `peb7268/byte-sized-blog`, `main`); `publish.sh` helper. No `tags` field today.

---

## 1. Frontmatter schema (`src/content.config.ts`)
Add three optional fields (all optional → zero breakage to existing posts):
```ts
series: z.string().optional(),        // e.g. "Agentic Governance"
seriesOrder: z.number().optional(),   // 1, 2, 3…  (position in the series)
tags: z.array(z.string()).optional(), // for "similar posts" scoring (optional but recommended)
```
Then tag the existing post (`the-review-is-the-work-now.md`):
```yaml
series: 'Agentic Governance'
seriesOrder: 1
tags: ['agentic-ai', 'code-review', 'engineering-leadership']
```

## 2. New component — `src/components/SeriesNav.astro`
Props: the current post. Logic:
1. `getCollection('blog')` → filter `!draft && data.series === current.series`, sort by `seriesOrder`.
2. Compute `index`, `total`, and `first / prev / next` entries.
3. Render a banded box at the **bottom of the article**:
   - Header: **"<Series> · Part {order} of {total}"** (e.g. "Agentic Governance · Part 1 of 1").
   - Three slots: **← First**, **‹ Previous**, **Next ›** — each a card (title + part number); disable/hide ones that don't exist (e.g. on Part 1, hide First/Previous; show only Next).
   - Optional small "View all in this series →" link to a series index (see §5).
Render nothing if the post has no `series`.

## 3. Wire into the post page (`src/pages/blog/[...slug].astro`)
- Import `SeriesNav`. Place it just above `<RelatedPosts>` inside `<BlogPost>`:
  ```astro
  <Content />
  <SeriesNav post={post} />
  <RelatedPosts posts={relatedPosts} />
  ```

## 4. Upgrade "Related" → "Similar" (the `relatedPosts` computation in `[...slug].astro`)
Today it's just "3 most recent." Replace with a small scoring function (still build-time, no client JS):
- **+100** same `series` (but exclude ones already shown in SeriesNav to avoid duplication — or keep series out of "similar" entirely and let SeriesNav own that).
- **+10 per shared tag.**
- **+1** recency tiebreaker (newer first).
- Take top 3. Falls back to recency when a post has no tags/series — so it still works for old posts.
- Rename the section heading to **"You might also like"** (keeps the existing `RelatedPosts.astro` card UI; only the *selection* changes). The component itself needs no markup change.

## 5. (Optional, recommended) Series index pages — `src/pages/blog/series/[series].astro`
- `getStaticPaths` over the distinct `series` values → one page per series listing all its posts in order.
- Slugify the series name for the URL (`Agentic Governance` → `agentic-governance`).
- Link to it from `SeriesNav` and from a small "Part of the **Agentic Governance** series" badge under the post title (in `BlogPost.astro`).

## 6. Authoring the next series — *Agentic Foundations*
Just new `.md` files with `series: 'Agentic Foundations'`, `seriesOrder: 1,2,3…`. Suggested early posts (from your note):
- `01` What is (agentic) governance?
- `02` What is token economics?
- `03` … (etc.)
No code changes needed per new post — the series nav/index/similar logic is data-driven.

## 7. Build / verify / ship
- `npm run dev` → open `/blog/the-review-is-the-work-now/` → confirm SeriesNav shows "Part 1 of 1" with only **Next** appearing once a Part 2 exists; confirm "You might also like" still renders.
- Add a throwaway `seriesOrder: 2` post locally to test prev/next, then remove.
- `npm run build` (catches schema/type errors), then commit → push `main` → Cloudflare Pages auto-deploys (or run `publish.sh`).

## Effort & sequencing
- **Phase 1 (core, ~1 hr):** §1 schema + §2 SeriesNav + §3 wire-in + tag the existing post. Ships the First/Prev/Next nav.
- **Phase 2 (~30 min):** §4 similar-posts scoring (+ add `tags` to existing posts).
- **Phase 3 (optional, ~30 min):** §5 series index pages + title badge.

## Decisions for you
1. Should "Similar posts" **include** same-series posts, or leave series entirely to SeriesNav (cleaner — my recommendation)?
2. Want the **series index pages** (§5) now, or defer to Phase 3?
3. Naming: section heading **"You might also like"** vs keep "Related Posts"? Series box label format — **"Agentic Governance · Part 1 of 3"** ok?
