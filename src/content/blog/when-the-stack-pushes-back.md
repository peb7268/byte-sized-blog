---
title: 'When the Stack Pushes Back'
description: "This whole series argues that your value moves up — to intent, to orchestration. This is the honest counterweight: the places where climbing the stack costs more than it pays, and how to tell you're standing on one."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1601224748193-d24f166b5c77'
draft: false
series: 'Agentic Engineering'
seriesOrder: 9
tags: ['agentic-ai', 'engineering-judgment', 'limits']
hashtags: ['agenticdevelopment', 'aiengineering', 'engineeringjudgment']
---

I've spent eight posts telling you to climb. Stop hand-coding, move up to intent. Stop authoring, start conducting. Let the agents do execution and put your judgment where the leverage is. I believe all of it. I also know how that kind of argument curdles when it's only ever told in one direction — it stops being a thesis and starts being a sales pitch, and the moment a reader catches you never naming a case where your own advice loses, they're right to stop trusting the cases where it wins.

So this is the post where I argue against myself. Not to retract anything — to draw the boundary. Because the climb up the stack is real and it pays, *and* there are well-defined places where it pushes back, where the right move is to drop a rung and put your hands back on the keys. Knowing which is which is itself the skill. A conductor who can't also read a single line of score isn't a conductor; he's a guy waving a stick.

> The honest version of "your value moves up the stack" is: *most of the time.* The professional skill is recognizing the times it doesn't — fast, before you've spent an hour specifying something you could have typed in ten minutes.

Here are the four places I keep finding the edge.

## 1. Genuine novelty, where there's no prior art to lean on

