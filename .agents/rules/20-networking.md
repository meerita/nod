---
name: 20-networking
description: "Defines Nod networking architecture, native network resources, transport semantics, packet ownership, routing, isolation, and compatibility rules."
owns: "network stack; native networking API; packet ownership; transport semantics; routing; network isolation; networking compatibility"
see-also: [07-security.md, 12-concurrency-and-synchronization.md, 14-capabilities-and-resources.md, 16-ipc-and-messaging.md, 18-drivers-and-hardware.md]
---

# 20. Networking

## Invariants

1. Nod owns its native network stack.
2. Native Nod networking is not defined by BSD sockets.
3. Connections, streams, datagrams, interfaces, and routes are typed resources.
4. Network authority is capability-based.
5. Packet ownership is explicit.
6. Network I/O uses asynchronous completion internally.
7. Blocking socket semantics belong only in compatibility or convenience layers.
8. Network drivers do not own protocol policy.
9. Protocol layers do not depend on device-specific representations.
10. Packet processing avoids unnecessary copies.
11. Queues are bounded.
12. Backpressure is explicit.
13. Routing policy is separate from packet transport.
14. Network namespaces or equivalent isolation are first-class.
15. Machine specialization can remove unused networking code and drivers.
16. Compatibility protocols do not define native Nod interfaces.

## Layering

Keep these ownership boundaries separate:

```text
network device
-> device-class interface
-> link layer
-> network layer
-> transport layer
-> network service
-> application resource
```

A lower layer owns mechanism.

A higher layer owns semantics and policy.

Do not put TCP state in a network driver.

Do not put device queue details in transport code.

## Native Resources

Represent network concepts as typed resources.

Examples:

```text
NetworkInterface
Route
DatagramEndpoint
Connection
Stream
Listener
PacketBuffer
Resolver
```

Each resource defines:

* Identity.
* Owner.
* Supported operations.
* Required capabilities.
* Lifetime.
* Failure behavior.

Do not force unrelated network operations through one generic socket type.

## Native API

Prefer explicit operations.

Examples:

```text
Connection
  connect
  close
  state

Stream
  send
  receive
  shutdown

DatagramEndpoint
  send
  receive

Listener
  accept
```

Do not use integer protocol families or generic option bags as the native Nod contract.

Do not require an `ioctl`-style escape path for normal network control.

## BSD Socket Compatibility

Support BSD sockets only through a compatibility layer when required.

Translate:

```text
BSD socket API
-> compatibility adapter
-> Nod networking resources
```

Do not let:

```text
socket()
bind()
listen()
accept()
setsockopt()
```

define native Nod architecture.

Compatibility behavior remains at the boundary.

## Asynchronous I/O

Use asynchronous completion as the native network execution model.

A network operation can:

```text
submit
-> continue execution
-> receive completion
```

Do not require one blocked thread per outstanding network operation.

Synchronous behavior can exist as a convenience layer.

Do not implement the internal stack around blocking semantics.

## Packet Ownership

For each packet buffer, define:

* Owner.
* Mutable owner.
* Lifetime.
* Device ownership.
* Stack ownership.
* Application ownership when exposed.
* Reuse point.

Prefer ownership transfer over shared mutation.

Example:

```text
NIC
-> receive queue
-> network stack
-> transport
-> consumer
-> recycle
```

Do not reuse a packet buffer before ownership returns.

## Packet Copies

Avoid unnecessary packet copies.

Prefer:

* Ownership transfer.
* Scatter-gather I/O.
* Borrowed views.
* Shared immutable payloads.
* DMA-aware buffers.

Zero-copy is an optimization.

Do not increase complexity for zero-copy without evidence that the copy cost matters.

Do not call a path zero-copy without verifying the actual data path.

## Packet Parsing

Parse external packet data at the protocol boundary.

For packet parsers:

* Validate lengths before access.
* Validate version and type fields.
* Reject malformed input explicitly.
* Keep untrusted offsets bounded.
* Preserve protocol-defined byte order.

Do not let wire representations become internal Nod types.

## Network Drivers

A network driver owns:

* Device initialization.
* Hardware queues.
* Descriptor rings.
* DMA.
* Interrupts.
* Device reset.
* Link hardware state.

A network driver exposes a Nod `NetworkDevice` interface.

It does not own:

* IP.
* TCP.
* UDP.
* Routing policy.
* DNS.
* Firewall policy.

## Receive Path

Prefer a bounded receive path.

Conceptually:

```text
device completion
-> packet ownership transfer
-> link validation
-> network-layer dispatch
-> transport dispatch
-> endpoint queue
```

Keep expensive application work outside device and interrupt context.

Do not perform unbounded protocol processing inside an interrupt handler.

## Transmit Path

A transmit operation defines:

* Payload ownership.
* Queue ownership.
* Backpressure.
* Completion.
* Cancellation when supported.
* Failure.

Do not report successful transmission before the contract's completion point.

Keep device submission separate from transport acknowledgment semantics.

## Queues

All network queues have an explicit capacity or pressure policy.

Define:

* Owner.
* Producer.
* Consumer.
* Capacity.
* Full behavior.
* Empty behavior.
* Wake-up behavior.
* Shutdown behavior.

Pressure behavior can include:

```text
reject
wait
drop by contract
shed
coalesce
```

Do not use unbounded packet queues.

Do not hide overload through memory growth.

## Backpressure

Propagate pressure toward the producer when practical.

Examples:

```text
device queue full
-> network stack slows submission

receive queue full
-> protocol-specific pressure or drop policy

application not consuming
-> endpoint pressure
```

