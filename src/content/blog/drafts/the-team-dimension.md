---
title: 'The Team Dimension'
description: "Everything in this series so far has been about you — your judgment, your intent, your review. But moving up the stack is a team sport, and a team that climbs unevenly doesn't just move slower. It rots while shipping more."
pubDate: 'Jun 29 2026'
draft: true
series: 'Agentic Engineering'
seriesOrder: 10
tags: ['agentic-ai', 'team-adoption', 'engineering-leadership']
hashtags: ['agenticdevelopment', 'teamadoption', 'engineeringleadership']
---

Every post in this series so far has had a single protagonist: you. Your judgment is the scarce thing now. Your **intent** is the artifact. The [review is your work](/blog/the-review-is-the-work-now/). The climb from **OI to AI**, from soloist to conductor, has been framed as a thing one engineer does to one engineer's habits.

That framing is incomplete, and I've started to think it's the more dangerous half of the story to get wrong. Because almost nobody ships software alone. You ship it on a team. And a team doesn't move up the stack the way a person does — all at once, by deciding to. A team moves up the stack the way a rope team climbs a mountain: tied together, at the speed of its hardest decision, with very real consequences when half of you have moved to the next ledge and half of you haven't.

This post is about that rope. What actually happens when a whole team tries to climb together — the adoption dynamics, the holdouts, the artifacts that suddenly have to be shared, the roles that quietly restructure, and the specific way a team can compound with these tools or rot while looking, on the burndown chart, like it's never been faster.

## The Easy-Bake Oven, at scale

I wrote once about [Easy-Bake Oven developers](/blog/easy-bake-oven-developers/) — the engineer who dumps a pile of files into the window, pushes the button, and expects a cake. Garbage in, gospel out. As an individual failure mode it's annoying but contained. The slop is theirs; the cleanup is theirs.

On a team, the Easy-Bake Oven mindset stops being contained. Because the cake gets served to everyone. One person's unverified, rubber-stamped agent output becomes the next person's load-bearing assumption. The [context poisoning](/blog/garbage-in-gospel-out/) that used to live in one developer's session now lives in the shared codebase, the shared specs, the shared mental model of how the system works. **GIGO becomes a team-level contaminant.** One member treating the agent like a vending machine raises the verification tax for everyone downstream of their merges.

And here's the part that makes it political rather than merely technical: the Easy-Bake Oven developer is, on paper, your most productive engineer. They're shipping volume. They're closing tickets. They're the loudest evidence that "the AI stuff is working." Which means the person generating the most shared cleanup cost is often the person leadership is holding up as the model to copy. Scale the wrong behavior and you don't get a faster team. You get a team that's fast at manufacturing rework for itself.

## The artifacts go from private to shared

When you worked organically — hands on keyboard, line by line — your understanding of the system was a **private** artifact. It lived in your head, the OI you grew by building the thing. Nobody else could read it, and mostly nobody needed to. The code was the shared surface; the reasoning behind it was yours.

Move up the stack and the center of gravity shifts to things that *only have value if they're shared*: the **spec**, the **plan**, the **intent**, the **review**. A spec that only its author can parse is a private artifact wearing a shared artifact's clothes. The [anatomy of a good spec](/blog/anatomy-of-a-spec/) — the thing that makes it legible, that lets someone who didn't write it reconstruct the intent — stops being a nicety and becomes the load-bearing wall of the whole team.

This is the team version of a point I keep circling: completeness is easy, legibility is the product. On a solo project you can get away with a private, exhaustive, unreadable plan, because you hold the missing context in your head. On a team, the missing context isn't in anyone's head — it's supposed to be *in the artifact*. If the spec isn't legible, you haven't created a shared understanding. You've created a document that each reader has to reverse-engineer separately, which is just distributed rework with a Confluence page attached.

The discipline of [doing it the same way twice](/blog/the-same-way-twice/) — repeatable, externalized process instead of heroic one-offs — is what turns these into genuinely shared assets. A pipeline that builds the same disciplined context for the hundredth task as the first is a thing a *team* can rely on. A clever prompt that lives in one person's shell history is not.

## The roles restructure, whether you plan it or not

