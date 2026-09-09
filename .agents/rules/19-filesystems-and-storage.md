---
name: 19-filesystems-and-storage
description: "Defines Nod filesystem identity, persistence, integrity, transactions, storage, deletion, and compatibility rules."
owns: "native filesystem semantics; storage layering; object identity; persistence; integrity; deletion; filesystem compatibility"
see-also: [11-errors-and-failure.md, 13-memory-management.md, 14-capabilities-and-resources.md, 18-drivers-and-hardware.md]
---

# 19. Filesystems and Storage

## Invariants

1. Paths are names.
2. Filesystem objects have stable identity.
3. Blocks are implementation details.
4. Renaming or moving an object does not change its identity.
5. Directories map names to objects.
6. Filesystem state changes support transactions.
7. Data and metadata have integrity protection.
8. The native filesystem uses copy-on-write.
9. Snapshots and reflinks are native operations.
10. Metadata is typed where practical.
11. Persistent operations define durability and recovery.
12. Deletion, destruction, and physical reclamation are separate operations.
13. Strong deletion uses cryptographic erasure.
14. Physical reclamation can occur asynchronously.
15. Native storage design targets SSD and NVMe first.
16. External filesystems are compatibility boundaries.
17. External filesystem semantics do not define native Nod semantics.

## Storage Layers

Keep these ownership boundaries separate:

```text
device
-> block service
-> filesystem
-> namespace
-> application-facing resource
```

A lower layer owns mechanism.

A higher layer owns semantics.

Do not put filesystem policy in a device driver.

Do not expose device command formats through filesystem interfaces.

## Object Identity

A filesystem object can own:

* Stable identity.
* Names.
* Data.
* Metadata.
* Capabilities.
* Version state.
* Storage references.

A name can change without changing object identity.

Example:

```text
/projects/nod/design.md
          |
          v
     object 7f31...
```

Do not use a path as persistent identity.

## Directories

A directory maps:

```text
name -> object
```

Directory operations define:

* Lookup.
* Insert.
* Remove.
* Rename.
* Enumeration.
* Atomicity.

Do not expose physical storage layout through directory semantics.

## Transactions

Transactions are a native filesystem primitive.

Use them when multiple changes must commit as one operation.

Example:

```text
transaction
  write object A
  rename object B
  remove object C
commit
```

A transaction defines:

* Initial state.
* Changes.
* Commit point.
* Failure state.
* Recovery state.

Do not expose partial committed state as success.

## Copy-on-Write

Use copy-on-write for native persistent updates.

CoW supports:

* Atomic updates.
* Crash consistency.
* Snapshots.
* Reflinks.
* Cheap version retention.

Keep CoW implementation details below the filesystem contract.

Do not expose physical sharing as shared logical identity.

## Snapshots

Snapshots are native filesystem state references.

Define:

* Creation.
* Lifetime.
* Visibility.
* Storage accounting.
* Deletion.
* Interaction with `purge`.
* Interaction with `destroy`.

A snapshot must not silently preserve content after a successful `destroy`.

## Reflinks

Reflinks create independent logical objects that can share physical content.

For shared extents:

* Preserve separate object identity.
* Use copy-on-write on mutation.
* Account for shared storage.
* Preserve integrity metadata.

Do not expose shared physical backing as shared authority.

## Integrity

Protect:

* Filesystem metadata.
* Object references.
* Persistent structure metadata.
* File data.

Use checksums or stronger integrity mechanisms as required by the data class.

Do not return known-corrupt data as valid.

Corruption must have explicit failure and recovery behavior.

## Metadata

Prefer typed metadata for native properties.

Applicable fields can include:

```text
content type
creation time
modification time
security policy
encryption policy
compression policy
origin
integrity state
application attributes
```

Keep system metadata separate from application metadata.

Design metadata for extension without requiring a new filesystem format for every new property.

## Content and Object Identity

Keep logical object identity separate from physical content identity.

Two objects can reference the same physical content:

```text
foo.iso ----+
            +--> content ABC
bar.iso ----+
```

The objects remain independent.

A content reference does not replace object identity.

## Encryption

Support encryption at narrow scopes.

