---
title: 'Trimming Token Cost'
description: "Most teams overpay for agents by default — re-sending the same context, running a flagship model on trivial work, and stuffing the window with junk. Here are the levers that cut the bill without cutting quality."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1558540491-9a69d75ebab4'
draft: true
series: 'Token Economics'
seriesOrder: 3
tags: ['token-economics', 'context-engineering', 'cost-optimization']
hashtags: ['aiengineering', 'tokeneconomics', 'contextengineering']
---

Most teams I talk to treat their agent bill the way they treat their cloud bill in year one: as a fixed cost of doing business, a number that shows up at the end of the month and gets shrugged at. It isn't fixed. It's a *frontier* — a curve where cost and quality trade against each other — and almost everyone is sitting well above the curve, paying more than they need to for output that isn't any better for the extra spend.

That's the thing I want to make concrete here. There's a popular instinct that cutting token cost means accepting worse results — that you're trading quality for thrift. Sometimes. But the biggest savings on the table cost you *nothing* in quality, and a few of them actually make the output **better**. The waste and the slop come from the same place. Trim one and you trim the other.

Let me walk the levers, roughly in order of how much they move the needle.

## Lever 1 — Context discipline (the one that pays twice)

![Pruning shears trimming an overgrown bundle of files down to two clean labeled sheets, the clippings falling away as glowing wasted tokens — less junk, cheaper and sharper.](/img/trimming-token-cost/context-discipline-pruning-shears.png)

If you read [Garbage In, Gospel Out](/blog/garbage-in-gospel-out/), you already know the failure mode: dump a pile of files into the window, expect structured output, get slop. What I didn't dwell on there is that the same pile is also burning money. Every irrelevant file you load is tokens you pay for on *every turn it stays in the window* — and tokens the model has to wade through to find the signal you actually care about.

This is why context discipline is the single highest-leverage cost lever, and the only one that pays twice. The forthcoming *Context Is King* makes the full case for treating context as the medium of the work, but the cost angle stands on its own: **less junk in the window means fewer tokens spent AND a higher chance of the right answer.** A tight, curated folder is cheaper than a fat one and produces better output than a fat one. You are not trading cost against quality here. You're buying both with the same move.

The practical version: before you fire a task, ask what it actually needs. The two files that matter, the interface contract, the one example of the pattern you want followed. Leave out the forty that don't. People reach for "more context, just in case" because it feels safe. It isn't safe — it's expensive *and* it dilutes the signal. The discipline of loading less is the cheapest performance win you'll ever get, and the bill drops as a side effect.

## Lever 2 — Cache the stuff that doesn't change

A surprising fraction of what you send an agent is identical turn after turn: the system instructions, the project's ground rules, the big reference doc, the coding standards. Re-sending that block every single turn means re-paying to process the same pages over and over, all session long. At one message it's nothing. At ten thousand it's a line item.

**Caching** is telling the system "this part didn't change — reuse it." Done right, the model only processes the *new* pages each turn instead of re-reading the whole folder from scratch, and you pay a [steep discount on the cached portion](https://platform.claude.com/docs/en/build-with-claude/prompt-caching). The latency drops with the cost, which is a nice bonus.

The catch is that caching rewards *stability of layout*. Caches key off a stable prefix — keep the unchanging material in a consistent place at the front and let the volatile stuff (the current question, the latest tool output) live at the back. Shuffle the stable block around between turns and you bust your own cache and pay full freight. So the move isn't just "turn on caching," it's "structure the window so the unchanging parts *can* be reused." Most modern harnesses do a version of this automatically once you stop moving the furniture around.

## Lever 3 — Right-size the model

![A brass manifold with a wide-open cheap valve passing a stream of small identical parts and a smaller premium valve gated for one large complex gear — route flow by the size of the job.](/img/trimming-token-cost/right-size-model-valve-manifold.png)

This is the one teams resist hardest, and it's pure money left on the table. There's a reflex to run the most capable model on everything, because why would you want a *worse* model? But most agentic work isn't one hard problem — it's one hard problem wrapped in a dozen trivial ones. Classifying an intent. Extracting a field. Renaming variables. Summarizing a diff. Reformatting JSON. None of that needs your flagship, and the flagship can cost an [order of magnitude more per token](https://epoch.ai/data-insights/llm-inference-price-trends) than a small fast model that does those jobs perfectly.

Right-sizing means matching the model to the *subtask*, not the project. Use the cheap, fast model for the cheap, mechanical work — the parsing, the routing, the boilerplate — and reserve the strong, expensive model for the place where judgment actually lives: the architecture call, the gnarly debug, the review. The skill is being honest about which is which. A lot of work that *feels* like it needs the big brain is really pattern-shaped, and a small model nails it for a tenth of the price.

You don't even have to choose globally. A well-built pipeline routes per-step: small model drafts and classifies, big model decides and reviews. That's not a downgrade. That's spending your premium tokens *where they buy something* instead of spreading them evenly over work that doesn't care.

## Lever 4 — Prune the history before it prunes you

Long-running sessions have a quiet tax: the conversation itself. Every turn, the entire back-and-forth gets re-sent, so a session that's been running for an hour is dragging an hour of transcript behind it — paid for, again, on every new turn. Worse, most of that history is dead weight. The exploratory dead-ends, the tool output you already acted on, the file you read and moved past — none of it needs to ride along forever.

The fix is **summarization and pruning**: periodically compress the long tail of the conversation into a tight summary of what matters — decisions made, current state, open threads — and drop the raw transcript that produced it. You keep the *conclusions* and shed the *deliberation*. The window stays lean, the cost-per-turn stops climbing, and as a bonus the model stops getting distracted by stale pages it no longer needs. A bloated history isn't just expensive; it's a slow leak of attention. Pruning plugs both.

## Lever 5 — Stop re-sending what hasn't changed

This one rhymes with caching but it's broader, and it's mostly a workflow habit. Watch how people actually use agents and you'll see them re-paste the same file three times in a session because they tweaked one line. Re-attach the whole spec to ask a follow-up. Re-run a task from scratch because it's easier than figuring out what changed.

The discipline is to send *deltas*, not full re-loads. If the model already has the file and you changed five lines, hand it the five lines, not the file. If you're iterating on a doc, point at the section, not the whole thing. This connects to a theme I keep circling in [The Same Way Twice](/blog/the-same-way-twice/): the leverage comes from systems that do the disciplined thing *automatically*, so the hundredth task is as lean as the first. A pipeline that tracks what the agent already has and ships only what's new will quietly save you more than any heroic one-off optimization, because it never forgets to.

## Walking the frontier on purpose

Here's the reframe. None of these levers is "use AI less" or "accept worse answers." Every one of them is about **not overpaying by default** — and the default, for most teams, is steep overpayment dressed up as thoroughness.

Context discipline buys you cost *and* quality at once. Caching and delta-sending kill the dumbest waste, the same material billed over and over. Right-sizing puts your expensive tokens where judgment actually lives. Pruning keeps a long session from quietly bleeding. Stack them and the bill can fall by more than half with the output holding steady or improving.

The mental shift is to stop treating the bill as a fixed cost and start treating it as a curve you choose a point on. Every wasted token is a decision you didn't make on purpose. Make it on purpose. That's the whole discipline of token economics: walk the cost-quality frontier deliberately, instead of camping above it and calling the overpayment the price of doing business.
