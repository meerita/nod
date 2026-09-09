---
name: 21-processes-and-services
description: "Defines process, service, lifecycle, isolation, spawning, authority, supervision, and system-service rules for Nod."
owns: "process model; service model; spawning; supervision; lifecycle; process isolation; system-service ownership"
see-also: [07-security.md, 11-errors-and-failure.md, 12-concurrency-and-synchronization.md, 14-capabilities-and-resources.md, 16-ipc-and-messaging.md, 17-scheduling-and-execution.md]
---

# 21. Processes and Services

## Invariants

1. A process is an isolated execution and resource domain.
2. Process creation is explicit.
3. Nod does not use `fork()` as its native process-creation model.
4. A child receives only explicitly granted authority.
5. Process identity does not imply authority.
6. Process lifetime is independent from human-readable names.
7. System services run outside the kernel when practical.
8. Service failure should remain inside the service fault boundary.
9. Restart policy belongs to the service supervisor.
10. Process termination releases owned resources through explicit lifecycle rules.
11. A service interface is versioned independently from its implementation.
12. A replacement service can provide the same native contract.

## Process Model

A process owns an isolation boundary.

A process can own:

* Address space.
* Capabilities.
* Handles.
* Threads or tasks.
* Memory mappings.
* IPC endpoints.
* Resource limits.
* Execution policy.
* Exit state.

Do not treat a process as only a scheduler container.

Do not use global identity as the native authority model.

## Process Creation

Create a process from an explicit description.

Conceptually:

```text
spawn
  image
  memory
  capabilities
  arguments
  environment
  namespace
  execution policy
-> process
```

Do not implement native process creation as:

```text
duplicate current process
-> mutate duplicate
-> replace image
```

`fork()` compatibility can exist at a compatibility boundary.

It does not define the Nod process model.

## Spawn Contract

A spawn request defines applicable properties such as:

* Executable resource.
* Initial capabilities.
* Initial handles.
* Arguments.
* Environment.
* Namespace.
* Memory limits.
* CPU policy.
* Parent relationship when needed.
* Startup channel.

Do not implicitly inherit all parent authority.

Prefer an empty authority set plus explicit grants.

## Process Identity

A process can have:

* Stable runtime identity.
* Display name.
* Parent relationship.
* Service identity.
* Diagnostic metadata.

Do not use a PID-like number as authority.

A local numeric handle can reference a process.

It is not the semantic identity of the process.

## Parent and Child

Parent-child relationships are lifecycle relationships, not universal authority relationships.

A parent can receive explicit authority to:

* Inspect.
* Wait.
* Stop.
* Restart.
* Delegate resources.

Do not assume that every parent has unrestricted control over every child.

Do not make orphan behavior depend on Unix semantics.

## Process Exit

A process exit defines:

* Exit reason.
* Exit status when applicable.
* Owned-resource cleanup.
* Outstanding IPC behavior.
* Capability release.
* Shared-resource behavior.
* Supervisor notification.

Do not leave resources permanently owned by a dead process.

Do not destroy shared resources that remain valid for other owners.

## Termination

Distinguish termination causes.

Examples:

```text
normal completion
requested stop
policy termination
resource exhaustion
fault
security violation
service replacement
system shutdown
```

Keep the reason observable to the authority that owns lifecycle policy.

Do not reduce all termination to one generic signal.

## Native Control

Prefer typed process operations.

Examples:

```text
Process
  inspect
  wait
  request_stop
  terminate
  suspend
  resume
```

Do not use Unix signals as the native process-control model.

Signal compatibility can exist in a compatibility layer.

## Graceful Stop

A cooperative stop request is different from forced termination.

Define:

```text
request_stop
    -> process can complete owned cleanup

terminate
    -> system ends execution
```

Do not require cooperative behavior when forced termination is required for isolation or safety.

## Services

A system service is a userspace component that owns one system capability or policy domain.

Examples can include:

```text
filesystem service
network service
device service
resolver
audio service
display service
package service
update service
```

Prefer services outside the kernel when their function does not require kernel privilege.

Do not move service policy into the kernel only to reduce IPC.

## Service Contract

A service exposes a typed, versioned contract.

The contract defines:

* Operations.
* Required capabilities.
* Message types.
* Failure behavior.
* Lifecycle behavior.
* Compatibility policy.

A client depends on the contract.

It does not depend on one permanent implementation.

## Replaceable Services

A service implementation can be replaced.

A replacement must preserve the required service contract.

A replacement can become preferred when it proves better applicable properties such as:

* Correctness.
* Safety.
* Latency.
* Memory use.
* CPU use.
* Isolation.
* Maintainability.
* Recovery behavior.

