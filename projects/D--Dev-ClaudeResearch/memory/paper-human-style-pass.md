---
name: paper-human-style-pass
description: Every paper edit and every pre-submission check must run the human-style review pass in the write-nlp-paper skill
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 57123419-c371-423b-947c-a6c5784f8b37
  modified: 2026-09-14T10:03:16.911Z
---

After any writing or revision of a paper, and always before submission, run the review pass in
`~/.claude/skills/write-nlp-paper/references/09-human-style-pass.md` without being asked: no bold run-in
paragraph labels, no em dashes, no slogan/aphorism/metaphor phrasing or round counting, no traces of tools or
workflow, only final-run results (no rerun or nondeterminism talk), claims matched to evidence, and a
whole-paper consistency sweep after changing a definition or term.

**Why:** the user reviewed FJCAI 2027 and ICEIR 2026 (2026-09) and found these patterns read as machine-polished
and self-defensive; they asked that the check be done every time.

**How to apply:** load the write-nlp-paper skill for any paper task, run the grep commands in section 09, decide
each hit by hand, recompile and recheck page limits. Related: [[topic-02-papers]].
