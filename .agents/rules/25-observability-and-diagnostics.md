---
name: 25-observability-and-diagnostics
description: "Defines Nod observability, diagnostics, metrics, tracing, logs, inspection, and debug boundaries."
owns: "observability; diagnostics; metrics; tracing; logs; inspection; debug data"
see-also: [07-security.md, 11-errors-and-failure.md, 14-capabilities-and-resources.md, 17-scheduling-and-execution.md, 21-processes-and-services.md]
---

# 25. Observability and Diagnostics

## Invariants

1. Observability is explicit.
2. Diagnostics do not define system semantics.
3. Native observability uses typed data.
4. Human-readable text is a presentation format.
5. Diagnostic access follows capability rules.
6. Diagnostics do not expose unrelated privileged state.
7. Observability overhead must remain bounded.
8. Disabled diagnostics should have minimal runtime cost.
9. Metrics have stable meaning.
10. Tracing does not become required for correctness.
11. Logs do not become a hidden persistence mechanism.
12. Debug behavior does not weaken release behavior.

## Native Model

Prefer:

```text
system state
-> typed diagnostic data
-> renderer or tool
```

Do not make `/proc`, `/sys`, text pseudo-files, or log parsing the native observability model.

Compatibility layers can expose those forms when required.

## Diagnostic Resources

Expose diagnostics through typed resources.

Examples:

```text
ProcessInfo
MemoryStats
CpuStats
SchedulerStats
DeviceStats
NetworkStats
FilesystemStats
ServiceStats
```

Each resource defines:

* Owner.
* Scope.
* Required capability.
* Snapshot or live semantics.
* Update behavior.
* Failure behavior.

Do not expose internal mutable structures directly.

## Metrics

A metric defines:

* Name.
* Unit.
* Scope.
* Owner.
* Meaning.
* Collection point.

Prefer stable semantic metrics.

Examples:

```text
bytes
operations
nanoseconds
queue depth
allocation count
context switches
restarts
errors
```

Do not publish a metric whose meaning depends on undocumented implementation detail.

## Counters

Counters should be monotonic when their contract is cumulative.

Define reset behavior when reset is supported.

Do not overload one counter with multiple meanings.

Do not use a counter as control state.

## Gauges

Use gauges for current state.

Examples:

```text
resident memory
queue depth
active processes
open resources
current load
```

Define whether the value is exact, sampled, or approximate.

Do not present sampled values as exact state.

## Histograms and Distributions

Use distributions when averages hide important behavior.

Applicable cases include:

* Latency.
* Queue wait time.
* Scheduler delay.
* I/O completion time.
* IPC round-trip time.

Prefer explicit percentile or histogram semantics.

Do not infer tail behavior from a mean.

## Tracing

Tracing records ordered events.

A trace event should define:

* Event type.
* Timestamp.
* Source.
* Relevant identity.
* Relevant state.
* Correlation identity when required.

Keep events small.

Do not record full payloads when metadata is sufficient.

Do not make tracing mandatory for normal execution.

## Correlation

Use explicit correlation for operations that cross boundaries.

Examples:

```text
request
-> service
-> driver
-> completion
```

Correlation identifiers are diagnostic metadata.

They are not authority.

Do not use diagnostic identifiers as capabilities.

## Logging

Logs are for human and operational diagnostics.

A log entry can contain:

* Component.
* Severity.
* Event.
* Relevant context.
* Cause when known.

Prefer structured fields internally.

Render text at the presentation boundary.

Do not parse human log text as a system API.

## Log Levels

Use levels consistently.

Example classes:

```text
error
warn
info
debug
trace
```

Do not log expected high-frequency events at a level that creates uncontrolled output.

Do not use `error` for normal control flow.

## Sensitive Data

Do not expose through diagnostics:

* Secret keys.
* Capability secrets.
* Private memory.
* Credentials.
* Unrelated user data.
* Raw privileged payloads without explicit authority.

Redaction belongs at the owning diagnostic boundary.

Do not rely on downstream tools to remove secrets.

## Process Inspection

Process inspection requires explicit authority.

Diagnostic access can expose applicable information such as:

