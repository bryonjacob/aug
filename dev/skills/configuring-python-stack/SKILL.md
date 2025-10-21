---
name: configuring-python-stack
description: Use when setting up Python projects, configuring quality tools (formatting, linting, type checking, testing), or running web services in containers - provides modern toolchain standards using uv and ruff
---

# Configuring Python Stack

## Overview

Modern Python toolchain using **uv** (package management) and **ruff** (formatting + linting). Replaces Poetry/pip + black + isort + flake8 with faster, simpler tools.

## Toolchain (Complete List)

| Tool | Purpose | Replaces |
|------|---------|----------|
| **uv** | Package manager, venv, builds | pip + venv + setuptools |
| **ruff** | Format + lint + import sort | black + flake8 + isort |
| **mypy** | Type checking (strict) | - |
| **pytest** | Testing framework | - |
| **pytest-cov** | Coverage (80%+ threshold) | - |
| **pytest-watcher** | Watch mode for tests | - |
| **radon** | Complexity analysis | - |
| **pygount** | File size monitoring (<150 lines) | - |

**IMPORTANT:** Install ALL dev dependencies - missing tools = incomplete quality checks.

## Quick Reference

```bash
# Setup
uv venv .venv
uv pip install -e ".[dev]"

# Quality checks (use 'uv run' to auto-activate venv)
uv run ruff format .           # Format
uv run ruff check .            # Lint
uv run mypy src                # Type check
uv run pytest --durations=10   # Test (show 10 slowest)
uv run pytest --cov=src --cov-report=term-missing --cov-fail-under=80 --durations=10
uv run radon cc src -a -nb     # Complexity
uv run pygount --format=sloccount src/ | sort -rn | head -20  # File sizes
```

## Web Services: Critical Configuration

**Always bind to `0.0.0.0` (not `127.0.0.1`) for Docker compatibility.**

Make host/port configurable via environment variables:

```python
import os

if __name__ == "__main__":
    host = os.getenv("HOST", "0.0.0.0")
    port = int(os.getenv("PORT", "8000"))
    uvicorn.run("app:app", host=host, port=port)
```

## pyproject.toml Essentials

```toml
[project]
name = "package-name"
requires-python = ">=3.11"
dependencies = []

[project.optional-dependencies]
dev = [
    "pytest>=8.0", "pytest-cov>=4.1", "pytest-watcher>=0.4",
    "mypy>=1.8", "ruff>=0.3", "radon>=6.0", "pygount>=3.1",
]

[tool.ruff]
line-length = 100
target-version = "py311"
select = ["E", "F", "I", "N", "UP", "B", "C90"]  # NO 'D' (docstring rules)

[tool.ruff.mccabe]
max-complexity = 10

[tool.mypy]
strict = true
disallow_untyped_defs = true

[tool.coverage.report]
fail_under = 80
```

## UV Filesystem Warning Fix

If seeing "Failed to hardlink files" warnings, configure UV globally (one-time):

```bash
mkdir -p ~/.config/uv
cat > ~/.config/uv/uv.toml << 'EOF'
link-mode = "copy"
EOF
```

## justfile Commands

```just
dev:
    uv venv .venv && uv pip install -e ".[dev]"

format:
    uv run ruff format .

lint:
    uv run ruff check .

typecheck:
    uv run mypy src

test:
    uv run pytest --durations=10  # CRITICAL: --durations=10 monitors test performance

test-watch:
    uv run pytest-watcher --now --clear . -- --durations=10

coverage:
    uv run pytest --cov=src --cov-report=term-missing --cov-fail-under=80 --durations=10

check-all: format lint typecheck coverage
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Using Poetry/pip | Use **uv** for all package management |
| Using black + isort | Use **ruff** alone (does both) |
| Missing dev tools | Must install: pytest-watcher, radon, pygount |
| Forgetting --durations=10 | **Every pytest command** must include --durations=10 |
| Binding to 127.0.0.1 | Bind to **0.0.0.0** for Docker |
| Including 'D' in ruff rules | **Remove** - we don't enforce docstring rules |
| Verbose pyproject.toml | Keep ruff select minimal: ["E", "F", "I", "N", "UP", "B", "C90"] |

## Quality Thresholds

- Coverage: **80% minimum** (90%+ before refactoring)
- Complexity: **Max 10** (cyclomatic)
- Type coverage: **100%** (mypy strict mode)
- File size: **<150 lines** where practical
