---
name: 23-boot-and-machine-specialization
description: "Defines Nod boot flow, machine profiles, specialization, hardware discovery, recovery images, and machine-specific system generation."
owns: "boot flow; machine profiles; specialization; recovery boot; machine-specific image generation"
see-also: [01-project-invariants.md, 09-build-and-tooling.md, 13-memory-management.md, 17-scheduling-and-execution.md, 18-drivers-and-hardware.md, 27-architecture-and-hal.md]
---

# 23. Boot and Machine Specialization

## Invariants

1. Nod boots from an explicit machine profile.
2. Hardware discovery feeds specialization.
3. The installed system image can be machine-specific.
4. Machine specialization is a first-class feature.
5. Nod does not carry unused hardware support without a reason.
6. Boot initializes only required hardware and services.
7. Machine-specific optimization does not change native Nod semantics.
8. A generic recovery environment remains available when machine-specific support is insufficient.
9. Hardware changes can trigger machine-profile regeneration.
10. The boot path stays small and explicit.
11. Firmware outside Nod remains an external trust boundary.
12. QEMU and physical hardware share the same architecture contracts when practical.

## Boot Boundary

Keep the boot boundary explicit.

Conceptually:

```text
platform firmware
-> Nod boot code
-> kernel entry
-> machine initialization
-> required services
-> user environment
```

Firmware behavior below the Nod boundary is external.

Do not treat firmware code as part of Nod.

The machine profile declares the entry exception level.

Boot code validates the observed level against the declaration.

Discovery validates a profile. Discovery never selects one.

A mismatch rejects the optimized boot, as Fallback requires.

Nod never enters at EL3.

Source: `tmp/investigations/completed/01-aarch64-execution-level-and-privilege-model.md`.

## Boot Code

Boot code owns:

* Entry from the platform.
* Early CPU state.
* Early memory state.
* Kernel image loading.
* Initial machine information.
* Transfer to the kernel.

Keep boot code small.

Do not place general system policy in the boot path.

Do not keep boot-time compatibility mechanisms alive after the kernel no longer needs them.

## Machine Profile

A machine profile describes the hardware and specialization inputs that Nod needs.

Applicable data can include:

* Architecture.
* Entry exception level.
* CPU model.
* Core count.
* Core topology.
* Cache topology.
* Memory size.
* Memory regions.
* NUMA topology.
* Page-size capabilities.
* Interrupt controller.
* Timers.
* Buses.
* Storage devices.
* Network devices.
* Graphics devices.
* Input devices.
* DMA constraints.
* IOMMU support.
* Firmware interfaces.

Do not include data that no Nod component uses.

## Discovery

Discovery produces verified machine facts.

Keep separate:

```text
discovery
-> machine profile
-> specialization
-> installed image
```

Do not let one device driver become the owner of global machine discovery.

Do not encode unsupported hardware guesses into the machine profile.

## Specialization

Use the machine profile to specialize applicable parts of the system.

Specialization can affect:

* Included drivers.
* Included services.
* CPU-specific code paths.
* SIMD support.
* Scheduler placement.
* Queue counts.
* Memory structures.
* Interrupt placement.
* NUMA placement.
* Device initialization.
* Boot order.
* Binary selection.

Prefer compile-time specialization when runtime flexibility is not required.

Prefer runtime specialization when hardware can change or one image must support a controlled hardware class.

## Remove Unused Support

A machine-specific image should not include unrelated implementations when they cannot be used.

Example:

```text
machine:
  ARM64
  one NVMe controller
  one Ethernet controller
  no Wi-Fi
  no SATA

image:
  include ARM64
  include required NVMe driver
  include required Ethernet driver
  exclude x86
  exclude SATA
  exclude unrelated network drivers
```

Do not keep unused support only because a generic operating system normally does.

## CPU Specialization

Use known CPU capabilities when they provide a useful implementation advantage.

Applicable inputs can include:

* ISA extensions.
* SIMD features.
* Cache topology.
* Core classes.
* Atomic capabilities.
* Timer features.

Prefer direct specialized implementations over repeated runtime feature branches when the machine image is fixed.

Do not use a CPU feature that the machine profile does not guarantee.

## Scheduler Specialization

Use known topology to guide scheduling.

Applicable inputs include:

* Core count.
* Shared caches.
* NUMA domains.
* Performance classes.
* Interrupt locality.
* Device locality.

Prefer known machine topology over generic heuristics when the machine profile is fixed.

`17-scheduling-and-execution.md` owns scheduling policy.

## Memory Specialization

