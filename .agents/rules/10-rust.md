---
name: 10-rust
description: "Defines Rust language rules for Nod system code."
owns: "Rust version; language use; error handling; code style"
see-also: [06-dependencies.md, 15-unsafe.md, 40-testing.md]
---

# Rust

Use:

* Stable Rust.
* Rust 2024 edition.
* Safe Rust by default.
* Explicit error types.
* Exhaustive matches where practical.
* Small modules.
* Small functions.
* Clear ownership.

Use https://en.algorithmica.org/hpc/ for reference for anything we want to program.

Avoid:

* `unwrap()`.
* `expect()`.
* `todo!()`.
* `unimplemented!()`.
* `dbg!()`.
* Hidden allocation.
* Hidden blocking.
* Unnecessary cloning.
* Unnecessary dynamic dispatch.
* Global mutable state.

For errors:

* Propagate recoverable errors.
* Keep error paths explicit.
* Do not use panics for normal control flow.

For APIs:

* Prefer concrete types.
* Prefer typed state over flags.
* Keep public interfaces small.
* Keep ownership explicit.
