---
name: strengthen-review-paper
description: >-
  Turn a literature review / survey / SLR into genuine scientific synthesis that
  survives the standard editor gauntlet, instead of a paper that only compiles,
  classifies, and summarizes existing work. Use whenever the user is writing,
  revising, "finishing", or polishing a review/survey/systematic review, or
  responding to editor/reviewer comments on one — especially when the worry is
  that it "just summarizes existing studies", "isn't novel enough", "reads like
  a list", "needs a conceptual framework", or "lacks a real contribution".
  Trigger even without the word "review": e.g. "the editor says my survey just
  compiles papers", "how do I make my literature review more original", "reviewer
  wants deeper analysis of each method family", "my future-work section is just a
  list", "why is another review on this topic needed", "viết lại phần tổng quan
  cho có đóng góp khoa học", "editor chê bài chỉ tổng hợp tài liệu", "làm rõ tính
  mới so với các survey trước". Works in any language. Complements write-abstract
  (which handles the abstract itself).
---

# Strengthen a review paper into synthesis

## The core problem this solves

Reviews get "major revision" or "reject" for one recurring reason: they **organize**
the literature (compile → classify → summarize reported results) instead of
**synthesizing** it (explain *why*, connect the pieces, produce a new way to read
the field). A review's contribution is **a new understanding of the evidence, not a
new pile of references.** Adding the latest papers to an existing taxonomy does not
answer "why is another review needed?".

The reliable move: convert prose claims into **structured artifacts** (comparison
table, framework figure, trade-off table, cause-effect table) that make the
synthesis visible and checkable. Each artifact below is what actually silences a
specific editor objection.

## The editor gauntlet — five recurring questions

Almost every review-paper decision letter is some subset of these. Treat them as a
pre-submission checklist; each has a concrete deliverable.

