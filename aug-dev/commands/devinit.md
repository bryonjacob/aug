---
name: devinit
description: Audit project and setup missing development components
---

# devinit

## Task
$ARGUMENTS

## Purpose

Audit project, set up missing development workflow components. Ensure standards from ~/.claude/CLAUDE.md.

## Audit Checklist

**1. Git:**
```bash
git rev-parse --git-dir  # Is git repo?
git remote get-url origin | grep github.com  # GitHub remote?
git branch --show-current  # Current branch
```

**2. Justfile:**
```bash
[ -f justfile ] && echo "exists" || echo "missing"
just --list | grep -E "^    (dev|format|lint|typecheck|test|test-watch|coverage|check-all|clean)$"
```

**3. CLAUDE.md:**
```bash
[ -f CLAUDE.md ] && echo "exists" || echo "missing"
```

**4. Language Stack:**

Python:
```bash
[ -f pyproject.toml ] || [ -f setup.py ]
[ -d .venv ]
grep -q "ruff\|mypy\|pytest" pyproject.toml
```

JavaScript:
```bash
[ -f package.json ]
[ -f pnpm-lock.yaml ]
[ -f tsconfig.json ]
grep -q "prettier\|eslint\|typescript" package.json
```

**5. Git Hooks:**
```bash
[ -f .git/hooks/pre-commit ] && [ -x .git/hooks/pre-commit ]
[ -f .git/hooks/pre-push ] && [ -x .git/hooks/pre-push ]
grep -q "just" .git/hooks/pre-commit
```

**6. GitHub Actions:**
```bash
[ -f .github/workflows/pr-checks.yml ]
```

## Setup Actions

**Justfile:** Use `creating-justfiles` skill

**CLAUDE.md template:**
```markdown
# [Project Name]

## Purpose
[Description]

## Tech Stack
[Detected]

## Development Setup
1. Install: `just dev`
2. Hooks: `just hooks`
3. Test: `just test`

## Architecture
[Optional]

## Development Workflow
See ~/.claude/CLAUDE.md
```

**Language:**
- Python → `configuring-python-stack` skill
- JavaScript → `configuring-javascript-stack` skill

**Hooks:** `installing-git-hooks` skill, run `just hooks`

**Actions:** `configuring-github-actions` skill

## Flow

1. **Audit** - Check all, report status
2. **Confirm** - Ask which missing to setup
3. **Setup** - Create/configure
4. **Verify** - Run `just check-all`
5. **Commit** - Offer to commit

## Report Format

```
Development Environment Audit
==============================

✅ Git repository initialized
✅ GitHub remote configured
✅ Branch: main

❌ Justfile missing
   → Create with standard commands

✅ CLAUDE.md exists

✅ Python project detected
❌ pyproject.toml missing ruff
   → Add standard configuration

❌ Git hooks not installed
   → Install: just hooks

❌ GitHub Actions missing
   → Create .github/workflows/pr-checks.yml

---
Setup missing components? (y/n)
```

## Notes

- Non-destructive - ask before changes
- Auto-detect language
- Use appropriate skill for each setup
- Verify before declaring complete
- Offer commit at end
