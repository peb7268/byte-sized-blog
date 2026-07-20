---
title: 'Code the Interface, Delegate the Implementation'
description: "The interface is intent made precise and verifiable. The implementation is the cheap, fungible part now. Here's the working pattern: you write the contract, the agent fills in the body."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1542621334-a254cf47733d'
draft: false
series: 'The New Ways of Working'
seriesOrder: 5
tags: ['agentic-ai', 'interface-design', 'software-craft']
hashtags: ['agenticdevelopment', 'aiengineering', 'softwaredesign']
---

There's a move I keep watching good engineers make with agents, almost without naming it, and there's a move I keep watching everyone else fail to make. The difference between them is the whole game right now, so let me name it.

The good ones don't ask the agent to build a feature. They write the **interface** — the function signature, the types, the contract, the test that has to pass — and then they hand the *inside* of the box to the agent. They draw the box; the agent fills it.

The everyone-else version is vibe-prompting: "build me a service that reconciles the trade blotter against the custodian feed and flags the breaks." That's a wish, not a contract. And a wish gets you a plausible-looking blob you now have to reverse-engineer to trust.

So here's the pattern I want to make explicit, because once you see it you can't unsee it:

> **Code the interface. Delegate the implementation.** You own the shape of the thing — the boundary, the names, the types, the acceptance criteria. The agent owns the body. The boundary is where your judgment lives now. The body is fungible.

![A hand drafting a precise rigid frame while an agent fills in the interior — you draw the seams, the agent pours the concrete.](/img/code-the-interface/draw-the-box.png)

## The boundary was always the expensive part

We've had this backwards for a while, and AI just made the backwardness obvious.

For most of software history, typing the implementation *felt* like the work because it took the most hours. But the hours were never where the value was. The value was always in the decisions encoded at the **boundary** — what this function promises, what it refuses, what shape the data takes, what "correct" means. The body was just the cost of cashing those decisions out into syntax.

