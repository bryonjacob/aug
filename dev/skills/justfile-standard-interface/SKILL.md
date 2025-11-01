---
name: justfile-standard-interface
description: Standard justfile interface - all projects implement these commands with exact comment strings
---

# Justfile Standard Interface

All projects implement this interface. Commands must have exact comment strings. Stub unimplemented commands with `@echo "⚠️  <command> not implemented"`.

## Standard Interface

```just
set shell := ["bash", "-uc"]

# Show all available commands
default:
    @just --list

# Install dependencies and setup development environment
dev-install:
    <install deps, create venvs, download tools>

# Format code (auto-fix)
format:
    <auto-fix whitespace/style, fastest check>

# Lint code (auto-fix, complexity threshold=10)
lint:
    <auto-fix linting, complexity=10 blocks>

# Type check code
typecheck:
    <static type checking, no auto-fix>

# Run unit tests
test:
    <unit tests only (unmarked/untagged), fast>

# Run tests in watch mode
test-watch:
    <continuous test execution on file changes>

# Run unit tests with coverage threshold (96%)
coverage:
    <unit tests with 96% threshold, blocks if below>

# Run integration tests with coverage report (no threshold)
integration-test:
    <integration tests (marked/tagged), report only, never blocks>

# Detailed complexity report for refactoring decisions
complexity:
    <per-function/class complexity, informational, does not block>

# Show N largest files by lines of code
loc N="20":
    <show N largest files by LOC, sorted descending>

# Show outdated packages
deps:
    <list packages with newer versions>

# Check for security vulnerabilities
vulns:
    <scan/audit for known CVEs>

# Analyze licenses (flag GPL, etc.)
lic:
    <flag GPL/LGPL, legal compliance>

# Generate software bill of materials
sbom:
    <generate SBOM in CycloneDX format>

# Build artifacts
build:
    <build distributable artifacts (wheels/jars/bundles)>

# Run all quality checks (format, lint, typecheck, coverage - fastest first)
check-all: format lint typecheck coverage
    @echo "✅ All checks passed"

# Remove generated files and artifacts
clean:
    <remove build artifacts, caches, generated files>
```

## Key Rules

**Testing:**
- Unit tests (unmarked) = quality gate, 96% coverage, blocks merges
- Integration tests (marked) = exploratory, no threshold, never in check-all

**Complexity:**
- Basic in `lint` (threshold=10, blocks)
- Detailed in `complexity` (report only)

**check-all order:**
format → lint → typecheck → coverage (fastest first, fail fast)

**All commands present:**
Stub if not applicable. Exact comment strings required for validation.

## Validation

```bash
bash scripts/validate-justfile.sh path/to/justfile
```

Checks: all commands present, comments match, check-all dependencies correct.

## Implementation

See stack skills for tool-specific implementations:
- **configuring-python-stack** - uv, ruff, mypy, pytest
- **configuring-javascript-stack** - pnpm, prettier, eslint, vitest
- **configuring-java-stack** - maven, spotless, spotbugs, junit5
- **configuring-polyglot-stack** - multi-language orchestration (root + subprojects)
