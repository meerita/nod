---
name: 26-time-and-timers
description: "Defines Nod clocks, timers, deadlines, timekeeping, timer ownership, and machine-specific time sources."
owns: "clock semantics; timers; deadlines; timekeeping; timer ownership; time-source selection"
see-also: [12-concurrency-and-synchronization.md, 16-ipc-and-messaging.md, 17-scheduling-and-execution.md, 23-boot-and-machine-specialization.md, 25-observability-and-diagnostics.md, 27-architecture-and-hal.md]
---

# 26. Time and Timers

## Invariants

1. Nod distinguishes monotonic time from civil time.
2. Latency and deadlines use monotonic time.
3. Wall-clock changes do not change monotonic time.
4. Timers are typed resources.
5. Timer ownership is explicit.
6. Timer queues are bounded by owned resources.
7. Timer expiration uses asynchronous completion.
8. A timer does not require one blocked thread.
9. Clock selection belongs to the time subsystem.
10. Architecture-specific counters do not leak into native time semantics.
11. Machine specialization can select the best available hardware time source.
12. Timekeeping does not depend on network availability.

## Clock Types

Keep separate clock semantics.

Native clocks can include:

```text
MonotonicClock
BootClock
CivilClock
```

`MonotonicClock`:

* Never moves backward.
* Measures durations.
* Owns deadlines.
* Owns scheduler and timeout timing.

`BootClock`:

* Measures time relative to system boot.
* Can include semantics that differ from active execution time when required.

`CivilClock`:

* Represents calendar time.
* Can be adjusted.
* Can synchronize with external sources.
* Must not own latency or deadline semantics.

Do not use one universal timestamp type for different clock domains.

## Time Values

Use typed time values.

Keep separate:

```text
Instant
Duration
Deadline
CivilTime
```

Do not represent all native time values as untyped integers.

A value from one clock domain must not be accepted by another clock domain without explicit conversion.

## Monotonic Time

Use monotonic time for:

* Deadlines.
* Timeouts.
* Scheduling.
* Performance measurement.
* Retransmission timing.
* Backoff.
* Lease expiry when elapsed time is the contract.

Do not use wall-clock time for elapsed-time calculations.

## Civil Time

Civil time owns calendar representation.

It can depend on:

* Hardware real-time clock.
* User configuration.
* Time-zone data.
* Network synchronization.
* Administrative adjustment.

A civil-time correction must not invalidate monotonic deadlines.

Do not make system execution correctness depend on civil time being accurate.

## Hardware Time Sources

The architecture or machine layer exposes available hardware time sources.

Examples can include:

```text
architectural counter
platform timer
RTC
device timer
virtual timer
```

The time subsystem selects the source that satisfies the required contract.

On AArch64 the available comparator set and the timer interrupt identifier
depend on the kernel execution level. The machine supplies the identifier as
handoff data.

Source: `tmp/investigations/completed/01-aarch64-execution-level-and-privilege-model.md`.

Do not expose raw hardware counters as the native application clock.

## Time-Source Selection

Select a time source from verified properties.

Relevant properties include:

* Monotonicity.
* Frequency.
* Resolution.
* Stability.
* Cross-core consistency.
* Read cost.
* Power behavior.
* Virtualization behavior.

Use machine specialization to avoid unnecessary runtime source selection when the machine profile guarantees one source.

Do not select a source only because it has the highest nominal frequency.

## Cross-Core Time

A monotonic clock must preserve its contract across CPUs.

When hardware counters differ across cores:

* Compensate.
* Restrict ownership.
* Use another source.

Do not expose cross-core clock regressions to callers.

## Resolution

Keep clock resolution explicit.

Do not promise nanosecond accuracy because the API uses nanoseconds.

Distinguish:

```text
representation precision
clock resolution
clock accuracy
```

Do not conflate them.

## Timers

A timer is a resource.

A timer defines:

* Owner.
* Clock.
* Deadline.
* Completion target.
* Cancellation.
* Re-arm behavior.
* Lifetime.

Prefer one-shot timers as the primitive.

