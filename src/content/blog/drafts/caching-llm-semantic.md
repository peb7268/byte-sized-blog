---
title: 'Caching: Prompt, LLM, and Semantic'
description: "Agents re-read the same context on every turn and re-answer the same questions all day. Three kinds of caching kill that waste — but each one has a failure mode that quietly serves you the wrong answer."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d'
draft: true
series: 'Token Economics'
seriesOrder: 5
tags: ['token-economics', 'caching', 'agentic-ai']
hashtags: ['agenticdevelopment', 'aiengineering', 'tokeneconomics']
---

The rest of this series has been about not paying for the same work twice. [The Same Way Twice](/blog/the-same-way-twice/) made the case at the workflow level: if you can't reproduce the run, you can't economize on it. This post takes that idea down to the metal, where it has a name and a line item — **caching**.

Here's the thing nobody tells you when you start building with agents: an agentic loop is the single most repetitive thing you will ever attach to a language model. Same system prompt, every turn. Same project rules, every turn. The same questions, asked a dozen different ways by a dozen different people across a week. A naive agent re-reads its entire world and re-derives every answer from scratch, forever, and you pay full freight each time.

Caching is how you stop. But "caching" isn't one thing — for agents it's three, stacked at different layers, with different savings and different ways to bite you. Let me take them in order, from the one you should turn on today to the one you should be nervous about.

## Layer 1 — Prompt caching: stop re-paying to read the same folder

Start with the cheapest win, because it's almost free and most people leave it on the table.

Recall the manila folder from the context window (the *Context Is King* post in this series, forthcoming, lays this out in full). Every turn, you hand the model a folder: system instructions, project rules, the big reference doc, then today's actual question. The first three are **stable** — they're byte-for-byte identical turn after turn. The model doesn't know that. By default it reads the whole folder from scratch every single turn, and you pay to process every one of those tokens again.

**Prompt caching** — sometimes called prefix caching — tells the system: *this front portion of the folder didn't change, reuse the work you already did on it.* The model keeps the processed state of that stable prefix and only does fresh work on the new pages at the end. You're not re-paying to re-read the rules; you're paying to read the one new question.

The savings are not marginal. Cached input tokens typically run a fraction of the price of fresh ones — [on the order of a 90% discount on the cached portion](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) — and the latency drop is just as real, because processing the prefix was a chunk of the wait. For an agent that loops twenty times against the same 10,000-token preamble, that's the difference between paying for 200,000 tokens of preamble and paying for it roughly once.

The catch is a discipline, not a danger: **caching keys off an exact prefix match.** Change one token near the top of the folder — inject a timestamp, reorder the rules, splice today's date into the system prompt — and the cache misses from that point on. Everything after the change is now "new." This is the operational payoff of the lesson from *Context Is King*: structure the folder so the unchanging parts sit up front and actually stay unchanged. The volatile stuff — the user's current message, fresh tool output — goes at the *end*. Get that layout right and the tooling rewards you automatically. Get it wrong by sprinkling variability through the preamble and you've quietly disabled the cheapest optimization you have.

This layer has essentially no correctness risk. The cached content *is* the content. You're reusing computation over identical bytes. Turn it on, lay out your context with the stable stuff first, and move on.

## Layer 2 — Response caching: don't re-answer the identical question

