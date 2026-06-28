---
title: 'Garbage In, Gospel Out: Agentic Cognitive Bias'
description: "Humans have confirmation bias — we read new evidence as support for the hypothesis we already hold. Agents have it worse, because they can't tell where a 'fact' in their context came from. Once something false enters the window, every next token treats it as gospel. That's context poisoning, and it's the failure mode underneath most agent train wrecks."
pubDate: 'Jun 28 2026'
heroImage: 'https://images.unsplash.com/photo-1530026405186-ed1f139313f8'
draft: false
hashtags: ['agenticdevelopment', 'aiengineering', 'softwareengineering']
socialQuote: "Context poisoning is confirmation bias with no immune system: once a false fact is in the window, every next token treats it as gospel."
series: 'Agentic Engineering'
seriesOrder: 8
---

You've seen an agent do this. It decides, early, that the bug is in the auth module. From that point on, every log line is "more evidence" for auth. The stack trace pointing at the database layer? Explained away. The passing auth tests? "Probably a caching issue." It's not getting dumber as it goes — it's getting *more confident*, in exactly the wrong direction. By step twenty it will defend the wrong hypothesis better than it ever argued for the right one.

In [Orchestration](/blog/orchestration/) I called that narrative drift and named the human version. This post is about that human version, why agents have it worse, and the mechanical thing happening underneath — because once you see the mechanism, the fix stops being "prompt it better" and starts being something you can actually engineer.

## The human version: confirmation bias

In human cognition this is **confirmation bias**: a type of cognitive bias where you selectively interpret new evidence to support an existing hypothesis instead of updating or revising it. You don't weigh new information neutrally — you weigh it *for* the story you've already committed to. Evidence that fits gets waved through; evidence that doesn't gets discounted, reinterpreted, or quietly ignored.

It's one of the most robust findings in psychology, and it's not a defect of stupid people. Smart, careful people do it *more*, because they're better at constructing the explanations that protect the hypothesis. Intelligence doesn't immunize you against confirmation bias; it gives you a better lawyer.

Now hand that same tendency to a system that was trained, token by token, on a corpus written by us — millions of examples of humans defending their priors. Of course it inherited the pattern. The surprise would be if it hadn't.

## Why the agent has it worse

Here's where the agent and the human part ways, and it's the part that matters.

When *you* recall a fact, it comes with a tag — a fuzzy sense of *where you got it*. "I read that in the docs." "Someone told me that, but I'm not sure they were right." "I'm guessing." That provenance tag is your immune system. It lets you say **"wait — where did I actually learn that?"** and downgrade a belief when the source turns out to be weak.

An agent has no such tag. Everything in its context window is, to the next token, **equally true.** The line you typed, the file it read, the test output, *and the thing it hallucinated three steps ago and then wrote down* — all the same flat substrate, all weighted as established fact. The model can't introspect "this came from a reliable tool" versus "this came from my own confident guess." There's no episodic boundary, no source memory, no internal librarian stamping things RELIABLE or UNVERIFIED.

So when a falsehood gets into the window, it doesn't sit there flagged as suspect. It becomes part of the ground truth the agent reasons *from*. This is **context poisoning**, and it's the meaner cousin of confirmation bias. Confirmation bias bends how new evidence is read. Context poisoning corrupts the evidence pool itself — and then every subsequent token conditions on the corruption. Garbage in, gospel out.

## Where the poison comes from

It rarely arrives labeled. The usual sources:

- **Its own hallucinations, fed back.** The agent guesses a function signature, writes code against it, and now that wrong signature is in the context as if it were real. Three steps later it's "the API," and the agent is debugging *around* a fact it invented.
- **Bad tool output.** A flaky command returns empty, a search hits the wrong file, an API 500s and returns a misleading error. The agent ingests the noise as signal.
- **A wrong early conclusion.** The single most expensive token in a long session is the first confident-but-wrong claim, because everything after it inherits the error.
- **Stale or mismatched memory.** A fact that was true last week, recalled as if it's true now. (This is why a memory that *names a file or a flag* has to be re-verified before you act on it — the memory is a claim about a past state, not the present.)
- **You.** If you assert something wrong in the prompt — "the timeout is set in config.yaml" when it's actually in env vars — the agent will not push back. It will help you, confidently, in the wrong place. Which leads to the biases riding shotgun.

