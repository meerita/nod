---
name: benchmark
description: "Measure Nod performance with reproducible workloads, controlled comparisons, recorded environments, and evidence suitable for implementation and plan closure."
---

# Benchmark

Measure performance.

Do not optimize code unless the task explicitly includes implementation.

`42-performance.md` owns performance rules.

## Start

Before measurement:

* Read the applicable plan or task.
* Read `42-performance.md`.
* Identify the decision that the benchmark must support.
* Identify the required baseline.
* Inspect existing benchmarks.
* Inspect existing performance evidence.

Do not create a benchmark when existing evidence already answers the question.

## Question

Define one primary measurement question.

Examples:

```text
Does implementation B reduce scheduler handoff latency?
Does the new allocator reduce peak memory?
Does the fast path remove one allocation?
Does Nod boot with less resident memory than the baseline?
```

Do not start with a preferred result.

## Workload

Define:

* Operation.
* Input.
* Scale.
* Concurrency.
* Duration or sample count.
* Warm-up when required.
* Environment.

Keep compared workloads equivalent.

Change one material variable at a time when practical.

## Environment

Record relevant environment data.

Include applicable fields:

* Nod revision.
* Baseline revision.
* Architecture.
* CPU.
* Core count.
* Memory.
* Emulator and version.
* Physical machine.
* Compiler version.
* Build profile.
* Machine profile.
* Storage device.
* Network device.
* Relevant configuration.

Do not compare results from materially different environments without stating the difference.

## Baseline

Establish the baseline before evaluating a change.

A baseline can be:

* Current Nod behavior.
* Previous Nod revision.
* Alternative Nod implementation.
* Linux under equivalent resources.
* Hardware limit.
* Published result when direct reproduction is not possible.

Prefer a directly reproducible baseline.

Do not use an external result as if it were measured locally.

## Metrics

Measure only metrics relevant to the decision.

Examples:

* Latency.
* Throughput.
* CPU time.
* Instructions.
* Cycles.
* Allocations.
* Memory use.
* Cache behavior.
* Context switches.
* Boot time.
* Binary size.
* Energy use.

For latency, use distributions when relevant.

Prefer:

```text
median
p95
p99
maximum
```

Do not rely on an average when it hides material tail behavior.

## Execution

Before each comparison:

* Build the required revision.
* Confirm the required configuration.
* Reset mutable state when required.
* Confirm the workload.
* Record failures.

During measurement:

* Keep the environment stable.
* Avoid unrelated workloads.
* Use enough samples to expose variance.
* Preserve raw results when practical.

Do not discard valid runs because they contradict the expected result.

## Comparisons

Compare equivalent work.

Check:

* Same operation.
* Same input.
* Same resource limits.
* Same concurrency.
* Same correctness requirement.
* Same durability requirement.
* Same validation semantics.

Do not call a result faster when it performs less work.

Do not move cost outside the measured interval without reporting it.

## Noise

When results vary materially:

* Repeat the measurement.
* Quantify the variance.
* Look for environmental causes.
* Separate stable states when they exist.

Do not average distinct performance states into one misleading number.

Do not claim a regression or improvement inside measurement noise.

## Negative Results

Keep negative results.

Record when:

* An optimization has no effect.
* An optimization regresses performance.
* A presumed bottleneck is not a bottleneck.
* A result cannot be reproduced.
* The environment dominates the measurement.

A negative result can close an investigation.

## Evidence

Record enough evidence for another agent to audit the result.

Include:

* Question.
* Baseline.
* Workload.
* Environment.
* Commands or method.
* Raw or summarized result.
* Variance when relevant.
* Interpretation.
* Limitations.

When executed during implementation, attach the evidence to the phase execution record.

Do not make `definition-of-done` reproduce the benchmark.

## External Comparisons

For comparisons with another operating system or implementation:

* Match available hardware resources.
* Match workload semantics.
* State configuration differences.
* State features that cannot be made equivalent.

Do not tune Nod and leave the comparison target untuned when the claim requires a fair comparison.

Do not claim general superiority from one benchmark.

## Result

Conclude with one of:

```text
SUPPORTED
NOT SUPPORTED
INCONCLUSIVE
```

Use `SUPPORTED` when the evidence supports the tested claim.

Use `NOT SUPPORTED` when the evidence contradicts the tested claim.

Use `INCONCLUSIVE` when the evidence cannot distinguish the alternatives.

Report the result without changing the claim after seeing the data.