* State.
* CPU use.
* Memory use.
* Threads.
* Open resources.
* Scheduling data.
* Failure state.

Do not expose process-private content only because the caller can see the process name.

## Resource Inspection

Resource inspection can expose:

* Type.
* Identity.
* Owner.
* Lifetime state.
* Allowed diagnostic metadata.

Do not expose capabilities held by another process beyond the caller's diagnostic authority.

## Kernel Diagnostics

Keep kernel diagnostics narrow.

Prefer exporting stable diagnostic snapshots or events.

Do not expose raw kernel pointers as native identifiers.

Do not make userspace tooling depend on private kernel layouts.

## Driver Diagnostics

A driver can expose:

* Device state.
* Queue state.
* Errors.
* Reset count.
* Interrupt count.
* Throughput counters.
* Device-specific diagnostics when explicitly typed.

Do not expose raw MMIO access through diagnostics.

Do not make a debug interface an authority bypass.

## Scheduler Diagnostics

Scheduler diagnostics can expose:

* Runnable work.
* Queue depth.
* Runtime.
* Wake-ups.
* Migrations.
* Preemptions.
* Queue latency.

Keep collection overhead bounded.

Do not add global synchronization only for diagnostics unless evidence justifies it.

## Memory Diagnostics

Memory diagnostics should identify ownership.

Applicable views include:

```text
kernel
drivers
system services
applications
page tables
shared memory
pinned memory
caches
```

Do not report only one total when ownership information is required to diagnose usage.

`13-memory-management.md` owns memory accounting semantics.

## Filesystem Diagnostics

Filesystem diagnostics can expose:

* Capacity.
* Used space.
* Reclaimable space.
* Snapshot use.
* Shared extent use.
* Integrity failures.
* Transaction state.
* Device health references.

Keep logical and physical accounting separate.

Do not report reclaimable snapshots as irreducible live data.

## Network Diagnostics

Networking diagnostics can expose:

* Interfaces.
* Routes.
* Connections.
* Queue pressure.
* Drops.
* Retransmissions.
* Device errors.
* Transport statistics.

Expose typed state.

Do not require text parsing from a pseudo-filesystem.

## Service Diagnostics

A service can expose:

* State.
* Readiness.
* Restarts.
* Failure reason.
* Resource use.
* Queue state.
* Contract version.

Do not expose internal implementation state unless it has diagnostic value.

## Debug Builds

Debug behavior can add:

* Assertions.
* Extra validation.
* Trace points.
* Expensive diagnostics.

Do not let a debug-only mechanism become required for correctness.

Do not let release builds silently weaken required safety checks.

## Assertions

Use assertions for internal invariants.

Do not use assertions for expected external failure.

Keep expensive diagnostic assertions outside critical release paths when they are not required for correctness.

## Crash Diagnostics

On a fatal failure, preserve the smallest useful diagnostic state.

Applicable data can include:

* Failure reason.
* CPU state.
* Current execution unit.
* Relevant stack.
* Recent trace events.
* Machine profile identity.
* Build identity.

Do not attempt complex recovery inside fatal diagnostic code.

Keep crash capture bounded.

## Time

Diagnostic timestamps use an explicit clock.

Distinguish when required:

```text
monotonic time
wall-clock time
boot-relative time
```

Do not use wall-clock time for latency measurement.

Do not assume wall-clock time is monotonic.

## Performance

Observability has a cost.

Measure applicable cost such as:

* CPU overhead.
* Memory overhead.
* Cache impact.
* Lock contention.
* Trace bandwidth.
* Log volume.

Prefer designs where disabled diagnostics remove most of the cost.

Do not keep high-cost observability permanently enabled without evidence.

## Compatibility

Compatibility layers can expose foreign observability forms such as:

```text
/proc
/sys
traditional process tables
text command output
foreign debug APIs
```

Translate native typed diagnostics at the boundary.

Do not make foreign observability layouts part of Nod's native contract.

## Evidence

When choosing an observability design, measure applicable properties such as:

* Collection overhead.
* Memory cost.
* Trace throughput.
* Lost-event behavior.
* Diagnostic latency.
* Contention.
* Disabled-path cost.

Use `investigate` to promote a proven observability decision into this rule.
