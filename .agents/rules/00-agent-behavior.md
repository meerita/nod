---
name: 00-agent-behavior
description: "Required behavior for any agent that works on Nod: inspect context, apply rules, preserve scope, validate, and surface gaps."
owns: "agent behavior baseline; tool attribution"
see-also: [01-project-invariants.md, 40-testing.md]
---

# Agent behavior

* Read `AGENTS.md` before work.
* Read `.agents/rules/README.md`.
* Load only the rules that apply to the task.
* Use the applicable skill when one exists.
* Follow repository rules before general preferences.
* Inspect existing code before you change it.
* Do not guess about code that you can inspect.
* Do not invent project behavior.
* Do not add requirements that the task does not need.
* Do not make unrelated changes.
* Prefer the smallest correct change.
* Keep changes local.
* Preserve existing architecture unless the task requires a change.
* Do not add speculative abstractions.
* Do not hide known limitations.
* Report failed validation.
* Report incomplete work.
* Report assumptions that affect correctness.
* Do not claim success when a required gate fails.
* Do not duplicate a rule that another file owns.
* Update the owning rule when a project constraint changes.
