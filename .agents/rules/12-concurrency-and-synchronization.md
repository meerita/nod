---
name: 12-concurrency-and-synchronization
description: "Defines concurrency, synchronization, ownership, and shared-state rules for Nod."
owns: "concurrency model; synchronization; shared mutable state; ordering guarantees"
see-also: [01-project-invariants.md, 07-security.md, 11-errors-and-failure.md, 15-unsafe.md]
---

# 12. Concurrency and Synchronization

## Invariants

1. Prefer ownership transfer to shared mutable state.
2. Prefer message passing across subsystem boundaries.
3. Keep shared state local.
4. Synchronization is explicit.
5. Blocking is explicit.
6. Memory ordering is justified.
7. Lock scope is minimal.
8. Lock ordering is stable.
9. Work inside critical sections is bounded when practical.
10. Concurrency behavior is part of the contract when callers can observe it.

## Ownership

Prefer one owner for mutable state.

When ownership moves:

* Make the transfer explicit.
* Preserve lifetime guarantees.
* Preserve capability requirements.
* Preserve failure ownership.

Do not share mutable state only to avoid designing ownership.

## Message Passing

Prefer message passing for:

* Cross-service communication.
* Driver communication.
* Scheduler coordination when ownership permits it.
* Core-to-core coordination when shared state is not required.
* Isolation boundaries.

Define:

* Message owner.
* Send semantics.
* Receive semantics.
* Backpressure.
* Failure behavior.
* Cancellation when applicable.

Do not use an unbounded queue by default.

## Shared State

Use shared mutable state only when it has a measurable or architectural reason.

For each shared structure, define:

* Owner.
* Readers.
* Writers.
* Synchronization primitive.
* Ordering.
* Lifetime.
* Failure behavior.

Keep shared state smaller than the subsystem that uses it when practical.

## Locks

For locks:

* Keep the protected state explicit.
* Keep lock scope small.
* Avoid I/O while holding a lock.
* Avoid allocation while holding a lock when practical.
* Avoid calling unrelated subsystems while holding a lock.
* Define lock ordering when more than one lock can be acquired.

Do not rely on undocumented lock order.

Do not hold a lock across an operation that can block unless the contract requires it.

## Critical Sections

A critical section should contain only work that requires exclusivity.

Avoid:

* Unbounded loops.
* Large memory reclamation.
* Device I/O.
* Logging that can block.
* Calls into unknown ownership domains.
* Work proportional to unbounded user input.

When bounded execution matters, define the bound.

## Atomics

Use atomics when the synchronization contract requires them.

For each non-trivial atomic ordering:

* State what is ordered.
* State which operation it pairs with.
* State the published or observed state.

Prefer the weakest ordering that preserves the contract.

Do not use `SeqCst` only to avoid reasoning about ordering.

Do not weaken ordering without evidence.

## Memory Ordering Comments

Document a non-obvious ordering at the operation that owns the invariant.

Example:

```rust
// Release publishes the descriptor before the consumer observes the tail.
tail.store(next, Ordering::Release);
```

`05-comments-and-source-files.md` owns comment form.

## Blocking

An operation that can block must make blocking visible at the owning interface when practical.

Define:

* What can block.
* What wakes it.
* Whether cancellation exists.
* Whether a deadline exists.
* What resources remain held.

Do not hide indefinite blocking behind a synchronous-looking helper.

## Backpressure

For bounded resources, define pressure behavior.

Use one or more:

```text
reject
wait
shed
coalesce
retry
```

Do not grow queues without a bound only to preserve acceptance.

The producer must not assume that the consumer can always keep up.

## Cancellation

Cancellation must leave owned state valid.

At a cancellation point:

* Define what work is committed.
* Define what work is discarded.
* Release temporary ownership.
* Preserve persistent invariants.
* Preserve queue and lock invariants.

Do not make cancellation depend on undefined partial state.

## Core-Local State

Prefer core-local state when it removes unnecessary shared synchronization.

Do not use core-local state when correctness requires one shared authority.

When state is replicated across cores:

* Define the source of truth.
* Define update propagation.
* Define stale-state behavior.
* Define reconciliation.

## Interrupt Context

For interrupt-context work:

* Keep work minimal.
* Avoid blocking.
* Avoid allocation unless the allocator contract explicitly supports it.
* Defer non-critical work.
* Keep ownership transfer explicit.

Do not call code from interrupt context unless its contract permits interrupt-context use.

## Deadlocks

Prevent deadlocks by design.

Use:

* Stable lock ordering.
* Narrow lock scope.
* Message passing.
* Ownership partitioning.
* Non-blocking handoff where appropriate.

Do not rely on timeouts as the primary deadlock prevention mechanism.

## Concurrency Evidence

When a concurrency decision affects correctness or performance, preserve evidence such as:

* Stress tests.
* Ordering tests.
* Contention measurements.
* Scheduler traces.
* Race-focused tests.
* Hardware measurements.

Do not infer concurrent correctness from a successful single-threaded run.
