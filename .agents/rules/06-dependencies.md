---
name: 06-dependencies
description: "Defines dependency and supply-chain rules for Nod system code."
owns: "third-party dependencies; vendoring; supply-chain policy"
see-also: [01-project-invariants.md, 07-security.md, 10-rust.md]
---

# Dependencies

In trusted system code, do not use:

* Third-party runtime dependencies.
* Git dependencies.
* Vendored third-party source.
* Opaque binary dependencies.

Trusted system code can use:

* Nod-owned crates.
* External specifications.
* Documented external firmware interfaces.

Treat firmware outside Nod as an external trust boundary.

For each unavoidable external trust boundary:

* Document it.
* Keep it explicit.
* Keep it minimal.

For dependencies:

* Do not add one for convenience.
* Implement required system primitives inside Nod.
* Keep the dependency graph explicit.
* Keep the dependency graph minimal.
