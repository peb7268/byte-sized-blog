---
title: 'From PRD to Pixel: How AI Agents Build Our Design Pipeline'
description: 'A deep dive into our 5-stage AI design workflow — from product requirements through ASCII wireframes, Nano Banana mockups, Veo animations, and autonomous agent handoffs that ship production code.'
pubDate: 'Mar 22 2026'
heroImage: 'https://images.unsplash.com/photo-1558655146-9f40138edfeb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3MzE0MDd8MHwxfHNlYXJjaHwxfHxibHVlcHJpbnQlMjBkZXNpZ258ZW58MHwwfHx8MTc3NDE2MDk3NXww&ixlib=rb-4.1.0&q=80&w=1080'
draft: false
---

What if your entire design pipeline — from product requirements to production code — was orchestrated by AI agents that hand off work to each other like a relay team?

That's not hypothetical. It's what we built.

Our design workflow uses a 5-stage pipeline powered by 10+ specialized AI agents, each with clear responsibilities, quality gates, and structured handoff packages. The human stays in the loop at critical decision points, but the agents handle the grind: wireframing, prototyping, visual review, implementation, and optimization.

Here's how it actually works.

## Stage 0: The PRD

Every project starts with a Product Requirements Document. Our PM agent drafts it based on a conversation or brief, producing a structured document that captures:

- **Problem statement** — what are we solving and for whom?
- **User stories** — specific behaviors and expectations
- **Success criteria** — measurable outcomes
- **Technical constraints** — platforms, performance budgets, accessibility requirements
- **Visual references** — 3-5 reference URLs, brand assets, mood direction

The PRD isn't just documentation. It's the source of truth that every downstream agent references. When the wireframe designer asks "what goes in the hero section?", it reads the PRD. When the reviewer checks whether the prototype meets requirements, it validates against the PRD.

This is what separates an agentic workflow from "asking ChatGPT to make a website." The PRD creates a persistent contract that survives across agent handoffs.

## Stage 1: ASCII Wireframes

Here's where things get interesting. Before any pixels are pushed, our wireframe designer agent creates **ASCII art wireframes** — low-fidelity layouts using nothing but text characters.

```
+----------------------------------------------------------+
|  [Logo]              Home | About | Work | Contact       |
+----------------------------------------------------------+
|                                                          |
|              *  Welcome to Our Platform  *               |
|           Tagline goes here in smaller text               |
|                                                          |
|              [  Get Started  ]  [  Learn More  ]         |
|                                                          |
+----------------------------------------------------------+
|                                                          |
|   {Feature 1}      {Feature 2}      {Feature 3}         |
|   Description       Description      Description        |
|                                                          |
+----------------------------------------------------------+
```

Why ASCII? Three reasons:

1. **No tooling overhead.** No Figma license, no design software, no rendering. It's pure text that any agent can read and reason about.
2. **Forces structure over style.** ASCII wireframes strip away color, typography, and imagery. What's left is information architecture — the skeleton that everything else hangs on.
3. **Universal readability.** Every agent in the pipeline can parse ASCII. It embeds cleanly in markdown, version controls perfectly in git, and diffs meaningfully in pull requests.

The wireframe agent follows strict ASCII conventions: `|` and `-` for borders, `+` for corners, `*` for buttons, `[]` for inputs, `{}` for content placeholders. Everything constrained to 80 characters wide. It's a design system for text.

The deliverables from this stage aren't just wireframes. The agent produces a `ui-plan.md` (complete structure plan), `wireframe-config.json` (technical specifications), individual section wireframes, a reusable `components.md` library, `responsive-notes.md`, and `accessibility-notes.md`.

**Gate 1** requires all sections wireframed, responsive breakpoints defined, component library established, accessibility requirements documented, and — critically — human approval.

## Stage 2: Nano Banana Pro — From ASCII to Visual Mockup

