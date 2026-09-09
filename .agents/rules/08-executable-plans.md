---
name: 08-executable-plans
description: "Defines the invariants that every Nod implementation plan must satisfy."
owns: "plan invariants; plan completeness; validation ownership"
see-also: [03-surfacing-gaps.md, 40-testing.md, 42-performance.md]
---

# 08. Executable Plans

## Invariants

A plan:

1. describes executable work.
2. has one explicit goal.
3. defines its scope.
4. defines excluded scope when needed.
5. separates required work from optional work.
6. exposes blocking gaps.
7. orders work by dependency.
8. does not invent work for unrelated future milestones.
9. changes when evidence invalidates it.
10. closes only with evidence.

Each phase:

1. has one observable outcome.
2. defines its validation.

Performance work defines a baseline and a metric.

## Validation

Each planned requirement must map to evidence.

Valid evidence includes:

* Build gates.
* Lint gates.
* Unit tests.
* Integration tests.
* Emulator tests.
* Hardware tests.
* Benchmarks.
* Binary inspection.
* Specification checks.

Do not use vague validation such as:

```text
test thoroughly
verify it works
check performance
```

## Gaps

Do not hide an unresolved dependency inside a plan.

For a blocking gap:

* Record it.
* Mark the affected work as blocked.
* Continue independent work when practical.

`03-surfacing-gaps.md` owns gap form.

## Completion

A plan is complete only when:

* Required work is complete.
* Required validation passes.
* Required evidence exists.
* Blocking gaps are closed.
* Remaining non-blocking gaps are reported.
