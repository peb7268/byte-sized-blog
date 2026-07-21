---
title: 'Measuring Agent Spend Over Time'
description: "You can't manage what you can't see. Before you optimize a single token, you need to know where the money goes — by session, by user, by agent, by model. Here's how to actually measure it."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1458007683879-47560d7e33c3'
draft: true
series: 'Token Economics'
seriesOrder: 1
tags: ['token-economics', 'observability', 'cost-management']
hashtags: ['tokeneconomics', 'aiengineering', 'llmops']
---

A leader I work with asked me a simple question about our agent fleet: *"What did that cost us last month?"* I didn't have an answer. Not a fuzzy one, not a ballpark — nothing. We were running dozens of agents across a dozen people, burning through millions of tokens a day, and the honest reply was a shrug and a promise to "look into it."

That shrug is the most expensive thing in this entire series. Because everything else I'm going to write about — caching, model routing, context discipline, knowing when a cheaper model does the job — is downstream of one prerequisite most teams skip:

> You cannot manage what you cannot measure. And almost nobody measuring agent spend is measuring it at the resolution that lets them actually *do* anything about it.

So this is the foundation post. Not the clever optimization. The boring, load-bearing one: **how to see what your agents are spending, over time, at a resolution that supports a decision.** Get this wrong and every later move in the series is guesswork dressed up as strategy.

## The dashboard number is a trap

