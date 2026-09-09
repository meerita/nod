---
name: 09-build-and-tooling
description: "Defines build, toolchain, reproducibility, and repository tooling rules for Nod."
owns: "build entry points; toolchain pinning; reproducible builds; repository tooling"
see-also: [02-git-and-branching.md, 06-dependencies.md]
---

# 09. Build and Tooling

## Invariants

1. `make` is the human entry point for repository operations.
2. Build behavior has one owner.
3. Toolchain versions are explicit.
4. Build inputs are explicit.
5. Generated artifacts are reproducible when required.
6. Local convenience does not define repository behavior.
7. Build scripts do not hide dependencies.
8. Build tooling does not modify source files unless generation is its explicit purpose.
9. A build does not depend on undeclared host state.

## Entry Points

Expose repository operations through `make`.

A Make target can delegate to:

* Cargo.
* Repository scripts.
* Emulators.
* Image builders.
* Inspection tools.

Do not duplicate delegated logic in the Makefile.

The delegated tool owns the implementation.

The Makefile owns the public entry point.

## Toolchain

Pin required toolchain versions.

Keep version ownership in the repository.

Examples:

```text
rust-toolchain.toml
Cargo.lock
tool configuration
emulator version policy
```

Do not depend on the user's global default when the repository can define the version.

Do not upgrade a toolchain as part of unrelated work.

## Build Inputs

A build derives from explicit inputs.

Inputs can include:

* Source.
* Toolchain.
* Target.
* Machine profile.
* Build profile.
* Configuration.
* Reproducible generated inputs.

Do not read undocumented local state into a build.

Do not depend on:

* Shell aliases.
* Editor configuration.
* User-specific paths.
* Untracked configuration.

## Reproducibility

For a reproducible artifact:

* Use the same source revision.
* Use the same declared toolchain.
* Use the same declared inputs.
* Avoid unnecessary timestamps.
* Avoid unnecessary random data.
* Record unavoidable nondeterminism.

Do not claim reproducibility without evidence.

## Scripts

Repository scripts:

* Have one clear purpose.
* Use explicit inputs.
* Fail on errors.
* Return meaningful exit status.
* Avoid interactive behavior in automation paths.
* Avoid hidden environment requirements.

Keep scripts small.

Move reusable logic into an owned tool when a script becomes a subsystem.

## Environment

Environment variables are build inputs.

For each required variable:

* Document it.
* Define its scope.
* Define whether it is required.
* Define its default when one exists.

Do not silently change behavior from an undocumented variable.

Do not commit secrets.

## Generated Artifacts

Keep generated build artifacts outside source directories unless the owning format requires otherwise.

Examples:

```text
target/
build/
dist/
images/
```

Do not commit generated build output unless the repository explicitly owns that artifact.

`05-comments-and-source-files.md` owns generated source.

## Host Independence

Keep host-specific behavior behind tooling boundaries.

Do not make Nod source semantics depend on macOS, Linux, or Windows host behavior.

When a host tool is required:

* Document the requirement.
* Detect unsupported hosts explicitly.
* Fail clearly.
