---
name: 17-scheduling-and-execution
description: "Defines scheduling, execution, CPU ownership, preemption, fairness, and bounded-work rules for Nod."
owns: "scheduler semantics; execution ownership; preemption; CPU placement; fairness; bounded execution"
see-also: [12-concurrency-and-synchronization.md, 13-memory-management.md, 16-ipc-and-messaging.md, 42-performance.md]
---

# 17. Scheduling and Execution

## Invariants

1. Execution ownership is explicit.
2. Scheduling policy is separate from execution mechanism.
3. CPU placement can use machine topology.
4. Preemption semantics are explicit.
5. Scheduler-critical work is bounded.
6. A runnable workload does not imply unlimited execution time.
7. Priority does not imply permanent starvation of lower-priority work.
8. Blocking removes work from runnable state.
9. Wake-up behavior is explicit.
10. Cross-core migration has a reason.
11. Scheduler state does not depend on application cooperation for correctness.
12. Machine specialization can replace unnecessary generic scheduling heuristics.

## Execution Units

Define each execution unit by its contract.

Examples:

```text
process
thread
task
kernel task
interrupt work
deferred work
```

For each execution unit, define:

* Owner.
* Address space.
* Scheduling class.
* CPU affinity when applicable.
* Blocking behavior.
* Cancellation behavior.
* Failure boundary.

Do not merge different execution semantics into one abstraction only for API uniformity.

## Scheduler Policy

Keep scheduling policy separate from low-level context switching.

Policy can decide:

* Which runnable unit executes next.
* On which CPU it executes.
* For how long.
* Whether it can migrate.
* How priority affects selection.
* How latency and throughput are balanced.

Mechanism owns:

* Context switch.
* Register state.
* CPU state transition.
* Timer or reschedule trigger.
* Architecture-specific execution state.

Do not embed high-level policy in architecture-specific switch code.

## CPU Ownership

Prefer clear CPU ownership of scheduler-local state.

Use core-local state when practical for:

* Run queues.
* Accounting.
* Timer state.
* Deferred execution state.

Do not use one global scheduler structure without evidence that it is required.

When work moves between CPUs:

* Transfer ownership explicitly.
* Preserve wake-up state.
* Preserve priority.
* Preserve affinity constraints.
* Preserve capability and address-space requirements.

## Machine Topology

Use known machine topology when it improves placement.

Relevant inputs can include:

* Core count.
* SMT topology.
* Performance and efficiency cores.
* Cache sharing.
* NUMA topology.
* Interrupt affinity.
* Device locality.

Prefer direct machine knowledge over generic heuristics when Nod has a specialized machine profile.

Do not make one topology a native semantic requirement.

## Affinity

Affinity can be:

```text
required
preferred
unrestricted
```

Use required affinity only when correctness or hardware requires it.

Use preferred affinity for locality or measured performance.

Do not pin work permanently without a reason.

## Migration

Migration has a cost.

Consider:

* Cache locality.
* NUMA locality.
* Scheduler contention.
* Working-set size.
* Device locality.
* Priority.
* Load balance.

Do not migrate only because another CPU is momentarily idle.

Do not forbid migration when imbalance has a larger measured cost.

## Preemption

Define where preemption can occur.

For non-preemptible regions:

* Keep them small.
* Keep work bounded.
* Do not block.
* Do not perform unrelated subsystem work.
* Do not perform unbounded reclamation.

Do not disable preemption as a substitute for proper synchronization.

## Time Slicing

Do not assume one fixed time slice is optimal for all workloads.

A scheduling class can use different execution budgets when required.

When execution time is bounded, define:

* Budget.
* Renewal.
* Expiry behavior.
* Preemption behavior.

Do not make time-slice policy part of a public application contract unless required.

## Priorities

Priority is an explicit scheduling input.

Define:

* Priority range.
* Inheritance behavior when applicable.
* Interaction with blocking.
* Interaction with resource ownership.
* Starvation policy.

Do not use priority to bypass capability or ownership rules.

Do not allow priority inversion to remain implicit when shared resources can cause it.

## Fairness

Define fairness for the scheduling class that requires it.

Fairness can apply across:

* Threads.
* Processes.
* Users.
* Services.
* CPU shares.
* Scheduling groups.

Do not promise strict fairness when the scheduler only provides eventual opportunity.

Keep latency-critical classes separate from general fairness when required.

## Blocking

When work blocks:

* Remove it from runnable state.
* Record the wake-up source.
* Preserve its execution context.
* Release scheduler ownership that is no longer required.

Do not poll when an explicit wake-up mechanism exists and polling has no measured advantage.

## Wake-Up

A wake-up defines:

* Source.
* Target execution unit.
* Target CPU when relevant.
* Queue transition.
* Ordering.
* Duplicate wake-up behavior.

Do not enqueue the same runnable unit twice unless the scheduler contract explicitly permits it.

## Idle

Idle execution should consume minimal resources.

When no runnable work exists:

* Enter the appropriate CPU idle state when supported.
* Preserve required timer and interrupt wake-up behavior.
* Avoid unnecessary polling.

Do not burn CPU only to reduce scheduler implementation complexity.

## Deferred Work

Use deferred execution for work that should not run in interrupt context.

For deferred work:

* Transfer ownership explicitly.
* Keep the queue bounded.
* Define execution priority.
* Define cancellation or shutdown behavior when required.

Do not use deferred work as an unowned dumping ground for expensive operations.

## Bounded Work

Latency-sensitive scheduler paths must avoid work proportional to unbounded external input.

Applicable operations include:

* Enqueue.
* Dequeue.
* Wake-up.
* Preemption.
* Context selection.
* Cross-core handoff.

When an operation cannot be bounded:

* Move work outside the critical path.
* Split work into bounded units.
* Record the reason when neither is possible.

## Accounting

Scheduler accounting can track:

* Runtime.
* Runnable time.
* Blocked time.
* CPU migrations.
* Preemptions.
* Wake-ups.
* Queue latency.

Keep accounting cost proportional to the value of the data.

Do not make diagnostics materially change scheduling behavior.

## Evidence

When choosing scheduler policy, measure applicable properties such as:

* Wake-up latency.
* Context-switch latency.
* Run-queue contention.
* Tail scheduling latency.
* Throughput.
* Migration rate.
* Cache effects.
* CPU utilization.
* Idle power.
* Fairness.
* NUMA cost.

Do not promote a scheduler policy to a project preference without evidence in the workload classes Nod cares about.

Use `investigate` to promote a proven scheduler decision into this rule.
