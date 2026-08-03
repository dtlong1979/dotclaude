---
name: write-abstract
description: >-
  Draft or audit the abstract of a scientific/technical manuscript using a
  six-question formula — Problem, Limitation, Design, Results, Conclusion,
  Contribution. Use this whenever the user wants to write, rewrite, tighten,
  review, or "fix" a paper abstract, a summary/tóm tắt for a journal or
  conference submission, a grant/report summary, or asks whether their abstract
  "covers everything." Trigger even when they don't say the word "abstract" —
  e.g. "make the opening of my paper stronger", "summarize this study for the
  journal", "viết lại tóm tắt", "does my abstract have a takeaway?". Works in
  any language; if the user drafts in one language and translates later, keep
  the language they ask for.
---

# Write / audit an abstract with the six-question formula

An abstract is not a mini-introduction and not a table of contents. It is a
self-contained argument that a busy reader can check in one pass. The most
reliable way to make it self-contained is to answer six questions, in order,
each in one or two sentences. If any question is missing, the abstract has a
hole a reviewer will feel even if they can't name it.

## The six questions

Answer each one explicitly. The label is for *you* — don't print the labels in
the final abstract; the reader should feel the structure, not see scaffolding.

**0. Câu dẫn nhập / Framing (một câu, trước khi vào Vấn đề).** Don't open cold on
the gap — a reader who doesn't yet know the *domain* gets thrown into the middle
of a problem they can't place. Lead with exactly one sentence that orients them:
what class of system this is and why the general task matters ("In multiprocessor
/ IoT-edge systems, recovering the whole system's tasks when a node fails is a
key reliability problem, and many solutions exist…"). One sentence only — it is a
runway, not a mini-introduction. Then pivot straight into the specific gap
(Problem → Limitation). Skip it only when the venue's readership already lives in
the domain and a framing line would read as filler.

1. **Vấn đề / Problem** — What phenomenon, quantity, or question is still
   unexplained or unaddressed? State the gap as something concrete, not "little
   work exists on X." A good problem sentence names a thing the field currently
   *cannot say or do*.
2. **Hạn chế / Limitation** — Where do prior methods break, get confounded, or
   go uncontrolled? This is the *why-now*: name the specific weakness your work
   removes, not a generic "existing methods are limited."
3. **Thiết kế / Design** — How does the new method eliminate exactly that
   limitation? Give the mechanism in plain terms — the one idea that makes it
   work — not a feature list. The reader should see the causal link back to the
   limitation you just named.
4. **Kết quả / Results** — What is the single most important number or
   observation, with its comparison baseline and, where possible, its
   uncertainty (±, CI, n)? Numbers beat adjectives. If there are two evidence
   types (e.g. simulation + real testbed), give the headline from each.
5. **Kết luận / Conclusion** — What, precisely, do the data license you to
   claim — and, just as important, what they do *not*? A conclusion that also
   states the boundary of the claim reads as competent, not weak. Overclaiming
   is the fastest way to lose a reviewer's trust.
6. **Đóng góp / Contribution** — So what, and for whom? Name the actual
   audience (operators, a research community, a class of systems) and the
   concrete benefit they get. "This is useful" is not a contribution; "gives
   edge operators a checkable guarantee that centralized schedulers don't emit"
   is.

## How to use it

**Drafting:** Write one or two sentences for each of the six, in order, as a
scratch outline. Then fuse them into flowing prose — usually one paragraph of
~150–250 words for a journal, two short paragraphs at most. Remove the labels.
Read it once cold and cut every sentence that doesn't advance one of the six.

**Auditing an existing abstract:** Map each existing sentence to one of the six
slots. Report which slots are **empty**, **weak**, or **doubled** (two sentences
fighting for the same slot while another slot is empty). Then propose a rewrite
that fills the gaps. Show the user the slot-by-slot mapping first — it makes the
diagnosis obvious and teaches the formula at the same time.

## Style rules that keep it honest

These matter because the abstract is where reviewers form their first,
stickiest impression.

- **Let numbers carry the claim.** Prefer "≈6× faster (56.6 ± 6.1 s vs 351.6 ±
  2.4 s, n=6/4)" over "significantly faster."
- **State the boundary of the claim in the same breath as the claim.** If the
  method doesn't beat a centralized optimum, say so — then say what it *does*
  win on (decentralization, communication cost, a certificate). Honest framing
  is more persuasive than a claim a reader can puncture.
- **Cut metadiscourse.** Delete "In this paper we propose", "It is important to
  note that", "Our results show that". Just state the result.
- **One idea per sentence.** If a sentence has two `and`-joined clauses doing
  different jobs, split it.
- **No undefined jargon or acronyms** on first use in the abstract.
- **Match the venue.** A systems journal wants the mechanism and the numbers; a
  theory venue wants the guarantee; skim one abstract from the target venue and
  mirror its density.

## Worked mapping (compact example)

- *Problem:* Reactive edge orchestrators can't state, at the current state,
  which simultaneous-failure sets are still repairable.
- *Limitation:* Kubernetes-style control loops only reschedule on free
  capacity and certify nothing; fault-injection resilience testing is
  post-hoc; ML orchestrators optimize expected latency but don't certify and
  have no fallback out of distribution.
- *Design:* Each node runs a one-hop local rule; on failure a distributed
  resistive-diffusion field routes role re-assignment over vertex-disjoint
  paths, carrying a min-cut repairability certificate and a training-free
  fallback.
- *Results:* In simulation the field is near-optimal and 30–725× above an
  uncoordinated baseline at O(diameter) communication; on a real K3s testbed
  the live certificate predicts recoverability correctly and recovery is ≈6×
  faster than default Kubernetes.
- *Conclusion:* The assurance comes from problem structure (min-cut + a physical
  field); the learned layer only closes part of the gap and its RL variant
  fails — stated plainly, not inflated.
- *Contribution:* Gives IoT/edge operators and the network-and-service
  management community a checkable operational assurance of fault tolerance —
  decentralized and low-communication — that centralized schedulers do not emit.

Fused, that outline becomes a single tight paragraph. Always end on the
contribution: the last sentence a reader keeps is *who benefits and why*.
