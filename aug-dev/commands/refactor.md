---
name: refactor
description: Systematic refactoring - identify targets with coverage/complexity tools, plan issues, execute safely
argument-hint: <scope>
---

# refactor

## Task
$ARGUMENTS

## Purpose
Use `just coverage` and `just complexity` to find refactoring targets, then `/plan` and `/work` to execute safely.

Uses `refactoring` skill for workflow.

## Workflow

### 1. Identify Targets

```bash
just coverage      # Must pass (96%)
just complexity    # Find hotspots (>10)
```

### 2. Plan Issues

```bash
/plan Refactor validation module - complexity 15, target <10
```

### 3. Execute

```bash
/work 99  # Small steps, test after each change
```

### 4. Verify

```bash
just complexity  # Confirm reduction
just check-all   # Quality gate
```

## Coverage Requirement

**96%** before refactoring (justfile-standard-interface threshold)

**If below:** Write tests first, then refactor

## When to Use

✅ High complexity (>10), deep nesting (>3), long functions (>50 lines), duplication
❌ Time pressure, low coverage, unclear behavior