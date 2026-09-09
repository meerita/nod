# Nod repository entry point.
#
# `09-build-and-tooling.md` owns the entry point policy. Each target delegates
# to the tool that owns the implementation. Do not duplicate delegated logic
# here.

CARGO ?= cargo

.PHONY: help build check fmt fmt-check lint test validate clean

help:
	@echo "build      compile the workspace"
	@echo "check      type-check the workspace without producing artifacts"
	@echo "fmt        format the workspace"
	@echo "fmt-check  fail when the workspace is not formatted"
	@echo "lint       run clippy over the workspace and its targets"
	@echo "test       run the workspace tests"
	@echo "validate   fmt-check, lint, and test"
	@echo "clean      remove build artifacts"

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
