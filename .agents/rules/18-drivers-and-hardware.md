---
name: 18-drivers-and-hardware
description: "Defines hardware discovery, driver isolation, device-class interfaces, firmware boundaries, and hardware-specific implementation rules for Nod."
owns: "hardware discovery; driver model; device classes; firmware boundaries; MMIO and DMA ownership"
see-also: [01-project-invariants.md, 07-security.md, 13-memory-management.md, 14-capabilities-and-resources.md, 15-unsafe.md, 16-ipc-and-messaging.md]
---

# 18. Drivers and Hardware

## Invariants

1. The kernel knows hardware mechanisms, not every device policy.
2. Prefer drivers outside the kernel when practical.
3. A driver owns one explicit hardware boundary.
4. A device exposes a Nod-owned device-class interface.
5. Hardware-specific representations stop at the owning driver or architecture boundary.
6. Device authority is capability-based.
7. DMA authority is narrower than physical-memory authority.
8. Driver failure should remain local when practical.
9. Firmware outside Nod is an explicit external trust boundary.
10. Hardware support is based on verified specifications or measured behavior.
11. Machine specialization can remove unsupported hardware paths from a machine image.
12. Compatibility with foreign drivers does not define native Nod driver semantics.

## Hardware Discovery

Keep discovery separate from device operation.

Discovery identifies applicable properties such as:

* Bus.
* Vendor.
* Device.
* Class.
* Revision.
* Resources.
* Interrupts.
* MMIO regions.
* DMA capabilities.
* Firmware interface.

Do not start device policy inside discovery code.

Translate discovered hardware into Nod-owned resource descriptions before higher layers consume it.

## Buses

Bus support owns mechanisms such as:

```text
PCIe
USB
platform devices
architecture-specific buses
```

A bus layer can own:

* Enumeration.
* Resource discovery.
* Address assignment when required.
* Interrupt routing information.
* MMIO resource descriptions.
* Device identity.

A bus layer does not own device-class semantics.

Do not put storage, network, graphics, or input policy in generic bus code.

## Driver Ownership

A driver owns:

* Device-specific initialization.
* Device-specific registers.
* Command submission.
* Completion handling.
* Device reset.
* Device-specific failure translation.
* Hardware-defined queue or ring state.

A driver does not own higher-level policy when another subsystem owns it.

Example:

```text
NVMe driver
    -> owns NVMe queues and commands

block service
    -> owns block-device semantics

filesystem
    -> owns filesystem policy
```

## Userspace Drivers

Prefer userspace drivers when the device can be isolated without violating a required property.

Userspace driver design should allow:

* Process isolation.
* Restart after failure.
* Narrow capabilities.
* Explicit MMIO access.
* Explicit interrupt delivery.
* Explicit DMA domains.
* Versioned device-class interfaces.

Do not place a driver in the kernel only because traditional operating systems do.

## Kernel Drivers

Keep a driver in the kernel only when a demonstrated requirement needs it.

Possible reasons include:

* Early boot.
* Architecture bring-up.
* Interrupt-controller ownership.
* Memory-management dependency.
* Required latency that userspace cannot meet.
* Hardware that cannot be isolated safely outside the kernel.

Record the reason.

Do not treat kernel placement as permanent when the reason later disappears.

## Device Classes

Expose hardware through Nod-owned device classes.

Examples:

```text
BlockDevice
NetworkDevice
DisplayDevice
AudioDevice
InputDevice
CameraDevice
SensorDevice
ComputeDevice
```

A device class defines semantic operations.

A device-specific driver implements that contract.

Do not expose vendor registers or command formats through the generic device-class API.

## Device Interfaces

A device interface should define applicable properties such as:

* Supported operations.
* Ownership.
* Concurrency.
* Completion behavior.
* Cancellation.
* Failure behavior.
* Resource limits.
* Capability requirements.

Prefer typed operations.

Avoid a generic `ioctl`-style escape path for native Nod devices.

When device-specific control is required, keep it behind an explicit typed extension.

## MMIO

MMIO access belongs inside the smallest hardware-owning boundary.

For an MMIO region, define:

* Owner.
* Address range.
* Memory type.
* Access width.
* Alignment.
* Ordering requirements.
* Lifetime.

Do not expose raw MMIO pointers to unrelated code.

Do not use normal-memory assumptions for device memory.

`15-unsafe.md` owns unsafe access.

## Registers

Represent registers according to the hardware specification.

For register access:

* Use explicit widths.
* Preserve reserved bits.
* Define read and write semantics.
* Respect ordering requirements.
* Keep register constants near their owner.

Do not copy unexplained register values across modules.

Do not use a magic number when the specification defines the field.