### 1. "How does this differ from prior surveys? Why is another review needed?"
The charge: *you re-catalogued a solved problem.* Recency ("we add the newest
methods") is never a sufficient answer.
- Build a **head-to-head comparison table**: rows = the N most representative prior
  surveys (span the sub-areas, not 2–3 cherry-picked); columns = the dimensions of
  novelty. Include a **capability column that is empty for every prior survey and
  filled only by yours** — that empty column *is* the gap.
- State the **coding procedure** for the table in one sentence (who coded, criterion
  for "addressed", how ambiguity was resolved) so it reads as evidence, not opinion.
- Add one sentence naming the contribution as a *reinterpretation*, e.g. "This
  reinterpretation, not the additional references, is the contribution." Split
  contributions into **methodological** vs **conceptual** groups in the intro.

### 2. "Give a deeper, more critical analysis of each family / approach."
The charge: *you listed results, you didn't explain them.* For each family, prose
must cover four things, not just the numbers:
- **Evidence/mechanism**: what signal it exploits and **why** high scores arise
  (e.g. dataset shortcuts, modality consistency, propagation structure).
- **When it fits**: the scenario where it is the right choice.
- **Limits**: data need, latency, cost, transferability.
- **Trade-offs made explicit**: build a **trade-off table** — families × {in-domain
  performance, generalization, explainability, labeled-data need, compute, early
  detection, …}. Use a small ordinal scale (Low/Moderate/High/**Conditional**), and
  **state the rating rule** ("High = consistently present across representative
  studies; ratings are structured qualitative judgments, not measured aggregates").
  Split "data need" into *labeled data* vs *compute* when they diverge.

### 3. "Your classification is systematic but gives no new conceptual perspective."
The charge: *a flat taxonomy counts the field but doesn't explain it.* The tell:
your categories are not on the same conceptual level (e.g. one names an
architecture, another a data type, another a usage mode).
- Introduce a **higher-level framework**: 3–4 **orthogonal-ish dimensions** (state
  them as "complementary, though operationally interacting", not strictly
  "orthogonal") that the existing categories *map across* rather than *onto*.
- Add a **figure** of the dimensions and a **table positioning each category on
  each dimension** (the figure shows the axes; the table does the positioning — a
  figure that only lists boxes will be told it "just illustrates a list").
- Use the framework to explain **relationships, evolution, and integration**: recast
  a "trends" list as **cumulative, overlapping stages** ("X-centric → … →
  robust-adaptive"), and state the one-line thesis of where the field is moving.
  A small **stage table** (stage / dominant evidence / enabling tech / unresolved
  limitation / integration with later stages) makes it hard to dismiss as a renamed
  trend list.

### 4. "Research gaps and future directions are largely descriptive."
The charge: *your future work is a wish-list.* Independent bullet-point challenges
read as description.
- Build a **cause→effect table**: root cause (usually in data/evaluation design) →
  direct challenge → deployment consequence → **which priority it maps to**.
- State the **tensions/trade-offs** among challenges (early detection vs evidence
  completeness; accuracy vs explainability; specialization vs generalization) — this
  is the "relationships among challenges" editors ask for.
- Give a **prioritized agenda** and **justify the order** with a dependency argument
  ("P1 first because reliable evaluation is a prerequisite for judging P2–P5"). Prefer
  **"dependency-ordered"** over **"causally ordered"** — a narrative review cannot
  establish causation, and reviewers will call that out.

### 5. "Clarify the broader contribution of the narrow/case-study part."
The charge: *why should a general reader care about your niche?* (Applies to any
case study, benchmark deep-dive, or single-domain section, not just one language.)
- Add a subsection that **abstracts the case into transferable principles**, and
  label them explicitly as **hypotheses to be tested**, not proven generalizations —
  this is honest and reviewer-proof.
- **Define scope terms** you lean on (e.g. what exactly "low-resource" or
  "resource-constrained" means here) and, where possible, cite ≥1 other setting so
  the claim isn't a single data point.

## Cross-cutting rigor reviewers reward

These are not in every letter but pre-empt the next one:
- **Verifiability**: check each headline number against its **primary source**; say
  "every extracted headline metric used in the synthesis was confirmed", not "every
  metric". Release the evidence base (a CSV of the included studies).
- **No invalid aggregation**: do not convert between metrics (Accuracy/F1/AUC) or
  pool across heterogeneous datasets/tasks; report **ranges**, and compare only
  within a **matched (dataset, task)** setting. Drop or flag single unreliable
  outliers.
- **Bias appraisal**: report a **qualitative, corpus-level appraisal of potential
  sources of bias** (leakage, split protocol, external validation, result
  selection, reproducibility). Call it exactly that — not a "risk-of-bias
  assessment" — unless you actually scored each study; distinguish *"unclear due to
  insufficient reporting"* from *"poorly conducted"*.
- **Don't fabricate a PRISMA funnel**: if you did not run a real exhaustive database
  search with per-source counts and independent screeners, do **not** claim a
  "systematic literature review". Reframe honestly (e.g. "structured,
  verifiability-focused review") and say plainly what you did not do.

## The hedging ladder — calibrate every strong claim

Reviewers punish claims stronger than the evidence. For each assertion, know which
rung it is on and phrase it accordingly:
1. **Evidence from the corpus** — state plainly ("GPT-4 reaches 68.2% on X [ref]").
2. **Author interpretation** — flag it ("in our reading of the reviewed evidence…",
   "appears shaped as much by … as by …" instead of "is driven more by").
3. **Practical recommendation** — frame as advice, not fact.
4. **Hypothesis needing validation** — say "transferable hypotheses to be tested".

Soften absolutes: "none" → "none of the N examined"; "most likely reflects leakage"
→ "is vulnerable to explanations such as leakage or dataset-specific separability";
"proves" → "suggests". Never call a benchmark "easy" or a dataset "curated" without
a criterion — say "with strong dataset-specific separability" or "evaluated
in-distribution".

## Pre-submission consistency & presentation checklist

Editors who can't *read* the contribution will not credit it.
- **Terminology consistency** across **title, filename, submission system, abstract,
  RQs, contributions, conclusion, and the response letter** — the article-type name
  and every RQ label must match everywhere.
- **RQ ↔ Conclusion**: every research question is answered in the conclusion using
  the *same wording*. If you upgrade RQs to analytical questions (factors, trade-offs,
  evolution, priorities), update the conclusion in lockstep.
- **Wide tables must render**: put comparison / trade-off / stage tables in
  **landscape**, cut columns, use ✓/— and short cell values; a contribution shown in
  a broken, column-shifted table is a contribution the editor cannot see.
- **Figures legible**: large enough font; a framework figure must actually *position*
  the items its caption claims it does.
- **Auto-number** tables/figures and cross-references so inserting one artifact
  doesn't silently break the rest.
- Kill duplicated sentences, "an curated"-type artifacts, and stray old numbers after
  edits.

## Writing the response-to-editor letter

- **Point-by-point**: quote each editor comment, then "Response:", then the exact
  Section/Table/Figure changed.
- After each point add a **"Resulting scientific point"** — the *conclusion* the
  change produced, not just its location ("This yields the finding that …"). Editors
  want to see new understanding, not a diff.
- **Never let the letter overclaim beyond the manuscript**: if the paper says "among
  the surveys examined", the letter must not say "none of all surveys ever"; if the
  paper verified *headline* metrics, don't write "every metric". Mismatch invites a
  new round of questions.
- Only say a supplement is "released/provided" if it is **actually in the submission
  package** — verify the file is attached.
