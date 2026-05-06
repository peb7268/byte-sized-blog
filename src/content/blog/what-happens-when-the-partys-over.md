---
title: "What happens when the party's over."
description: 'Token prices have been falling for two years. They will not fall forever. Here is how I am architecting agentic systems to survive the day one provider stops being economical.'
pubDate: 'May 04 2026'
heroImage: 'https://images.unsplash.com/photo-1708289312702-d39a7e77ee12?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3MzE0MDd8MHwxfHNlYXJjaHwyfHxlbXB0eSUyMHBhcnR5JTIwYWZ0ZXJtYXRoJTIwY29uZmV0dGl8ZW58MHwwfHx8MTc3Nzk4MzUxM3ww&ixlib=rb-4.1.0&q=80&w=1080'
tags: ["agentic", "economics", "optimus", "lock-in", "ai-infrastructure"]
---

For the last two years we have been at the open bar.

Token prices have been falling almost monotonically. GPT-5.4 Nano is at $0.20 per million input tokens. Gemini 2.5 Flash is at $0.15. Haiku-tier models are essentially free for the kinds of summary, extract, and classify work that makes up the bulk of any real agentic system. If you architected anything in 2024 and you priced it at 2024 token costs, your unit economics have only gotten better over time.

That trend will not continue forever. I am not predicting a crash. I am predicting that *one* provider, at *one* moment, will become uneconomical for *one* of your workloads — and you will need to migrate or eat the cost.

The party is going to end for somebody. The only question is whether your code knows how to leave.

## The first crack