Here's the uncomfortable structural fact. If the high-leverage work is now specifying, reviewing, and [orchestrating](/blog/orchestration/) — and the low-leverage work is hand-authoring implementation — then a team doesn't need the same *shape* it used to.

It needs fewer pure authors and more conductors. Not because authoring is worthless, but because the bottleneck moved. When generation is cheap, the constraint on a team's throughput isn't how many people can write code. It's how many people can hold a coherent intent, express it well enough for an agent to execute, and verify the result with real judgment. That's a different skill, distributed differently across your team than you'd expect — and it does *not* map cleanly onto seniority. Some of your best authors are mediocre conductors. Some quiet mid-level engineer turns out to be exceptional at it, because conducting rewards clarity of intent over speed of typing.

Most teams are restructuring around this by accident right now. The conductors are emerging organically, absorbing more and more of the real decisions, while the org chart still says everyone's an "engineer" doing the same job. The restructuring is happening; it's just happening invisibly, unrewarded, and unnamed. Which is exactly how you lose the people who are quietly doing the hardest new work — by not noticing that the job changed underneath them.

## The friction is the uneven adoption

Now the actual hard part, the thing nobody warns you about. The problem on a real team is almost never that the tools don't work. It's that they work *unevenly*.

Picture the rope team. A few engineers have genuinely made the climb — they've dropped the addition sign, they treat review as the work, their intent is legible, they conduct. A few are skeptics, dug in, still hand-coding everything and treating every agent suggestion as a threat to be refused. And most are somewhere in the muddled middle, half in, doing the Easy-Bake Oven thing on Tuesday and careful conducting on Thursday.

These three groups can't actually work at the same altitude, and that mismatch is where the friction lives:

- The fast movers produce specs and plans the skeptics won't read, then can't understand why their "obvious" handoffs get fumbled.
- The skeptics produce hand-crafted work that's solid but slow, and quietly resent being measured against the volume the Easy-Bake crowd is putting up.
- The middle absorbs slop from above and friction from below and learns the lesson nobody intends: that the new way is chaotic and the old way at least worked.

This is the moment a lot of teams misdiagnose. They look at the friction and conclude the *tools* are the problem, or that the skeptics are the problem, or that they need to mandate adoption harder. But the friction isn't a sign the climb is wrong. It's the predictable mechanical consequence of a roped-together team strung out across the slope. You don't fix it by yelling at the people on the lower ledge to move faster. You fix it by making the next ledge *legible and reachable* — shared specs people will actually read, review standards everyone holds, a context pipeline that gives the skeptic the same disciplined folder as the believer so the wins are obvious instead of evangelical.

## Compound or rot — there's no third option

I'll end where the first post in this series ended, because it turns out to be even truer at the team level than the individual one. The difference between a team that **compounds** with these tools and one that **quietly rots while shipping more than ever** is not how much AI they use. Both teams use a lot. Both teams look fast.

The compounding team treats the shared artifacts as the product: legible specs, real review, repeatable process, conductors who are recognized and rewarded for conducting. Each merge makes the next one easier because the shared understanding got *more* trustworthy, not less. The rope is taut and the whole team moves at the speed of the climb.

The rotting team treats the shared artifacts as overhead to skip. Easy-Bake output flows into the shared codebase unverified. Specs are private documents nobody reads. The conductors are invisible and burning out. And the [knowledge decay](/blog/the-review-is-the-work-now/) compounds the other direction — every fast, unverified merge makes the shared model of the system a little less true, until the team is sprinting confidently across terrain that no longer matches the map. They will be the last to know, because the burndown chart has never looked better.

Moving up the stack was never something you do to yourself. The OI-to-AI shift, the soloist-to-conductor climb, intent-as-artifact — every one of them only pays off if the *team* makes the move together, and on a team the artifacts have to be shared, the roles have to be re-cut, and the slowest, most skeptical person on the rope is part of your throughput whether you like it or not.

It's a team sport. The teams that figure that out compound. The ones that treat it as a sum of individual upgrades rot — fast, and in a way that's invisible right up until it isn't.

How's your team navigating the uneven part — the gap between the fast movers and the skeptics on the same rope? That's the conversation I most want to be having right now.
