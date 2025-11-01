---
name: refactor
description: Systematic refactoring with 90%+ coverage requirement
argument-hint: <scope>
---

# refactor

## Task
$ARGUMENTS

## Purpose
Systematic refactoring workflow that ensures high test coverage before changes and preserves behavior.

## Workflow

Use the `refactoring-with-coverage` skill for detailed refactoring guidance.

### 1. Assess Current Coverage

**If scope provided:** Check coverage on specified files/modules
**If no scope provided:** Run full coverage analysis

```bash
# Python
pytest --cov=src --cov-report=term-missing

# JavaScript
pnpm vitest run --coverage
```

**Required:** 90%+ coverage on code to be refactored

**If coverage < 90%:** Write tests first, then refactor

### 2. Identify Refactoring Targets

**If scope provided:** Analyze that area with complexity tools

**If no scope provided:** Run complexity analysis to find worst areas

```bash
# Python
radon cc src -a -nb
# Look for grade C/D/F or complexity > 10

# JavaScript (if configured)
pnpm eslint . --format json > complexity.json
```

### 3. Create Refactoring Plan

Create GitHub issue(s) documenting:
- Target files/functions
- Current complexity metrics
- Current coverage
- Specific problems identified
- Proposed changes
- Success criteria
- Testing strategy

Use `/plan` workflow to create issues.

### 4. Execute Refactoring

For each refactoring issue:

```bash
# Use /work to execute the refactoring issue
# Or use /quicktask if it's small and unplanned
```

**During refactoring:**
- Make small, incremental changes
- Run tests after each change: `just test`
- Commit frequently with clear messages
- Never commit broken tests
- Verify coverage doesn't drop: `just coverage`

**Example commit sequence:**
```bash
git commit -m "refactor: extract validation logic from process_data"
just test  # ✅ Pass

git commit -m "refactor: simplify nested conditionals with guards"
just test  # ✅ Pass

git commit -m "refactor: extract transformation logic"
just test  # ✅ Pass
```

### 5. Verify Improvements

After refactoring:
```bash
# Run complexity analysis again
radon cc src -a -nb  # Python
# or eslint for JavaScript

# Verify coverage maintained or improved
just coverage

# All quality gates pass
just check-all
```

Compare metrics before/after:
- Complexity reduced?
- Coverage maintained?
- All tests passing?
- Code more readable?

## When to Use

**Good reasons to refactor:**
- High cyclomatic complexity (> 10)
- Deep nesting (> 3 levels)
- Long functions (> 50 lines)
- Duplicate code
- Unclear naming
- Mixed concerns (doing too many things)

**Bad reasons to refactor:**
- "It looks messy" without specific issues
- Time pressure (rushed refactoring creates bugs)
- Insufficient test coverage
- Unclear about current behavior

## Execution Notes
- Use `refactoring-with-coverage` skill for patterns and best practices
- Never refactor without 90%+ test coverage
- Make small incremental changes
- Run tests after every change
- Commit working code frequently
- Refactoring changes structure, not behavior
- If behavior must change, that's a feature/fix, not a refactor

## Coverage First Rule

If coverage < 90%:
1. Stop
2. Create issue for adding tests
3. Use `/work` to add tests
4. Verify 90%+ coverage
5. Then refactor

Never refactor untested code.