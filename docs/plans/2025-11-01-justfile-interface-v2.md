# Justfile Interface v2 - Standard Contract

**Date:** 2025-11-01
**Status:** Approved

## Overview

Define a standard justfile interface that every project must implement. Each command has an exact comment string for validation, and all commands must be present (even if stubbed with `@echo "⚠️  <command> not implemented"`).

## Goals

1. **Predictable interface** - `just --list` shows same commands across all projects
2. **Validation** - Can programmatically verify justfile compliance
3. **Quality gates** - Clear separation between blocking checks and informational tools
4. **YAGNI** - Simple, focused commands without over-engineering

## Command Specifications

### Core Development

- `default` - Show all available commands via `@just --list`
- `dev-install` - Install dependencies and setup development environment
- `clean` - Remove generated files and artifacts

### Code Quality (Quality Gates)

- `format` - Format code (auto-fix, fastest check)
- `lint` - Lint code (auto-fix, complexity threshold=10, blocks on failure)
- `typecheck` - Type check code
- `test` - Run unit tests only (unmarked)
- `coverage` - Unit test coverage with 96% threshold (blocks on failure)
- `check-all` - Run all quality checks in fastest-first order: format → lint → typecheck → coverage

### Testing

- `test-watch` - Run tests in watch mode (unit tests)
- `integration-test` - Run integration tests (marked), coverage report but NO threshold

### Analysis (Informational)

- `complexity` - Detailed complexity report for refactoring decisions (informational)
- `loc N="20"` - Show N largest files by lines of code

### Dependencies & Security

- `deps` - Show outdated packages
- `vulns` - Check for security vulnerabilities (CVEs)
- `lic` - Analyze licenses (flag GPL, incompatible licenses)
- `sbom` - Generate software bill of materials

### Build

- `build` - Build artifacts (if applicable)

## Design Decisions

### Testing Philosophy

**Unit tests are the quality gate:**
- Unmarked tests = unit tests
- Run fast, high coverage (96%)
- Block merges if failing or below threshold

**Integration tests are exploratory:**
- Marked with `@pytest.mark.integration` (Python) or in `tests/integration/` (JS)
- Run slower, lower coverage expectations
- Generate coverage reports but don't block
- Never run in `check-all`

### Complexity Checking

**Two-tier approach:**
1. `lint` - Basic complexity (threshold=10) blocks on failure
2. `complexity` - Detailed report for refactoring decisions (informational)

This separates "quality gate" from "analytical tool".

### Dependency Analysis

**Separate commands for focused checks:**
- `deps` - Outdated packages (maintenance)
- `vulns` - Security vulnerabilities (critical)
- `lic` - License compliance (legal)

Keep each fast and focused rather than one slow comprehensive command.

### Check-All Ordering

**Fastest first for quick feedback:**
1. `format` - Fastest (whitespace/style)
2. `lint` - Fast (static analysis + complexity)
3. `typecheck` - Medium (type checking)
4. `coverage` - Slowest (run tests with coverage)

Fail fast on cheap checks before running expensive tests.

## Tool Matrix

### Python Stack

- Package management: `uv`
- Format/Lint: `ruff` (both formatting and linting)
- Type checking: `mypy`
- Testing: `pytest`
- Complexity: `radon`
- LOC: `pygount`
- Security: `pip-audit`
- Licenses: `pip-licenses`
- SBOM: `cyclonedx-py`

### JavaScript/TypeScript Stack

- Package management: `pnpm`
- Format: `prettier`
- Lint: `eslint`
- Type checking: `tsc`
- Testing: `vitest`
- Complexity: `@pnpm cyclomatic-complexity` or `madge`
- LOC: `cloc`
- Security: `pnpm audit`
- Licenses: `license-checker`
- SBOM: `@cyclonedx/cyclonedx-npm`

### Java Stack

- Build tool: `maven`
- Format: `spotless`
- Lint: `spotbugs`
- Type checking: `mvn compile`
- Testing: `junit5`
- Complexity: `pmd`
- LOC: `cloc`
- Security: `dependency-check-maven`
- SBOM: `cyclonedx-maven-plugin`

## Validation

Projects can be validated against this spec by checking:

1. All required commands exist
2. Comment strings match exactly
3. `check-all` has correct dependencies in correct order
4. Stub commands use standard message format

A `just validate-justfile` command in this repo will perform these checks.

## Migration from v1

**Breaking changes:**
- `dev` → `dev-install` (rename for clarity)
- Coverage threshold: 80% → 96%
- New commands: `vulns`, `lic` (split from `deps`)
- Complexity moved to `lint` (threshold) and `complexity` (report)
- `check-all` must run in specific order

**Compatible changes:**
- `integration-test` is new (optional implementation)
- All commands must be present (can be stubbed)
