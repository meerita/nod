---
name: 07-security
description: "Defines trust, privilege, isolation, and authority rules for Nod."
owns: "trust boundaries; privilege; isolation; capabilities"
see-also: [01-project-invariants.md, 06-dependencies.md, 15-unsafe.md]
---

# Security

Prefer:

* Explicit capabilities.
* Least privilege.
* Small trust boundaries.
* Small privileged components.
* Isolation between components.
* Explicit resource ownership.

Avoid:

* Ambient authority.
* Global privilege.
* Shared mutable state across trust boundaries.
* Hidden privilege escalation.
* Implicit access to system resources.

For privileged components:

* Expose the smallest interface.
* Grant only required capabilities.
* Keep failure local when practical.
* Keep recoverable services outside the kernel when practical.

For trust boundaries:

* Make them explicit.
* Document them.
* Keep data flow across them explicit.
