---
name: 24-compatibility
description: "Defines how Nod supports foreign APIs, filesystems, ABIs, commands, drivers, and application behavior without allowing compatibility to define native architecture."
owns: "compatibility boundaries; foreign API translation; legacy behavior; compatibility isolation"
see-also: [01-project-invariants.md, 14-capabilities-and-resources.md, 18-drivers-and-hardware.md, 19-filesystems-and-storage.md, 20-networking.md, 21-processes-and-services.md, 22-system-commands-and-shell.md]
---

# 24. Compatibility

## Invariants

1. Compatibility exists at explicit boundaries.
2. Native Nod semantics are not defined by foreign systems.
3. Compatibility adapters translate into Nod-owned types.
4. Foreign representations do not cross native ownership boundaries.
5. Compatibility does not grant broader authority.
6. Compatibility behavior is isolated from native behavior.
7. Compatibility can be removed without changing native contracts.
8. Compatibility cost is paid only when compatibility is used.
9. Compatibility limitations are explicit.
10. Nod does not preserve historical behavior without a compatibility requirement.

## Boundary Model

Prefer:

```text
foreign interface
-> compatibility adapter
-> Nod contract
-> Nod implementation
```

Do not implement:

```text
Nod internals
-> foreign semantics everywhere
```

Translate at the edge.

Keep the native system unaware of foreign representations when practical.

## Foreign APIs

A compatibility API can emulate:

* POSIX.
* BSD sockets.
* Unix process behavior.
* Foreign command interfaces.
* Foreign filesystem semantics.
* Foreign device interfaces.
* Foreign executable ABIs.

The adapter owns:

* Input translation.
* Output translation.
* Error translation.
* Lifetime translation.
* Authority translation.
* Unsupported behavior.

Do not let foreign API types become native Nod types.

## Semantic Translation

Translate semantics, not only structure.

When a foreign concept does not map exactly to Nod:

* Define the closest correct behavior.
* Expose unsupported behavior.
* Preserve safety.
* Preserve authority boundaries.
* Avoid stronger guarantees than Nod can provide.

Do not silently approximate behavior when correctness depends on the difference.

## POSIX

POSIX can exist as a compatibility environment.

Keep POSIX concepts at that boundary.

Examples:

```text
file descriptor
fork
exec
signal
uid
gid
mode bits
errno
```

Translate them into Nod resources, capabilities, process operations, and errors.

Do not make POSIX requirements constrain native Nod architecture.

## Process Compatibility

Foreign process behavior can expose:

```text
PID
fork
exec
signals
process groups
environment inheritance
```

Translate these into the Nod process model.

Do not require the native process model to preserve `fork()` semantics.

Do not grant authority because a foreign process model expects identity-based privilege.

## Filesystem Compatibility

Foreign filesystems can expose:

* Foreign path rules.
* Foreign metadata.
* Foreign permissions.
* Foreign link semantics.
* Foreign timestamps.
* Foreign durability limitations.

Translate them into Nod filesystem resources.

Do not weaken the native Nod filesystem contract to match a foreign filesystem.

When the foreign filesystem cannot provide a native guarantee:

* Expose the limitation.
* Restrict the operation when required.
* Do not pretend the guarantee exists.

## Networking Compatibility

BSD sockets and similar interfaces remain adapters.

Translate:

```text
socket
-> Nod endpoint or connection

file descriptor
-> local compatibility handle

setsockopt
-> typed Nod operation where supported
```

Do not add native generic option bags only to support socket compatibility.

## Command Compatibility

Legacy command names can exist as aliases or compatibility commands.

Examples:

```text
ls
cp
mv
rm
ps
lsof
```

Map them to native command contracts when practical.

Do not make historical command names canonical Nod names.

`22-system-commands-and-shell.md` owns native command semantics.

## Driver Compatibility

A foreign driver subsystem can exist when it materially improves hardware coverage.

Keep it isolated.

Prefer:

```text
foreign driver
-> compatibility runtime
-> Nod device-class interface
```

Do not expose foreign kernel assumptions to native services.

Do not give foreign drivers unrestricted kernel authority only because their original platform did.

## Executable Compatibility

Foreign executable support can translate:

* Binary format.
* ABI.
* Syscalls.
* Runtime expectations.
* Process model.
* Filesystem expectations.

Keep the compatibility runtime separate from native execution semantics.

Do not make native Nod binaries depend on a foreign ABI.

## Error Translation

Translate foreign errors at the compatibility boundary.

Example:

```text
Nod NotFound
-> POSIX ENOENT
```

Do not propagate foreign numeric error codes through native Nod interfaces.

Keep richer Nod diagnostics when translation loses information.

## Authority Translation

A compatibility layer cannot create authority.

When a foreign API assumes broad ambient access:

* Check the caller's Nod capabilities.
* Grant only permitted access.
* Return the appropriate compatibility failure otherwise.

Do not emulate `root` by granting unrestricted Nod authority.

## Performance

Compatibility is allowed to cost more than native execution.

Do not compromise native architecture only to make a compatibility path faster.

Optimize compatibility when evidence shows that it matters.

Keep compatibility overhead measurable.

## Isolation

Prefer compatibility environments that can fail independently.

A compatibility subsystem should not:

* Own unrelated native state.
* Become required for native boot.
* Become required for native applications.
* Expand the kernel trust boundary without a demonstrated need.

Keep failure local.

## Versioning

Version compatibility contracts when external software depends on them.

For a compatibility change, define:

* Supported version.
* Translation behavior.
* Removed behavior.
* Migration when applicable.

Do not promise indefinite compatibility without an explicit project commitment.

## Unsupported Behavior

Unsupported behavior must fail explicitly.

Do not:

* Ignore the request.
* Return false success.
* Substitute weaker semantics silently.
* Corrupt native state to imitate foreign behavior.

Keep unsupported areas discoverable.

## Native Preference

Prefer native Nod interfaces for new software.

Compatibility exists for interoperability and migration.

It is not the preferred design surface.

Documentation for new Nod software should show native interfaces first.

## Evidence

Measure compatibility work when cost or correctness depends on it.

Applicable evidence includes:

* API coverage.
* Behavioral compatibility.
* Test-suite compatibility.
* Performance overhead.
* Memory overhead.
* Translation cost.
* Failure isolation.
* Authority preservation.

Use `investigate` when compatibility requires choosing between competing translation models.
