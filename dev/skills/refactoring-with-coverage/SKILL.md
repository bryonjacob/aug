---
name: refactoring-with-coverage
description: Use when refactoring code to reduce complexity or improve maintainability - requires 90%+ test coverage before starting, small incremental steps, and continuous test verification
---

# Refactoring with Coverage

## Overview

**Core principle:** Never refactor without high test coverage. Refactoring changes structure, not behavior. Tests prove behavior is preserved.

**Required coverage:** 90%+ on code being refactored

## Quick Reference

```bash
# 1. Check coverage
pytest --cov=src --cov-report=term-missing  # Python
pnpm vitest run --coverage  # JavaScript

# 2. Find complexity targets
radon cc src -a -nb  # Python (look for C or worse)

# 3. Small refactor
# Edit code

# 4. Verify tests still pass
just test

# 5. Commit
git commit -m "refactor: extract validation function"

# 6. Repeat
```

## Workflow

### 1. Assess Coverage

**Before any refactoring:**

```bash
# Python
pytest --cov=src --cov-report=term-missing
# Look for coverage % on target modules

# JavaScript
pnpm vitest run --coverage
# Check coverage/index.html for details
```

**Required:** 90%+ on code being refactored

**If < 90%:** Write tests first, then refactor

### 2. Identify Targets

**If scope provided:** Analyze that specific area

**If no scope:** Run complexity analysis

```bash
# Python
radon cc src -a -nb
# Focus on grade C or worse, cyclomatic complexity > 10

# JavaScript (if using eslint-plugin-complexity)
pnpm eslint . --format json
```

### 3. Small Steps

**Refactoring cycle:**
1. Run tests → Ensure green ✅
2. Make one small refactor
3. Run tests → Ensure still green ✅
4. Commit with clear message
5. Repeat

**Example commits:**
```bash
git commit -m "refactor: extract validation from process_data"
# Tests pass ✅

git commit -m "refactor: extract transformation from process_data"
# Tests pass ✅

git commit -m "refactor: simplify conditional logic with guards"
# Tests pass ✅
```

**Never commit broken tests.**

### 4. Verify Improvements

```bash
# Check complexity improved
radon cc src -a -nb  # Python
pnpm eslint .  # JavaScript

# Verify coverage maintained
pytest --cov=src  # Python
pnpm vitest run --coverage  # JavaScript

# All quality checks pass
just check-all
```

## Common Refactoring Patterns

### Extract Function

**Before:**
```python
def process_user(data):
    # Validate
    if not data.get("email"):
        raise ValueError("Email required")
    if "@" not in data["email"]:
        raise ValueError("Invalid email")

    # Transform
    email = data["email"].lower().strip()

    # Save
    db.save({"email": email})
```

**After:**
```python
def validate_email(email: str) -> None:
    if not email:
        raise ValueError("Email required")
    if "@" not in email:
        raise ValueError("Invalid email")

def normalize_email(email: str) -> str:
    return email.lower().strip()

def process_user(data: dict) -> None:
    email = data.get("email", "")
    validate_email(email)
    normalized = normalize_email(email)
    db.save({"email": normalized})
```

### Replace Nested Conditionals with Guards

**Before:**
```python
def calculate_discount(user, order):
    if user:
        if user.is_premium:
            if order.total > 100:
                return order.total * 0.2
            else:
                return order.total * 0.1
        else:
            return 0
    else:
        return 0
```

**After:**
```python
def calculate_discount(user, order):
    if not user or not user.is_premium:
        return 0

    if order.total > 100:
        return order.total * 0.2

    return order.total * 0.1
```

### Extract Magic Numbers

**Before:**
```python
if age >= 18 and age < 65:
    # Working age
```

**After:**
```python
WORKING_AGE_MIN = 18
WORKING_AGE_MAX = 65

if WORKING_AGE_MIN <= age < WORKING_AGE_MAX:
    # Working age
```

## When NOT to Refactor

| Situation | What to Do Instead |
|-----------|-------------------|
| Coverage < 80% | Write tests first |
| Unclear behavior | Study code, understand it |
| Behavior must change | That's not refactoring, that's a feature |
| No clear problem | Identify specific issue (complexity, duplication) |
| Time pressure | Leave it, refactor later properly |

## Refactoring Checklist

**Before starting:**
- [ ] Coverage >= 90% on target code
- [ ] All existing tests pass
- [ ] Clear understanding of current behavior
- [ ] Specific goal (reduce complexity, remove duplication, etc.)

**During refactoring:**
- [ ] Make small, incremental changes
- [ ] Run tests after each change
- [ ] Commit working code frequently
- [ ] Coverage doesn't drop

**After refactoring:**
- [ ] All tests still pass
- [ ] Coverage >= 90% maintained
- [ ] Complexity reduced (measured)
- [ ] No behavioral changes
- [ ] `just check-all` passes

## Complexity Metrics

**Targets:**
- Cyclomatic complexity: < 10 (prefer < 7)
- Lines per function: < 50 (prefer < 20)
- Parameters per function: < 5 (prefer < 3)
- Nesting depth: < 4 (prefer < 3)

**Tools:**
- **Python:** radon, pytest-cov, mypy
- **JavaScript:** eslint-plugin-complexity, vitest coverage, TypeScript

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Refactoring without tests | Write tests first (90%+) |
| Large refactors | Small steps, test after each |
| Changing behavior | Refactoring preserves behavior |
| Committing broken tests | Tests must pass every commit |
| Dropping coverage | Maintain or increase coverage |
