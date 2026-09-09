---
name: 14-capabilities-and-resources
description: "Defines Nod resource identity, capability authority, access, transfer, revocation, and lifetime rules."
owns: "resource identity; capabilities; authority transfer; revocation; resource lifetime"
see-also: [01-project-invariants.md, 07-security.md, 11-errors-and-failure.md, 12-concurrency-and-synchronization.md]
---

# 14. Capabilities and Resources

## Invariants

1. A resource has explicit identity.
2. A capability grants explicit authority.
3. Possession of a capability does not imply unrelated authority.
4. Authority is narrower than identity.
5. Resource access does not depend on ambient privilege.
6. Capability transfer is explicit.
7. Capability duplication is explicit.
8. Capability revocation has defined semantics.
9. Resource lifetime is independent from its human-readable name.
10. A path or name is not the resource identity.
11. Resource interfaces expose only supported operations.
12. Compatibility handles do not define native Nod resource semantics.

## Resources

Treat system objects as typed resources.

Examples:

```text
file
directory
process
thread
memory region
device
connection
timer
surface
queue
service
```

A resource defines:

* Identity.
* Owner.
* Lifetime.
* Supported operations.
* Required capabilities.
* Failure behavior.

Do not force every resource into file semantics.

## Identity

Use stable internal identity where the resource requires persistence across names or references.

A resource name can change without changing resource identity.

Example:

```text
/projects/nod/design.md
        |
        v
resource 7f31...
```

Moving or renaming the file changes the name.

It does not require a new resource identity.

Do not use a path as the only internal identity when stable identity matters.

## Capabilities

A capability identifies:

* Resource.
* Granted operations.
* Scope.
* Transfer rights when applicable.
* Delegation rights when applicable.
* Revocation behavior when applicable.

Examples:

```text
read
write
map
send
receive
inspect
modify
control
delegate
```

Do not grant a broad capability when a narrow capability is sufficient.

## Acquisition

A component obtains a capability through an explicit authority path.

Examples:

```text
parent delegation
service response
resource creation
explicit system grant
capability transfer
```

Do not grant capabilities because a process knows a resource name.

Knowing a resource exists is not authority to use it.

## Transfer

When transferring a capability, define whether the operation:

```text
moves
copies
attenuates
delegates
```

A transfer must not increase authority unless an explicit authority source permits it.

Prefer attenuation when the receiver needs less authority than the sender holds.

## Delegation

A component can delegate only authority that its capability permits it to delegate.

When delegating:

* Preserve resource identity.
* Narrow authority when practical.
* Keep the delegation boundary explicit.

Do not create authority through delegation.

## Revocation

When a capability can be revoked, define:

* Who can revoke it.
* What is revoked.
* Whether derived capabilities are affected.
* What happens to in-flight operations.
* What error callers observe.
* Whether revocation is immediate or eventual.

Do not claim revocation semantics that the implementation cannot guarantee.

## Resource Lifetime

Define separately:

```text
resource exists
reference exists
capability exists
resource is named
resource is reachable
```

These states are not equivalent.

A resource can outlive one name.

A name can disappear before the resource is reclaimed.

Do not reclaim a resource while valid authority can still reach it unless the resource contract permits forced termination.

## Naming

A namespace maps names to resources.

A namespace does not own the resource unless its contract says so.

Keep separate concepts for:

* Name.
* Resource identity.
* Capability.
* Ownership.

Do not infer authority from namespace visibility.

## Typed Interfaces

A resource exposes operations that match its type.

Example:

```text
File
  read
  write
  map

Connection
  send
  receive

Timer
  wait

Surface
  present
```

Do not force unsupported operations through a generic escape mechanism.

Avoid a universal `ioctl`-style interface for native Nod resources.

Use typed operations.

## Handles

A handle is a local reference to authority.

Keep the distinction clear:

```text
handle
    -> local reference

capability
    -> authority

resource
    -> underlying object
```

Do not make a small integer handle the semantic identity of a resource.

A handle table can map local handles to capabilities.

## Cross-Process Transfer

For capability transfer across process or service boundaries:

* Validate transfer rights.
* Preserve the intended authority.
* Preserve resource lifetime.
* Define ownership of transferred messages.
* Define failure if the receiver cannot accept it.

Do not duplicate authority accidentally during IPC.

## Compatibility

A compatibility layer can expose:

```text
file descriptor
POSIX handle
legacy path
foreign descriptor
```

Translate these at the compatibility boundary.

Do not let compatibility handles become Nod's native authority model.

## Diagnostics

Diagnostics can expose resource identity when policy permits it.

Do not expose capability secrets, privileged metadata, or unrelated authority through diagnostics.

## Evidence

When a capability design changes authority, preserve evidence for:

* Granted operations.
* Denied operations.
* Transfer behavior.
* Delegation behavior.
* Revocation behavior.
* Lifetime behavior.
* Isolation behavior.

Do not infer authority correctness from type safety alone.
