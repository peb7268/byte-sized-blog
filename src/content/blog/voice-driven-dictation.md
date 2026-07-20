---
title: 'Voice-Driven Dictation'
description: "You can talk roughly three times faster than you type, and your agents don't care which one you use. Here's why voice is a first-class input to an agentic workflow — and where it's still genuinely clumsy."
pubDate: 'Jun 29 2026'
heroImage: 'https://images.unsplash.com/photo-1555965435-f88618f05915'
draft: false
series: 'The New Ways of Working'
seriesOrder: 3
tags: ['voice-input', 'agentic-workflow', 'developer-productivity']
hashtags: ['voicedictation', 'agenticdevelopment', 'aiengineering']
---

I dictated the first draft of this post pacing around my kitchen with a coffee in one hand and nothing in the other. No keyboard. No screen in front of me. By the time I sat down, there were four hundred words waiting in my notes, and the only editing I had to do was the editing I'd have had to do anyway.

That's not a productivity-hack flex. It's the point. The moment agents took over the typing, the keyboard stopped being the thing standing between my intent and the work. And once the keyboard isn't sacred anymore, you start to notice how much it was costing you.

Most people treat voice as a gimmick — a party trick for sending texts while driving, a feature you toggle on once and forget. I want to argue the opposite. **Voice is the highest-bandwidth input you own, and an agentic workflow is the first kind of work that can actually use it.**

## The throughput gap nobody budgets for

Start with the raw numbers, because they're lopsided in a way that's easy to wave off until you feel it.

A fast typist hits maybe 70 words per minute. A *good* one, on a great day, 90. Comfortable conversational speech [runs **130 to 150 words per minute**](https://en.wikipedia.org/wiki/Words_per_minute) without trying. So before we say anything about AI, before any cleverness, the mouth is roughly twice the keyboard and often more — [one Stanford study clocked speech input at three times faster than typing](https://engineering.stanford.edu/news/smartphone-speech-recognition-faster-and-more-accurate-typing). That gap has always existed. What's new is that it finally matters.

It didn't matter before because the bottleneck wasn't getting words out of your head — it was getting *correct code* into a file. Typing speed was never the constraint on real engineering; thinking was. So the throughput advantage of speech had nowhere to go. You'd just talk yourself into a faster pile of wrong syntax.

But [intelligence has moved up the stack](/blog/intelligence-moves-up-the-stack/). The agent handles the syntax now. What it needs from you is **intent** — described richly, with enough context that it can fill in the rest. And intent is exactly the thing speech is good at producing in volume. You're no longer dictating characters into a buffer. You're dictating *direction* into a system that turns direction into code. The bandwidth that used to be wasted suddenly lands on the part of the job that's left.

## Thinking out loud is a feature, not a side effect

![A person mid-sentence with a smooth, unbroken ribbon of speech flowing into a microphone, contrasted with a cramped typed line — talking is effortless where typing is constrained.](/img/voice-driven-dictation/thinking-out-loud.png)

Here's the part I didn't expect.

When I type, I edit as I go. I write half a sentence, hate it, backspace, rephrase. It feels like rigor. It's actually a tax — I'm pruning the thought before it's finished growing. Typing makes me commit too early.

Talking doesn't let me do that. When I dictate, I have to keep moving, which means I have to follow the thought all the way to the end before I judge it. I ramble. I contradict myself. I say "no wait, the real reason is—" out loud. And that mess turns out to be *more* useful to an agent than my tidy, over-pruned prose, because it contains the reasoning, not just the conclusion. The model gets to see me think.

This is the same idea as [the review being the work now](/blog/the-review-is-the-work-now/), pointed at the other end of the pipeline. There, your judgment lands on the agent's output. Here, your judgment leaks into the agent's *input* — and a half-formed spoken brain-dump full of "because" and "but actually" is a better brief than three crisp bullet points. The contractor with amnesia wants the whole train of thought, not just the destination. Speech hands it over for free, precisely because it's harder to over-edit.

## Capturing intent when you're nowhere near a keyboard

The throughput argument is about speed at the desk. This one is about the desk not being involved at all.

The best ideas I have about a problem almost never arrive while I'm sitting in front of it. They show up on a walk, in the car, in the ninety seconds between meetings, in the shower (where, regrettably, even voice can't help me yet). For my entire career those ideas had a brutal half-life: by the time I got back to a keyboard, the good version was gone and I was reconstructing a smudged copy.

Voice closes that gap to zero. I can be a mile from my laptop and still **capture the intent at full fidelity, at the moment it's sharpest.** Not a note that says "think about the caching thing" — the actual reasoning, the actual shape of the fix, the actual objection I just thought of, spoken while it's hot.

And capture is only step one. The reason this isn't just a fancier voice memo is the **pipeline** behind it. My dictation doesn't die in a transcription app. It lands in my notes system, gets tagged, becomes context an agent can pick up later. The walk produces a brain-dump; the brain-dump becomes a brief; the brief becomes a draft the next time I'm at the machine. Voice is the front door to a system that's already running — which is the whole bet behind the [PCMS manifesto](/blog/pcms-manifesto/): your context shouldn't depend on you being at a keyboard to capture it. The mouth becomes a write head for the system, from anywhere.

That's the reframe. Voice isn't a faster way to type. It's a way to feed the machine when typing isn't even an option.

## Where voice is still genuinely clumsy

![A firehose blasting water beside a precise surgical scalpel — dictation is a firehose, editing is a scalpel.](/img/voice-driven-dictation/firehose-vs-scalpel.png)

I'd be lying if I sold this as frictionless, and you'd stop trusting me, correctly.

Voice is great at *prose* and terrible at *precision*. The moment I need an exact identifier — a variable name, a file path, a regex, a closing brace three levels deep — speech falls apart. Try dictating `userRepository.findByIdOrThrow(tenantId)` out loud and watch what the transcriber does to it. Camel case, symbols, and syntax are a war you will lose. Anything where the *characters themselves* are the meaning is keyboard territory, full stop.

It's also bad at surgical edits. "Change line 42" is a pointing gesture, and you can't point with your voice without an awful lot of words. Repositioning a cursor, selecting a block, nudging one token — that's what hands and a mouse are for. Dictation is a firehose; editing is a scalpel. You don't operate with a firehose.

And there's an ambient cost people forget: you can't dictate in a quiet office without becoming the person dictating in a quiet office. Voice wants a door, a car, or a sidewalk. Open-plan reality clips its wings more than any technical limitation does.

So I don't use voice for everything. I use it for the **generative, exploratory, high-volume** parts — first drafts, briefs to an agent, talking through a design, capturing an idea on the move. Then I switch to the keyboard for the **precise, corrective, surgical** parts. The skill isn't "go all voice." It's knowing which mode the current move wants and paying nothing to switch between them.

## The new habit

The shift that took me longest to internalize was small and stupid: **talk first, type second.**

The old reflex is to open an editor and start typing the instant I have a task. The new one is to open my mouth and externalize the whole messy intent before I touch a key — let the high-bandwidth channel do the high-bandwidth work, then drop to the keyboard only for the parts that actually need fingers. Once that reflex flipped, the keyboard stopped being where work *started* and became where work got *finished*.

This is the same move the rest of this series keeps circling. The valuable thing you produce is no longer keystrokes — it's intent, judgment, and context. And it turns out the fastest, richest, most portable way to produce intent is the one we all learned before we could read: just say it out loud, and let the machine catch it.
