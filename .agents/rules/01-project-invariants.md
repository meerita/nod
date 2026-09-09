---
name: 01-project-invariants
description: "Defines the non-negotiable project-wide architecture constraints for Nod."
owns: "project-wide architecture invariants"
see-also: [06-dependencies.md, 07-security.md, 10-rust.md, 15-unsafe.md, 42-performance.md]
---

# Project invariants

* Nod is a new operating system.
* Nod is not Unix.
* Nod is not a Linux distribution.
* Do not inherit historical behavior without a Nod requirement.
* Prefer typed resources.
* Prefer explicit capabilities.
* Prefer message passing to shared mutable state.
* Keep hardware-specific behavior behind explicit architecture boundaries.
* Keep compatibility at explicit system boundaries.
* Treat machine specialization as a core feature.
* Keep the trusted system small.
* Keep privileged code small.
* Do not add speculative architecture.
* Treat official command names as interfaces.
* Do not treat an implementation as permanent.
* Allow a better implementation to replace an official one.