Build periodic behavior from explicit re-arming or a typed periodic contract.

## Timer Completion

Timer expiration produces completion or notification.

Conceptually:

```text
deadline
-> timer subsystem
-> expiration
-> wake-up or message
```

Do not require one thread to sleep inside the kernel for each timer.

Do not execute arbitrary application work in timer-interrupt context.

## Timer Queues

Timer structures have explicit ownership.

For each timer queue, define:

* Owner.
* Clock domain.
* Capacity behavior.
* Insertion semantics.
* Expiration ordering.
* Cancellation semantics.

Prefer per-core timer ownership when it reduces contention and preserves semantics.

Do not use one global timer lock without evidence.

## Deadlines

Prefer absolute monotonic deadlines at subsystem boundaries when timeout composition matters.

Example:

```text
deadline = now + 50 ms
```

Pass the deadline through dependent operations.

Do not repeatedly convert one timeout into new full-duration timeouts.

That can exceed the caller's intended limit.

## Timeouts

A timeout defines the maximum allowed elapsed duration for an operation.

On timeout:

* Preserve valid state.
* Release temporary ownership.
* Resolve outstanding work according to the owning contract.
* Return an explicit result.

Do not treat timeout as proof that the underlying operation did not complete.

`11-errors-and-failure.md` owns failure semantics.

## Cancellation

Timer cancellation defines:

* Whether expiration already won the race.
* Whether completion can still arrive.
* When resources can be reused.

Do not assume cancellation removes an already-visible completion.

Keep cancellation races explicit.

## Periodic Timers

For periodic timers, define:

* Period.
* First deadline.
* Missed-period behavior.
* Drift behavior.
* Overrun behavior.

Possible missed-period policies include:

```text
skip
coalesce
catch up
```

Do not silently accumulate unlimited missed timer events.

## Scheduler Timers

Scheduler timing can use the same clock infrastructure without sharing scheduler policy with it.

Applicable uses include:

* Preemption.
* Execution budgets.
* Wake-ups.
* Deferred scheduling events.

The scheduler owns scheduling policy.

The timer subsystem owns time and expiration mechanism.

## Power Management

Timekeeping must preserve its contract across supported CPU idle states.

When a hardware counter stops or changes behavior during idle:

* Compensate.
* Select another source.
* Restrict its use.

Do not disable useful power states only to simplify timekeeping without evidence.

## Virtualization

A virtual machine can expose virtual time sources.

Treat them as machine-specific implementations of Nod clock contracts.

Do not make QEMU-specific timer behavior part of native Nod semantics.

## Boot

Early boot can use a temporary time source.

When the final time subsystem becomes available:

* Preserve monotonic ordering.
* Define the handoff.
* Avoid visible backward jumps.

Do not require civil time for kernel initialization.

## Real-Time Clock

The RTC is a source for persistent civil-time initialization.

It is not the native monotonic clock.

Do not use RTC reads for high-frequency timekeeping.

## Synchronization

External time synchronization adjusts civil time.

Examples can include:

```text
network time
hardware source
administrative update
```

Keep synchronization policy outside the core timer mechanism.

Do not let a wall-clock correction change active monotonic timers.

## Leap and Calendar Semantics

Keep calendar policy outside monotonic time.

Civil-time handling can own:

* Time zones.
* Leap-second policy.
* Calendar conversion.

Do not make kernel scheduling depend on calendar representation.

## Observability

Expose applicable time diagnostics such as:

* Active clock source.
* Resolution.
* Civil-time synchronization state.
* Timer count.
* Timer queue depth.
* Timer lateness.
* Clock adjustment state.

Do not expose raw implementation state when stable semantic data is sufficient.

## Performance

Time reads can occur on critical paths.

Measure applicable properties such as:

* Clock-read latency.
* Timer insertion latency.
* Timer cancellation latency.
* Expiration latency.
* Wake-up latency.
* Cross-core timer cost.
* Timer memory overhead.
* Queue contention.

Do not choose a more complex timer structure without evidence that the current structure is a material limitation.

Use `investigate` to promote a proven clock or timer design into this rule.
