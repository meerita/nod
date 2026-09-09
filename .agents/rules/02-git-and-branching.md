---
name: 02-git-and-branching
description: "Defines Git, branch, commit, history, and change-scope rules for Nod."
owns: "Git workflow; branch discipline; commit scope; history integrity"
see-also: [00-agent-behavior.md]
---

# Git and branching

## Repository model

* Keep the `master` integration branch authoritative, buildable, and validated.
* Develop non-trivial changes on focused topic branches.
* Do not introduce GitFlow-style permanent `develop`, `feature`, `release`, or `hotfix` branch hierarchies.
* Prefer subsystem- or area-oriented topic branch names such as `arch/...`, `boot/...`, `irq/...`, `mm/...`, or `sched/...`.
* A branch must represent a coherent body of work rather than an arbitrary period of development.

## Private and published history

* Private topic branches may be rebased, reordered, amended, squashed, or otherwise rewritten before publication.
* Treat a branch as published once it is intentionally exposed as a stable base for review, integration, testing, or dependent work.
* Do not rewrite published history.
* Do not rebase commits authored or incorporated from another published history.
* Do not force-push published or shared branches.
* Once another branch depends on a published commit, preserve that commit's identity.
* Correct published mistakes with new commits or explicit reverts rather than by making the old history disappear.

## Rebasing

* Rebase only when rewriting private history or when deliberately moving private work to a justified new base.
* Do not rebase merely to produce a linear history.
* Do not continuously rebase topic branches onto the latest `master` branch without a technical reason.
* Treat rewritten commits as new code for validation purposes.
* Re-run the validation required for a branch after any rebase or other history rewrite.

## Merging

* Merge coherent histories instead of copying commits between them.
* Merge commits are valid and must not be avoided merely for cosmetic history.
* Do not merge `master` into a topic branch merely to keep the topic branch current.
* Merge upstream or sibling work into a topic branch only when a real dependency or integration requirement justifies it.
* Explain non-trivial merges in the merge commit message.
* Prefer an explicit prerequisite topic branch when multiple branches depend on the same unpublished infrastructure.
* Perform a test merge when useful to detect integration conflicts without modifying the published topic branch.

## Cherry-picking

* Do not use cherry-pick as the normal integration mechanism.
* Prefer preserving Git ancestry through merges.
* Use cherry-pick only when commit duplication is intentional, such as an explicit backport or recovery operation.

## Commits

* Keep each commit focused on one coherent change.
* Do not mix unrelated work in one commit.
* Keep commits reviewable.
* Every integrated commit must satisfy the validation required for its scope.
* Preserve bisectability.
* Do not intentionally leave intermediate integrated commits broken.
* Prefer commit subjects in `subsystem/component: Imperative description` form when a subsystem or component is identifiable.
* Use descriptive commit messages that explain why a change exists, not only what the diff contains.
* Preserve useful topic-branch commits during integration.
* Squash work-in-progress commits before publication when their individual history has no lasting value.

## Pull requests

* Open the pull request as a draft.
* Use the commit subject form for the pull request title.
* State what changed, why it changed, which validation ran, and which gaps stay open.
* Record the revision that the completion audit approved.
* Apply at least one area label that matches the topic branch area.
* Assign the pull request to the responsible maintainer.
* Follow `04-writing-and-documentation.md`.
* Keep the description short.
* Do not restate the diff.
* Link to the owning document instead of copying it.

## Change scope

* Do not rewrite unrelated history.
* Do not modify unrelated files without a task-related reason.
* Do not modify generated files by hand.
* Do not commit local build artifacts.
* Do not commit secrets or credentials.
* Do not delete branches that contain unmerged work.
* Do not change repository history unless the current task requires it.

## Working tree discipline

* Inspect the working tree before making changes.
* Identify and preserve unrelated pre-existing changes.
* Do not overwrite or absorb unrelated local modifications.
* Inspect the final diff before completion.
* Report unrelated pre-existing changes that remain in the working tree.
