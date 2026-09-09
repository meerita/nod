---
name: 15-unsafe
description: "Defines when and how unsafe Rust can be used in Nod."
owns: "unsafe Rust; safety justification; unsafe boundaries"
see-also: [07-security.md, 10-rust.md, 40-testing.md]
---

# Unsafe Rust

Use `unsafe` only when required for:

* Hardware access.
* Architecture-specific operations.
* Memory management primitives.
* FFI at explicit trust boundaries.
* Operations that safe Rust cannot express.

For each `unsafe` block:

* Keep it small.
* Add a `SAFETY:` comment.
* State the required invariant.
* State why the invariant holds.

For unsafe abstractions:

* Expose a safe interface when practical.
* Keep unsafe code behind a narrow boundary.
* Keep architecture-specific unsafe code local.
* Test the safe contract around the boundary.

Avoid:

* Large unsafe functions.
* Unsafe code for convenience.
* Repeated unsafe access to the same primitive.
* Leaking unsafe requirements into callers.
