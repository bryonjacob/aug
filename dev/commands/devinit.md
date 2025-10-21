# devinit

## Task
$ARGUMENTS

## Purpose
Audit project and set up missing development workflow components. Ensures project follows standards defined in ~/.claude/CLAUDE.md.

## Audit Checklist

Run these checks and report status:

### 1. Git Setup
```bash
# Is this a git repo?
git rev-parse --git-dir 2>/dev/null

# Does it have a GitHub remote?
git remote get-url origin 2>/dev/null | grep -q github.com

# Current branch
git branch --show-current
```

### 2. Justfile
```bash
# Does justfile exist?
[ -f justfile ] && echo "exists" || echo "missing"

# If exists, check for required commands
if [ -f justfile ]; then
  just --list | grep -E "^    (dev|format|lint|typecheck|test|test-watch|coverage|check-all|clean)$"
fi
```

### 3. Project CLAUDE.md
```bash
# Does project CLAUDE.md exist in root?
[ -f CLAUDE.md ] && echo "exists" || echo "missing"
```

### 4. Language Stack
Detect language and check setup:

**Python:**
```bash
# Detect Python project
[ -f pyproject.toml ] || [ -f setup.py ] || [ -f requirements.txt ]

# Check for .venv
[ -d .venv ]

# Check pyproject.toml has required tools
grep -q "ruff" pyproject.toml
grep -q "mypy" pyproject.toml
grep -q "pytest" pyproject.toml
```

**JavaScript:**
```bash
# Detect JavaScript project
[ -f package.json ]

# Check for pnpm
[ -f pnpm-lock.yaml ]

# Check for TypeScript
[ -f tsconfig.json ]

# Check package.json has required tools
grep -q "prettier" package.json
grep -q "eslint" package.json
grep -q "typescript" package.json
```

### 5. Git Hooks
```bash
# Check if hooks exist
[ -f .git/hooks/pre-commit ] && [ -x .git/hooks/pre-commit ] && echo "pre-commit installed"
[ -f .git/hooks/pre-push ] && [ -x .git/hooks/pre-push ] && echo "pre-push installed"

# Check if hooks call justfile
if [ -f .git/hooks/pre-commit ]; then
  grep -q "just" .git/hooks/pre-commit && echo "uses justfile"
fi
```

### 6. GitHub Actions
```bash
# Check for PR checks workflow
[ -f .github/workflows/pr-checks.yml ] && echo "exists" || echo "missing"
```

## Setup Actions

After audit, offer to set up missing components:

### Setup Justfile
Use the `creating-justfiles` skill and create appropriate template based on detected language.

### Setup Project CLAUDE.md
Create template:
```markdown
# [Project Name]

## Purpose
[User provides description]

## Tech Stack
[Detected from project files]

## Development Setup
1. Install dependencies: `just dev`
2. Install git hooks: `just hooks`
3. Run tests: `just test`

## Architecture
[User provides or leave blank]

## Development Workflow
See ~/.claude/CLAUDE.md for standard workflow.
```

### Setup Language Stack
**Python:** Use `configuring-python-stack` skill for setup
**JavaScript:** Use `configuring-javascript-stack` skill for setup

### Setup Git Hooks
Use `installing-git-hooks` skill and run `just hooks` command

### Setup GitHub Actions
Use `configuring-github-actions` skill and create appropriate workflow file

## Execution Flow

1. **Audit:** Check all components, report status
2. **Confirm:** Ask user which missing components to set up
3. **Setup:** Create/configure requested components
4. **Verify:** Run `just check-all` to ensure everything works
5. **Commit:** Offer to commit setup changes

## Report Format

```
Development Environment Audit
==============================

✅ Git repository initialized
✅ GitHub remote configured (origin)
✅ On branch: main

❌ Justfile missing
   → Can create with standard commands

✅ Project CLAUDE.md exists

✅ Python project detected
✅ Virtual environment (.venv) exists
❌ pyproject.toml missing ruff configuration
   → Can add standard configuration

❌ Git hooks not installed
   → Can install with: just hooks

❌ GitHub Actions workflow missing
   → Can create .github/workflows/pr-checks.yml

---
Ready to set up missing components? (y/n)
```

## Execution Notes
- Non-destructive - always ask before creating/modifying files
- Detect language automatically from project files
- Use appropriate agent for each setup task
- Verify setup works before declaring complete
- Offer to commit all changes at the end