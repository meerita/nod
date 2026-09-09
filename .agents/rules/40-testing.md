---
name: 40-testing
description: "Defines test requirements for Nod."
owns: "test scope; test behavior; regression coverage"
see-also: [00-agent-behavior.md, 10-rust.md, 15-unsafe.md, 42-performance.md]
---

# Testing

Test:

* Public behavior.
* Error paths.
* Boundary conditions.
* State transitions.
* Unsafe boundaries.
* Regressions.
* Architecture-independent logic.

Prefer:

* Deterministic tests.
* Small tests.
* Fast tests.
* Explicit fixtures.
* Reproducible failures.

For each bug fix:

* Add a regression test when practical.

For hardware-dependent behavior:

* Separate hardware logic from testable logic.
* Use emulation when practical.
* Test on real hardware when the behavior depends on it.

Do not:

* Hide flaky tests.
* Ignore failed tests.
* Depend on test order.
* Use timing assumptions without justification.
