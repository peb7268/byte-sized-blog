# Site Branding Updates - blog.byte-sized.io

## Overview

This document outlines the plan to update blog.byte-sized.io from the default Astro template to reflect the Byte-Sized brand and PaulThatAIGuy identity.

**Date**: October 22, 2024
**Status**: Planning
**YouTube Channel**: PaulThatAIGuy

---

## Current State

The blog is currently using the default Astro blog template with:
- Site title: "Astro Blog"
- Description: "Welcome to my website!"
- Default Astro social links (Mastodon, Twitter, GitHub)
- Default favicon and placeholder images
- Generic home page content

## Target Branding

### Identity
- **Blog Name**: Byte-Sized (or blog.byte-sized.io)
- **Tagline**: "iterate daily. ship fast"
- **Purpose**: PKMS repository for micro-learnings, blog posts, and tech content
- **Content Focus**:
  - Primary: Micro-learnings stored in `/private/` folder
  - Secondary: Blog posts linking to YouTube vlogs
  - Topics: Product reviews, agentic development, PKMS workflows
- **YouTube**: PaulThatAIGuy channel integration

---

## Branding Updates Required

### 1. Site Constants (`src/consts.ts`)

**Current:**
```typescript
export const SITE_TITLE = 'Astro Blog';
export const SITE_DESCRIPTION = 'Welcome to my website!';
```

**Proposed:**
```typescript
export const SITE_TITLE = 'Byte-Sized';
export const SITE_TAGLINE = 'iterate daily. ship fast';
export const SITE_DESCRIPTION = 'Micro-learnings, tech insights, and PKMS workflows. iterate daily. ship fast';
```

### 2. Home Page (`src/pages/index.astro`)

**Updates Needed:**
- Replace generic Astro welcome text
- Add brief intro to the blog purpose
- Highlight connection to YouTube channel
- Link to latest posts
- Call-to-action for PKMS/agentic development content

**Suggested Content Structure:**
- Hero section with tagline
- About the blog (PKMS focus, micro-learnings)
- YouTube integration mention
- Recent posts preview
- Topics covered (tech reviews, AI, workflows)

### 3. Header (`src/components/Header.astro`)

**Current Social Links (Remove):**
- Mastodon: `https://m.webtoo.ls/@astro`
- Twitter: `https://twitter.com/astrodotbuild`
- GitHub: `https://github.com/withastro/astro`

**New Social Links (Add):**
- YouTube: PaulThatAIGuy channel URL (need to get exact URL)
- LinkedIn: https://www.linkedin.com/in/peb7268/
- Optional: GitHub (personal), Twitter/X (if applicable)

**Navigation:**
- Keep: Home, Blog, About
- Optional additions: Topics, PKMS, YouTube

### 4. Logo & Favicon (`public/`)

**Current:**
- `favicon.svg` - Default Astro logo

**Needed:**
- Create/upload Byte-Sized logo
- Replace `favicon.svg`
- Optional: Add logo to header
- Consider: Different sizes for various devices (favicon-16x16.png, favicon-32x32.png, apple-touch-icon.png)

**Design Considerations:**
- Should reflect "Byte-Sized" concept
- Align with tech/AI/PKMS themes
- Complement YouTube channel branding

### 5. About Page (`src/pages/about.astro`)

**Updates Needed:**
- Introduce yourself (Paul)
- Explain the blog's purpose as a PKMS
- Describe micro-learnings concept
- Link to YouTube channel (PaulThatAIGuy)
- Outline content themes:
  - Agentic development
  - PKMS workflows
  - Product reviews
  - Tech tutorials
- Obsidian + Astro workflow (meta content)

### 6. Footer (`src/components/Footer.astro`)

**Current:**
- Default Astro attribution

**Updates:**
- Copyright/attribution to Paul/Byte-Sized
- Social links (YouTube, etc.)
- Optional: Quick links (Home, Blog, About, YouTube)
- Optional: RSS feed link

### 7. Blog Placeholder Images (`public/`)

**Current:**
- `blog-placeholder-1.jpg` through `blog-placeholder-5.jpg`
- `blog-placeholder-about.jpg`

**Options:**
- Keep as fallbacks
- Replace with branded placeholder images
- Create custom hero images for key posts

### 8. Metadata & SEO (`src/components/BaseHead.astro`)

**Review & Update:**
- Default OpenGraph images
- Site description for social sharing
- Twitter card metadata
- Ensure blog.byte-sized.io is properly configured

---

## Implementation Order

### Phase 1: Essential Branding (Priority)
1. Update site title/description in `consts.ts`
2. Replace favicon with Byte-Sized logo
3. Update social links in header (YouTube)
4. Update about page content

### Phase 2: Content & Polish
5. Redesign home page content
6. Update footer attribution
7. Review/update metadata for SEO

### Phase 3: Advanced (Optional)
8. Create custom hero images
9. Add logo to header navigation
10. Implement additional navigation sections
11. Add YouTube embed components for post integration

---

## Design Notes

### Color Scheme Ideas
- Tech-focused: Blues, purples (AI/tech associations)
- PKMS-focused: Organized, clean, minimal
- "Byte-Sized": Small, digestible, approachable

### Typography
- Keep readable, blog-friendly fonts
- Consider code-friendly font for technical content
- Maintain accessibility

### Voice & Tone
- Educational but approachable
- Tech-savvy without being pretentious
- "Byte-sized" = digestible, quick insights
- Balance between deep dives (YouTube) and quick reads (blog)
- **Tagline embodiment**: "iterate daily. ship fast"
  - Action-oriented, developer-focused
  - Emphasizes continuous improvement and velocity
  - Aligns with agile/lean development principles

---

## Action Items

- [x] Decide on exact site title/tagline - "Byte-Sized" / "iterate daily. ship fast"
- [ ] Design or source Byte-Sized logo
- [ ] Get YouTube channel URL for PaulThatAIGuy
- [ ] Write about page content
- [ ] Write home page intro/hero content
- [x] Collect social media URLs to link
  - LinkedIn: https://www.linkedin.com/in/peb7268/
  - YouTube: PaulThatAIGuy (need exact URL)
- [ ] Decide on color scheme
- [ ] Test branding in dev mode (`npm run dev`)
- [ ] Build and deploy to production

---

## Notes

**Private Folder Integration:**
- Primary content lives in `/Users/pbarrick/Documents/Main/Resources/Learning/Blog/private/`
- This is where micro-learnings are stored
- Symlinked to Astro project, so all posts automatically available
- Consider filtering or organizing by topic/tags

**YouTube Integration:**
- Blog posts can link to corresponding YouTube videos
- Consider embedded video players in posts
- Cross-reference blog post IDs with video topics

**Future Enhancements:**
- Search functionality for micro-learnings
- Tag system for topics (AI, PKMS, reviews, etc.)
- Newsletter signup (optional)
- Comments system (optional)
