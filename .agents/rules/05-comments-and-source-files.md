---
name: 05-comments-and-source-files
description: "Defines how Nod source files, source-code comments, module boundaries, and generated source are written and organized."
owns: "comment form; comment classes and budgets; source-file layout; local source boundaries"
see-also: [01-project-invariants.md, 04-writing-and-documentation.md, 15-unsafe.md]
---

# 05. Comments and Source Files

## Invariants

1. Comments explain non-obvious invariants, contracts, ordering, safety, hardware constraints, or measured tradeoffs.
2. Comments do not restate obvious code.
3. Inline comments are minimal, non existant if possible.
4. One line is the normal inline-comment budget.
5. Three lines is the inline-comment limit.
6. Prose that exceeds the inline budget moves to a doc comment or to `docs/`.
7. A doc comment describes the contract, not the implementation.
8. Every unsafe block has a `SAFETY:` comment.
9. Source files keep a consistent local layout.
10. Architecture-independent code does not depend on architecture-specific types.
11. Hardware access does not leak into unrelated system code.
12. A compatibility layer does not define native Nod semantics.
13. A hot-path optimization names the measurement that justifies it.
14. Generated source remains inspectable and reproducible.
15. Comments and rustdoc use the project voice from `04-writing-and-documentation.md`.
16. No decorations, no emojis, no special characters to decorate.
17. No AI prose. Stick to the project voice.

## Comment Classes

Use four comment classes:

| Class      | Marker       | Purpose                                              | Budget                                    |
| ---------- | ------------ | ---------------------------------------------------- | ----------------------------------------- |
| module doc | `//!`        | State what the module owns and what it does not own. | Short paragraph.                          |
| item doc   | `///`        | State the public contract.                           | Contract, errors, and caller obligations. |
| inline     | `//`         | Explain why the code is not the obvious code.        | One line. Three lines maximum.            |
| safety     | `// SAFETY:` | Explain why an unsafe operation is sound.            | As long as the safety argument requires.  |

`15-unsafe.md` owns the `SAFETY:` class.

Do not shorten a safety argument to meet a comment budget.

## Inline Comments

An inline comment states one fact that the code cannot state.

Use an inline comment for:

* A hardware ordering requirement.
* A memory-ordering requirement.
* A register field with non-obvious semantics.
* A bounds check required by an external format.
* A capability or ownership assumption.
* A scheduler ordering constraint.
* A lifetime requirement around borrowed memory.
* An interrupt or concurrency invariant.
* A protocol or filesystem format constraint.
* A measured hot-path tradeoff.
* A compatibility exception.

When an explanation grows, move it:

```text
caller contract                     -> item doc
module ownership                    -> module doc
architecture or lifecycle           -> docs/
measured tradeoff                   -> benchmark or research artifact
design decision                     -> investigation or architecture document
unresolved question                 -> gap record
```

Prefer a reference to the owning document over duplicated prose.

## Do Not Write These Comments

Do not write:

```text
narration of the next line
step numbering for direct code
restatement of a variable or type name
explanation of basic Rust syntax
summary of the function below or above
history of a previous implementation
unused alternative designs
notes addressed to the reader
hedges such as "probably" or "should be fine"
ASCII section banners
commented-out code kept for later
TODO comments without an owned gap or task
```

Bad:

```rust
// Increment the index.
index += 1;

// Create a new queue.
let queue = Queue::new();
```

Good:

```rust
// Release publishes the descriptor before the consumer observes the tail.
tail.store(next, Ordering::Release);
```

## Module Documentation

A module doc states:

* What the module owns.
* What the module does not own.
* Its external boundary.
* Its important invariants when they are not obvious.

Do not use a module doc as a file history or implementation walkthrough.

Example:

```rust
//! Owns translation between PCI discovery data and Nod device resources.
//!
//! This module does not own driver lifecycle or device-class policy.
```

## Item Documentation

Document a public item when a caller needs to know:

* Preconditions.
* Postconditions.
* Ownership transfer.
* Capability requirements.
* Error behavior.
* Blocking behavior.
* Allocation behavior when relevant.
* Safety requirements.
* Lifetime constraints that the type system does not make obvious.

Do not document a function only because it is public.

## Source-File Layout

Keep a consistent local order when the file structure allows it:

```text
module documentation
imports
constants
types
public implementation
private implementation
tests
```

Do not create section banners to enforce the layout.

Split a file when it owns more than one clear concern.

Do not split a file only to reduce its line count.

## Source Boundaries

Keep these concerns separate when they exist:

```text
architecture-specific code
hardware abstraction
memory management
scheduler
IPC
capabilities
device discovery
drivers
filesystem
networking
system services
command interfaces
compatibility adapters
```

Translate external representations at the owning boundary.

Examples:

```text
hardware register layout -> architecture or driver-owned type
wire representation      -> protocol-owned type
filesystem encoding      -> filesystem-owned type
compatibility ABI        -> native Nod type
```

Do not let an external representation become Nod's internal semantic model.

## Architecture-Specific Source

Architecture-specific code belongs under an explicit architecture boundary.

Architecture-independent code must not:

* Import architecture-specific register types.
* Depend on fixed physical addresses.
* Depend on interrupt-controller details.
* Depend on a specific boot protocol.
* Depend on a specific machine profile without an abstraction that owns it.

A generic abstraction must exist because two real implementations need it or because an architectural boundary requires it.

Do not create speculative portability abstractions.

## Hardware Source

Keep hardware constants near the code that owns the hardware interface.

For hardware-defined values:

* Use the name from the specification when practical.
* Cite the specification when the value is not self-evident.
* Do not copy unexplained magic numbers across files.
* Keep volatile and MMIO access behind a narrow interface.

Hardware code states the hardware contract.

It does not define higher-level system policy.

## Generated Source

Generated source must have:

* A deterministic input.
* A reproducible generator.
* A clear generated-file marker.
* An inspectable output.

Do not hand-edit generated source.

When generated source is committed, the repository must also contain the source and process that reproduce it.

Do not use generation to hide code that would otherwise violate project rules.

## Diagrams in Source

Do not put Mermaid diagrams in comments or rustdoc.

Use plain text only when alignment is part of the technical content.

Acceptable examples:

```text
63                     32 31                      0
+------------------------+-------------------------+
|        address         |          flags          |
+------------------------+-------------------------+
```

Put architectural diagrams in the document that owns the architecture.

## Performance Comments

A performance comment states a measured constraint, not an intuition.

Prefer:

```rust
// One allocation increased p99 by 11%; keep this path allocation-free.
```

Avoid:

```rust
// Faster this way.
```

Keep detailed measurements in the benchmark or research artifact.

The source comment keeps only the invariant required to preserve the result.
