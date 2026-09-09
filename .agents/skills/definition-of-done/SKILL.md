---
name: definition-of-done
description: "Audit whether an implemented Nod task or plan delivered its required scope, decisions, outcomes, evidence, and closure conditions. Does not implement code or run development validation."
---

# Definition of Done

Audit an implemented task or plan.

Do not implement production code.

Do not run build, lint, test, benchmark, emulator, or hardware gates.

Use the evidence produced during implementation.

## Inputs

Require:

* The approved task or plan.
* The exact repository revision being audited.
* The implemented repository state.
* The implementation diff or commits.
* Phase execution records when a plan exists.
* Evidence produced during implementation.

Do not determine completion from a summary alone.

Do not reconstruct evidence that implementation failed to record.

## Primary Question

Answer:

> Did the implementation deliver what the approved task or plan required?

Evaluate the approved task or plan as written.

Do not add new requirements during this review.

## Scope

Compare implemented work with approved scope.

Confirm that:

* Required work exists.
* Required outcomes exist.
* Required ownership boundaries are preserved.
* Excluded scope remains excluded.
* Material scope deviations are recorded.
* Unrelated work did not replace required work.

A different implementation can satisfy the approved work when it preserves the required contract and decisions.

Do not require textual implementation fidelity when semantic fidelity is sufficient.

## Decisions

For each material approved decision, confirm that implementation follows it.

Check applicable decisions such as:

* Architecture.
* Ownership.
* Representation.
* Interfaces.
* Security.
* Compatibility.
* Persistence.
* Performance.

Report any implementation that contradicts a required decision.

Do not reinterpret the approved task or plan to fit the implementation.

## Phases

When a plan exists, for each phase confirm that:

* Required changes were implemented.
* The observable outcome exists.
* The exit condition was satisfied.
* Required validation was recorded.
* Required evidence exists.
* Material deviations were recorded.
* Blocking gaps were resolved or explicitly superseded.

Do not rerun phase work.

Do not repeat phase validation.

## Evidence

Compare required task or plan evidence with implementation evidence.

For each required result, confirm that the execution record contains the required proof.

Evidence can include:

* Build results.
* Lint results.
* Test results.
* Emulator results.
* Hardware results.
* Benchmark results.
* Binary inspection.
* Specification checks.
* Resource measurements.
* Reproduced defects and fixes.

A required result without recorded evidence is incomplete.

A failed required result is incomplete unless the approved task or plan explicitly accepts that result.

Do not infer a pass from code state.

Do not rerun missing evidence.

`implement` owns evidence production.

## Performance

When the task or plan requires performance evidence, confirm that:

* The required baseline exists.
* The required workload exists.
* The required metric exists.
* The required measurement exists.
* The environment is recorded when required.
* The result supports the required decision when required.
* Material negative results were preserved.

Do not benchmark again.

`42-performance.md` owns performance policy.

## Gaps

Inspect gaps referenced or opened by the task or plan.

Confirm that:

* Blocking gaps required for completion are closed.
* Deferred gaps remain explicit.
* Assumptions that became decisions were recorded.
* No implementation gap was hidden.

Do not create a new requirement because another design is possible.

`03-surfacing-gaps.md` owns gap form.

## Deviations

A deviation is acceptable when:

* It is recorded.
* Its reason is recorded.
* Required evidence supports it.
* It preserves the required approved outcome.
* The task, plan, or owning decision was updated when required.

A silent material deviation is incomplete.

## Documentation

When the task or plan requires documentation changes, confirm that:

* They exist.
* They match implemented behavior.
* Planned architecture changes are reflected.
* Planned interface changes are reflected.
* Planned persistent-format changes are reflected.

Do not expand documentation scope during this review.

## Closing Phase

When a plan has a closing phase, confirm that:

* It was executed.
* Its required evidence exists.
* Its exit condition was satisfied.
* Defects it exposed were resolved or explicitly accepted.
* Required closure work happened.

Do not repeat closing-phase work.

## Result

Return one status:

```text
DONE
NOT DONE
BLOCKED
```

Use `DONE` when implementation and recorded evidence satisfy the approved task or plan.

Use `NOT DONE` when required work, evidence, or closure is missing.

Use `BLOCKED` when completion cannot be determined because required information or a blocking gap remains unresolved.

## Report

Report only:

* Status.
* Audited revision.
* Missing required work.
* Task or plan deviations.
* Missing required evidence.
* Open blocking gaps.
* Required corrections.

Do not report unrelated improvements.

Do not propose new scope.

Do not run development validation.