Three weeks ago Anthropic shipped Opus 4.7 with a new tokenizer. The sticker price did not change. The math did. The new tokenizer is denser for some languages and sparser for others, and depending on the shape of your prompts, the same conversation now costs anywhere from 0% to 35% more per request. ([Finout's breakdown](https://www.finout.io/blog/claude-opus-4.7-pricing-the-real-cost-story-behind-the-unchanged-price-tag) is the cleanest writeup I have read.)

That is not a price increase you can see on a pricing page. It is a price increase hidden inside a model upgrade.

In the same window, Anthropic moved enterprise customers to pure usage-based billing, [removing the flat-rate ceiling](https://kingy.ai/ai/usage-based-billing-no-flat-rate-why-anthropics-2026-pricing-shift-changes-everything-for-claude-users/) that used to cap a heavy month at a known number. Simon Willison documented the [Claude Code confusion](https://simonwillison.net/2026/apr/22/claude-code-confusion/) that followed, where teams who thought they understood their burn rate found out they did not.

Meanwhile OpenAI and Google are still cutting prices. Grok is undercutting both. The provider landscape is no longer "everyone gets cheaper together." It is "some get cheaper, one quietly does not, and you find out at end of month."

This is the new normal. And it makes one architectural decision the only one that actually matters.

## The only failure mode that is strictly self-inflicted

Markets do what markets do. Models get more or less expensive. New labs ship better models at lower prices. Old labs raise prices because their costs went up or their investors got tired of waiting. None of that is in your control.

What *is* in your control is whether your code can switch.

If your application calls `anthropic.messages.create()` directly from your business logic, you do not have an architecture. You have a dependency. The day Anthropic raises prices on the workload you happen to be running, you have a migration project on your hands — and migration projects on running production systems are where good ideas go to die.

If your application calls `harness.complete(task)` and the harness picks the model, you have an architecture. The day prices move, you change one config file.

Lock-in is the only failure mode in this entire space that is strictly self-inflicted. Everything else — model quality, latency, rate limits, regional availability — is somebody else's decision. Lock-in is yours.

## What I actually built

I just shipped [Optimus](https://blog.byte-sized.io/optimus/), and the harness layer is the thing I am proudest of. Every AI feature in Optimus speaks one interface. The harness picks the model based on the task class, the cost budget, the latency target, and what is currently working. Feature code never knows which provider it is talking to. Feature code does not get to know.

That sounds like over-engineering until you remember Opus 4.7 shipped with a new tokenizer. When that happened, the only thing I had to do was retest my prompt cache hit rates and update one routing rule. No feature code changed. No tests changed. No customer noticed.

The harness layer is not a clever pattern. It is the absolute minimum bar for shipping agentic software in 2026. If you do not have one, build one. It is a weekend of work and it is the difference between "we adjust" and "we rewrite."

## Six strategies that survive a pricing event

Once you have a harness, the rest of cost engineering is tactical. Here is what is in the Optimus harness today, in roughly the order I would build them:

### 1. Cache aggressively, at every layer

Anthropic charges 10% of input rate for the cached portion of a prompt. OpenAI does something similar. If your prompts have a stable system message and a stable tool definition block — and they should — you are leaving 80%+ of your input cost on the floor by not using prompt caching.

Above that, cache your *own* retrievals. If a query returned the same five Nexus rows ten minutes ago, you do not need to re-embed and re-rerank. Stick a TTL cache in front of your retrieval layer. Cache hits cost zero tokens. Zero is a very good price.

### 2. Batch what does not need to be live

Most providers offer 50% off for the batch API. Most agentic workloads have a long tail of work that does not need to complete in 200ms — overnight summarization, daily digests, weekly rollups, anything where "by morning" is the SLA.

If you are running it through the live API, you are paying double for no reason. Move it to batch. The harness should make this trivial — same interface, different lane.

### 3. Shrink context. Always. Forever.

The single biggest lever for cost is the size of the input. Stuffing 80k tokens of context into every call because "the model can handle it" is a 2024 move. The 2026 move is embed-then-rerank: pull the 5–20 chunks that actually matter and discard the rest before the call.

This is exactly what [Nexus](https://blog.byte-sized.io/optimus/nexus/) is for in Optimus — it is the data primitive that does semantic plus structural retrieval to narrow the context to the rows that matter for *this* request. A well-tuned retrieval layer routinely cuts input tokens by 10x. That is a 10x cost reduction with no model change.

### 4. Run small models on cheap things. Escalate when needed.

The trillion-dollar tier of agentic work is multi-step reasoning chains. The vast majority of agentic work is not that. It is summarize this email, classify this ticket, extract these fields, decide which of three branches to take. Haiku-tier models do this work for an order of magnitude less money than the flagships, and they are good at it.

Reserve Opus and GPT-5 for the calls where you actually need them. The harness should know the difference. Mine does — the routing rule is "default to the cheapest model that has cleared the eval bar for this task class, escalate on retry."

### 5. Verify with cheaper models and tighter guardrails

This is where the [test-driver pattern](https://blog.byte-sized.io/optimus/test-driver/) earns its keep. If you wrap a cheap model in a strict-enough harness — schema validation, retry on malformed output, escalation to a bigger model on persistent failure — you get most of the reliability of the flagship at a fraction of the cost.

The mental model is QA, not generation. The cheap model produces the candidate output. The harness validates it. The harness decides if it shipped. The flagship is the appellate court, not the trial court.

### 6. Keep a local-LLM path warm

I do not run Ollama in production. But the Optimus harness has an Ollama adapter, and it works, and it is in CI. The reason is not that I expect to flip the switch tomorrow. The reason is that *if I had to*, I could.

That is a different posture from "we depend on Anthropic and we will figure it out if something happens." It means a 35% pricing surprise is a Tuesday-afternoon configuration change, not a quarter-long migration. The cost of keeping the door open is one adapter and a CI job. The value of having the door open is your entire business surviving a pricing event.

## What this actually buys you

Run through the worst case. Your primary provider raises prices 35% on your most expensive workload tomorrow morning.

Without a harness, that is an all-hands meeting, a migration project, a rewrite of feature code that touches the provider SDK directly, regression testing across your whole product surface, and a customer-facing pricing conversation. Probably six weeks of work and a temporary margin hit.

With a harness, plus the six tactics above, that is:

1. Run the eval suite against the cheaper alternative provider for that workload class.
2. If it clears the bar, change one routing rule.
3. If it does not, raise the cache TTL, shrink the context window further, move more of the workload to batch, and absorb the rest.
4. Move on.

Probably an afternoon. No customer notices.

That is the entire payoff. You stop being a hostage to any one provider's pricing decisions. You stop having a "what if" conversation every time a competitor's blog post mentions tokenizer changes. The conversation about pricing becomes a conversation about routing.

## The actual prediction

I do not know which provider is going to have the unhappy quarter. I do not know whether it is going to be a tokenizer change, a usage-based billing shift, a regional pricing adjustment, or just a straight rate increase. The specifics do not matter.

What matters is that *somebody* is going to do it, and the teams who built provider-agnostic systems are going to wave at the news cycle and the teams who did not are going to spend a quarter rewriting code that should never have been provider-coupled in the first place.

[BCG put the agentic-AI services opportunity at $200B](https://www.bcg.com/publications/2026/the-200-billion-dollar-ai-opportunity-in-tech-services). A lot of that revenue is going to go to teams who understand that the provider is a detail. The party is great while it lasts. Build like it is going to end.

It will.
