---
name: compatibility
description: "Establish reproducible observable behavior at one explicit Nod compatibility boundary. Produces compatibility evidence; does not choose Nod architecture, implement production code, or measure performance."
---

# Compatibility

Use `/compatibility` when Nod needs to know exactly how an external system, ABI, format,
firmware interface, operating system, executable, protocol, or compatibility surface behaves.

This skill establishes **observable reference behavior**.

It does not decide that Nod should copy that behavior.

## Ownership

`/compatibility` owns:

* Reference-system selection for one compatibility question.
* Reference version, configuration, and environment capture.
* Controlled compatibility probes.
* Observable behavior capture.
* Difference classification.
* Reproducible compatibility evidence.

It does not own:

* Architecture or product decisions. Use `/investigate`.
* Implementation planning. Use `/plan-authoring`.
* Production-code changes. Use `/implement`.
* Performance measurement. Use `/benchmark`.
* Completion auditing. Use `/definition-of-done`.
* Pull-request readiness or merging.

## Start

Before running a compatibility probe:

* Read `AGENTS.md`.
* Read the applicable rules.
* Identify the explicit compatibility boundary.
* State one observable question.
* Identify the strongest reference for that question.
* Inspect existing compatibility evidence before creating a new probe.

Do not run a compatibility exercise when repository evidence already answers the question.

## Question

State one narrow question about externally observable behavior.

Examples:

```text
How does Linux expose this ELF relocation at the compatibility boundary?
What exact UEFI memory-map behavior must Nod accept?
What observable errno/result does a POSIX compatibility layer need here?
What bytes and alignment does this executable format require?
How does the reference system expose this device or firmware contract?
```

Do not turn `/compatibility` into a general architecture survey.

If the real question is:

> Which behavior should Nod adopt?

that decision belongs to `/investigate`.

## Reference

Prefer the strongest executable or normative reference available:

1. Hardware or protocol specification.
2. ABI or file-format specification.
3. Official reference implementation.
4. A pinned operating-system implementation.
5. A controlled executable probe.
6. Secondary documentation only when stronger evidence is unavailable.

Pin applicable details:

* Version or revision.
* Architecture.
* Machine.
* Configuration.
* Compiler/toolchain.
* Feature flags.
* Relevant environment.

A reference implementation is evidence, not authority over Nod's native design.

## Method

1. State the compatibility boundary and observable question.
2. Pin the reference and environment.
3. Define controlled input and initial state.
4. Run the minimum probe that answers the question.
5. Capture exact observable output and side effects.
6. Run Nod with equivalent semantics when a Nod implementation exists.
7. Classify the result.
8. Preserve enough evidence to reproduce the result.

When Nod does not yet implement the boundary, record the reference behavior without inventing a Nod result.

## Classification

Use one of:

```text
REFERENCE ESTABLISHED
MATCH
INTENTIONAL DIVERGENCE
UNSUPPORTED
REGRESSION
INCONCLUSIVE
```

Use `REFERENCE ESTABLISHED` when the probe exists to inform design before Nod implements the behavior.

Use `MATCH` only for the exact dimension tested.

Do not infer broad compatibility from one probe.

## Evidence

Record applicable evidence:

* Exact input.
* Exact output.
* Error/result class.
* Binary or wire representation.
* Observable state transition.
* Side effect.
* Reference version.
* Nod revision when compared.
* Architecture and machine.
* Commands or method.
* Limitations.

Preserve binary bytes, register values, command output, errors, and file-format data verbatim
when those bytes are the evidence.

Use Mermaid only for a multi-step comparison flow, normalization path, or lifecycle.
A diagram never replaces exact captured evidence.

## Performance Boundary

A compatibility probe may establish whether two systems perform equivalent work.

It must not measure or claim which one is faster.

Any latency, throughput, CPU, memory, cache, TLB, allocation, code-size, or energy question
belongs to `/benchmark`.

If an investigation needs both compatibility and performance evidence, keep the artifacts
separate and let `/investigate` combine their implications.

## Decision Boundary

Finding that Linux, Windows, macOS, Fuchsia, seL4, POSIX, UEFI, or another reference behaves
a certain way does not make that behavior a Nod requirement.

`/compatibility` ends with evidence.

`/investigate` decides whether Nod:

* adopts it,
* adapts it,
* exposes it only behind a compatibility boundary,
* or deliberately diverges.

## Artifact

When durable evidence is useful, write it at the path that `28-internal-artifacts.md`
declares for compatibility evidence.

Keep generated probe artifacts beside it only when they are required to reproduce the result.

## Closure

A compatibility run is complete when:

* The observable question is answered or explicitly inconclusive.
* The reference and environment are pinned.
* The evidence is reproducible.
* The tested compatibility dimension is named.
* Limitations are explicit.
* No architecture decision is smuggled into the result.
* No performance claim is made without `/benchmark`.
