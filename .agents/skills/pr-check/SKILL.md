---
name: pr-check
description: "Check whether a Nod topic-branch pull request is mechanically ready to merge into master. Reads existing completion evidence and repository/PR state; does not review implementation, rerun validation, or merge."
---

# PR Check

Use `/pr-check` after `/definition-of-done` reports `DONE` for the revision proposed for merge.

This skill owns **integration readiness**, not implementation correctness.

## Ownership

`/pr-check` owns:

* Pull-request base/head verification.
* Revision identity.
* Branch-policy compliance.
* Mergeability.
* Required remote check state.
* Pull-request metadata required by `02-git-and-branching.md`.
* Draft-to-ready transition.

It does not own:

* Design. Use `/investigate`.
* Planning. Use `/plan-authoring`.
* Implementation or fixes. Use `/implement`.
* Performance evidence. Use `/benchmark`.
* Compatibility evidence. Use `/compatibility`.
* Plan/task completion auditing. Use `/definition-of-done`.
* Code review of an external contribution. Use `/pr-review` when that skill is enabled.
* Merge execution. Use `/pr-merge`.
* Release creation or tagging.

## Required State

The ordinary Nod integration path is:

```text
topic branch
    |
    v
pull request
    |
    v
master
```

Nod does not require a permanent `dev` branch.

The pull request must target `master`.

## Inputs

Require:

* The pull request.
* Its current head revision.
* A `DONE` result from `/definition-of-done` for that exact revision.
* Repository branch policy from `02-git-and-branching.md`.

If the pull-request head changed after the completion audit, the previous audit is stale.

Do not compensate by rerunning implementation validation here.

Return the work to `/definition-of-done`.

## Checks

Check only integration-readiness facts:

```text
base branch is master
head is a topic branch, not master
the PR head SHA equals the revision audited by definition-of-done
the branch obeys published-history rules
the pull request is mergeable
required remote checks are already successful
required branch protection is satisfied
required PR metadata is present
the proposed merge strategy preserves repository history policy
no unresolved merge conflict exists
```

`02-git-and-branching.md` owns pull-request metadata.

Do not repeat the task/plan audit.

Do not independently decide whether:

* scope was implemented,
* architecture decisions were followed,
* tests were sufficient,
* benchmarks prove a claim,
* documentation is semantically complete,
* unsafe code is justified.

Those questions already belong to earlier skills and rules.

## No Validation Execution

`/pr-check` runs no:

* build,
* lint,
* test,
* benchmark,
* fuzzing,
* emulator test,
* physical-hardware test,
* implementation command.

It may **read** existing local or remote check state.

A missing or stale completion result is a blocker, not work for this skill to reproduce.

## History

Apply `02-git-and-branching.md`.

In particular:

* Do not require rebasing merely to create linear history.
* Do not rewrite published history.
* Do not require a topic branch to merge `master` merely to be current.
* Do not convert a good topic history into a squash merely for cosmetic reasons.

If repository policy requires a normal merge commit, verify that the PR can use it.

## Draft State

The draft flag records whether the PR has passed this integration-readiness check.

```text
all checks pass  -> mark ready
any check fails  -> remain draft or restore draft
```

When using GitHub:

```sh
gh pr ready <number>
```

If a later push changes the audited head revision, the PR is no longer ready until the new
revision passes `/definition-of-done` and `/pr-check`.

## Result

Return one status:

```text
READY
BLOCKED
```

Report:

* Status.
* PR number or identifier.
* Base branch.
* Head branch.
* Head revision.
* Completion revision.
* Mergeability.
* Required-check state.
* Draft/ready state.
* Exact blockers.

Do not merge.