![One glowing monthly-total number sealed under a bell jar with no knobs, while four dark unplugged gauges sit beside it — the dashboard number you can't turn.](/img/measuring-agent-spend/dashboard-number-trap-gauges.png)

Here's the first thing teams do, and why it fails them. They open the provider's billing dashboard, see a monthly total, and call it observability. *"We spent $4,200 on Anthropic in May."* Great. Now answer any question that matters:

- Which **agent** drove it?
- Which **user** drove it?
- Was it your planning agent's giant context loads, or a thousand tiny cheap calls?
- Did it go *up* week over week, and why?
- Which **model** ate the budget — and was it the right model for that work?

The monthly aggregate can't answer a single one of those. It's a smoke alarm that only tells you the house is on fire after it burns down. A total with no dimensions isn't a metric — it's a feeling. The whole game is **resolution**: the same dollar figure sliced by *session, user, agent, and model, over time.* Those are the four axes that turn "we spent a lot" into "the review agent's model choice is costing us $900 a month and a cheaper one would do."

## What you actually need to capture

Before *where* the data lives, get clear on *what* a useful record contains. For every meaningful unit of work — call it a turn, a call, a session, pick your grain — you want to capture, at minimum:

- **Input tokens** — what you sent. This is usually the silent majority of the bill, because context is fat and re-sent constantly.
- **Output tokens** — what the model generated. Priced higher per token, but often the smaller number.
- **Cached tokens** — input you didn't pay full freight for because the provider reused it. If you're not tracking this separately, you're blind to your [single biggest lever](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) (more on that in a later post).
- **Cost** — the actual dollars, computed from the above against that model's price card. Tokens are the physics; cost is the language your leadership speaks.
- **The dimensions** — timestamp, model id, and whatever tags let you attribute the spend: which agent, which user, which task or ticket.

That last bucket is the one people under-invest in and regret. **Tokens without attribution are trivia.** Knowing you burned 40M tokens tells you nothing actionable. Knowing your `planner` agent burned 40M tokens on input context for one user across three sessions tells you exactly where to go look. Capture the dimensions or you're collecting numbers you can't act on.

## Where the data actually lives

There are three places to get this, and they sit on a spectrum from "free but crude" to "rich but you have to build it." You'll probably use more than one.

**1. The transcripts / JSONL logs.** Most agent harnesses — Claude Code included — write a structured log of every session to disk, and those records carry per-turn token counts (input, output, cached) right there in the events. This is the cheapest possible starting point: the data already exists, on your machine, right now. A small script that walks the JSONL files and sums tokens by session gets you from zero to *something* in an afternoon. The catch is that it's local, per-machine, and after-the-fact — great for "what did *I* spend," weak for "what did the *team* spend this week" without somewhere central to ship it.

**2. A proxy layer.** This is the grown-up version. You route every agent call through a gateway — an **OpenRouter**, a **[LiteLLM](https://docs.litellm.ai/docs/)** layer, or your own thin proxy — and it logs every request centrally, with whatever tags you attach. Now you have one place that sees *all* traffic, from every user and every agent, in real time, and you can decorate each call with metadata (user, agent, ticket) the providers never know about. This is the move that makes "spend by user by agent over time" a query instead of a forensics project. It's more setup, but it's the difference between observability and archaeology.

**3. The provider dashboards.** Don't dismiss them — they're the ground truth for *billing*. When your homegrown numbers and the invoice disagree, the invoice wins, and you'll want the provider's view to reconcile against. But treat them as the **audit trail, not the instrument panel.** They tell you what you were charged. They don't tell you why, by whom, or for what — and they lag.

The pattern I'd push you toward: a proxy for live, dimensioned visibility; the JSONL logs as a local fallback and a sanity check; the provider dashboard as the reconciliation backstop. Belt, suspenders, and the receipt.

## Watch it over time, or you're just taking snapshots

![A hand pinning a rising trend-line strip chart onto a workbench beside a pile of discarded single-number Polaroids — the moving film beats the still snapshot.](/img/measuring-agent-spend/spend-trendline-vs-snapshots.png)

The word *over time* in the title is doing real work. A single number — even a beautifully dimensioned one — is a photograph. What you want is the film.

Spend per session is noisy and individually meaningless. Spend per agent **trending week over week** is a signal: a line creeping up is a context window quietly bloating, a prompt that grew, a model that got swapped. The questions that change behavior are *differences*, not levels. "Why did the review agent's cost-per-run double after Tuesday?" is answerable and actionable. "We spent $4,200" is neither. Whatever you build, build it so you can put a **trendline** on each dimension. The anomaly you catch in week two is the four-figure surprise you don't get in month two.

And this connects to a discipline I keep coming back to elsewhere in my writing. In [Trust, but Verify](/blog/trust-but-verify/) the point was that you don't get to assume the agent did the right thing — you confirm it. Cost is exactly the same muscle pointed at the bill: don't *assume* your spend is reasonable, *verify* it against data. And in [The Same Way Twice](/blog/the-same-way-twice/) I argued that reliability comes from making the work repeatable rather than artisanal. Measurement is what makes cost repeatable too — when every run is logged the same way, every dimension the same way, you can compare run to run honestly. An unmeasured pipeline can't be a reliable one, because you can't even tell when it regressed.

## Visibility first, cleverness later

I'll spend the rest of this series on the satisfying stuff — the caching wins, the model routing, the context engineering that cuts input tokens in half. (A lot of it leans on context discipline; the *Context Is King* piece elsewhere in my writing lays that groundwork.) But every one of those moves is an *optimization*, and you cannot optimize what you cannot see. Worse, if you start cutting before you measure, you won't know whether your clever change helped, hurt, or did nothing — you'll just have a new shrug.

So here's the whole post in one line: **build the gauge before you touch the throttle.** Capture input, output, and cached tokens plus cost. Tag every record with session, user, agent, and model. Get it from your transcripts today and your proxy tomorrow, reconcile against the provider, and chart it over time.

Do that, and the next time a leader asks "what did that cost us last month," you don't shrug. You pull up the trendline and point at the exact agent, the exact model, the exact week. That answer is where token economics actually begins. Everything else is downstream of being able to see.

How are you measuring your agent spend right now — dashboard, logs, proxy, or honestly nothing yet? I'd like to compare notes, especially with anyone who's wired up per-agent attribution cleanly.
