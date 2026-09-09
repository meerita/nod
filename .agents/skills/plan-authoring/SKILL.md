---
name: plan-authoring
description: "Convert an approved Nod investigation or an understood task into an executable plan with phases, dependencies, exit gates, and required evidence. Produces a plan artifact. Does not implement production code."
---

# Plan Authoring

Use `/plan-authoring` when the design is settled and the work is material.

Do not re-decide architecture. `/investigate` owns that.

## Ownership

`/plan-authoring` owns:

* Converting a settled decision into executable phases.
* Phase ordering and dependencies.
* The exit gate of each phase.
* The evidence each phase must produce.
* Creation of the plan artifact.
* Completion of the investigation the plan was authored from.

It does not own:

* Research or alternatives. Use `/investigate`.
* Implementation. Use `/implement`.
* Completion auditing. Use `/definition-of-done`.
* Plan invariants. `08-executable-plans.md` owns them.
* Artifact paths and states. `28-internal-artifacts.md` owns them.

## Start

Before authoring:

* Read `AGENTS.md`.
* Read the rules the work touches.
* Read the approved investigation when one exists.
* Inspect the repository state the plan will change.
* Surface blocking gaps.

Do not author a plan for a decision that is not settled.

## Input

Author from one of:

```text
an approved investigation
an understood task with a settled design
```

A plan authored from neither has no source for its decisions.

## Artifact

Write the plan at the path that `28-internal-artifacts.md` declares for a plan.

Use one file when the plan is small.

Use a directory with one master and one file per phase when one file cannot hold the plan
clearly.

The master carries the goal, the scope, the dependencies, and one status row per phase.

A phase file carries what only that phase needs.

## Invariants

`08-executable-plans.md` owns the invariants every plan satisfies.

Satisfy them. Do not restate them inside the plan.

## Phases

Each phase is one reviewable unit.

Each phase states:

* The rules it loads.
* Its observable outcome.
* Its exit gate.

Each phase ends in one commit. `02-git-and-branching.md` owns the commit and branch rules.

Do not defer all validation to the last phase.

Do not write a phase whose outcome cannot be observed.

## Rules Belong to the Phase

Name the rules a phase loads, so the implementing agent routes nothing.

Do not list `00-agent-behavior.md` or `01-project-invariants.md`. Every task reads them.

Do not name a rule whose domain the phase does not touch.

A phase that reaches an unnamed domain loads that rule and records it in the execution
record.

## Exit Gates

An exit gate names the evidence the phase produces.

State the exact expected result.

Ask for the cheapest evidence that supports the decision.

`08-executable-plans.md` rejects vague validation.

A gate that a phase repeats has written its cost into every phase. State a heavy gate once,
in the closing phase.

## The Closing Phase

A plan of more than one phase ends with a phase that owns the gates the others deferred.

It is a phase, with its own outcome, its own gate, and its own commit.

Size it for the defects it absorbs.

## Diagram

Carry a diagram of the phase dependencies, so the order and the parallel work are readable
without tracing prose.

In a directory plan the diagram lives in the master.

## Close the Investigation

A plan authored from an investigation completes that investigation in the same run.

```text
1. back up the investigation
2. reduce it to what the plan did not take
3. set its status to completed and record the reduction
4. move it to the completed state
```

`28-internal-artifacts.md` owns the paths, the states, and the re-check that a move obliges.

Reduction removes what the plan or a rule now owns. It keeps what nothing else owns: a
deferred question, a rejected alternative, negative evidence, and a gap carried forward.

An investigation whose direction was refused is rejected and does not move.

An investigation whose question is still open stays active and does not move.

A plan authored from no investigation completes nothing.

## Result

Report:

```text
Plan: <artifact>
Phases: <count>
Blocking gaps: <none or exact blocker>
Investigation: <completed artifact, or none>
```

Do not implement the plan. Use `/implement`.
