---
name: 11-errors-and-failure
description: "Defines error, failure, recovery, and fault-boundary rules for Nod."
owns: "error semantics; failure propagation; recovery ownership; fault boundaries"
see-also: [01-project-invariants.md, 07-security.md, 10-rust.md]
---

# 11. Errors and Failure

## Invariants

1. Expected failure is part of the contract.
2. Recoverable failure does not become a panic.
3. A lower layer reports mechanism failure.
4. A higher layer owns recovery policy.
5. Failure does not cross an ownership boundary without an explicit representation.
6. A component does not hide a failed operation.
7. Partial success is explicit.
8. Destructive operations define their failure state.
9. Persistent operations define their recovery state.
10. Failure should remain inside the smallest practical fault boundary.

## Error Ownership

The layer that detects a failure reports what failed.

The layer that owns policy decides what to do next.

Example:

```text
NVMe driver
    -> reports command timeout

storage service
    -> decides retry or device failure

filesystem
    -> decides transaction outcome

application
    -> receives the final contract result
```

Do not put filesystem recovery policy in a device driver.

Do not put application policy in the kernel.

## Error Types

Prefer errors that describe the failed contract.

Examples:

```text
NotFound
PermissionDenied
Unavailable
TimedOut
InvalidState
InvalidInput
CorruptData
OutOfMemory
Unsupported
```

Keep implementation detail out of public errors unless the caller needs it.

Do not expose hardware-specific errors through a native Nod API when a stable semantic error is sufficient.

Preserve detailed cause information for diagnostics when practical.

## Failure Propagation

When propagating failure:

* Preserve its meaning.
* Preserve relevant context.
* Do not convert failure into success.
* Do not silently retry unless retry is part of the owning policy.
* Do not silently fall back to weaker semantics.

A fallback that changes behavior is part of the contract.

## Partial Failure

For an operation that can complete partially, define:

* What completed.
* What did not complete.
* What state remains valid.
* Whether retry is safe.
* Whether rollback exists.

Do not return a generic success for partial completion.

## Recovery

Recovery belongs to the component that owns the affected state.

For recoverable state, define:

* Detection.
* Valid pre-recovery state.
* Recovery action.
* Valid post-recovery state.
* Failure of recovery.

Do not depend on reboot as a normal recovery mechanism unless the subsystem contract requires it.

## Persistent Failure

For persistent state, define:

* Atomicity boundary.
* Durable state.
* Incomplete state.
* Recovery source.
* Corruption behavior.

Do not leave ambiguous state after a reported success.

Do not report durable success before the required durability boundary is complete.

## Resource Exhaustion

Treat resource exhaustion as an expected system condition when practical.

Examples:

* Memory exhaustion.
* Queue exhaustion.
* Handle exhaustion.
* Storage exhaustion.
* Capability exhaustion.

Define whether the operation:

```text
fails
waits
sheds work
retries
```

Do not allow unbounded growth as the default response to pressure.

## Fault Boundaries

Prefer failure isolation.

Examples:

```text
driver failure
    -> driver restart

service failure
    -> service restart

application failure
    -> application termination
```

Escalate to kernel or system failure only when required state cannot remain valid.

Do not turn a recoverable userspace service failure into a system-wide failure.

## Panics

A panic indicates a violated internal invariant, not a normal runtime condition.

Do not use panic for:

* Invalid user input.
* Missing resources.
* Device failure.
* Network failure.
* Resource exhaustion.
* Unsupported requests.

`10-rust.md` owns Rust panic use.

## Diagnostics

A diagnostic can contain implementation detail.

A public error contract should remain stable.

Keep these separate when practical.

Diagnostics should identify:

* Failed component.
* Failed operation.
* Relevant context.
* Root cause when known.

Do not expose secrets or unrelated privileged state through diagnostics.
