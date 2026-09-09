---
name: pr-merge
description: "Merge an accepted Nod topic-branch pull request into master after explicit maintainer authorization, verify the resulting ancestry, and perform safe branch cleanup. Does not validate, review, plan, implement, or release."
---

# PR Merge

Use `/pr-merge` only after:

1. `/definition-of-done` reported `DONE`,
2. `/pr-check` reported `READY` for the same head revision,
3. the maintainer explicitly authorized the merge of that revision.

This skill owns the **integration mutation** and nothing earlier in the pipeline.

## Ownership

`/pr-merge` owns:

* Confirming merge authorization.
* Confirming the PR still points at the checked revision.
* Merging the PR into `master`.
* Verifying the resulting ancestry.
* Deletion of the merged topic branch on the remote and locally.
* Completion of the merged plan.

It does not own:

* Investigation.
* Planning.
* Implementation or fixes.
* Tests or validation.
* Benchmarks.
* Compatibility probes.
* Definition-of-done auditing.
* Independent code review.
* Roadmap progress decisions.
* Research-artifact reduction or archival.
* Tags, release notes, release artifacts, or publication.

## Preconditions

Before merging, verify:

```text
base branch is master
PR is READY
PR is not draft
current PR head SHA equals the SHA checked by pr-check
maintainer authorization applies to that exact revision
required remote checks remain successful
the PR remains mergeable
```

If the head SHA changed, stop.

Do not silently treat authorization for an earlier revision as authorization for a new one.

## Merge Strategy

Follow `02-git-and-branching.md`.

For ordinary Nod topic branches:

* Preserve useful commit ancestry.
* Prefer the repository's normal merge strategy.
* Do not squash a coherent topic history merely for cosmetic linearity.
* Do not rebase published history at merge time.
* Do not force-push to make the merge possible.
* Do not bypass branch protection.

When using GitHub and the repository policy is a normal merge:

```sh
gh pr merge <number> --merge
```

Do not choose `--squash` or `--rebase` unless repository policy or an explicit maintainer
instruction for that PR requires it.

## No Validation Execution

This skill runs no:

* build,
* lint,
* test,
* benchmark,
* fuzzing,
* emulator test,
* hardware test,
* implementation command.

Earlier stages produced and audited the evidence.

If required evidence or checks are missing, stop and return to the owning skill.

## Verification

After the merge:

* Confirm the PR reports merged.
* Confirm the merge landed on `master`.
* Record the resulting merge commit or integrated revision.
* Confirm the expected topic commits are ancestors of `master`.
* Confirm no unrelated history was rewritten.

Do not declare success from the merge command alone.

## Branch Cleanup

Delete the merged topic branch on the remote and locally.

Delete it only when:

* the merge is verified,
* all intended work from the branch is reachable from `master`,
* no unmerged work exists on the branch,
* repository policy allows deletion.

Use non-destructive deletion.

Do not delete a branch merely because the PR closed.

## Plan Completion

Move the merged plan to its completed state after the merge is verified.

`28-internal-artifacts.md` owns the paths, the states, and the re-check that a move obliges.

Complete a plan only.

Do not move an investigation. `plan-authoring` completed it when the plan was authored.

An investigation still active at merge time means the plan that consumed it skipped that
step. Report it as a gap and do not move it, because the reduction belongs to the plan
author.

Move the file.

Do not rewrite the plan.

Do not summarize the plan.

Do not complete a plan whose work is not fully merged.

When the merged work has no plan, report that no plan applied.

## No Roadmap or Artifact Mutation

A merge is not the owner of research, planning, or roadmap semantics.

Do not:

* tick research-roadmap decisions,
* rewrite investigation conclusions,
* archive an investigation,
* rewrite a plan,
* decide that a milestone is complete.

Those state changes belong to the workflow that owns the corresponding artifact.

Moving a plan to its completed state changes its location, not its content.

## Not a Release

`master` is the authoritative integration branch.

Merging into `master` does not by itself create a Nod release.

Do not:

* create a version tag,
* publish release artifacts,
* create release notes,
* declare a version released.

A future release skill owns that workflow.

## Result

Report:

```text
Merged: <PR and resulting revision>
Target: master
Head: <topic branch and checked SHA>
Strategy: <merge strategy>
Verified ancestry: <result>
Branch cleanup: <result>
Plan completion: <result>
Gaps: <none or exact blocker>
```
