---
name: creating-justfiles
description: Use when creating justfile for a new project or adding standard commands - provides templates for Python, JavaScript, Java, and polyglot projects with required commands (dev, format, lint, test, check-all, clean)
---

# Creating Justfiles

## Overview

Every project needs these standard commands:
- `dev` - Install dependencies
- `format` - Format code
- `lint` - Lint code
- `typecheck` - Type checking
- `test` - Run tests
- `test-watch` - Watch mode
- `coverage` - Coverage report
- `check-all` - All quality checks
- `clean` - Remove generated files

## Quick Reference

**Basic structure:**
```just
set shell := ["bash", "-uc"]

default:
    @just --list

dev:
    # Install dependencies

format:
    # Format code

lint:
    # Lint code

typecheck:
    # Type check

test:
    # Run tests

check-all: format lint typecheck test
    @echo "✅ All checks passed"

clean:
    # Remove generated files
```

## Python Project Template

**Use `uv run` for all commands to auto-activate venv:**

```just
set shell := ["bash", "-uc"]

default:
    @just --list

# Install dependencies
dev:
    uv venv .venv
    uv pip install -e ".[dev]"

# Format code with ruff
format:
    uv run ruff format .

# Lint code with ruff
lint:
    uv run ruff check .

# Type check with mypy
typecheck:
    uv run mypy src

# Run tests
test:
    uv run pytest --durations=10

# Run tests in watch mode
test-watch:
    uv run pytest-watcher --now --clear . -- --durations=10

# Run tests with coverage
coverage:
    uv run pytest --cov=src --cov-report=term-missing --cov-report=html --cov-fail-under=80 --durations=10

# Check code complexity
complexity:
    uv run radon cc src -a -nb

# Count lines of code (largest files first)
loc N="20":
    @echo "📊 Lines of code by file (largest first, showing {{N}}):"
    @uv run pygount --format=sloccount src/ | sort -rn | head -{{N}}

# Run all quality checks
check-all: format lint typecheck coverage
    @echo "✅ All checks passed"

# Clean generated files
clean:
    rm -rf .venv __pycache__ .pytest_cache .mypy_cache .coverage htmlcov dist build
    find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
    find . -type f -name "*.pyc" -delete
```

## JavaScript/TypeScript Project Template

```just
set shell := ["bash", "-uc"]

default:
    @just --list

# Install dependencies
dev:
    pnpm install

# Format code with prettier
format:
    pnpm prettier --write .

# Lint code with eslint
lint:
    pnpm eslint .

# Type check with tsc
typecheck:
    pnpm tsc --noEmit

# Run tests
test:
    pnpm vitest run --reporter=verbose

# Run tests in watch mode
test-watch:
    pnpm vitest

# Run tests with coverage
coverage:
    pnpm vitest run --coverage

# Check complexity
complexity:
    pnpm ts-complex src/**/*.ts

# Count lines of code (largest files first)
loc N="20":
    @echo "📊 Lines of code by file (largest first, showing {{N}}):"
    @pnpm cloc src/ --by-file --include-lang=TypeScript --quiet | sort -rn | head -{{N}}

# Build project
build:
    pnpm tsc

# Run all quality checks
check-all: format lint typecheck coverage
    @echo "✅ All checks passed"

# Clean generated files
clean:
    rm -rf node_modules dist coverage .vitest
```

## Java Project Template

```just
set shell := ["bash", "-uc"]

default:
    @just --list

# Install dependencies
dev:
    mvn clean install -DskipTests

# Format code with Spotless
format:
    mvn spotless:apply

# Lint code with SpotBugs
lint:
    mvn spotbugs:check

# Type check (compile)
typecheck:
    mvn clean compile

# Run tests
test:
    mvn test

# Run tests in watch mode
test-watch:
    mvn fizzed-watcher:run

# Run tests with coverage
coverage:
    mvn clean verify

# Check complexity (detailed analysis)
complexity:
    mvn pmd:pmd

# Count lines of code (largest files first)
loc N="20":
    @echo "📊 Lines of code by file (largest first, showing {{N}}):"
    @cloc src/ --by-file --include-lang=Java --quiet | sort -rn | head -{{N}}

# Build project
build:
    mvn clean package

# Run all quality checks
check-all: format lint typecheck coverage
    @echo "✅ All checks passed"

# Clean generated files
clean:
    mvn clean
```

