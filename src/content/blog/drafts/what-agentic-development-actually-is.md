---
title: 'What Agentic Development Actually Is'
description: "Everyone says 'agentic' and nobody defines it. Here's the line that actually separates it from chat, copilot, and autocomplete — the agent takes multi-step action, in a loop, against a goal you set."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1556009756-5a06dce4729d'
draft: true
series: 'Agentic Foundations'
seriesOrder: 2
tags: ['agentic-ai', 'fundamentals', 'developer-workflow']
hashtags: ['agenticdevelopment', 'aiengineering', 'softwareengineering']
---

# Agency

**/ˈā-jən-sē/** · *noun*

## *The capacity to take action toward a goal on your behalf — to plan, act, observe the result, and adjust, without being told each step.*

When we say a **person** has agency, we mean something older and deeper than any product feature: the capacity to act independently in the world — to make your own choices, pursue your own goals, and own the consequences. Philosophers and sociologists break it into three parts — **intentionality** (you set the goal), **autonomy** (you act without being controlled), and **self-reflection** (you weigh what happened and adjust). [Merriam-Webster](https://www.merriam-webster.com/dictionary/agency) strips it to the root: *"the capacity, condition, or state of acting or of exerting power."*

The whole story of agentic development is what happens when we hand a slice of that capacity — deliberately, and against a goal we set — to a machine.

---

I keep writing about what changes when agents take over execution — that your value moves up to judgment, that intent becomes the artifact, that [the review is the work now](/blog/the-review-is-the-work-now/). And a fair reader could stop me three sentences in and ask the question the whole series quietly skips:

**What do you actually mean by "agentic"?**

It's the most overused word in software right now. Every IDE, every chat box, every autocomplete plugin slapped "agentic" on its landing page the week the term got hot. The word has been stretched so thin it's nearly meaningless. So before the rest of this series builds on it, let me plant the flag and say the thing out loud. This is the start-here post. If "agentic" feels like a buzzword to you, good — that instinct is correct about most of what's marketed under it. Here's the part that isn't.

## The one-line definition

Agentic development is when **the AI takes multi-step action with tools, in a loop, with autonomy, against a goal you set** — instead of handing you turn-by-turn suggestions you accept or reject.

That's it. Read it again, because every word is doing work, and most "AI coding" products fail the test on at least one of them. **Action**, not suggestion. **Tools**, not just text. **A loop**, not a single turn. **Autonomy**, not your hand on the wheel for every keystroke. **A goal**, not a prompt for the next line.

The shift it describes is small to say and enormous to live: from *"AI helps me type faster"* to *"AI executes; I direct and verify."*

## The ladder

![A rustic four-rung wooden ladder ascending against open sky, the top rung catching the light — the climb from autocomplete to agentic.](/img/what-agentic-development-actually-is/the-ladder-four-rungs.png)

The cleanest way to see what's new is to climb the ladder of how AI has actually sat next to developers, rung by rung. Each rung adds exactly one capability, and the top rung is a different job.

**Rung 1 — Autocomplete.** The oldest. You type, it predicts the rest of the line or the next few. Tab to accept. It has no idea what you're building; it's pattern-completing the local text. The unit of help is *characters*. You are doing 100% of the thinking and roughly 100% of the deciding — it just saves keystrokes. Useful. Not agentic. Not close.

**Rung 2 — Chat.** Now there's a model you can actually talk to. You describe a problem, it writes back a function, an explanation, a snippet. This is a genuine leap — it reasons, it can hold a thread — but notice the shape: it's a *conversation*. The model produces text. *You* are still the one who reads it, decides if it's right, copies it, pastes it into the file, runs it, and reports back what happened. The model can't touch your world. The unit of help is *answers*, and you are the hands, the runtime, and the feedback loop.

**Rung 3 — Copilot.** Chat, but in the editor, aware of the file you're in and sometimes the wider project. It suggests whole blocks, it can be pointed at a selection. Better context, tighter fit. But it's still fundamentally **suggestion-shaped**: it proposes, you dispose, one turn at a time. It doesn't go off and *do* a sequence of things on its own. The unit of help is *blocks you approve*. You're still soloing — you just have a very good section-mate feeding you parts.

**Rung 4 — Agentic.** This is the rung where the shape changes, not just the quality. You hand it a *goal* — "add rate limiting to the public API and cover it with tests" — and it goes and *does* it. It reads files. It writes files. It runs the test suite. It reads the failures. It edits and runs again. It greps for the call sites it missed. It doesn't come back to you per line; it comes back when it's hit the goal, hit a wall, or hit a decision it shouldn't make alone. The unit of help is no longer characters, answers, or blocks. It's **outcomes**.

The first three rungs are all the same job with better tooling: *you write the software, the AI assists.* The fourth rung is a different job: *the AI writes the software, you direct and verify it.* That's the discontinuity. Everything I write about agentic engineering lives on rung 4, and almost all of the confusion in the discourse is rung 3 wearing rung 4's branding.

## What an agent actually does

![A closed circular loop of four stations — planning notes, a hand using a tool, an eye watching a result, and an arrow feeding back — plan, act, observe, iterate.](/img/what-agentic-development-actually-is/agent-loop-plan-act-observe.png)

The word "autonomy" makes people picture something mystical. It isn't. An agent runs a [dead-simple loop](https://www.anthropic.com/engineering/building-effective-agents), and once you see it you can't unsee it:

1. **Plan.** Given the goal, decide the next step. Not the whole plan carved in stone — the *next move*.
2. **Act.** Call a tool to make it real. Read a file. Run a command. Write a diff. Hit an API. Tools are the hands; without them you're back on rung 2, a brain in a jar producing text.
3. **Observe.** Look at what happened. The test output. The compiler error. The contents of the file it just opened. This is the part chat structurally *cannot* do — it has no eyes on the result.
4. **Iterate.** Feed that observation back in and decide the next step. Loop until the goal is met or it's genuinely stuck.

Plan, act, observe, iterate. That loop is the entire ballgame. The "intelligence" people attribute to agents is mostly just this: a model that can *see the consequence of its last action and adjust*. Autocomplete can't see anything. Chat sees only what you paste. Copilot sees your file but doesn't act-then-look. An agent closes the loop — and closing the loop is what lets it cross the gap from "produces plausible code" to "produces code that actually passes."

The tools are what make it real. A model with no tools can only ever talk. Give it the ability to run the test suite and *read the result*, and the difference is night and day: it stops handing you code that looks right and starts handing you code it has watched succeed. The autonomy isn't that it decides *what you want* — you set the goal. The autonomy is that it decides the dozens of small *hows* in between without making you adjudicate each one.

## Why the distinction earns its keep

This isn't pedantry. The rung you're actually on determines what skill matters, and getting it wrong means practicing the wrong thing.

On rungs 1 through 3, the scarce skill is **generating** — knowing the code, typing it well, choosing the right block from the suggestions. The AI is an accelerant on a job you're still doing. On rung 4, generation is cheap and getting cheaper, and the scarce skill moves entirely: it becomes **specifying the goal precisely** and **verifying the outcome rigorously**. The work climbs the stack from authoring to directing — which is the whole argument behind [intelligence moving up the stack](/blog/intelligence-moves-up-the-stack/), and exactly why I keep saying [the review is the work now](/blog/the-review-is-the-work-now/). When the agent does the typing, your leverage is no longer in the keys. It's in the goal you set and the judgment you apply to what comes back.

Get this wrong and you get the failure mode I've called the [easy-bake-oven developer](/blog/easy-bake-oven-developers/) — someone who treats rung 4 like a fancier rung 3, dumps an under-specified goal into the box, and is baffled when the outcome is slop. The agent did exactly what an agent does: it executed against the goal it was given. The goal was just garbage. On a suggestion tool that doesn't hurt much; you reject the bad suggestion and move on. On an action tool that runs a loop, a vague goal means it confidently *does* the wrong thing across fifteen files.

## Start here

So here's the ground floor the rest of this series stands on. Agentic development isn't autocomplete that got smart, or chat that moved into your editor. It's a **categorical** change: the AI stops suggesting and starts *acting* — planning, calling tools, observing results, and iterating in a loop until it hits a goal you defined.

Your job changes shape to match. You're not the author with a faster keyboard anymore. You're the one who sets the goal, supplies what the agent needs to hit it, and verifies what comes out. The soloist becomes the [conductor](/blog/orchestration/).

Everything else I write about agentic engineering assumes this rung. Now it's stated outright. The next move is the one the whole thing actually runs on — what you feed the agent so the loop produces signal instead of slop. That's context, and it gets its own post.
