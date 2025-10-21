---
name: installing-git-hooks
description: Use when setting up git pre-commit and pre-push hooks - provides simple shell script approach and pre-commit framework method, both calling justfile commands for DRY principle
---

# Installing Git Hooks

## Overview

Git hooks enforce quality checks automatically. Standard configuration:
- **Pre-commit:** Format, lint, typecheck
- **Pre-push:** Run tests

Hooks call justfile commands (DRY principle).

## Quick Reference

```bash
# Simple shell script approach (recommended)
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
set -e
echo "Running pre-commit checks..."
just format
just lint
just typecheck
echo "✅ Pre-commit checks passed"
EOF
chmod +x .git/hooks/pre-commit

cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
set -e
echo "Running pre-push checks..."
just test
echo "✅ Pre-push checks passed"
EOF
chmod +x .git/hooks/pre-push
```

## Installation Methods

### Option 1: Simple Shell Scripts (Recommended)

**Pre-commit hook** (`.git/hooks/pre-commit`):
```bash
#!/bin/bash
set -e

echo "Running pre-commit checks..."
just format
just lint
just typecheck

echo "✅ Pre-commit checks passed"
```

**Pre-push hook** (`.git/hooks/pre-push`):
```bash
#!/bin/bash
set -e

echo "Running pre-push checks..."
just test

echo "✅ Pre-push checks passed"
```

**Make executable:**
```bash
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/pre-push
```

### Option 2: Pre-commit Framework

For teams or complex setups: https://pre-commit.com/

**`.pre-commit-config.yaml`:**
```yaml
repos:
  - repo: local
    hooks:
      - id: format
        name: Format code
        entry: just format
        language: system
        pass_filenames: false

      - id: lint
        name: Lint code
        entry: just lint
        language: system
        pass_filenames: false

      - id: typecheck
        name: Type check
        entry: just typecheck
        language: system
        pass_filenames: false

      - id: test
        name: Run tests
        entry: just test
        language: system
        pass_filenames: false
        stages: [push]
```

**Install:**
```bash
pip install pre-commit  # or uv pip install pre-commit
pre-commit install
pre-commit install --hook-type pre-push
```

## Justfile Integration

Add hook installation to justfile:

```just
# Install git hooks
hooks:
    @echo "Installing git hooks..."
    @cat > .git/hooks/pre-commit << 'EOF'\n#!/bin/bash\nset -e\necho "Running pre-commit checks..."\njust format\njust lint\njust typecheck\necho "✅ Pre-commit checks passed"\nEOF
    @chmod +x .git/hooks/pre-commit
    @cat > .git/hooks/pre-push << 'EOF'\n#!/bin/bash\nset -e\necho "Running pre-push checks..."\njust test\necho "✅ Pre-push checks passed"\nEOF
    @chmod +x .git/hooks/pre-push
    @echo "✅ Git hooks installed"

# Remove git hooks
hooks-remove:
    rm -f .git/hooks/pre-commit .git/hooks/pre-push
    @echo "✅ Git hooks removed"
```

**Usage:**
```bash
just hooks         # Install hooks
just hooks-remove  # Remove hooks
```

## Language-Specific Hooks

### Python with Virtual Environment

```bash
#!/bin/bash
set -e
source .venv/bin/activate
just format
just lint
just typecheck
```

### Polyglot Projects

```bash
#!/bin/bash
set -e

# Check what changed
if git diff --cached --name-only | grep -q "^api/"; then
    echo "Python files changed, running Python checks..."
    cd api && just format && just lint && just typecheck
fi

if git diff --cached --name-only | grep -q "^web/"; then
    echo "JS files changed, running JS checks..."
    cd web && just format && just lint && just typecheck
fi
```

## Best Practices

**Fast feedback:**
- Format/lint/typecheck should complete in seconds
- If slow, consider running only on staged files
- Or split checks across commit/push

**Fail fast:**
- Use `set -e` so hooks exit on first error
- Clear output showing what failed

**Consistent with CI:**
- Hooks should match CI checks
- If CI runs `just check-all`, consider using it in pre-push

**Team alignment:**
- Document hook setup in README
- Include in onboarding instructions

## Skipping Hooks

Sometimes necessary (use sparingly):

```bash
# Skip pre-commit
git commit --no-verify -m "message"

# Skip pre-push
git push --no-verify
```

**Warning:** Skipping defeats the purpose. Only when absolutely necessary.

## Troubleshooting

**Hook not running:**
```bash
# Check exists and executable
ls -la .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Verify shebang
head -1 .git/hooks/pre-commit  # Should be #!/bin/bash
```

**Just command not found:**
```bash
# Add to PATH in hook
#!/bin/bash
export PATH="$HOME/.cargo/bin:$PATH"
set -e
just format
```

**Virtual environment issues:**
```bash
# Activate venv in hook
#!/bin/bash
set -e
source .venv/bin/activate
just format
```

## Setup Template

**Complete setup script:**
```bash
# Create hooks directory if needed
mkdir -p .git/hooks

# Install pre-commit
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
set -e
echo "Running pre-commit checks..."
just format
just lint
just typecheck
echo "✅ Pre-commit checks passed"
EOF
chmod +x .git/hooks/pre-commit

# Install pre-push
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
set -e
echo "Running pre-push checks..."
just test
echo "✅ Pre-push checks passed"
EOF
chmod +x .git/hooks/pre-push

echo "✅ Git hooks installed successfully"
```
