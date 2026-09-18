# Nod repository entry point.
#
# `09-build-and-tooling.md` owns the entry point policy. Each target delegates
# to the tool that owns the implementation. Do not duplicate delegated logic
# here.
#
# Build inputs:
#
#   CARGO   The cargo binary that every target invokes.
#           Scope:    every target in this file.
#           Required: no.
#           Default:  cargo, resolved from PATH, which `rust-toolchain.toml`
#                     pins to the declared channel.
#   QEMU    The QEMU binary that the run target invokes.
#           Scope:    run.
#           Required: no.
#           Default:  qemu-system-aarch64, resolved from PATH.

CARGO ?= cargo
QEMU ?= qemu-system-aarch64

# Pinned QEMU inputs for the M0 first boot (`tmp/plans/01-m0-first-boot.md`
# phase 3). The release must match exactly; a mismatch fails before launch.
# QEMU 11.1.1 is the current stable release (2026-08-27).

QEMU_VERSION_REQ := 11.1.1
QEMU_MACHINE := virt-11.1
QEMU_CPU := cortex-a76

# Fixed repository paths, not build inputs.

AGENT_SKILLS = .agents/skills
CLAUDE_SKILLS = .claude/skills
KERNEL_ELF = target/aarch64-unknown-none/debug/nod-kernel
BOOT_LOG = build/m0-boot.log

.PHONY: help build check fmt fmt-check lint test validate clean agents run

help:
	@echo "build      compile the workspace"
	@echo "check      type-check the workspace without producing artifacts"
	@echo "fmt        format the workspace"
	@echo "fmt-check  fail when the workspace is not formatted"
	@echo "lint       run clippy over the workspace and its targets"
	@echo "test       run the workspace tests"
	@echo "validate   fmt-check, lint, and test"
	@echo "run        boot the M0 kernel under the pinned QEMU invocation"
	@echo "clean      remove build artifacts"
	@echo "agents     link the repository skills into the local Claude Code directory"

build:
	$(CARGO) build --workspace

check:
	$(CARGO) check --workspace

fmt:
	$(CARGO) fmt --all

fmt-check:
	$(CARGO) fmt --all -- --check

lint:
	$(CARGO) clippy --workspace --all-targets

test:
	$(CARGO) test --workspace

validate: fmt-check lint test

# M0 first boot under QEMU. Every machine input stays pinned on the command
# line; GIC/SMMU/highmem/PCI stay at QEMU defaults because M0 has no
# consumer for them. The accelerator is pinned to TCG because semihosting
# is TCG-only; without it an HVF-capable host would take a path where the
# boot console does not work. The semihosting console goes to BOOT_LOG
# through a file chardev, so the log holds guest bytes only and tool
# diagnostics stay on the terminal.

run: build
	set -eu; \
	command -v "$(QEMU)" >/dev/null 2>&1 || { echo "make run: QEMU binary '$(QEMU)' not found. Install QEMU $(QEMU_VERSION_REQ) from https://www.qemu.org/download/ and ensure qemu-system-aarch64 resolves from PATH." >&2; exit 1; }; \
	version="$$($(QEMU) --version 2>/dev/null | head -n 1)"; \
	case " $$version " in \
	*" version $(QEMU_VERSION_REQ) "*) ;; \
	*) echo "make run: QEMU version mismatch: expected $(QEMU_VERSION_REQ), got '$$version'. The check ran '$(QEMU) --version'. Install QEMU $(QEMU_VERSION_REQ) from https://www.qemu.org/download/." >&2; exit 1;; \
	esac; \
	mkdir -p build; \
	"$(QEMU)" -accel tcg -machine "$(QEMU_MACHINE),dtb-randomness=off" -cpu "$(QEMU_CPU)" -smp 1 -kernel "$(KERNEL_ELF)" -chardev file,id=semi,path="$(BOOT_LOG)" -semihosting-config enable=on,chardev=semi -display none; \
	echo "run: captured output in $(BOOT_LOG)"

clean:
	$(CARGO) clean

# Local agent-tool setup. `.agents/` owns every skill. This target only creates
# ignored symlinks under `.claude/skills/` so Claude Code reads the same files,
# and never writes a skill.

agents:
	@command -v ln >/dev/null 2>&1 || { echo "make agents: this host provides no ln" >&2; exit 1; }
	@test -d $(AGENT_SKILLS) || { echo "make agents: $(AGENT_SKILLS) does not exist" >&2; exit 1; }
	@mkdir -p $(CLAUDE_SKILLS)
	@for link in $(CLAUDE_SKILLS)/*; do \
		test -L "$$link" || continue; \
		test -e "$$link" || rm -- "$$link"; \
	done
	@for skill in $(AGENT_SKILLS)/*/; do \
		test -d "$$skill" || continue; \
		name=`basename "$$skill"`; \
		ln -sfn "../../$(AGENT_SKILLS)/$$name" "$(CLAUDE_SKILLS)/$$name" || exit 1; \
	done
	@echo "agents: linked `ls -1 $(CLAUDE_SKILLS) | wc -l | tr -d ' '` skills into $(CLAUDE_SKILLS)"