![A librarian's hand pulling a pre-written answer card from a drawer instead of re-typing it — but the card carries a small red date stamp reading old. The staleness gotcha.](/img/caching-llm-semantic/response-cache-stale-date-stamp.png)

The next layer up stops re-running the model entirely.

Prompt caching still calls the model — it just makes the call cheaper. **Response caching** (the LLM-output cache) skips the call. You hash the full request, and if you've seen that exact request before, you return the stored answer without touching the model at all. Zero new tokens. Near-zero latency. It's the `memoize()` decorator you'd put on any expensive pure function, applied to inference.

This is enormously effective in the places you'd expect: a "summarize this document" endpoint hit repeatedly for the same document, a classification step that sees the same inputs, a docs-bot fielding the literal same FAQ a hundred times a day. When the input is identical, re-generating is pure waste — same prompt, same (ideally) answer, full price. Cache it once, serve it free thereafter.

Two real gotchas here, and they're sharper than Layer 1's.

First, **exact-match caching is brittle in the same way prefix caching is.** "Summarize this contract" and "Summarize this contract." with a trailing space are different keys. Natural language barely ever repeats verbatim across different users, so a strict response cache gets great hit rates on machine-generated identical calls and almost none on human phrasing. That brittleness is also its safety — which sets up Layer 3.

Second, and this is the one that bites: **a cache is only as fresh as the world it answered for.** If the underlying document, the account state, or the policy changed since you stored the answer, your cache is now confidently serving a stale truth. The model didn't hallucinate — your cache did, on its behalf. Anything non-deterministic or time-sensitive needs a deliberate invalidation strategy (key on a content hash or version, set a TTL) or it should not be cached at all. The failure is invisible until someone notices the answer is from last Tuesday.

## Layer 3 — Semantic caching: serve a hit when the question is *close enough*

![A precision dial whose needle, turned too far, crosses from a calm green zone into a red danger zone — the similarity threshold between savings and wrong answers.](/img/caching-llm-semantic/semantic-threshold-dial-savings-vs-lies.png)

The top layer is the powerful one, and the one to respect.

The limitation of response caching is that brittle exact match — humans never phrase things identically, so you whiff on most real traffic. **Semantic caching** fixes that by matching on *meaning* instead of *characters*. You embed the incoming query into a vector, compare it against the vectors of past queries, and if a previous one is close enough — above some similarity threshold — you serve that cached answer.

So "How do I reset my password?", "I forgot my password, what now?", and "can't log in, need a new password" all collapse to one cached answer despite sharing barely a word. For a high-traffic assistant where users orbit the same few intents in a thousand phrasings, this can lift your cache hit rate from near-zero into the double digits, and every hit is a model call you didn't make. It's the difference between caching the *string* and caching the *intent*.

Now the gotcha, because it's the whole ballgame: **that similarity threshold is a dial between savings and lies.** Set it too loose and "close enough" stops being close enough. "How do I cancel my subscription?" and "How do I change my subscription?" are semantically adjacent — a greedy threshold will serve the cancel answer to the change question, and the user gets a confidently wrong response that the model never actually generated for them. This is a *new* failure mode that Layers 1 and 2 don't have. Prompt and response caching reuse work over identical inputs; the worst they do is go stale. Semantic caching reuses an answer for a question that was never asked, and a too-loose threshold makes that happen on purpose.

The discipline is to treat the threshold as a tuned parameter, not a default. Hold it conservative. Reserve semantic caching for high-volume, low-stakes, read-only lookups — FAQs, docs retrieval, intent routing — and keep it far away from anything personalized, transactional, or stateful, where serving a neighbor's answer is actively dangerous. The cheaper the cache makes a wrong answer, the more it'll cost you when it's wrong.

## The stack, and the rule under it

Three layers, and you want them in this order:

- **Prompt caching** — reuse the processing of a stable prefix. Almost free, no correctness risk, gated only on keeping your context layout disciplined. Turn it on now.
- **Response caching** — skip the call for identical requests. Big wins on repeated machine inputs; watch staleness with TTLs and version keys.
- **Semantic caching** — skip the call for *similar* requests. The largest hit-rate gains and the only layer that can fabricate a wrong answer on purpose. Tune the threshold; keep it on safe ground.

The throughline of this whole series holds here too: with agents, generating the answer is the cheap part, and getting cheaper. The expensive part is doing it *needlessly* — and the most needless cost of all is paying, again, for an answer you already have. Caching is just refusing to. The art is refusing without lying to yourself about whether the cached answer is still true.