Do not make implementation identity part of the service contract unless required.

## Service Discovery

Service discovery returns authority, not only a name.

Conceptually:

```text
service lookup
-> capability to service
```

Knowing a service name does not grant authority to use it.

Discovery policy decides which capability the requester can receive.

## Supervision

A supervisor owns service lifecycle policy.

A supervisor can decide:

* Start.
* Stop.
* Restart.
* Replacement.
* Backoff.
* Failure escalation.
* Dependency ordering.

The service reports failure.

The supervisor decides recovery policy.

`11-errors-and-failure.md` owns failure semantics.

## Restart

For a restartable service, define:

* Durable state owner.
* Ephemeral state loss.
* Client behavior.
* Outstanding request behavior.
* Capability continuity.
* Device recovery when applicable.

Do not describe a service as restartable when restarting it can leave system state ambiguous.

## Service Dependencies

Keep service dependencies explicit.

A service dependency can define:

* Required service.
* Required contract version.
* Startup requirement.
* Failure relationship.
* Restart relationship.

Avoid dependency cycles.

Do not require global startup ordering when explicit dependency readiness is sufficient.

## Startup

System startup should activate only required services.

Use machine and system configuration to avoid starting irrelevant components.

Prefer:

```text
required hardware
-> required drivers
-> required services
-> user environment
```

Do not start a service only because the generic system image historically includes it.

Machine specialization can remove services that the machine cannot use.

## Readiness

Separate:

```text
process started
service initialized
service ready
```

Do not advertise a service as available before it can satisfy its contract.

Readiness should be explicit.

Avoid arbitrary sleep-based startup ordering.

## Resource Limits

A process or service can have explicit limits for:

* Memory.
* CPU.
* Handles.
* Capabilities.
* IPC queues.
* Device access.
* Persistent storage.
* Network authority.

Resource limits are policy.

Do not hide them inside allocator or scheduler internals.

## Isolation

Processes do not share authority by default.

Isolation can cover:

* Address space.
* Resource namespace.
* Network view.
* Device access.
* Filesystem authority.
* Service visibility.

Share only what the process contract requires.

Do not use one global environment when independent resource views provide better isolation.

## Shared Memory

Shared memory between processes is explicit.

For each shared region, define:

* Owners.
* Mapping rights.
* Mutation rights.
* Synchronization.
* Lifetime.
* Revocation.
* Cleanup.

Do not make shared memory the default IPC mechanism.

`16-ipc-and-messaging.md` owns IPC semantics.

## System Process Privilege

Do not grant broad privilege because a process is a system process.

A system service receives only capabilities required for its contract.

Avoid a universal `root` authority model for native Nod services.

Compatibility layers can emulate identity-based privilege when required.

They do not define native authority.

## Executable Identity

Keep executable identity separate from running process identity.

An executable resource can start multiple processes.

A process can record its executable origin for diagnostics and policy.

Do not use executable path as immutable process identity.

## Environment

Treat environment data as explicit process input.

Do not use ambient environment variables for privileged authority.

Environment variables can configure applications.

They do not grant capabilities.

## Process Inspection

Inspection requires explicit authority.

Inspection can expose applicable information such as:

* State.
* Resource use.
* Threads.
* Memory accounting.
* Capabilities at an allowed level.
* Open resources.
* Execution statistics.

Do not expose another process's private memory or authority through global diagnostics by default.

## Debugging

Debug authority is explicit and powerful.

A debugger can require capabilities for:

* Inspecting memory.
* Pausing execution.
* Modifying state.
* Reading registers.
* Setting breakpoints.

Do not make debugging authority implicit for all processes owned by the same user identity.

## Failure Isolation

A process fault should terminate or recover the smallest affected domain.

Prefer:

```text
application fault
    -> application

driver fault
    -> driver

service fault
    -> service
```

Escalate only when system invariants cannot remain valid.

Do not make recoverable process failure a kernel failure.

## Compatibility

Support foreign process semantics through explicit adapters.

Examples can include:

```text
POSIX process IDs
fork
exec
signals
Unix process groups
environment inheritance
```

Translate foreign semantics at the compatibility boundary.

Do not let compatibility requirements define the native process model.

## Evidence

When process or service architecture depends on cost, measure applicable properties such as:

* Spawn latency.
* Service startup latency.
* Process memory overhead.
* IPC overhead.
* Context-switch cost.
* Restart latency.
* Capability-table overhead.
* Isolation overhead.
* Supervisor recovery latency.

Use `investigate` to promote proven process or service decisions into this rule.
