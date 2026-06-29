---
title: 'Routing: LiteLLM, OpenRouter, and Automatic Token Routing'
description: "A routing layer isn't just a cost lever — it's a resilience and independence lever. One API across every provider, easy tasks to cheap models and hard ones to strong models, and failover when a lab falls over."
pubDate: 'Jun 29 2026'
draft: true
series: 'Token Economics'
seriesOrder: 4
tags: ['model-routing', 'token-economics', 'llm-infrastructure']
hashtags: ['modelrouting', 'tokeneconomics', 'llmops']
---

Here's a bet I'll make about most teams running agents in production: their code says `claude-opus-4` or `gpt-5` in a string somewhere, hardcoded, and every single request — the trivial ones and the gnarly ones alike — goes to that one model. One provider, one model, one price, one point of failure.

That's not a strategy. That's a default that nobody got around to questioning. And it's leaving money, speed, and resilience on the table all at once.

The fix is a piece of plumbing that doesn't get talked about enough because it isn't glamorous: a **routing layer**. The two names you'll run into are **LiteLLM** and **OpenRouter**, and the thing they do sounds boring until you sit with what it actually buys you. It's the substrate that makes a real multi-model practice possible — and it's the most underrated lever in this whole series.

## What a routing layer actually is

Strip it down. A routing layer is a single endpoint that sits between your code and every model provider on the planet. Your application talks to *it*, in one consistent format. It talks to OpenAI, Anthropic, Google, Mistral, the open-weight models hosted on a dozen inference shops — whatever — and translates as needed.

**OpenRouter** is a hosted service: you point at their API, drop in one key, and you've got access to hundreds of models from one billing relationship. **LiteLLM** is the same idea you run yourself — an open-source proxy (or a Python library) that you stand up, configure with your own provider keys, and own end to end.

The shapes differ — managed convenience versus self-hosted control — but the core trick is identical: **one API, many models.** Everything good downstream flows from that one move.

## Lever one: cost — stop sending easy work to expensive models

This is the obvious win, so I'll be quick about it. Not every request needs your best model. Classifying an intent, extracting a field, summarizing a short doc, formatting some JSON — a small, cheap, fast model nails those, often at a tenth or a hundredth of the price. Your frontier model should be reserved for the work that genuinely needs frontier reasoning.

But here's the part people miss: **you can't act on that insight without a routing layer.** If every call is hardwired to one model, "send easy tasks to cheap models" is a nice idea you can't execute. The routing layer is what turns the principle into a switch you can actually throw. The savings aren't in the insight — they're in the plumbing that lets you spend the insight.

## Lever two: resilience — providers go down, and yours shouldn't with them

This is the lever that turns a cost optimization into an operational necessity.

Model providers have outages. All of them. Rate limits spike, a region degrades, a model gets deprecated out from under you, an API has a bad afternoon. If your agent talks to exactly one provider and that provider falls over, *your* product falls over. You've inherited their uptime as your ceiling.

A routing layer gives you **failover**. You declare a primary and a fallback — "try Claude; if it errors or times out, retry the same request on GPT or Gemini" — and the layer handles the retry transparently. Your application never knew there was a problem. Same request shape, different engine, no outage on your side.

That's a different category of value than saving a few cents. It's the difference between "a vendor had an incident" being a line in *their* status page versus a line in *your* postmortem.

## Lever three: independence — don't get married to one lab

This is the one I care about most, and it's the quietest.

When every line of your code names one provider, you are *locked in* — not by a contract, but by inertia. Switching means a migration. And that lock-in is exactly what kills your leverage: when a better, cheaper model ships next quarter (it will), you can't just *use* it. You have to schedule a project to adopt it.

A routing layer dissolves that. When your code talks to one neutral endpoint, the specific model behind it becomes a **config value, not an architecture decision.** A new model drops? Change a string, run your evals, ship. Anthropic raises prices or Google undercuts everyone? You re-route in an afternoon. You stay a customer of *the market* instead of a hostage to one lab.

This is the same altitude shift the rest of this series keeps circling. The model is a commodity input you should be able to swap. The routing layer is what makes "swappable" true in practice instead of true on a slide.

## How the routing decision actually gets made

"Automatic routing" sounds like magic. It isn't. It's a set of rules you choose, in roughly increasing order of cleverness:

- **Static, per-task.** The blunt and honest one: *this* job calls the cheap model, *that* job calls the strong one, because you already know which is which. Your summarizer is wired to a small model; your planning agent to a frontier model. No magic, just deliberate assignment — and it captures most of the available win.
- **Failover chains.** A prioritized list. Try A, fall back to B, then C — on error, timeout, or rate limit. This is the resilience lever expressed as config.
- **Model-picks-the-model.** A cheap, fast model reads the incoming request and classifies its difficulty, then routes easy ones to a small model and hard ones to a big one. You pay a tiny tax on every request to *decide*, in exchange for not overpaying on the bulk of them.
- **Policy-based.** Route on cost ceilings, latency budgets, context-window needs, or even data-residency rules. "Anything over 100K tokens goes to the long-context model." "This tenant's data never leaves these providers."

You don't need the fancy end. Most teams capture the lion's share with static per-task routing plus a failover chain. That's a weekend of work, not a research project. Be suspicious of anything that demands the difficulty-classifier before you've done the boring deliberate version — it's the [same-way-twice](/blog/the-same-way-twice/) trap, automating a decision before you've made it by hand enough times to know the rule.

## The tradeoffs, honestly

A routing layer is not free, and I'd be selling you something if I pretended otherwise.

**You add a hop.** Every request now passes through one more component. A hosted router like OpenRouter adds real network latency; a self-hosted LiteLLM proxy adds less but still adds an operational thing you have to keep alive. For latency-sensitive paths, measure it.

**You add a dependency.** With OpenRouter, you've traded "depends on one model provider" for "depends on OpenRouter" — better, because *they* handle the multi-provider failover, but it's still a third party in your critical path. With LiteLLM you own that uptime yourself, which is more control and more pager.

**The abstraction leaks.** "One API for every model" is mostly true and occasionally a lie. Providers differ on tool-calling formats, structured-output guarantees, prompt-caching semantics, and how they count tokens. The router smooths the common path; the edges still poke through. A prompt tuned for one model is not automatically optimal on its fallback — which is the whole reason you don't get to skip evaluating the swap.

**More config, more ways to be wrong.** A silent fallback to a weaker model can quietly tank your output quality while everything looks "up." Route, but [trust but verify](/blog/trust-but-verify/) — instrument which model actually served each request, and watch quality per route, not just latency and cost.

## The plumbing under the practice

Everything else in this series — sending cheap work to cheap models, keeping a frontier model for the hard 10%, treating the model as a swappable commodity — assumes one thing that nobody says out loud: that you *can* move work between models without rewriting your app. The routing layer is what makes that assumption true.

It's not the exciting part. It's the pipe. But [orchestration](/blog/orchestration/) of multiple models is a fantasy until the pipe exists, the same way a kitchen is a fantasy until someone runs the plumbing. LiteLLM and OpenRouter are that plumbing. Put it in early, while you've still got one model hardcoded in one place — because the longer you wait, the more strings there are to find and change, and the more that one default quietly becomes your architecture.