When I wrote that [intelligence moves up the stack](/blog/intelligence-moves-up-the-stack/), this is the concrete, hands-on-keyboard version of it. The thing that climbed the stack is *exactly* this: the boundary stays with you, and the body — the cheap, mechanical translation of a contract into a working block of code — falls to the agent. Generation got cheap. Specification did not — that gap is the whole premise behind [spec-driven development](https://developer.microsoft.com/blog/spec-driven-development-ai-native-engineering/), the pattern frontier teams are converging on. The interface is the specification at the smallest possible scope.

And it ties straight back to the [anatomy of a spec](/blog/anatomy-of-a-spec/): a spec **is** an interface. A type signature is a spec the compiler can check. A test is a spec the runtime can check. An acceptance criterion is a spec a human can check. They're the same artifact at different altitudes — a promise written down precisely enough that something other than your good intentions can verify it was kept.

## What "code the interface" actually looks like

Let me get concrete, because this drowns in abstraction otherwise.

Say I need that blotter reconciliation. The vibe-prompt version hands the agent the goal and prays. The interface-first version hands the agent a box with very hard walls:

```typescript
// I write this. All of it. By hand.
type Trade = { id: string; symbol: string; qty: number; ts: Date };
type CustodianRecord = { ref: string; symbol: string; qty: number; settledTs: Date };
type Break = { trade: Trade; reason: 'MISSING' | 'QTY_MISMATCH' | 'STALE' };

// The contract. The agent must satisfy this signature, no other.
function reconcile(
  trades: Trade[],
  custodian: CustodianRecord[],
  asOf: Date
): Break[];
```

Then I write the cases that pin down what `reconcile` *means* — not as an afterthought, as the actual specification:

```typescript
// A trade with no matching custodian record is MISSING.
// A match with differing qty is QTY_MISMATCH.
// A custodian record settled after asOf is STALE, not a break.
// Same symbol, same qty, settled on time -> no break.
```

I have now done the hard part. I've decided what a `Break` is, that `STALE` is a *category* rather than an error, that `asOf` is a parameter and not `Date.now()` buried inside. Those are judgment calls with consequences, and they're all visible at the boundary. *Then* I tell the agent: make these pass. Fill the box.

What I did **not** do is describe the loop, the lookup map, the comparison. I don't care. Three different implementations that all turn the tests green are equivalent to me, and I'll take whichever the agent produces. That's what I mean by the body being fungible — it's interchangeable precisely because the interface constrains it from every side that matters.

## Why this beats vibe-prompting, every time

![A chaotic slot machine with spinning reels transforming into a clean deterministic machine that emits one fixed shape every time — turning a slot machine into a function.](/img/code-the-interface/slot-machine-to-function.png)

It comes down to one word: **verifiable**.

When you vibe-prompt a whole feature, you get output you can only check by reading all of it and reconstructing what the agent must have been thinking. I've written about why that's the trap — [the review is the work now](/blog/the-review-is-the-work-now/), and a sprawling, unconstrained generation makes the review maximally expensive. You're auditing a stranger's reasoning across hundreds of lines with no anchor.

When you code the interface first, you've pre-positioned the verification. The signature won't compile if the agent returns the wrong shape. The tests fail loudly if the behavior drifts. The acceptance criteria you wrote are the rubric you grade against. You moved the checking *upstream of the generation* — you decided what "right" means before the agent got a vote. This is [trust but verify](/blog/trust-but-verify/) with the verify part built into the structure instead of bolted on after, with your fingers crossed.

There's a determinism payoff too. One of the quiet miseries of vibe-prompting is that you never get [the same way twice](/blog/the-same-way-twice/) — ask for the feature on Monday and Thursday and you get two different architectures, two different naming schemes, two different sets of assumptions. The interface is the fixed point. When *you* own the signatures and the types, the agent's freedom is fenced into the body, where variation is harmless. The shape is stable because you authored the shape. You've turned a slot machine into a function.

And it scales down as well as up. The unit can be a single function, or it can be a module boundary — a set of public methods, the events a service emits, the schema of a queue message. Same discipline at every grain: **you draw the seams of the system, the agent pours concrete inside them.** The seams are the architecture. The concrete is commodity.

## The failure mode, so you can catch yourself

The way this goes wrong is subtle, and I've done it: you write a *thin* interface and call it done. `function process(data: any): any`. That's not an interface, that's a shrug with a name. You've delegated the implementation *and* the design, and the agent will happily invent both — which puts you right back to reverse-engineering a stranger's choices.

The discipline is that the interface has to carry real information. Precise types, not `any`. Named cases, not booleans you'll misread in six months. Tests that encode the *edges*, because the edges are where intent actually hides — the stale record that isn't a break, the empty input, the duplicate. If your interface doesn't pin down the hard cases, you haven't specified anything; you've just moved the vibe-prompt behind a function name.

Here's the tell: if you can't write the failing test, you don't yet understand the thing well enough to delegate it. That's not the agent's problem to solve. That's the part that's still yours.

## The division of labor, stated plainly

So the working split, the one I'd put on the wall:

- **You write:** the signatures, the types, the contracts, the acceptance criteria, the tests that pin the edges. The boundary. The intent, made precise enough to check.
- **The agent writes:** the body that satisfies all of it. The mechanical translation. The fungible part.

This isn't a productivity hack you bolt onto the old way of working. It's a reallocation of where your attention goes — the same migration this whole series keeps circling. Less time spent typing the inside of boxes; more time spent deciding, precisely, what the boxes are. The interface is intent you can verify. The implementation is a detail you can buy by the yard.

Draw the box well and the agent can't get the feature wrong in any way that matters. Draw it badly — or skip drawing it and just describe the vibe — and no amount of model capability saves you, because there was never a definition of right to hit.

Code the interface. Delegate the implementation. The shape is the work now.
