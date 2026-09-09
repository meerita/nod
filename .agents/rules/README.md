# Rules

Each rule owns one constraint.

Do not duplicate rules.

Read:

* `00-agent-behavior.md` for agent behavior and tool attribution.
* `01-project-invariants.md` for project-wide invariants.
* `02-git-and-branching.md` for Git, branch, commit, and pull request rules.
* `03-surfacing-gaps.md` for gaps, unknowns, and incomplete work.
* `04-writing-and-documentation.md` for writing style and terminology.
* `05-comments-and-source-files.md` for comment form and source-file layout.
* `06-dependencies.md` for third-party dependencies and supply chain.
* `07-security.md` for trust boundaries, privilege, and isolation.
* `08-executable-plans.md` for plan invariants and completeness.
* `09-build-and-tooling.md` for build entry points, toolchain, and reproducibility.
* `10-rust.md` for Rust language use and code style.
* `11-errors-and-failure.md` for error semantics and failure propagation.
* `12-concurrency-and-synchronization.md` for the concurrency model and ordering.
* `13-memory-management.md` for memory ownership, allocation, and reclamation.
* `14-capabilities-and-resources.md` for resource identity, capabilities, and authority.
* `15-unsafe.md` for unsafe Rust and safety justification.
* `16-ipc-and-messaging.md` for IPC semantics, message ownership, and delivery.
* `17-scheduling-and-execution.md` for scheduler semantics and CPU placement.
* `18-drivers-and-hardware.md` for hardware discovery, drivers, and firmware boundaries.
* `19-filesystems-and-storage.md` for filesystem semantics, persistence, and integrity.
* `20-networking.md` for the network stack, packet ownership, and transport semantics.
* `21-processes-and-services.md` for the process and service model.
* `22-system-commands-and-shell.md` for system commands and shell semantics.
* `23-boot-and-machine-specialization.md` for boot flow and machine profiles.
* `24-compatibility.md` for compatibility boundaries and foreign API translation.
* `25-observability-and-diagnostics.md` for observability, metrics, tracing, and logs.
* `26-time-and-timers.md` for clock semantics, timers, and deadlines.
* `27-architecture-and-hal.md` for the architecture and HAL research direction.
* `28-internal-artifacts.md` for the internal artifact corpus.
* `29-public-documentation.md` for public documentation architecture.
* `40-testing.md` for test scope and regression coverage.
* `42-performance.md` for benchmarks and performance claims.

Add a new rule only when no existing rule owns the constraint.
