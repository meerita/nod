---
name: 13-memory-management
description: "Defines memory ownership, allocation, reclamation, mapping, pressure, and machine-memory rules for Nod."
owns: "memory ownership; allocation; reclamation; virtual memory; memory pressure; memory accounting"
see-also: [01-project-invariants.md, 11-errors-and-failure.md, 12-concurrency-and-synchronization.md, 15-unsafe.md, 42-performance.md]
---

# 13. Memory Management

## Invariants

1. Memory has an explicit owner.
2. Allocation is visible at performance-sensitive boundaries.
3. Reclamation is bounded where latency matters.
4. Memory pressure is a normal system condition.
5. The system does not consume memory only because memory is available.
6. Machine memory topology is an optimization input, not a hidden assumption.
7. Architecture-independent code does not depend on one physical memory layout.
8. Virtual memory policy does not leak into unrelated subsystems.
9. Memory accounting reflects actual ownership.
10. A successful allocation has explicit lifetime and reclamation semantics.
11. Failure to allocate does not corrupt existing state.
12. Memory safety does not depend on allocator behavior that is not part of its contract.

## Memory Budget

Treat memory as an owned resource.

For system components:

* Keep fixed overhead small.
* Keep idle memory use small.
* Avoid permanent allocation for optional capabilities.
* Allocate for actual machine resources, not hypothetical hardware.
* Release memory that no longer serves an owned purpose.

Do not use available RAM as justification for higher baseline consumption.

A machine with more memory should primarily make more memory available to workloads and useful caches.

## Machine Specialization

Use the detected machine profile when it can remove unnecessary memory cost.

Relevant inputs can include:

* Installed physical memory.
* Memory regions.
* NUMA topology.
* Cache topology.
* Core topology.
* Supported page sizes.
* DMA constraints.
* Device memory requirements.

Do not compile or allocate structures for hardware that the machine profile excludes when Nod does not need runtime portability for that structure.

Keep the generic contract separate from the specialized implementation.

## Ownership

For each allocated region, identify:

* Owner.
* Lifetime.
* Mutability.
* Sharing.
* Reclamation owner.
* Failure behavior.

Prefer one clear owner.

When memory ownership transfers:

* Make the transfer explicit.
* Preserve alignment requirements.
* Preserve lifetime requirements.
* Preserve mapping requirements.
* Remove the previous owner's authority when required.

Do not use shared ownership when transfer is sufficient.

## Allocation

Separate allocation classes when their contracts differ.

Examples:

```text
boot-time allocation
physical frame allocation
virtual address allocation
kernel object allocation
core-local allocation
DMA allocation
userspace allocation
temporary scratch allocation
```

Do not force all memory through one allocator abstraction when the underlying contracts differ.

For a performance-sensitive path, know whether it:

* Allocates.
* Can fail.
* Can block.
* Can trigger reclamation.
* Can grow internal metadata.

Do not hide these properties behind a convenience API.

## Physical Memory

Physical-memory management owns physical frames.

Keep separate concepts for:

* Physical ownership.
* Virtual mapping.
* Device ownership.
* Persistent storage.

Do not treat a physical address as a general-purpose pointer.

Do not expose physical addresses outside the boundary that requires them.

Reserve firmware, device, kernel, and unavailable regions explicitly.

## Virtual Memory

Virtual memory owns address-space mappings.

A mapping defines applicable properties such as:

* Address range.
* Physical backing.
* Access rights.
* Execution rights.
* Sharing.
* Lifetime.
* Device or normal memory type.

Keep mapping policy explicit.

Do not grant write or execute access when it is not required.

Do not make identity mapping a permanent architectural assumption.

## Page Size

Do not hard-code one page size into architecture-independent semantics.

A subsystem that requires a page-size property must state that requirement.

Machine or architecture code can specialize for supported page sizes.

Do not introduce huge pages or alternate page sizes without a measured or architectural reason.

## Core-Local Memory

Prefer core-local memory for state that does not require shared ownership.

Core-local allocation can reduce:

* Lock contention.
* Cache-line movement.
* Cross-core synchronization.

Do not replicate state across cores when the state requires one authoritative value.

`12-concurrency-and-synchronization.md` owns replicated-state coordination.

## Reclamation

The component that owns memory owns its normal reclamation.

For reclamation, define:

* Trigger.
* Amount of work.
* Context in which it runs.
* Whether it can block.
* Whether it can allocate.
* Whether work is bounded.
* Whether work can be deferred.

Do not perform unbounded reclamation inside a latency-critical section.

Move expensive destruction outside critical ownership when practical.

Do not assume that releasing a small number of allocations has constant-time cost.

## Memory Pressure

Define pressure behavior before exhaustion becomes catastrophic.

Possible responses include:

```text
reject allocation
reclaim cache
defer work
shed work
notify owner
terminate an isolated workload
```

Do not use unbounded allocation as pressure handling.

Do not silently steal memory from another ownership domain without policy that explicitly permits it.

Keep kernel-critical reserves separate when required for forward progress.

## Out of Memory

Allocation failure is an explicit result where recovery is possible.

On allocation failure:

* Preserve existing valid state.
* Release temporary ownership.
* Return the failure to the policy owner.
* Avoid recursive allocation in the failure path.

Do not use panic as the normal response to workload-driven memory exhaustion.

`11-errors-and-failure.md` owns failure policy.

## Caches

A cache is reclaimable memory.

For each cache, define:

* Owner.
* Maximum or pressure behavior.
* Eviction policy.
* Rebuild source.
* Whether contents are authoritative.

Do not make correctness depend on reclaimable cache contents.

Do not count useful cache as irreducible OS baseline memory.

## DMA

DMA memory has a distinct contract.

For DMA allocations, define:

* Device owner.
* Physical constraints.
* Alignment.
* Mapping.
* IOMMU scope when available.
* CPU visibility.
* Device visibility.
* Cache-coherency requirements.
* Lifetime.

Do not give a device access to physical memory outside its required DMA domain.

`07-security.md` owns device authority.

## Zeroing and Reuse

Do not expose stale memory contents across trust boundaries.

Before memory changes ownership between isolation domains:

* Clear data when confidentiality requires it.
* Preserve only explicitly shared state.

Do not add zeroing to internal same-owner paths when the contract does not require it and the cost is material.

Measure material zeroing costs before changing a hot path.

## Memory Accounting

Accounting should answer:

```text
who owns this memory?
what purpose does it serve?
is it reclaimable?
is it shared?
is it pinned?
```

Keep separate accounting for applicable classes such as:

* Kernel.
* Drivers.
* System services.
* Applications.
* Page tables.
* Device mappings.
* Caches.
* Shared memory.
* Pinned memory.

Do not hide permanent system cost inside a cache category.

## Memory Targets

Treat low base memory use as an architectural property.

Track applicable measures such as:

* Kernel resident memory.
* Privileged system memory.
* Idle system memory.
* Per-process overhead.
* Per-core overhead.
* Per-device overhead.
* Page-table overhead.

Do not optimize only the total number.

Identify which owner consumes the memory.

`42-performance.md` owns measurements and performance claims.

## Evidence

When a memory design decision depends on cost, measure the relevant property.

Evidence can include:

* Bytes allocated.
* Peak resident memory.
* Allocation count.
* Reclamation latency.
* Mapping cost.
* Page-table size.
* Fragmentation.
* Cache behavior.
* Per-core overhead.
* Per-object overhead.

Do not describe a memory design as lightweight without evidence.
