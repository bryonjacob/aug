---
name: refactoring
description: Systematic refactoring workflow - use coverage/complexity tools to identify targets, plan issues, execute with tests
---

# Refactoring

## Purpose

Systematically improve code maintainability using `just coverage` and `just complexity` to identify targets, then `/plan` and `/work` to execute refactoring safely.

**Core principle:** Never refactor without high test coverage. Tests prove behavior is preserved.

## Software Laws

Apply these principles during refactoring:

- **Gall's Law** - Move from simple to complex incrementally
- **Kernighan's Law** - Simplify over-clever code
- **Leaky Abstractions** - Adjust/remove abstractions when they leak
- **DRY** - Eliminate duplication, single source of truth
- **RED-GREEN-REFACTOR** - Tests green before and after every change

## Uses

**Standard Interface:** aug-just/justfile-interface (Level 0+1)

```bash
just coverage      # Find low-coverage areas (blocks if <96%)
just complexity    # Find high-complexity targets
just test         # Verify after each change
just check-all    # Quality gate before merge
```

## Finding Refactoring Opportunities

**Two approaches:**

### Autonomous (Recommended)

```bash
/refactor
# AI analyzes codebase
# Finds opportunities automatically
# Creates detailed GitHub issues
```

Then execute: `/work <issue-number>`

### Manual

Use justfile commands to identify targets yourself.

## Workflow

### 1. Identify Targets

**Coverage gaps:**
```bash
just coverage
# Fails if <96% - write tests before refactoring
```

**Complexity hotspots:**
```bash
just complexity
# Python: radon cc - look for C grade or complexity >10
# JavaScript: complexity report - functions >10
# Java: PMD report - methods >10
```

### 2. Plan Refactoring

Create issues for each refactoring target:

```bash
/plan Refactor user validation module - current complexity 15, target <10
```

This creates issues with:
- Clear acceptance criteria (complexity reduction measured)
- Technical notes (extract functions, simplify conditionals)
- Dependencies (test coverage prerequisites)

### 3. Execute Refactoring

```bash
/work 99  # Sequential execution with test verification
```

**RED-GREEN-REFACTOR cycle per issue:**
1. Run `just test` → Ensure green ✅
2. Make one small refactor
3. Run `just test` → Ensure still green ✅
4. Commit with clear message
5. Repeat until acceptance criteria met
6. Run `just check-all` before merge

### 4. Verify Improvements

```bash
just complexity  # Confirm reduction
just coverage    # Confirm maintained
```

## Small Steps

**Good refactoring commits:**
```bash
refactor: extract validation from process_data
refactor: extract transformation from process_data
refactor: simplify conditionals with guard clauses
```

**Never commit broken tests.**

## Coverage Threshold

**Required before refactoring:** 96% (aug-just baseline threshold)

**If below threshold:** Write tests first, then refactor

## Common Patterns

**Extract Function** - Break large functions into single-purpose units
**Guard Clauses** - Replace nested conditionals with early returns
**Extract Constants** - Replace magic numbers with named constants
**Simplify Conditionals** - Reduce boolean complexity

## When NOT to Refactor

- Coverage <96% → Write tests first
- Unclear behavior → Study code first
- Behavior must change → That's a feature, not refactoring
- Time pressure → Do it right or not at all

## Integration

This skill works with:
- `aug-just` plugin - Provides coverage/complexity/test commands
- `/refactor` - Autonomous analysis, creates refactoring issues (recommended)
- `/plan` - Manual planning for custom refactorings
- `/work` - Executes refactoring with test verification gates

**Typical flow:**
```bash
/refactor          # Find opportunities, create issues
/work 101          # Execute using this skill's guidance
/work 102          # Continue with next refactoring
```
