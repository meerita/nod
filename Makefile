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

CARGO ?= cargo

# Fixed repository paths, not build inputs.

AGENT_SKILLS = .agents/skills
CLAUDE_SKILLS = .claude/skills

.PHONY: help build check fmt fmt-check lint test validate clean agents

help:
	@echo "build      compile the workspace"
	@echo "check      type-check the workspace without producing artifacts"
	@echo "fmt        format the workspace"
	@echo "fmt-check  fail when the workspace is not formatted"
	@echo "lint       run clippy over the workspace and its targets"
	@echo "test       run the workspace tests"
	@echo "validate   fmt-check, lint, and test"
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
