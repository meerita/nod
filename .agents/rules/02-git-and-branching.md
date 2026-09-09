---
name: 02-git-and-branching
description: "Defines Git, branch, commit, and change-scope rules for Nod."
owns: "Git workflow; branch discipline; commit scope"
see-also: [00-agent-behavior.md]
---

# Git and branching

* Keep each change focused.
* Do not mix unrelated work in one commit.
* Do not rewrite unrelated history.
* Do not modify generated files by hand.
* Do not commit local build artifacts.
* Do not commit secrets or credentials.
* Use descriptive branch names.
* Use descriptive commit messages.
* Keep commits reviewable.
* Preserve bisectability when practical.
* Do not force-push shared branches.
* Do not delete branches that contain unmerged work.
* Do not change repository history unless the task requires it.
* Inspect the working tree before changes.
* Inspect the final diff before completion.
* Report unrelated pre-existing changes.