## Polyglot Project Template

**For projects with multiple languages:**

```just
set shell := ["bash", "-uc"]

default:
    @just --list

# Install all dependencies
dev:
    @just dev-python
    @just dev-js

dev-python:
    cd api && uv venv .venv && uv pip install -e ".[dev]"

dev-js:
    cd web && pnpm install

# Format all code
format:
    @just format-python
    @just format-js

format-python:
    cd api && uv run ruff format .

format-js:
    cd web && pnpm prettier --write .

# Lint all code
lint:
    @just lint-python
    @just lint-js

lint-python:
    cd api && uv run ruff check .

lint-js:
    cd web && pnpm eslint .

# Type check all code
typecheck:
    @just typecheck-python
    @just typecheck-js

typecheck-python:
    cd api && uv run mypy src

typecheck-js:
    cd web && pnpm tsc --noEmit

# Run all tests
test:
    @just test-python
    @just test-js

test-python:
    cd api && uv run pytest --durations=10

test-js:
    cd web && pnpm vitest run

# Run tests in watch mode
test-watch:
    @echo "Run 'just test-watch-python' or 'just test-watch-js'"

test-watch-python:
    cd api && uv run pytest-watcher --now --clear . -- --durations=10

test-watch-js:
    cd web && pnpm vitest

# Run all tests with coverage
coverage:
    @just coverage-python
    @just coverage-js

coverage-python:
    cd api && uv run pytest --cov=src --cov-report=term-missing --cov-report=html --cov-fail-under=80 --durations=10

coverage-js:
    cd web && pnpm vitest run --coverage

# Run all quality checks
check-all: format lint typecheck coverage
    @echo "✅ All checks passed"

# Clean all generated files
clean:
    @just clean-python
    @just clean-js

clean-python:
    cd api && rm -rf .venv __pycache__ .pytest_cache .mypy_cache .coverage htmlcov

clean-js:
    cd web && rm -rf node_modules dist coverage .vitest
```

## Key Principles

**One verb per command:**
- `test` (not `test-unit`, `test-integration`)
- Simple is better

**Fail fast:**
- Commands exit with non-zero on failure
- CI and git hooks catch problems

**DRY with dependencies:**
```just
check-all: format lint typecheck coverage
```
Runs all four in order

**Consistent output:**
```just
check-all: format lint typecheck coverage
    @echo "✅ All checks passed"
```

**Cross-platform:**
- Use bash commands (Linux/macOS)
- Windows users: WSL or Git Bash

## Common Patterns

### With Confirmation

```just
# Deploy to production (requires confirmation)
deploy:
    @echo "⚠️  Deploy to production?"
    @read -p "Type 'yes' to continue: " confirm && [ "$$confirm" = "yes" ]
    ./deploy.sh
```

### With Environment Variables

```just
# Run with specific env
test-integration:
    ENV=test pytest tests/integration/
```

### Conditional Execution

```just
# Only format if files exist
format:
    @if [ -d "src" ]; then ruff format src; fi
    @if [ -d "tests" ]; then ruff format tests; fi
```

### Recipe with Parameters

```just
# Show N largest files (default: 20)
loc N="20":
    @uv run pygount --format=sloccount src/ | sort -rn | head -{{N}}
```

Usage: `just loc` or `just loc 50`

## Installation

Tell users to install just:

```bash
# macOS
brew install just

# Linux
cargo install just
# or
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/bin

# Windows
cargo install just
# or
scoop install just
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Too many commands | Keep it simple, standard set |
| Parameters everywhere | Use named recipes instead |
| Platform-specific commands | Use cross-platform bash |
| Forgetting `@` prefix | Use `@echo` for output |
| Not using dependencies | `check-all: format lint test` |
| Hardcoded paths | Use `$(pwd)` or relative paths |

## Template Selection

- **Python only:** Use Python template
- **JavaScript only:** Use JavaScript template
- **Java only:** Use Java template
- **Multiple languages:** Use Polyglot template (adapt for your combination)
- **Other language:** Adapt one of the existing templates to your stack