Do not let one slow consumer consume unbounded system memory.

## TCP

Implement TCP as a Nod-owned transport.

Keep TCP state separate from application state.

TCP owns applicable behavior such as:

* Connection state.
* Sequence tracking.
* Acknowledgments.
* Retransmission.
* Flow control.
* Congestion control.
* Ordered byte delivery.

Do not expose internal TCP machinery as the native `Stream` contract.

Allow transport algorithms to evolve behind the stable resource interface.

## UDP

Represent UDP through typed datagram semantics.

A datagram preserves message boundaries.

Define:

* Source.
* Destination.
* Payload.
* Maximum accepted size.
* Delivery failure behavior.

Do not expose UDP as a byte stream.

## IP

Keep IPv4 and IPv6 as protocol implementations below the native endpoint contract.

Do not require applications to select internal protocol machinery when policy can choose it.

Preserve explicit address selection when the application requires it.

Do not make IPv4 assumptions part of native networking semantics.

## Routing

Routing owns path selection.

Keep separate:

```text
route discovery
route policy
interface state
packet forwarding
transport state
```

A route can depend on:

* Destination.
* Interface.
* Metric.
* Source policy.
* Namespace.
* Machine topology.

Do not put routing policy inside transport implementations.

## Interfaces

A network interface is a typed resource.

It can expose:

* State.
* Link properties.
* Addresses.
* Capabilities.
* Statistics.
* Configuration.

Do not expose raw driver internals through interface configuration.

## Network Isolation

Network visibility and authority can differ per process, service, or environment.

Support isolated network views when required.

An isolated environment can have its own:

* Interfaces.
* Addresses.
* Routes.
* Listeners.
* Resolver configuration.
* Policy.

Do not require one global network namespace.

Knowing an address or endpoint does not grant authority to use it.

## Capabilities

Use capabilities for network authority.

Applicable capabilities can grant:

```text
connect
listen
send
receive
configure interface
modify route
inspect network state
```

Do not grant full network authority when a process only requires one endpoint or operation.

`14-capabilities-and-resources.md` owns capability semantics.

## DNS and Name Resolution

Keep name resolution outside transport semantics.

A resolver is a service or resource.

Define:

* Resolver authority.
* Namespace.
* Cache ownership.
* Failure behavior.
* Configuration source.

Do not make DNS availability a requirement for raw network connectivity.

Do not put resolver policy in the kernel unless a demonstrated requirement needs it.

## Firewall and Policy

Network policy belongs above packet transport.

Policy can decide:

* Which endpoints can communicate.
* Which interfaces can be used.
* Which capabilities can be granted.
* Which traffic can cross an isolation boundary.

Do not mix firewall policy into device drivers or transport algorithms.

## Checksums and Offload

Use hardware offload when:

* Hardware supports it.
* The driver exposes it explicitly.
* Correctness remains observable.
* Evidence shows a useful benefit.

Possible offloads include:

```text
checksum
segmentation
receive aggregation
queue steering
```

Do not make offload availability part of protocol correctness.

Provide a correct software path.

## Multi-Core Networking

Prefer ownership partitioning over one global network lock.

Possible partitioning can use:

* Interface queues.
* Flow ownership.
* Connection ownership.
* Core-local packet queues.

Keep connection state on one owner when practical.

Use explicit transfer when flow ownership changes.

Do not introduce cross-core shared state without a demonstrated requirement.

## Machine Specialization

Use the machine profile to specialize networking.

A machine image can know:

* Installed network devices.
* Queue counts.
* CPU topology.
* Interrupt topology.
* Offload capabilities.
* Expected interface classes.

Use this information to remove unused drivers and specialize queue placement.

Do not hard-code one machine's topology into native network semantics.

## Network Memory

Keep packet memory bounded.

Account for:

* Receive buffers.
* Transmit buffers.
* Connection state.
* Retransmission state.
* Endpoint queues.
* Routing state.
* Resolver cache.

Do not allow connection count or packet backlog to create uncontrolled memory growth.

`13-memory-management.md` owns memory-pressure policy.

## Failure

Network failure is expected runtime behavior.

Examples:

* Link loss.
* Packet loss.
* Timeout.
* Reset.
* Route loss.
* Device failure.
* Remote close.
* Resource exhaustion.

Expose failure through the owning contract.

Do not turn ordinary network failure into a system panic.

`11-errors-and-failure.md` owns failure policy.

## Compatibility

Support foreign networking interfaces only through explicit adapters.

Examples can include:

```text
BSD sockets
POSIX networking
Linux-compatible socket options
foreign address structures
```

Translate foreign representations at the compatibility boundary.

Do not carry foreign socket structures through the native stack.

## Observability

Expose network diagnostics without coupling diagnostics to protocol correctness.

Applicable data can include:

* Interfaces.
* Connections.
* Routes.
* Queue pressure.
* Packet counters.
* Retransmissions.
* Drops.
* Latency.
* Device errors.

Do not require `/proc`, `/sys`, or text pseudo-files for native observability.

Expose typed diagnostic resources.

## Evidence

Measure networking decisions that depend on cost.

Applicable measurements include:

* Packet latency.
* Connection latency.
* Throughput.
* Tail latency.
* Packet copies.
* Allocations.
* CPU per packet.
* Memory per connection.
* Queue contention.
* Cross-core traffic.
* Interrupt cost.
* Context-switch cost.
* IPC cost.
* Packet-drop behavior under pressure.

Use `investigate` to promote proven networking decisions into this rule.
