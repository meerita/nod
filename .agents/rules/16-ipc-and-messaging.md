---
name: 16-ipc-and-messaging
description: "Defines IPC, message ownership, delivery, backpressure, cancellation, and cross-boundary communication rules for Nod."
owns: "IPC semantics; message ownership; delivery; backpressure; cancellation; cross-boundary messaging"
see-also: [12-concurrency-and-synchronization.md, 14-capabilities-and-resources.md, 11-errors-and-failure.md, 07-security.md]
---

# 16. IPC and Messaging

## Invariants

1. IPC crosses an explicit ownership boundary.
2. Message ownership is explicit.
3. Message lifetime is explicit.
4. Delivery semantics are explicit.
5. Backpressure is explicit.
6. Cancellation is explicit when supported.
7. Failure is observable.
8. Authority transfer is explicit.
9. IPC does not imply shared mutable state.
10. Message formats do not leak subsystem-private representations.
11. Unbounded queues are not the default.
12. Cross-boundary communication preserves isolation.

## Message Ownership

For each message, define:

* Sender.
* Receiver.
* Payload owner.
* Lifetime.
* Transfer semantics.
* Failure behavior.

A send operation must state whether payload ownership:

```text
moves
copies
borrows
shares
```

Do not make ownership depend on undocumented implementation behavior.

## Message Types

Use typed messages.

A message type should represent one contract.

Prefer:

```text
Request
Response
Event
Notification
Control
```

Do not use one generic message shape for unrelated operations.

Do not pass internal subsystem structs across IPC boundaries unless they are the owned interface type.

## Delivery

Define the delivery guarantee that the interface requires.

Examples:

```text
best effort
at most once
ordered
unordered
synchronous acknowledgment
asynchronous completion
```

Do not imply exactly-once delivery unless the complete system can guarantee it.

Do not add stronger delivery semantics than the caller requires.

## Request and Response

For request-response IPC, define:

* Request identity when required.
* Response ownership.
* Completion behavior.
* Error behavior.
* Cancellation behavior.
* Timeout or deadline behavior when supported.

Do not keep request state forever when the receiver disappears.

## Backpressure

Every bounded IPC path defines pressure behavior.

Use one or more:

```text
reject
wait
shed
coalesce
drop by contract
```

Do not grow a queue without a bound to preserve acceptance.

Do not hide backpressure inside memory growth.

## Queue Ownership

For each queue, define:

* Owner.
* Capacity.
* Producer set.
* Consumer set.
* Wake-up behavior.
* Full behavior.
* Empty behavior.
* Shutdown behavior.

Keep queue policy with the component that owns the queue.

Do not let producers define consumer policy implicitly.

## Cancellation

When cancellation is supported, define:

* Who can cancel.
* What operation is cancelled.
* What work can already be committed.
* What resources are released.
* What response the caller receives.
* What happens to an in-flight message.

Cancellation must leave both endpoints in valid states.

Do not treat dropping a local handle as equivalent to cancellation unless the contract defines it.

## Deadlines

When deadlines are supported:

* Make the deadline explicit.
* Define which clock owns it.
* Define when expiry is observed.
* Define the result after expiry.

Do not silently convert a deadline into an arbitrary retry policy.

## Capability Transfer

When IPC transfers authority:

* Validate transfer rights.
* Preserve the intended capability scope.
* Preserve resource lifetime.
* Define whether authority moves or duplicates.
* Reject unauthorized transfer.

Do not infer capability transfer from payload contents.

`14-capabilities-and-resources.md` owns capability semantics.

## Shared Memory

Use shared memory when copying would violate a demonstrated performance or functional requirement.

For shared memory, define:

* Owner.
* Mapping rights.
* Read and write authority.
* Synchronization.
* Lifetime.
* Revocation behavior.
* Cleanup.
* Trust boundary.

Do not use shared memory only to avoid defining message ownership.

Shared memory does not remove the need for an IPC control contract.

## Zero-Copy

Zero-copy is an optimization, not a semantic requirement.

Use it when evidence justifies its complexity.

For a zero-copy path, define:

* Buffer owner.
* Borrow duration.
* Mutation rights.
* Completion point.
* Reuse point.
* Cancellation behavior.

Do not reuse a buffer before ownership returns.

Do not describe a path as zero-copy without measuring actual copies when the distinction matters.

## Cross-Core Messaging

For cross-core messaging, define:

* Sending core.
* Receiving core.
* Queue ownership.
* Wake-up mechanism.
* Ordering.
* Capacity.
* Cache-coherency assumptions.

Prefer core-local ownership with explicit transfer when it reduces shared synchronization.

Do not require one global queue without evidence.

## Interrupt Interaction

When an interrupt produces IPC work:

* Keep interrupt-context work minimal.
* Transfer ownership explicitly.
* Defer non-critical processing.
* Use bounded work.
* Preserve queue capacity guarantees.

Do not perform arbitrary service work in interrupt context.

## Service Failure

When an endpoint fails:

* Release or recover owned messages.
* Resolve outstanding requests.
* Preserve capability lifetime rules.
* Notify callers when the contract requires it.
* Keep failure inside the smallest practical fault boundary.

Do not leave requests permanently pending after endpoint loss.

`11-errors-and-failure.md` owns failure policy.

## Message Format Evolution

For versioned IPC:

* Define compatibility direction.
* Reject unsupported versions explicitly.
* Keep old representations at the boundary.
* Translate into current Nod-owned types.

Do not let legacy message layouts define internal semantics.

## Evidence

When an IPC design decision depends on performance or scale, measure applicable properties such as:

* Send latency.
* Round-trip latency.
* Queue contention.
* Wake-up cost.
* Copy count.
* Memory per queued message.
* Throughput.
* Tail latency.
* Cross-core cache traffic.

Do not prefer shared memory or zero-copy without evidence when a simpler message path meets the requirement.