## Interrupts

A driver that receives interrupts defines:

* Interrupt source.
* Ownership.
* Acknowledgment.
* Masking.
* Wake-up behavior.
* Deferred work.
* Failure behavior.

Keep interrupt-context work minimal.

Do not perform arbitrary device or service work inside an interrupt handler.

Transfer work to the owning execution context when practical.

## DMA

Treat DMA as explicit device authority over memory.

For each DMA mapping, define:

* Device.
* Buffer owner.
* Physical constraints.
* Direction.
* Lifetime.
* CPU visibility.
* Device visibility.
* Cache-coherency requirements.
* IOMMU mapping when available.

Prefer IOMMU isolation when hardware supports it.

Do not give a device access to unrelated physical memory.

Do not reuse a DMA buffer until the device contract returns ownership.

## IOMMU

When an IOMMU exists:

* Use the narrowest practical mapping.
* Keep mappings device-specific or domain-specific.
* Remove mappings when authority ends.
* Preserve DMA lifetime ordering.

Do not map all physical memory only to simplify driver implementation.

When hardware lacks an IOMMU, record the larger trust boundary.

## Firmware

Firmware outside Nod is externally trusted.

Examples can include:

* Platform firmware.
* Device firmware.
* Raspberry Pi firmware.
* Storage-controller firmware.
* Network-controller firmware.

For each required firmware boundary:

* Document it.
* Define the interface Nod depends on.
* Keep assumptions minimal.
* Avoid depending on undocumented behavior when a specification exists.

Do not call firmware first-party Nod code.

`06-dependencies.md` owns external trust dependency policy.

## Hardware Specifications

Prefer authoritative sources:

```text
architecture manual
device specification
bus specification
vendor programming manual
standards document
```

When the specification and observed hardware differ:

* Record the discrepancy.
* Reproduce it.
* Keep the workaround narrow.
* Do not generalize from one device revision without evidence.

Use `investigate` when behavior is unclear.

## Hardware Quirks

Keep quirks explicit.

A quirk identifies:

* Affected hardware.
* Required condition.
* Required workaround.
* Source or evidence.
* Scope.

Do not hide a hardware quirk inside generic logic.

Do not apply a quirk to unaffected hardware.

## Machine Specialization

A specialized machine image can include only drivers required by that machine and its supported expansion policy.

For a known machine profile:

* Include required buses.
* Include required drivers.
* Include required firmware interfaces.
* Exclude unrelated device implementations when safe to do so.

Do not remove runtime discovery when the machine supports hardware that can change dynamically.

Machine specialization must not change the native device-class contract.

## Hot-Plug

For hot-pluggable hardware, define:

* Discovery.
* Driver binding.
* Resource allocation.
* Capability publication.
* Removal.
* In-flight operation behavior.
* Cleanup.

Do not assume that a discovered device remains present forever.

Forced removal must leave system-owned state valid.

## Driver Binding

Binding selects a driver from explicit compatibility information.

Relevant inputs can include:

* Bus type.
* Vendor ID.
* Device ID.
* Class.
* Revision.
* Firmware interface.
* Declared driver compatibility.

Do not bind by human-readable name.

Do not let an untrusted driver claim unrelated hardware authority.

## Driver Replacement

A driver implementation is replaceable.

A replacement can become preferred when it demonstrates better applicable properties such as:

* Correctness.
* Safety.
* Performance.
* Memory use.
* Failure isolation.
* Maintainability.
* Hardware coverage.

The device-class contract remains stable when possible.

Use `investigate` to promote a proven implementation preference into the owning rule.

## Foreign Driver Compatibility

A compatibility subsystem can support a foreign driver model when required.

Keep it isolated.

Translate:

```text
foreign driver contract
    -> compatibility boundary
    -> Nod device-class contract
```

Do not allow a foreign driver ABI to become Nod's native driver ABI.

Do not grant foreign drivers broader authority than native drivers require.

## Failure

On driver failure:

* Preserve system-owned state.
* Revoke or recover device authority.
* Resolve in-flight operations.
* Reset the device when supported and required.
* Restart the driver when the contract permits it.
* Escalate only when the affected hardware is required for system integrity.

Do not turn an isolated peripheral failure into a kernel failure without necessity.

`11-errors-and-failure.md` owns failure policy.

## Evidence

When choosing a driver architecture or hardware path, measure applicable properties such as:

* Interrupt latency.
* Completion latency.
* IPC cost.
* DMA setup cost.
* Queue throughput.
* CPU use.
* Memory use.
* Restart cost.
* Context-switch cost.
* Isolation overhead.

Do not move a driver into the kernel for performance without evidence that the userspace boundary is the material limitation.
