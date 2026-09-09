---
name: document
description: "Update durable Nod documentation after implementation is complete and validated. Documents actual behavior, contracts, guarantees, limits, and evidence. Does not invent architecture or present intent as current behavior."
---

# Document

Use `/document` after `/definition-of-done` when durable behavior changed.

Write a public page for current behavior only.

## Ownership

`/document` owns:

* Updating a public page after validated behavior changed.
* Stating the scope a documented behavior holds under.
* Keeping a page consistent with `master`.

It does not own:

* Architecture decisions. Use `/investigate`.
* Implementation. Use `/implement`.
* Completion auditing. Use `/definition-of-done`.
* The page contract and the tree layout. `29-public-documentation.md` owns them.
* Writing style and terminology. `04-writing-and-documentation.md` owns them.

## Start

Before writing:

* Read `AGENTS.md`.
* Read `29-public-documentation.md`.
* Read the implementation evidence the change produced.
* Inspect the current behavior in the repository.

Do not document behavior you have not verified.

## Evidence

An internal artifact is evidence, not a public dependency.

`28-internal-artifacts.md` owns that corpus.

A page never cites an internal artifact, because a reader of the repository does not have it.

## Scope

State the scope of every documented behavior:

```text
the version, and the version axes the behavior depends on
the configuration it holds under
the limits it holds within
the known gaps
the validation evidence, when the claim needs it
```

A guarantee with no named configuration is an unscoped claim.

## Current Behavior Only

Document what `master` does now.

Intent is not documentation.

Do not present a plan, a roadmap item, or an investigation direction as current behavior.

`29-public-documentation.md`, Current State Only, owns what a page must not carry.

## Pages

A page is one shape for one reader.

`29-public-documentation.md`, Page Classes, owns the shapes and the trees.

A contract page states its surface precisely enough to implement against.

## Diagrams

When this change alters a flow, a boundary, a lifecycle, or a decision path that an existing
diagram draws, update that diagram in the same change.

A diagram that no longer matches `master` is a gap, not a cosmetic issue.

## Voice

A page states what `master` does, and stops.

No opener, no recap, no reader instruction, no enthusiasm marker, and no hedge that carries
no measurement.

`04-writing-and-documentation.md` owns the register.

## Result

Report:

```text
Pages: <changed pages>
Behavior documented: <revision>
Unscoped claims found: <none or exact page>
Gaps: <none or exact blocker>
```
