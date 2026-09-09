---
name: 28-internal-artifacts
description: "Defines the Nod internal artifact corpus: its classes, paths, lifecycle states, and the owner of each transition."
owns: "internal artifact corpus; artifact paths; artifact lifecycle states; transition ownership"
see-also: [03-surfacing-gaps.md, 04-writing-and-documentation.md, 08-executable-plans.md]
---

# 28. Internal Artifacts

## Invariants

1. The corpus holds work artifacts, not repository history.
2. Each artifact class has one declared path.
3. Each artifact has one current state.
4. One skill owns each transition.
5. A path is declared here and cited everywhere else.

## Corpus

The corpus is not tracked.

Git preserves no history for a corpus file.

Back up an untracked file before you change it.

## Classes and Paths

```text
investigation   tmp/investigations/<NN>-<short-topic>.md
                tmp/investigations/completed/
plan            tmp/plans/<NN>-<short-topic>.md
                tmp/plans/completed/
research        tmp/research/
compatibility   tmp/compatibility/<NN>-<short-topic>.md
backup          tmp/backups/<date>-<topic>/
```

Use a directory instead of one file when one file cannot hold the artifact clearly.

## States

An investigation is `active`, `completed`, or `rejected`.

A plan is `active` or `completed`.

A completed artifact lives under `completed/` inside its own class.

A rejected investigation does not move.

A research, compatibility, or backup artifact has no state transition.

## Transitions

```text
create an investigation     investigate
complete an investigation   plan-authoring
create a plan               plan-authoring
complete a plan             pr-merge
```

Do not perform a transition that another skill owns.

Report an artifact in an illegal state as a gap.

## Moving an Artifact

Moving an artifact changes its path.

Re-check every artifact that cites the old path.

The corpus is not tracked, so a recursive search from the repository root skips it.

Search the corpus with explicit paths or with the ignore filter disabled.

## Form

This rule owns location and state.

It does not own the internal form of an artifact.

`08-executable-plans.md` owns plan invariants.

`investigate` owns investigation structure.