This is where the magic happens. We take those ASCII wireframes and feed them to [Nano Banana Pro](https://deepmind.google/models/gemini-image/pro/), Google DeepMind's image generation model built on Gemini 3 Pro.

Nano Banana doesn't just generate pretty pictures. It understands UI conventions. Hand it an ASCII wireframe with a prompt like:

> "Convert this wireframe into a modern SaaS landing page. Use a dark gradient hero with a glassmorphism card layout. Inter font family. Primary color #6366f1."

And it produces a high-fidelity mockup that respects the spatial relationships defined in the wireframe. Navigation stays at the top. The three-column feature grid stays centered. The CTA buttons land where you placed them.

The real power is in iteration. Don't like the hero? Regenerate just that section. Want to explore three color variations? Generate them in parallel. Need to match an existing brand? Provide reference images and Nano Banana adapts.

This replaces what used to be days of Figma work with minutes of prompt refinement. And because the input is structured ASCII (not a vague description), the output is architecturally sound from the first generation.

We use Google AI Studio as the prototyping environment — it's the fastest way to experiment with prompts and see results before committing to a direction.

## Stage 3: Veo — Animated Prototypes and Motion Design

Static mockups are great for layout. But modern interfaces move. Hover states, page transitions, loading animations, scroll effects — these define the feel of a product as much as its visual design.

Enter [Veo](https://deepmind.google/models/veo/), Google's video generation model. With the March 2026 unification of Google Flow, we can now go from static Nano Banana keyframes directly into animated prototypes without leaving the workspace.

The workflow:

1. **Generate keyframes** in Nano Banana — the hero section in its default state, hover state, and scrolled state
2. **Import into Flow** — Nano Banana is now natively integrated
3. **Animate with Veo 3.1** — describe the transition: "The hero text fades in from below over 0.8 seconds, followed by the CTA button scaling up with a subtle bounce"
4. **Add ambient details** — Veo 3 can generate sound effects and ambient audio natively
5. **Direct camera movements** — specify pans, zooms, and parallax effects with text prompts

The output isn't production code — it's a motion reference that our frontend agents use to implement CSS animations and JavaScript interactions. Think of it as an animated specification. Instead of writing "the card should have a hover effect," you hand the developer agent a video of exactly what the hover effect should look like.

This is particularly powerful for stakeholder communication. Show a client an animated prototype and they understand the vision immediately. Show them a wireframe and you'll spend 30 minutes explaining what "parallax scroll" means.

## Stage 4: Agent Handoff — The Relay Race

This is where our pipeline differs fundamentally from "using AI tools." Each stage doesn't just produce deliverables — it produces a **structured handoff package** that the next agent consumes programmatically.

### Wireframe → Prototype Handoff

```json
{
  "stage": "wireframe",
  "deliverables": {
    "wireframes": "wireframes/sections/",
    "ui_plan": "wireframes/ui-plan.md",
    "config": "wireframes/wireframe-config.json",
    "components": "wireframes/components.md"
  },
  "metrics": {
    "sections_count": 8,
    "components_defined": 12,
    "responsive_breakpoints": 3
  }
}
```

The frontend prototyper agent picks this up and builds a complete HTML/CSS/JS prototype using Tailwind CSS, Alpine.js, and an atomic design methodology (atoms → molecules → organisms). It doesn't guess at the layout — it reads the wireframe config. It doesn't improvise the component structure — it implements the component library.

### Prototype → Implementation Handoff

```json
{
  "stage": "prototype",
  "deliverables": {
    "html": "prototype/dist/",
    "assets": "prototype/assets/",
    "build_config": "prototype/package.json"
  },
  "metrics": {
    "lighthouse_score": 95,
    "bundle_size": { "css": "42KB", "js": "78KB" }
  },
  "requirements": {
    "post_types": ["portfolio", "testimonials"],
    "menus": ["primary", "footer"]
  }
}
```

### The Orchestrator

The `ui-orchestrator` agent manages the entire pipeline. It:

- Assigns tasks to the right specialist agent
- Enforces quality gates between stages
- Routes failures back to the responsible agent with specific feedback
- Tracks progress through all five stages
- Handles the human-in-the-loop approval at each gate

No agent proceeds to the next stage without passing its gate. Gate 2, for example, requires W3C validation, WCAG 2.1 AA compliance, Lighthouse score above 90, cross-browser testing, and performance budget adherence. The `ui-reviewer` agent performs automated visual testing using Playwright, capturing screenshots at every breakpoint and comparing them against the wireframe specifications.

## Stage 5: Visual Review — The Safety Net

After each major stage (prototype and final implementation), the `ui-reviewer` agent performs an automated visual audit:

1. Navigate to the output at all responsive breakpoints (mobile, tablet, desktop)
2. Capture screenshots and compare against the previous stage's output
3. Test every interactive element — clicks, hovers, form submissions
4. Validate content integrity — no lorem ipsum leaking through
5. Run accessibility checks
6. Measure Core Web Vitals (FCP < 1.5s, LCP < 2.5s, CLS < 0.1)
7. Generate a pass/fail report with severity-classified issues

Visual accuracy threshold: 95% match at the prototype stage, 98% at final implementation. If it fails, the reviewer generates specific remediation instructions and routes them back to the implementing agent.

## The Agent Roster

Here's who does what:

| Agent | Role |
|-------|------|
| **ui-orchestrator** | Pipeline coordinator, gate enforcer |
| **wireframe-designer** | ASCII wireframes, UI planning |
| **frontend-prototyper** | HTML/Tailwind/Alpine.js prototype |
| **ui-reviewer** | Playwright visual testing, QA |
| **ui-designer** | Visual design system, brand compliance |
| **ui-developer** | Production frontend implementation |
| **ui-integrator** | Backend API integration |
| **ui-mobile-optimizer** | PWA, Service Workers, touch UX |
| **ui-performance** | Bundle optimization, Core Web Vitals |
| **wordpress-implementor** | WordPress theme conversion |

Ten agents. One pipeline. Zero context loss between stages.

## What This Actually Looks Like in Practice

A real project flow:

1. **9:00 AM** — Client brief arrives. PM agent drafts PRD, routes to #docs channel for review.
2. **9:30 AM** — Human approves PRD. Orchestrator assigns wireframe task.
3. **10:15 AM** — Wireframe agent delivers 8-section ASCII layout with component library. Posts to #implementations.
4. **10:20 AM** — Human reviews wireframes, approves with one change ("move CTA above the fold"). Agent revises in 3 minutes.
5. **10:30 AM** — Nano Banana generates 3 visual directions from the approved wireframes. Human picks direction B.
6. **11:00 AM** — Veo produces animated prototype showing page transitions and hover states.
7. **11:15 AM** — Frontend prototyper builds interactive HTML prototype. Lighthouse: 94.
8. **11:30 AM** — UI reviewer runs automated visual audit. 97% match. Two minor spacing issues flagged.
9. **11:45 AM** — Prototyper fixes spacing. Reviewer re-validates. 99% match. Gate passed.
10. **12:00 PM** — WordPress implementor converts to production theme. Human reviews staging site.
11. **12:30 PM** — Final visual review: 98.5% match. All gates green. Deployment package ready.

Three and a half hours. From "we need a website" to "here's the deployment package."

That's not an exaggeration — it's what happens when you eliminate the context-switching tax that humans pay when moving between design phases. Each agent starts its stage with full context from the previous stage's handoff package. No "can you explain what you meant by...?" No "I think the wireframe showed...?" No lost-in-translation.

## The Storybook Layer

There's one more piece: automatic component extraction. Our design pipeline workflow includes a Storybook integration that analyzes the final HTML prototype and automatically extracts reusable components:

- **Hero sections** — identified by `hero-*` classes, gradient backgrounds, large headings
- **CTA elements** — buttons with `btn-*` or `cta-*` classes
- **Card components** — `bg-white`, rounded corners, shadow patterns
- **Form elements** — inputs with state variants (focus, error, disabled)
- **Navigation** — header, mobile menu, footer patterns

Each component gets a Storybook story with interactive controls, documentation, and variant showcases. This means the component library doesn't just exist in a markdown file — it's a living, browsable reference that future projects can pull from.

## Why This Matters

The traditional design process is a game of telephone. A designer creates a mockup. A developer interprets the mockup. A QA engineer checks the developer's interpretation against the designer's intent. At every handoff, information degrades.

Our pipeline eliminates that degradation by making every handoff structured, machine-readable, and validated. The wireframe config isn't a screenshot with annotations — it's a JSON specification. The prototype handoff isn't a Slack message saying "it's in the staging branch" — it's a package with metrics, deliverables, and requirements.

The human still makes the important decisions: approving the information architecture, choosing the visual direction, signing off on the final product. But the human doesn't have to do the translation work between stages. The agents speak the same language because they read the same structured handoff packages.

That's the real innovation. Not "AI can make websites" — AI has been able to generate HTML for years. The innovation is **AI agents that can collaborate on a design pipeline with the same rigor and traceability as a professional design team**, with quality gates that prevent garbage from flowing downstream.

From PRD to pixel. One pipeline. Ten agents. Zero context loss.

---

*Built with the [AGENT_VAULT](https://github.com/peb7268/AGENT_VAULT) multi-agent framework. Design pipeline powered by [Nano Banana Pro](https://deepmind.google/models/gemini-image/pro/) and [Google Veo](https://deepmind.google/models/veo/).*
