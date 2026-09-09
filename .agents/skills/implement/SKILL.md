---
name: implement
description: "Implement an approved Nod task or plan, run its required development validation, and record the evidence needed to prove completion."
---

# Implement

Implement approved work.

Do not expand scope without evidence.

## Start

Before implementation:

* Read `AGENTS.md`.
* Read the applicable rules.
* Read the approved plan when one exists.
* Inspect the current repository state.
* Inspect the files that the task will change.
* Check for unrelated working-tree changes.
* Surface blocking gaps.

Do not modify code that you have not inspected.

## Scope

Implement only the approved scope.

For each change:

* Keep ownership local.
* Preserve unrelated behavior.
* Preserve unrelated formatting.
* Avoid speculative abstractions.
* Avoid cleanup that the task does not require.

When new work becomes necessary:

* Determine whether it is required for correctness.
* Record the reason.
* Keep the new work minimal.
* Update the plan when the scope changes materially.

Do not hide scope expansion inside implementation.

## Rules

Load the rules for each domain that the implementation touches.

Do not duplicate rule text inside code or plans.

If implementation enters a new domain:

1. Load the owning rule.
2. Apply it before continuing.
3. Record the new rule in the execution record when a plan exists.

## Architecture

Preserve ownership boundaries.

Before crossing a boundary, identify:

* The owner of the data.
* The owner of the operation.
* The dependency direction.
* The trust boundary.
* The failure boundary.

Do not move policy into a lower-level mechanism.

Do not let compatibility behavior define native Nod semantics.

Do not leak architecture-specific types into architecture-independent code.

## Code

Prefer:

* Small changes.
* Small functions.
* Explicit ownership.
* Explicit state transitions.
* Explicit error paths.
* Existing project patterns.

Avoid:

* Hidden allocation.
* Hidden blocking.
* Unnecessary cloning.
* Unnecessary dynamic dispatch.
* Global mutable state.
* New abstractions with one speculative use.
* Unrelated refactors.

Use safe Rust by default.

`15-unsafe.md` owns unsafe code.

## Files

For each changed file:

* Keep one clear ownership concern.
* Preserve local structure.
* Keep comments within their class and budget.
* Update documentation when behavior changes.

Do not edit generated source by hand.

`05-comments-and-source-files.md` owns source-file form.

## Testing

Add tests with the behavior they protect.

For a bug fix:

* Reproduce the defect when practical.
* Add a regression test.
* Apply the fix.
* Confirm the regression test passes.

For new behavior:

* Test the public contract.
* Test relevant errors.
* Test relevant boundaries.

`40-testing.md` owns test policy.

## Validation

Run the validation required by the current phase or task.

Prefer the cheapest useful gate during development.

Run heavier gates only when the plan assigns them to the phase.

Do not weaken a gate to make the implementation pass.

Do not report a required gate as passed unless it was run successfully.

## Evidence

Implementation owns evidence production.

For every required plan result:

* Produce the required evidence.
* Record the command or method when relevant.
* Record the result.
* Record the environment when relevant.
* Preserve material measurements.
* Preserve failed results when they affect the decision.

Evidence can include:

* Build results.
* Lint results.
* Test results.
* Emulator results.
* Hardware results.
* Benchmark results.
* Binary inspection.
* Specification checks.
* Measured resource use.
* Reproduced defects and fixes.

Do not make `definition-of-done` reconstruct missing evidence.

Do not rely on memory or a conversational summary as the only evidence.

## Execution Record

For each implemented phase, record:

* Status.
* Material changes.
* Material deviations.
* New rules loaded.
* Validation run.
* Evidence produced.
* Failed gates.
* Defects found.
* Gaps opened or closed.
* Exit condition result.

Keep the record concise.

Record facts required by later phases or `definition-of-done`.

Do not turn the execution record into a development diary.

## Performance

When the phase requires performance evidence:

* Preserve the baseline.
* Use the planned workload.
* Measure the planned metric.
* Record the environment.
* Record the result.
* Keep negative results.

Do not claim improvement without recorded evidence.

`42-performance.md` owns performance policy.

## Failures

When validation fails:

* Determine whether the change caused the failure.
* Fix failures caused by the change.
* Record unrelated pre-existing failures.
* Preserve failure evidence when it affects completion.

Do not hide failed required validation.

## Phase Completion

Before completing a phase:

* Confirm its required changes exist.
* Run its required validation.
* Record its required evidence.
* Check its exit condition.
* Record material deviations.
* Record remaining gaps.

Do not start a dependent phase before the current phase satisfies its exit condition unless the plan permits it.

## Completion

Before reporting implementation complete:

* Inspect the final diff.
* Check for unrelated changes.
* Check for stale comments.
* Check for stale documentation.
* Check for unresolved blocking gaps.
* Confirm required evidence is recorded.

Implementation completion does not replace `definition-of-done`.

`definition-of-done` performs the final plan-to-result audit.
