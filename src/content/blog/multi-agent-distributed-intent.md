---
title: 'Multi-Agent / Distributed Intent'
description: "Directing one agent is orchestration. Directing many is composition — and the moment your intent fans out across agents, behavior nobody specified starts showing up in the gaps between them. Here's how to compose intent without losing the plot."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1516434233442-0c69c369b66d'
draft: false
series: 'Agentic Engineering'
seriesOrder: 11
tags: ['multi-agent', 'intent-composition', 'agentic-governance']
hashtags: ['multiagent', 'agenticdevelopment', 'aigovernance']
---

This series started with one engineer losing the thread at step three of a delivery plan. One agent, one plan, one human trying to keep up. That was already a big enough shift — from soloist to conductor, from writing the code to [reviewing the code that is now the work](/blog/the-review-is-the-work-now/).

This is the capstone, so let me push it as far as it goes.

Because the frontier isn't one agent anymore. It's five. Or twelve. A [planner that fans work out to implementers](https://www.anthropic.com/engineering/building-effective-agents), a reviewer watching their output, a test agent gating the merge, a docs agent trailing behind — all running at once, all chewing on the same codebase, all acting on some slice of an intent you expressed exactly once, somewhere upstream.

> Directing one agent is orchestration. Directing many is **composition**. And composition is a genuinely different skill, because the thing you have to get right is no longer the agent — it's the *space between* the agents.

That space is where this post lives.

## The progression, stated plainly

It's worth naming the arc the whole series has been walking, because the last step is the one nobody's ready for:

- **Implementer.** You write the code. Your intent and the artifact are the same thing — they live in your hands.
- **Orchestrator of one.** You direct a single agent. Intent and artifact split apart; [intent becomes the thing you author](/blog/intelligence-moves-up-the-stack/), and the review is where you reunite them.
- **Conductor of an orchestra.** You direct many agents at once. Now your intent has to *decompose* cleanly enough that several agents can each take a piece without colliding — and recombine into something coherent.

The jump from one to many is not linear. With one agent, if it drifts you notice, because you're watching it. With many, drift hides. Each agent is locally correct. The bug is in the interaction — and no single transcript contains it.

## Intent composition: the actual hard part

Here's the move people underestimate. When you direct one agent, you express intent and it executes. When you direct many, you have to express intent in a form that *survives being split*.

Think about what that requires. You can't hand each agent the same paragraph and hope. You have to **decompose** the intent into pieces that are individually buildable, mutually non-overlapping, and — this is the killer — *recomposable* into the thing you actually wanted. That last property doesn't come for free. Three perfectly-built parts can still assemble into the wrong whole.

This is why [the spec stops being documentation and becomes the coordination layer](/blog/anatomy-of-a-spec/). When intent fans out, the spec is the only shared truth every agent reads. If it's ambiguous, each agent resolves the ambiguity *differently*, locally, confidently — and you get three correct answers to three slightly different questions. The shared artifact is the wrong place to be sloppy, because sloppiness there doesn't produce one error. It produces N divergent ones.

A concrete shape that works: a **single source of intent** (the spec, the delivery package, the ticket) that every agent resolves against, and **narrow, explicit contracts** at each hand-off. Not "build the API." Instead: "build the API that satisfies *this* interface, returns *these* shapes, and the consumer agent will assume exactly that." The contract is what lets you decompose without the pieces silently disagreeing about the seam.

## The patterns that actually hold

![Two precision-machined metal parts meeting at one exact interlocking seam — the contract at the seam that lets pieces decompose without silently disagreeing.](/img/multi-agent-distributed-intent/decomposition-by-contract-machined-seam.png)

After enough of these, the durable patterns are unglamorous and few.

**Decomposition by contract, not by task.** The instinct is to split work the way you'd split it for humans — by feature, by file, by ticket. That's not enough for agents, because agents won't have the hallway conversation that resolves the seam. Split by *contract*: define the interface between the pieces first, freeze it, then let each agent build to its side. The contract is the part you author by hand. The implementations are the part you delegate.

**Hand-offs are explicit artifacts, never vibes.** When agent A finishes and agent B picks up, what passes between them has to be a real, inspectable thing — a written interface, a generated file, a structured summary. The failure mode is the implicit hand-off, where B infers what A "probably meant." Inference at the seam is where [garbage in becomes gospel out](/blog/garbage-in-gospel-out/) — except now it's one agent treating another agent's half-finished assumption as ground truth, and compounding on it.

**Verification *between* agents, not just at the end.** One agent's output is another agent's input, which means a defect doesn't sit still — it propagates. So you put a check at the seam. The reviewer agent reads the implementer's output *before* the test agent builds on it. This is [trust-but-verify](/blog/trust-but-verify/) applied to the org chart of agents: every hand-off is a place a wrong assumption can enter, so every hand-off earns a gate. The verification burden doesn't go away when you add agents. It distributes — to the boundaries.

**A coordinator that holds the intent, not the work.** The thing standing in front of the orchestra doesn't play an instrument and doesn't micromanage the players. It holds the *score* — the single source of intent — and its only job is to keep the parts coherent: who owns what, what's frozen, where the seams are. When I conduct a fleet of agents, the layer I'm actually maintaining is this one. The agents do the work. I keep the intent whole.

## Emergence: the part I won't soft-pedal

![Three workers painting one wall, each to a slightly different chalk guideline that diverges where they meet — each stroke locally perfect, the whole subtly wrong.](/img/multi-agent-distributed-intent/emergence-three-diverging-guidelines.png)

Here's the thing that genuinely keeps me up, and the reason this is also pillar #5 of the governance model — **multi-agent coordination and emergence.**

When you run many agents against shared state, you get [behavior that *no single prompt specified*](https://www.anthropic.com/engineering/multi-agent-research-system). Not a bug in any one agent — an emergent property of the system. Agent A renames a thing; agent B, running concurrently, builds against the old name; the test agent, reading a third snapshot, validates against neither. Each was correct. The system produced something none of them was told to produce.

This is the qualitatively new risk, and it's why I keep insisting the skill is the space between the agents. In a single-agent world, every behavior traces back to an instruction — you can always ask "what told it to do that?" In a multi-agent world, **some behavior has no author.** It emerged from timing, ordering, and shared state. You cannot review your way to it by reading any one transcript, because it isn't *in* any one transcript. It's in the interaction.

The governance stakes scale with the autonomy. One rogue agent makes one mess you can see. A fleet of locally-correct agents can compound a wrong shared assumption across a whole codebase before any human looks — fast, confident, and uniform. The blast radius of an ungoverned multi-agent system isn't bigger than a single agent's. It's a different *category*, because the error is systemic, not local.

So the governance has to move up to match. You don't govern multi-agent systems by reviewing outputs harder — there are too many, produced too fast, and the dangerous ones aren't in the outputs anyway. You govern them by **constraining the space between agents**: freezing contracts so the seams can't drift, gating hand-offs so assumptions can't propagate unchecked, and keeping a single source of intent so divergence has somewhere to be reconciled. Emergence isn't eliminable — it's the nature of the system. But it's *boundable*. You shrink the gaps where it can hide.

## What the conductor of conductors actually does

Push the arc one more click and you get the real endgame: not directing agents, but directing *orchestrators* — agents that themselves direct agents. An orchestra of orchestras. The planner doesn't write code; it fans out to implementers who fan out to their own tool-using sub-agents. The further up you go, the less you touch any artifact and the more you do exactly one thing: **keep intent coherent as it cascades down through every layer of delegation.**

That's the whole job at the top. Not generating — generation is cheap and getting cheaper, all the way down the stack. Not reviewing line by line — there's far too much, and the failures live in the seams anyway. The scarce skill is composing an intent clean enough to survive being decomposed across many agents, then governing the spaces between them so what emerges is what you meant.

The implementer holds the code in their hands. The orchestrator holds one agent's intent. The conductor holds the whole score — and trusts the players, but verifies every hand-off.

That's where this is going. The soloist became a conductor. Now the conductor is learning to stand in front of an orchestra that, if you're not careful, starts writing its own music.

The work isn't to silence it. It's to make sure it's still playing your song.

---

If you've run real fleets of agents against a shared codebase, I'd genuinely like to compare notes — especially on where you've seen emergent behavior nobody specified, and what you did at the seams to bound it.