![A cartographer's hand drawing the first ink line onto a blank sheet of vellum — nothing to copy from, the first instance written by hand.](/img/when-the-stack-pushes-back/novelty-blank-map-first-line.png)

A model is, at its core, a magnificent compression of things people have already written down. When you ask it to do something that sits squarely inside that distribution — a REST endpoint, a migration, a React form, the thousandth variant of a pattern it has seen ten million times — it is astonishing, because you are essentially [retrieving a consensus answer](https://www.anthropic.com/engineering/building-effective-agents) and adapting it.

Now ask it to do something genuinely new. Not new-to-you. New to *the field* — a novel algorithm, an architecture nobody's published, a trick that works because of a property of your specific system that exists nowhere in the training data. The model has nothing to compress. It will still answer, confidently, in the average shape of adjacent problems — which is exactly the failure mode, because the average of nearby solutions to a problem that has no nearby solutions is plausible nonsense.

This is the GIGO point ([Garbage In, Gospel Out](/blog/garbage-in-gospel-out/)) turned inside out. Usually the garbage is bad context you supplied. Here the garbage is *absence* — there's no signal in the weights to retrieve, so the model manufactures one. No amount of [context engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) fixes a void. When the work is genuinely novel, your **Organic Intelligence** isn't a fallback, it's the only intelligence in the room that has ever actually held the problem. Build it yourself. Then, once you've made it real, *that* becomes prior art the model can extend — but you have to write the first instance by hand.

## 2. Irreducible ambiguity, where specifying costs more than doing

The premise underneath this whole series is that [intent is the artifact](/blog/intelligence-moves-up-the-stack/) — that the valuable thing you produce is a precise specification, and the agent compiles it down to code. That premise has a cost curve, and we mostly pretend it doesn't.

Some tasks are cheap to specify and expensive to build: "wire this established pattern across forty files." Delegate every time. The spec is short, the work is long, the leverage is enormous.

But some tasks invert that. The work is small and the *intent is the hard part* — fuzzy, full of taste, the kind of thing where you don't actually know what you want until you see the wrong version. A subtle UX interaction. A tricky bit of formatting where "right" is a feeling. A ten-line function whose behavior at the edges you'd have to enumerate in three paragraphs of prose to pin down. In [Anatomy of a Spec](/blog/anatomy-of-a-spec/) I argued a good spec is precise. The corollary nobody likes: when achieving that precision in words costs more than just typing the code, the spec is a worse artifact than the code. You'd be translating a thought into English so a model can translate it back into a language you already speak fluently — paying twice for one trip.

The tell is when you catch yourself on the third revision of a prompt, re-describing, re-constraining, watching the agent miss by inches each time. That loop is the signal. You're not failing at prompting. You've hit a task where the ambiguity is irreducible and the cheapest path to an unambiguous artifact is to *write the artifact.* Drop the rung.

## 3. The tasks where your OI is simply faster

There's an unglamorous category we skip because it embarrasses the thesis: the change you could just *do.*

A one-line fix in code you wrote last week and still hold in your head. A rename. A config tweak you've made a hundred times. The migration of OI to AI I keep describing is a trade — you give up the hands-on understanding in exchange for leverage — and like any trade it only makes sense when the leverage exceeds the cost. For small, familiar, in-your-head work, there is no leverage to capture. The agent has to load context you already have, you have to write the prompt and then *review the output* — and as [The Review Is the Work Now](/blog/the-review-is-the-work-now/) lays out, that review is not free; it's the expensive part. For a one-liner, the orchestration overhead — prompt, wait, read, verify — dwarfs the task.

Delegating a thirty-second edit so you can feel modern is a real failure mode, and I've done it. It's cargo-culting the workflow. The skill isn't "always delegate." It's having a genuine, honest sense of where your own speed beats the round trip — and that line moves with your familiarity, not with the calendar.

## 4. The moments you should drop a rung *inside* a delegated task

![A single hand reaching into a running assembly line to fix one jammed part while the rest keeps moving — a surgical, targeted intervention.](/img/when-the-stack-pushes-back/drop-a-rung-hand-on-assembly-line.png)

The first three are about not climbing in the first place. This one's sneakier: you were right to delegate, the agent did 90% of it well, and then it hit a wall — the same wall three times, each fix uglier than the last. This is the [doing it the same way twice](/blog/the-same-way-twice) problem in reverse: the agent will keep producing variations on a wrong approach forever, because it has no way to know its frame is the problem; it can only iterate within the frame you gave it.

When you see that loop, the move is not a better prompt. It's to drop in, hand-write the gnarly twenty lines that needed a human's model of the system, and hand the keyboard back. Orchestration ([Orchestration](/blog/orchestration)) is not a vow never to touch the instrument. The best conductors play. The discipline is knowing it's a *targeted* drop — fix the load-bearing part, then climb right back to coordinating — not a retreat all the way down to writing the whole thing by hand because one piece got hard.

## How to tell you're on an edge

I don't have a clean rule, because the whole point is that this is judgment — the thing that doesn't compress. But I have a checklist I actually run:

- **Has anyone solved this before?** If yes, climb — the model's strength is retrieval. If it's genuinely novel, your OI is the only real intelligence available. Build it first, then delegate the extensions.
- **What's cheaper, the spec or the code?** If the intent is short and the work is long, delegate. If you're on prompt revision three and still missing by inches, the ambiguity is irreducible — write it.
- **Do I already hold this in my head?** If the context lives in your OI and the task is small, just do it. The round trip costs more than the work.
- **Am I in a loop?** Same wrong shape, three times? Stop reprompting. Drop in, fix the load-bearing piece by hand, hand it back.

Notice none of these say *don't use agents.* They say *use judgment about altitude* — which is the actual thesis of the whole series, finally stated without the cheerleading. The climb up the stack is the right default. A default is not a law. The engineers who get the most out of these tools aren't the ones who delegate everything; they're the ones who've developed a fast, honest instinct for the four or five percent of work where dropping a rung is the smarter move — and who do it without flinching, then climb right back.

That instinct *is* the senior skill now. Not "can you code" and not "can you prompt" — but "do you know which one this task wants." The stack pushes back sometimes. Listen when it does.
