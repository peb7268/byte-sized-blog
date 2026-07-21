---
title: 'Ambition → Intention → Execution'
description: "Every built thing travels the same path: from wanting it, to specifying it, to making it. Agentic development didn't change the path — it changed which step is scarce. Execution got cheap. Intention became the whole job."
pubDate: 'Jul 21 2026'
draft: true
series: 'The New Ways of Working'
seriesOrder: 7
tags: ['agentic-ai', 'intention', 'spec-driven-development', 'ways-of-working']
hashtags: ['agenticdevelopment', 'aiengineering', 'waysofworking']
---

Everything anyone has ever built travels the same three stops, in the same order.

**Ambition** — you want something. A feature, a company, a clean kitchen. It starts as a pull, a vague shape of a better state that doesn't exist yet.

**Intention** — you turn the want into a plan specific enough to act on. What exactly, in what order, meeting what bar. This is where ambition gets *pinned down* — where "I want a better onboarding flow" becomes "collect email, verify it, drop them on a checklist, skip the tour for returning users."

**Execution** — you do the work. Hands on keys, the thing gets made.

This isn't new. It's how a cathedral got built and how you make breakfast. What *is* new — and what this whole series is about — is that agentic development quietly re-weighted the three. For the entire history of software, execution was the expensive stop, the one that ate the calendar. That stopped being true. And when the cost of a stage collapses, the scarce stage becomes the one that decides everything.

> Execution used to be the bottleneck, so we optimized for it and hired for it. Agents made execution cheap and fast. The bottleneck moved upstream to **intention** — and most people haven't moved their attention with it.

## Execution fell off a cliff

Be honest about what an agent actually collapsed. It did not collapse *wanting* things and it did not collapse *deciding what good looks like.* It collapsed the middle-hours part — the typing, the boilerplate, the wiring, the "I know exactly what this should be, I just have to sit here and produce it." That was most of the job, by hours, for decades. It's the part that's now measured in minutes.

This is the same current I traced in [Intelligence Moves Up the Stack](/blog/intelligence-moves-up-the-stack/): when the machine absorbs the mechanical layer, your value doesn't disappear — it relocates to the layer above. The trap is that we spent careers building identity and craft around execution. We are *proud* of being fast at the thing that just got automated. So we keep pouring attention into a stage that no longer needs it, and starve the stage that now does all the deciding.

## The failure mode: ambition handed straight to a machine

Here's what it looks like when someone skips the middle stop. They have an ambition — "build me a dashboard that shows how the business is doing" — and they hand it, raw, to an agent. No spec. No definition of "how the business is doing." No constraints. And the agent, which is very good at execution, *executes* — confidently, immediately, on its own guess about what you meant.

You get something. It's plausible. It's also not what you wanted, and now you're debugging the gap between a vague ambition and a confident output, which is a miserable place to work. This is [garbage in, gospel out](/blog/garbage-in-gospel-out/) at the level of the whole task: an under-specified intention produces a fluent, authoritative wrong answer, and the fluency is what makes it dangerous. The agent didn't fail. *You never finished the intention,* and it filled the vacuum for you.

The reflex — the old reflex — is to blame execution and iterate on the output. Nudge the prompt, re-roll, tweak the result. But you can't patch your way out of a missing spec. The work you skipped is upstream. You have to go back and do the intention.

## Intention is the job now — so what's it made of

If intention is where the leverage moved, "just be clearer" is useless advice. Let me be concrete about what a real intention contains, because these are the things an agent cannot infer and will invent if you don't supply them:

- **The actual outcome, not the gesture at it.** "How the business is doing" is a gesture. "Weekly revenue, churn, and new signups, versus the prior week, for the last quarter" is an outcome. The specificity isn't bureaucracy — it's the difference between one build and five re-rolls.
- **The constraints that bound the space.** What it must not do, what it must use, what it must never touch. The rules an agent will otherwise decide for itself — and it *will* decide.
- **What "done" means, in advance.** The acceptance criteria you'd check against. State them before you see the output or you'll grade on a curve — the whole argument behind [eval-driven development](/blog/what-are-evals/): write the bar down while you're still honest.
- **The shared vocabulary.** The names, the conventions, the two-letter shorthand you think in — so "ship it to the usual place" actually resolves. This is its own discipline; it's why [a common vocabulary](/blog/context-is-king/) is worth teaching your system once.

Notice that none of this is execution. It's all *design of the intent* — and it's exactly the move I made the case for in [Code the Interface, Delegate the Implementation](/blog/code-the-interface-delegate-the-implementation/). You draw the box precisely; you let the machine fill it. Drawing the box *is* intention. It's the skill that used to be optional because you were going to write the code yourself anyway and could course-correct as you typed. You're not typing anymore. The box is all the agent gets.

## This is a promotion, and it feels like a demotion

The uncomfortable part: doing intention well feels slower and less productive than executing, because for your whole career "productive" *meant* executing. Sitting and specifying — with no code accumulating, no visible output — pattern-matches to procrastination. It isn't. It's the highest-leverage work you can do now, because a well-formed intention makes execution nearly free, and a sloppy one makes it infinitely expensive in re-rolls.

The people who will be most effective in agentic development are not the fastest executors — that race is over, the machine won it. They're the ones who can take a raw, fuzzy ambition and *metabolize it into a precise intention* faster and more completely than anyone else. That's a real skill, it's trainable, and almost nobody is practicing it deliberately because we're all still emotionally invested in the stage that got automated.

So the reframe I'll leave you with is small and load-bearing. When the next piece of work lands and you feel the itch to jump straight to making it — pause at the stop you're tempted to skip. Ambition is easy; everyone has ambitions. Execution is now cheap; the agent has it covered. **Intention is the whole job.** Spend your time where the leverage actually is.
