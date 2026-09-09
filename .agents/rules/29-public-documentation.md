---
name: 29-public-documentation
description: "Defines the architecture and page contract of Nod public documentation."
owns: "public documentation architecture; page contract; page classes"
see-also: [03-surfacing-gaps.md, 04-writing-and-documentation.md, 28-internal-artifacts.md]
---

# 29. Public Documentation

Public documentation states durable behavior available from `master`.

The internal corpus is the other documentation class. `28-internal-artifacts.md` owns it.

A public page never depends on an internal artifact.

## Structure

```text
docs/guide/
docs/commands/
docs/interfaces/
docs/architecture/
docs/operations/
docs/compatibility/
docs/development/
```

`docs/commands/` and `docs/interfaces/` are the contract trees.

An official command name is an interface. `01-project-invariants.md` states it, and
`22-system-commands-and-shell.md` owns the contract itself.

A contract page is precise enough to implement against, or it is incomplete.

## The Page Header

Every page under `docs/` opens with a YAML frontmatter block.

The header is the only place a page states its metadata.

Do not repeat a header field in the body.

Required:

```text
title          the name of the subject, matching the H1 that follows
description    one sentence, stating what the page covers
class          guide, reference, explanation, or contribution
audience       the one reader the page is written for
order          position of the page inside its tree, counting from 1
```

Stated when the page depends on them:

```text
version_axes        every version axis the content depends on
interface_version   the system interface version the page specifies
command             the official command the page documents
status              the implementation status of a specified contract
applies_to          the part of the repository a contribution page covers
persistent_format   the persistent format the documented version writes
```

A page with a version axis and no `version_axes` entry has an incomplete header.

## Current State Only

A page states what `master` does now.

A page is not a history of Nod.

Do not write:

```text
what an earlier version did
what changed between two versions
what was removed, renamed, or replaced
a migration note from a previous behavior
a dated entry or a changelog section
a statement kept for a reader of an older version
```

When behavior changes, the page changes with it, and the previous statement is deleted.

The Git log holds the change and the reason for it. `02-git-and-branching.md` owns it.

A version axis in the header is not history. It states which versions the content depends on.

## Page Classes

A page is written for one audience and one shape.

Do not mix two shapes on one page.

| Class | Shape | Reader | Tree |
|---|---|---|---|
| guide | task | someone using Nod for the first time, or performing one task | `docs/guide/` |
| reference | exhaustive | someone implementing or operating against a surface | `docs/commands/`, `docs/interfaces/`, `docs/operations/`, `docs/compatibility/` |
| explanation | conceptual | someone who needs the model behind the behavior | `docs/architecture/` |
| contribution | procedural | someone building or changing Nod | `docs/development/`, `CONTRIBUTING.md` |

A guide reaches a working result. It states the steps in order, shows the expected output,
and names the limits of what it demonstrates.

A guide does not become a partial copy of a reference. It links to the reference.

## The Command Surface

An official command is a public surface.

Document its arguments, its options, its inputs and outputs, and its exit results.

`22-system-commands-and-shell.md` owns each of those contracts. Documentation follows it and
does not restate it.

An option with no documented default is an incomplete entry.

## README and CONTRIBUTING

`README.md` is the entry page of the repository.

It states what Nod is, what `master` provides now, how to build and run it, and where the
documentation trees are.

It scopes every claim, and it does not restate intent as current capability.

`CONTRIBUTING.md` states how to build, validate, and submit a change.

It does not duplicate the rule corpus. It links to the owning rule.

## Guarantees

Do not state a durability, consistency, isolation, or performance guarantee without naming
the configuration and mode it holds under.

Do not write an unqualified claim such as "fully compatible", "faster", or "lock-free"
without current evidence for the specific path.

## Diagrams on a Page

A page carries a diagram of every structure it describes from this list:

```text
a pipeline or a data flow
an architectural boundary or a dependency direction
a lifecycle or a state machine
a decision path with more than two outcomes
an exchange between two or more processes
```

The diagram sits with the prose that states the same fact.

A frame layout, a list of values, a captured output, or a policy enumeration needs no
diagram. A frame layout stays a plain text block, because its alignment is the content.

A diagram that no longer matches `master` is a gap. `03-surfacing-gaps.md` owns the form.
