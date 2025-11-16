# Aug-Just: Justfile Standard Interface

Justfile standard interface management with maturity model assessment and upgrade paths.

## Features

### Standard Interface (Level 0)
Every project implements baseline commands with exact comment strings:
- `dev-install`, `format`, `lint`, `typecheck`, `test`, `coverage`, `check-all`, `clean`
- Stub unimplemented: `@echo "⚠️ not implemented"`

### Maturity Model
Progress from baseline to advanced capabilities:
- **Level 0**: Baseline (all projects)
- **Level 1**: Quality gates (test-watch, integration-test, complexity)
- **Level 2**: Security (vulns, lic, sbom, doctor)
- **Level 3**: Advanced (test-smart, deploy, migrate)
- **Level 4**: Polyglot (multi-language orchestration)

### Commands

```bash
# Install baseline interface
/just-init python
/just-init javascript
/just-init polyglot

# Assess current justfile
/just-assess
# Output: Level 1 (7/10 baseline, missing: integration-test, complexity, loc)

# Fix existing justfile
/just-refactor
# Adds missing commands, fixes comments, preserves implementations

# Upgrade capabilities
/just-upgrade 2              # Add level 2 (security)
/just-upgrade test-smart     # Add specific pattern
/just-upgrade deploy         # Add deployment commands
```

## Installation

```bash
# Add marketplace
/plugin marketplace add /path/to/aug

# Install plugin
/plugin install aug-just@aug
```

## Workflow

### New Project
```bash
/just-init python
# Generates justfile with baseline
just dev-install
just check-all
```

### Existing Project
```bash
/just-assess
# Shows: Level 0 (missing integration-test, wrong comments on lint)

/just-refactor
# Fixes: Added integration-test stub, fixed lint comment

/just-assess
# Shows: Level 0 complete, ready for level 1

/just-upgrade 1
# Adds: test-watch, proper integration-test, complexity, loc
```

### Production System
```bash
/just-assess
# Shows: Level 1 complete

/just-upgrade 2
# Adds security: vulns, lic, sbom, doctor

/just-upgrade deploy
# Adds deployment: deploy, logs, status
```

## Maturity Levels

**Level 0: Baseline** - EVERY project
- Standard commands (format, lint, test, etc.)
- `check-all` quality gate
- Exact comment strings

**Level 1: Quality Gates** - When CI matters
- test-watch for development
- integration-test separation
- complexity reporting
- loc analysis

**Level 2: Security** - When deploying
- Multi-tier vulnerability scanning
- License compliance (prod vs dev)
- SBOM generation
- Environment health checks (doctor)

**Level 3: Advanced** - Production systems
- Git-aware testing (test-smart)
- Deployment integration
- Migration management
- Service logs and status

**Level 4: Polyglot** - Multi-language projects
- Root orchestration justfile
- Per-subproject full interface
- Cross-project commands

## Skills

- **justfile-interface** - Baseline specification
- **justfile-maturity-model** - Assessment and progression
- **justfile-quality-patterns** - Level 1 patterns
- **justfile-security-patterns** - Level 2 patterns
- **justfile-advanced-patterns** - Level 3 patterns
- **justfile-polyglot-patterns** - Level 4 patterns

## Example: Python Project

```bash
/just-init python
```

Generates:
```just
set shell := ["bash", "-uc"]

# Show all available commands
default:
    @just --list

# Install dependencies and setup development environment
dev-install:
    uv sync --all-extras

# Format code (auto-fix)
format:
    uv run ruff format .
    uv run ruff check --fix .

# Lint code (auto-fix, complexity threshold=10)
lint:
    uv run ruff check . --select C90 --config "lint.mccabe.max-complexity=10"

# Type check code
typecheck:
    uv run mypy .

# Run unit tests
test:
    uv run pytest -v -m "not integration" --durations=10

# Run unit tests with coverage threshold (96%)
coverage:
    uv run pytest -m "not integration" --cov=app --cov-fail-under=96

# Run all quality checks
check-all: format lint typecheck coverage
    @echo "✅ All checks passed"

# Remove generated files
clean:
    rm -rf .venv __pycache__ .pytest_cache .coverage htmlcov
```

## Documentation

See `CLAUDE.md` for architecture and implementation details.

## Version

3.0.0 - Initial release with maturity model
