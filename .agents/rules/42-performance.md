---
name: 42-performance
description: "Defines performance measurement and optimization rules for Nod."
owns: "benchmarks; performance claims; optimization evidence"
see-also: [01-project-invariants.md, 40-testing.md]
---

# Performance

Before optimization:

* Measure current behavior.
* Record a baseline.
* Define the metric.
* Define the workload.

For benchmarks:

* Make them reproducible.
* Keep inputs explicit.
* Keep environments explicit.
* Compare equivalent workloads.
* Report variance when relevant.

For performance claims:

* Support them with data.
* State the tested environment.
* State the tested version.
* State important limits.

Do not accept an optimization that:

* Breaks correctness.
* Breaks safety.
* Hides work.
* Moves cost outside the measured path.
* Makes the result non-reproducible.

Prefer:

* Lower latency.
* Lower memory use.
* Lower CPU use.
* Lower allocation.
* Predictable behavior.