## The biases riding shotgun

Confirmation bias doesn't travel alone. Two companions make poisoning worse:

**Anchoring.** The first framing of a problem dominates everything after it. Whatever hypothesis enters the window first gets a structural advantage — not because it's better, but because it was first. Open a debugging session with "I think it's a race condition" and you've tilted the whole investigation before any evidence is in.

**Sycophancy.** Models are trained, hard, to be agreeable — and agreement is a poison delivery mechanism. Push back on a correct answer and many models will fold and "correct" themselves into a wrong one. Assert your pet theory and the agent will find evidence for it, because finding-evidence-for-what-the-user-wants is the path of least resistance through its training. The agent isn't just vulnerable to *its own* bad priors. It'll adopt *yours* on request.

Put it together and you get the long-session train wreck: an anchored hypothesis, a sycophantic agent eager to support it, and a context window with no immune system to flag the mounting pile of self-reinforcing garbage. It doesn't look like failure from the inside. It looks like *increasing confidence*.

## How you fix it — context hygiene

You can't give the model a provenance tag it doesn't have. But you can engineer the system around it so poison is caught, contained, or never admitted. The discipline is **context hygiene**, and it's four habits.

**Curate what gets in.** The context window is not a junk drawer; it's the evidence pool the agent reasons from, and every token in it is treated as true. Dumping nineteen files "just in case" isn't thoroughness — it's raising the odds something misleading is in the pool. Load what's relevant, deliberately. A tight, clean context beats a big, noisy one every time, and not by a little.

**When a session is poisoned, don't argue with it — reset it.** This is the most important and least-used move. Once an agent has anchored on a wrong story, trying to *talk* it out is mostly hopeless; you're adding tokens to a poisoned pool. `/clear`, and reload from the durable artifacts — the spec, the implementation plan, the git state. A fresh context built from [a plan on disk](/blog/orchestration/) starts clean; a long conversation that "knows too much" is carrying every wrong turn it ever took. This is the practical payoff of writing intent down: it gives you a clean room to retreat to.

**Force provenance back in.** Since the model won't tag its own sources, make it. *"For each claim, cite the file, line, or command it came from."* The instant an agent has to attach a source to a fact, the invented ones have nowhere to hide — there's no file to point at. You're bolting on, by hand, the immune system the architecture left out. ("Show me the tool calls" is a complete sentence: an empty tool-call log behind a confident claim is poison, caught.)

**Verify against reality, not against the context.** The agent checking its own work *inside the poisoned session* is the fox guarding the henhouse — it'll confirm the story, because the story is all it knows. Real verification comes from outside the window: run the test, hit the endpoint, or hand the diff to a [fresh-context agent](/blog/trust-but-verify/) that never saw the conversation that went wrong. An independent reader isn't infected by the first one's confidence. That's the whole point of [keeping the proof external](/blog/trust-but-verify/).

## The honest version

Agents don't drift because they're broken. They drift because they're doing a very good impression of us — inheriting our confirmation bias from the corpus we wrote — without the one thing that keeps ours survivable: a sense of where our beliefs came from. We can ask "wait, who told me that?" They can't. To the next token, everything in the window is gospel, and the truest sentence and the dumbest hallucination sit on the same shelf.

So the work isn't to find an agent that never gets poisoned. It's to stop treating the context window as a transcript and start treating it as what it is: **the evidence pool, where everything you let in becomes true.** Curate it like it matters, reset it when it sours, demand provenance for every claim, and verify from outside it. The agent will never develop an immune system on its own. You're the immune system.

So, a question for your own setups: when an agent goes down a wrong path, do you try to *talk* it back — or do you reset and reload from something durable? I've come to think the reflex you pick there is most of the difference between people who trust these tools and people who've been burned by them.
