---
name: investigate
description: "Investigate a Nod problem before implementation. Establishes verified state, constraints, alternatives, evidence, gaps, decisions, and durable project guidance. Does not implement production code."
---

# Investigate

Investigate before implementation when the correct design is not yet established.

Do not implement production code.

## Start

Before investigation:

* Read `AGENTS.md`.
* Read the applicable rules.
* Inspect the relevant repository state.
* Identify the owning subsystem.
* Identify known constraints.
* Surface blocking gaps.

Do not research a question that the repository already answers.

Do not assume current behavior from documentation when code can verify it.

## Investigation Question

State one primary question.

The question must be:

* Specific.
* Decision-relevant.
* Testable when practical.
* Narrow enough to close.

Use secondary questions only when they support the primary question.

Do not turn an investigation into a general survey.

## Artifact

Write the investigation at the path that `28-internal-artifacts.md` declares for an
investigation.

Use a directory only when one file cannot hold the required evidence clearly.

## Required Structure

An investigation contains:

* Question.
* Scope.
* Non-goals.
* Verified current state.
* Constraints.
* Relevant evidence.
* Alternatives.
* Findings.
* Gaps.
* Decision or recommendation.
* Durable rule impact.
* Validation needed before implementation.

Omit a section when it has no content.

## Verified State

Verify relevant facts from the strongest available source.

Prefer:

```text
code
-> tests
-> generated artifacts
-> measurements
-> repository documentation
-> external specifications
-> external research
```

Use the source appropriate to the fact.

Do not replace repository evidence with external general knowledge.

Distinguish:

* Verified fact.
* Measurement.
* Inference.
* Assumption.
* Open gap.

## External Research

Use external research when the question depends on:

* Hardware specifications.
* Protocol specifications.
* Architecture manuals.
* Published algorithms.
* Security properties.
* Prior operating-system work.
* Performance research.
* Compatibility behavior.

Prefer primary sources.

Examples:

* Architecture manuals.
* Standards.
* Specifications.
* Papers.
* Official implementation documentation.

Use secondary sources only when they add useful context.

Record enough source information to reproduce the research.

Do not copy an external design into Nod without evaluating its constraints.

## Alternatives

Include an alternative only when it is plausible.

For each material alternative, compare relevant properties such as:

* Correctness.
* Safety.
* Complexity.
* Ownership.
* Isolation.
* Memory cost.
* CPU cost.
* Latency.
* Portability.
* Hardware requirements.
* Compatibility.
* Failure behavior.
* Maintainability.

Do not force every investigation into the same comparison matrix.

Do not invent weak alternatives to make one option look better.

## Experiments

Use an experiment when documentation cannot answer the question reliably.

An experiment must define:

* Question.
* Baseline.
* Variable.
* Workload.
* Metric.
* Environment.
* Result.
* Interpretation.

Keep experimental code outside production paths unless the investigation accepts it.

Do not treat one measurement as a general property without justification.

## Performance Investigation

For performance questions:

* Measure before proposing optimization.
* Use equivalent workloads.
* Record the environment.
* Report distribution when relevant.
* Inspect CPU, memory, allocation, and latency when they affect the decision.
* Keep negative results.

A failed optimization is evidence.

Do not discard it because it does not support the expected result.

`42-performance.md` owns performance rules.

## Hardware Investigation

For hardware questions:

* Identify the exact architecture.
* Identify the exact device when relevant.
* Use the authoritative specification.
* Separate architectural behavior from implementation behavior.
* Separate emulator behavior from physical hardware behavior.
* Record undocumented behavior as a gap.

Do not infer hardware guarantees from one successful run.

## Security Investigation

For security questions, identify:

* Authority.
* Trust boundary.
* Privileged state.
* Attacker capability.
* Failure impact.
* Isolation boundary.

Do not call a design secure because it is memory-safe.

`07-security.md` owns security policy.

## Gaps

Record a gap when evidence cannot resolve a material question.

Do not guess through it.

`03-surfacing-gaps.md` owns gap form.

## Recommendation

A recommendation must follow from the evidence.

State:

* Recommended direction.
* Why it wins.
* Material tradeoffs.
* Remaining uncertainty.
* Evidence still required during implementation.

Use `No decision` when the evidence is insufficient.

Do not manufacture certainty.

## Promote Proven Decisions

Do not leave a settled architectural decision only inside an investigation.

When the evidence shows that one option dominates the relevant alternatives for Nod:

1. State the scope in which the result holds.
2. Confirm that no material tradeoff remains unresolved.
3. Identify the rule that owns the decision.
4. Add the resulting preference or invariant to that rule.
5. Link the rule change to the investigation evidence.
6. Remove obsolete ambiguity from affected documentation.

Example:

```text
Investigation:
buddy allocator vs bitmap allocator

Result:
buddy dominates for the Nod physical-frame allocator
under the required latency, memory, fragmentation,
scalability, and implementation constraints.

Rule impact:
13-memory-management.md

New preference:
Prefer a buddy allocator for physical-frame allocation.
Use another design only when new evidence invalidates
the assumptions or proves a material advantage.
```

Promote a result only when the evidence is strong enough to stop repeating the same decision.

Do not promote:

* A result from one narrow benchmark as a universal rule.
* A preference with unresolved material tradeoffs.
* An implementation detail that does not affect future decisions.
* A temporary workaround.
* A result that depends on an undocumented assumption.

A promoted preference remains revisable when new evidence invalidates it.

Rules are durable project knowledge, not permanent dogma.

## Durable Rule Impact

End each investigation with one of:

```text
RULE IMPACT: none
RULE IMPACT: update <rule>
RULE IMPACT: create <rule>
```

When rule impact exists, state:

* The proven decision.
* Its scope.
* The evidence that supports it.
* The condition that could invalidate it.

Do not make future agents rediscover a settled decision.

## Closure

An investigation is complete when:

* The primary question is answered or explicitly remains unresolved.
* Relevant evidence is recorded.
* Material alternatives are evaluated.
* Blocking gaps are visible.
* The recommendation follows from the findings.
* Durable rule impact is resolved.
* Required implementation validation is identified.

Do not implement the recommendation as part of this skill.

If implementation is approved, use `plan-authoring`.