Prefer scopes such as:

```text
filesystem
directory
object
```

Use narrow key ownership where it improves:

* Isolation.
* Key rotation.
* Secure deletion.
* Damage containment.

Do not expose raw keys outside their owning security boundary.

## Deletion

Nod distinguishes:

```text
remove
purge
destroy
```

### remove

`remove`:

* Removes the normal namespace reference.
* Releases logical ownership according to filesystem policy.
* Does not promise physical destruction.

### purge

`purge`:

* Removes retained filesystem history required by the operation.
* Removes relevant snapshots or versions.
* Preserves the object's security contract.

### destroy

`destroy`:

* Makes protected content cryptographically unrecoverable.
* Destroys the required encryption key material.
* Invalidates retained recoverable versions.
* Does not wait for physical block overwrite.

Do not describe `remove` as secure deletion.

## Cryptographic Erasure

Use cryptographic erasure for strong deletion.

Preferred model:

```text
destroy object key
-> content becomes cryptographically unrecoverable
-> physical blocks remain encrypted
-> storage reclaims blocks later
```

Do not use repeated overwrite as the normal secure-deletion mechanism.

Do not make strong deletion depend on SSD physical-cell behavior that Nod cannot control.

## Physical Reclamation

Keep these operations separate:

```text
namespace removal
cryptographic destruction
logical free
physical block reuse
device garbage collection
```

Physical reclamation can be asynchronous.

Do not hold a user-visible deletion operation open only to reclaim physical storage.

## SSD and NVMe

Design native storage for modern solid-state devices.

Account for:

* NVMe queues.
* Parallel I/O.
* Discard.
* Wear leveling.
* Internal remapping.
* Controller caches.
* Device garbage collection.
* Flush and durability boundaries.

Do not design native filesystem policy around mechanical-disk assumptions.

## Asynchronous I/O

Treat asynchronous completion as the native storage execution model.

Do not require a thread to block for each outstanding storage operation.

Keep synchronous APIs as higher-level convenience when needed.

Do not let synchronous compatibility semantics define the internal I/O model.

## Compression

Support compression as native storage policy.

Define:

* Scope.
* Algorithm.
* Random-access behavior.
* Interaction with CoW.
* Interaction with encryption.
* Accounting.

Do not force compression when it provides no useful benefit.

## Deduplication

Deduplication is optional.

Use it only when evidence justifies:

* CPU cost.
* Memory cost.
* Privacy implications.
* Fragmentation.
* Recovery complexity.

Do not require global deduplication for content sharing.

Reflinks already provide explicit sharing without global deduplication.

## Durability

A persistent operation states its durability level.

Applicable levels can include:

```text
memory-visible
filesystem-committed
device-submitted
durable-on-media
```

Do not report stronger durability than the complete storage path guarantees.

## Crash Consistency

For persistent structures, define:

* Valid pre-crash state.
* Commit boundary.
* Valid recovered state.
* Incomplete-write behavior.
* Corruption behavior.

Recovery must derive from valid persistent state.

Do not require applications to repair filesystem transaction semantics.

## External Filesystems

Support foreign filesystems through explicit adapters.

Relevant targets can include:

```text
FAT32
exFAT
ext4
NTFS
APFS
```

Translate:

```text
foreign filesystem semantics
-> compatibility adapter
-> Nod resources
```

Do not import foreign filesystem semantics into the native Nod model.

When exact translation is impossible:

* Preserve correctness.
* Expose the limitation.
* Do not invent stronger guarantees.

## Removable Storage

Use interoperable filesystems when portability is the primary requirement.

A removable device does not need to use the native Nod filesystem.

Example:

```text
system storage     -> Nod filesystem
portable storage   -> exFAT when interoperability requires it
```

## Evidence

Measure filesystem decisions that depend on cost.

Applicable measurements include:

* Read latency.
* Write latency.
* Transaction latency.
* Metadata latency.
* Snapshot cost.
* Reflink cost.
* Recovery time.
* Memory use.
* Write amplification.
* Space amplification.
* Reclamation latency.
* Destroy latency.
* Fragmentation.

Use `investigate` when evidence can replace an open choice with a durable project preference.