Use known memory properties to reduce unnecessary generic overhead.

Applicable inputs include:

* Installed memory.
* Physical regions.
* NUMA topology.
* Page-size support.
* DMA limits.
* Reserved firmware regions.

Do not allocate metadata for impossible machine states without a reason.

`13-memory-management.md` owns memory policy.

## Driver Specialization

Include only required native drivers and supported hot-plug classes.

When hardware is fixed:

* Bind the known driver directly when safe.
* Avoid unnecessary broad probing.
* Initialize known resources directly.

When hardware can change:

* Preserve the required discovery path.
* Preserve driver binding.

Do not optimize away hardware flexibility that the machine contract promises.

## Service Specialization

Start only services required by the machine and configured system.

Examples:

```text
no wireless device
-> no wireless service

no audio device
-> no audio service

headless machine
-> no graphical service
```

Do not start a service only because it exists in the generic source tree.

## Boot Order

Order boot by real dependencies.

Prefer:

```text
CPU and memory
-> interrupts and timers
-> required device mechanisms
-> required drivers
-> required system services
-> user environment
```

Do not serialize independent initialization without a dependency.

Allow parallel initialization when ownership and dependencies permit it.

## Fast Boot

Low boot latency is a design goal.

Prefer:

* Known machine state.
* Direct driver binding.
* Minimal probing.
* Parallel independent initialization.
* Small required service set.
* No arbitrary delays.

Do not trade correctness for boot-time numbers.

Do not use fixed sleeps for readiness.

## QEMU

Use QEMU as the initial development platform.

Prefer an architecture target that matches the physical reference platform.

For ARM64 development:

```text
QEMU virt
-> aarch64 Nod architecture boundary

Raspberry Pi
-> aarch64 Nod architecture boundary
```

Keep common architecture-independent code above platform-specific machine support.

Do not write QEMU-only semantics into the kernel contract.

## Physical Reference Platform

Raspberry Pi can serve as the initial physical reference platform.

Keep Raspberry Pi-specific behavior behind its machine boundary.

Do not make Raspberry Pi firmware, peripherals, memory map, or boot flow native Nod semantics.

The reference platform proves the system on real hardware.

It does not define the only future machine model.

## Installation

Installation can generate a machine-specific system image.

Conceptually:

```text
generic installer
-> hardware discovery
-> machine profile
-> specialization
-> machine image
-> install
```

The installed image can contain:

* Boot code.
* Specialized kernel.
* Required drivers.
* Required services.
* Native filesystem.
* Machine profile.

Do not install unrelated system components without a reason.

## Image Generation

A machine image derives from explicit inputs.

Applicable inputs include:

* Nod revision.
* Toolchain.
* Machine profile.
* System configuration.
* Selected system components.

Keep image generation reproducible when required.

`09-build-and-tooling.md` owns build reproducibility.

## Hardware Change

When hardware changes:

```text
detect change
-> update machine profile
-> add or remove required components
-> regenerate image when required
```

Do not require complete OS reinstallation only because one supported device changed.

Do not silently ignore hardware that the current image cannot support.

## Recovery Environment

Keep a generic recovery environment separate from the optimized installed image.

Recovery can provide:

* Broader hardware discovery.
* Storage access.
* Machine-profile inspection.
* System-image regeneration.
* Repair.
* Rollback.
* Diagnostic access.

The recovery environment can contain support that the optimized installed image excludes.

Do not make the normal runtime pay the full cost of recovery compatibility.

## Fallback

Fallback behavior is explicit.

Examples:

```text
specialized kernel fails
-> boot known-good image

new unsupported device
-> enter recovery or generic hardware path

machine profile invalid
-> reject optimized boot
```

Do not silently fall back to weaker security or integrity semantics.

## Profile Versioning

Version the machine-profile format when persistent compatibility requires it.

For a profile change, define:

* Compatibility.
* Regeneration.
* Migration.
* Failure behavior.

Do not expose internal profile format as a permanent public API without a requirement.

## Machine Identity

Do not confuse:

```text
machine profile
machine identity
hardware serial identity
user identity
```

A profile describes required hardware properties.

It is not automatically a security identity.

Do not grant authority from machine-profile contents alone.

## Evidence

Measure specialization decisions when they depend on cost.

Applicable measurements include:

* Boot time.
* Kernel size.
* System image size.
* Idle memory.
* Per-device memory.
* Initialization latency.
* CPU instruction count.
* Scheduler locality.
* Removed runtime branches.
* Driver probe cost.
* Service startup cost.

Use `investigate` to promote a proven specialization decision into this rule.
