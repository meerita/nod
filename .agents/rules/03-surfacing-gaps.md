---
name: 03-surfacing-gaps
description: "Defines how Nod records unknowns, missing requirements, blocked decisions, and incomplete work."
owns: "gaps; unknowns; blocked decisions; incomplete work"
see-also: [00-agent-behavior.md, 04-writing-and-documentation.md, 08-executable-plans.md]
---

# 03. Surfacing Gaps

## Invariants

1. Do not hide a gap.
2. Do not resolve a gap by guessing.
3. Separate known facts from assumptions.
4. Record a gap when it can affect correctness, architecture, safety, compatibility, or validation.
5. Keep a gap close to the artifact that owns the unresolved question.
6. Close a gap only with evidence or an explicit decision.
7. Do not use a TODO comment as a substitute for a gap.
8. Do not block unrelated work when the gap does not affect it.
9. Do not describe incomplete behavior as complete.
10. Preserve unresolved alternatives until a decision owns the choice.

## A Gap Exists When

Record a gap when one of these is unknown:

* Required behavior.
* Ownership.
* Trust boundary.
* Hardware behavior.
* External specification detail.
* Failure behavior.
* Compatibility requirement.
* Resource limit.
* Performance target.
* Validation method.
* Recovery behavior.
* Public interface.
* Required invariant.

A question is not a gap when existing code, documentation, tests, or specifications already answer it.

Inspect those sources first.

## Gap Form

Use the smallest form that preserves the problem:

```text
GAP: <short statement>

Known:
- <fact>

Unknown:
- <missing fact>

Blocks:
- <decision or work affected>
```

Add alternatives only when they already exist:

```text
Candidates:
- A: ...
- B: ...
```

Do not invent alternatives to make the record look complete.

## Assumptions

When work can continue with an assumption:

* State the assumption.
* State what depends on it.
* Keep the assumption reversible.
* Do not present it as a project decision.

Example:

```text
ASSUMPTION: QEMU exposes one generic timer during M0.

Affects:
- Initial timer bring-up only.
```

An assumption does not become an invariant through repetition.

## Blocking Gaps

A gap is blocking when continuing would require guessing about:

* Memory safety.
* Hardware correctness.
* Persistent data format.
* Security authority.
* Public ABI.
* Destructive behavior.
* Recovery semantics.
* Required compatibility.

Stop the affected work at that boundary.

Continue independent work when practical.

## Non-Blocking Gaps

A gap can remain open when:

* The current implementation does not depend on it.
* The decision can change without breaking the current contract.
* The work is exploratory.
* A later milestone owns the decision.

Do not solve future gaps early only to remove uncertainty.

## Closing a Gap

Close a gap with one of:

```text
code evidence
test evidence
benchmark evidence
hardware measurement
external specification
architecture decision
explicit requirement
```

When a decision closes the gap:

* Record the decision in the owning artifact.
* Remove stale alternatives.
* Update affected plans or documentation.
* Remove temporary assumptions that no longer apply.

## Do Not Use

Do not use:

```text
TODO with no owner
FIXME with no explanation
"probably"
"should work"
"likely"
"for now" with no boundary
silent fallback behavior
an invented default
an undocumented assumption
```

These forms hide uncertainty instead of owning it.

## Source Comments

Do not store project gaps in source comments unless the gap is local to that source and cannot affect architecture.

Prefer a gap record or planning artifact.

A source comment can point to the owning gap:

```rust
// See GAP-12: interrupt affinity policy is not defined yet.
```

`05-comments-and-source-files.md` owns comment form.

## Completion

Before reporting work as complete:

* Check for unresolved blocking gaps.
* Report any remaining non-blocking gaps.
* Do not convert a gap into implied future work without recording it.
* Do not claim full completion when a required decision remains open.
