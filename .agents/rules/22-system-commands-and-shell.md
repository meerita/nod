---
name: 22-system-commands-and-shell
description: "Defines Nod command contracts, implementation resolution, naming, aliases, shell behavior, and official command replacement."
owns: "system commands; command contracts; command resolution; command naming; aliases; shell semantics"
see-also: [01-project-invariants.md, 07-security.md, 14-capabilities-and-resources.md, 21-processes-and-services.md]
---

# 22. System Commands and Shell

## Invariants

1. A command name is an interface, not a permanent binary.
2. Official implementations are replaceable.
3. Command resolution is explicit.
4. User overrides do not modify the system default.
5. Command contracts are versioned when compatibility requires it.
6. A replacement must satisfy the required command contract.
7. Official status is earned by current quality, not historical ownership.
8. Command names favor clarity over historical abbreviation.
9. Related commands use consistent semantic families.
10. Aliases provide brevity without defining the native command interface.
11. The shell does not depend on an opaque ordered `PATH` for native command resolution.
12. Command authority follows Nod capabilities.

## Command Contracts

A system command defines a contract.

A contract can define:

* Name.
* Version.
* Inputs.
* Outputs.
* Errors.
* Exit behavior.
* Capabilities.
* Side effects.
* Compatibility requirements.

Example:

```text
command: process list
contract: system.process.list.v1
implementation: nod-process@1.0
```

Do not identify a command only by executable path.

## Implementations

Multiple implementations can satisfy one contract.

Example:

```text
system.process.open-files.v1

implementations:
  nod-open-files@1.0
  kernq@2.4
```

The command registry selects the active implementation.

Do not make one implementation permanent because it was first.

## Official Implementation

The official implementation is the current project-selected default.

Selection can consider:

* Correctness.
* Safety.
* Performance.
* Memory use.
* Startup cost.
* Reliability.
* Maintainability.
* Binary size.
* Compatibility.
* Resource use.

Performance alone does not determine official status.

Use `investigate` when evidence can establish a better implementation.

When one implementation clearly dominates the existing official implementation for the required Nod contract, promote the proven preference into the owning rule or command metadata.

## Replacement

A replacement must:

* Satisfy the required contract.
* Pass required compatibility behavior.
* Preserve required error semantics.
* Preserve required authority boundaries.
* Meet required validation.
* Provide evidence for claimed improvements.

A replacement can become official without changing the user-facing command name.

Example:

```text
before:
open-files -> nod-open-files@1.0

after:
open-files -> kernq@2.4
```

The interface remains stable.

The implementation changes.

## Command Resolution

Resolve native commands through an explicit registry.

Prefer resolution scopes such as:

```text
workspace
-> user
-> system
```

The exact precedence is part of the shell contract.

Do not depend on arbitrary directory order for native command identity.

A resolution query must be inspectable.

Example:

```text
command resolve open-files

contract: system.process.open-files.v1
implementation: kernq@2.4
scope: user
official: no
```

## System Scope

System scope contains Nod-approved default bindings.

Example:

```text
process list -> nod-process@1.0
file show    -> nod-file@1.0
network list -> nod-network@1.0
```

System bindings can change through approved system updates.

A normal user override does not modify them.

## User Scope

A user can select another compatible implementation.

Example:

```text
use kernq as process open-files
```

The override applies only to the allowed user scope.

Do not require replacement of the system binary.

Do not require filesystem path manipulation to override a native command.

## Workspace Scope

A workspace can select command implementations when reproducible tooling requires it.

Workspace bindings must be explicit.

Do not silently inherit a workspace override from an unrelated parent directory.

Do not allow workspace command configuration to grant authority that the user does not possess.

## Naming

Prefer names that are:

* Clear.
* Predictable.
* Consistent.
* Discoverable.
* Readable without historical knowledge.

Avoid abbreviations whose meaning must be memorized.

Prefer:

```text
list
copy
move
remove
search
process
network
storage
system
command
```

over historical names when Nod owns the native interface.

Do not preserve a legacy name only because Unix used it.

## Command Families

Group related operations under semantic command families.

Prefer:

```text
process list
process inspect
process stop

network interfaces
network connections
network routes

storage list
storage usage

file copy
file move
file remove
```

over unrelated flat abbreviations.

Use consistent verbs across command families.

Do not invent a new verb when an existing Nod verb has the same meaning.

## Discoverability

The shell should make command discovery direct.

A command family can enumerate its operations.

Example:

```text
network <completion>

connections
interfaces
routes
status
```

Command help should derive from the command contract when practical.

Do not require external manual-page knowledge for basic command discovery.

## Aliases

Aliases are user convenience.

Examples:

```text
ls -> directory list
rm -> file remove
ps -> process list
```

Aliases do not define native Nod semantics.

Aliases can be:

* User-owned.
* Workspace-owned when permitted.
* Explicitly configured.

Do not make a historical alias the canonical command name.

## Options

Prefer readable option names.

Example:

```text
file remove ./build --recursive --force
```

Do not make single-letter flags the only native interface.

Short aliases can exist for frequent options when useful.

Keep long option names stable and descriptive.

## Inputs and Outputs

Prefer typed system interfaces underneath commands.

The shell can render those results for humans.

Conceptually:

```text
command
-> typed system operation
-> typed result
-> shell rendering
```

Do not make parsing human-readable command output the required native interface between Nod components.

Human output is presentation.

System contracts are typed.

## Pipelines

Pipelines should preserve composability.

Do not require every native command to communicate only through untyped byte streams.

Nod can support:

* Byte streams.
* Typed streams.
* Resource references.

Keep text pipelines available for interoperability and direct human use.

Do not force structured system data through text when a typed path exists.

## Exit Results

A command result distinguishes:

* Success.
* Contract error.
* Usage error.
* Resource failure.
* Interrupted execution.

Do not encode all failure meaning in one numeric status when the native shell can preserve typed error information.

Compatibility shells can translate results into traditional exit codes.

## Authority

A command receives only authority available to its caller.

Command registration does not grant resource authority.

A replacement implementation does not gain more authority than the command contract requires.

Do not treat an official system command as implicitly omnipotent.

`14-capabilities-and-resources.md` owns authority semantics.

## External Commands

User-installed commands are separate from Nod system commands.

An external command can:

* Define a new command.
* Implement an existing compatible contract.
* Request a user-level binding.
* Provide aliases.

Installing an application does not replace a system binding without an explicit selection.

## Compatibility

A compatibility environment can expose historical commands such as:

```text
ls
cp
mv
rm
ps
lsof
grep
```

Translate these at the compatibility boundary.

Do not let legacy command names define Nod's native command vocabulary.

## Evidence

When replacing an official implementation, preserve evidence for applicable properties such as:

* Correctness.
* Compatibility.
* Latency.
* Throughput.
* CPU use.
* Memory use.
* Startup time.
* Binary size.
* Failure behavior.

Use `investigate` to promote a proven implementation into the official preference.
