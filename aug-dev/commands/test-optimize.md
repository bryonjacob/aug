---
name: test-optimize
description: Analyze test suite for speed and redundancy, create optimization issues
---

# Test Suite Optimization

Autonomous analysis to identify slow and redundant tests, create optimization issues.

## Usage

```bash
/test-optimize              # Analyze all modules
/test-optimize src/auth     # Analyze specific module
/test-optimize --dry-run    # Report only, don't create issues
```

## Instructions

### 1. Bootstrap State (if needed)

**Check for `.testaudit.yaml`:**

**If missing:**
- Create with template
- Find all CLAUDE.md directories (these are modules)
- Initialize each module with current HEAD commit

```yaml
version: 1

modules:
  src/auth:
    test_count: 0
    total_duration_ms: 0
    avg_duration_ms: 0
    slow_tests: 0
    last_analyzed_commit: <current-HEAD>
    last_analyzed_date: <now-ISO8601>
```

### 2. Module Discovery

Find all directories with CLAUDE.md - these define modules for analysis.

**If no CLAUDE.md files found:**
```
Error: No modules found (no CLAUDE.md files)
Run '/docsaudit' first to create CLAUDE.md hierarchy.
```

### 3. Determine Modules to Analyze

- If specific module provided: analyze only that module
- Otherwise: analyze all modules with tests

### 4. Run Analysis

Use `test-optimization` skill for domain knowledge on:
- Speed analysis (slow test causes and solutions)
- Redundancy detection (semantic overlap, logical subsumption)
- DRY analysis (fixtures, parameterization, helpers)

**Run slowtests to identify bottlenecks:**
```bash
just slowtests 50
```

If unavailable, run tests directly with timing output.

### 5. Prioritize Opportunities

Use `test-optimization` skill prioritization formula:
- Impact score (speed improvement, maintainability, test reduction)
- Complexity score (mocking vs redesign)
- Priority = impact / (complexity + 1)

### 6. Check Existing Issues

```bash
gh issue list --search "is:open [test-optimization]" --json number,title,body
```

Skip opportunities with similar existing issues.

### 7. Create GitHub Issues

For each new opportunity:

```markdown
[test-optimization] <Short description>

## Current State
- Test file: <file>
- Slow tests: <count> (avg: <ms>ms, target: <50ms)
- Redundant tests: <count>
- DRY opportunities: <count>

## Issues
[Speed, redundancy, and DRY issues identified]

## Approach
[Prioritized fix steps]

## Expected Improvement
- Speed: <current>ms -> <target>ms
- Maintainability: <tests removed/consolidated>

## Acceptance Criteria
- [ ] All tests run in <50ms each
- [ ] Coverage maintained at 96%
- [ ] just check-all passes
```

### 8. Update State File

Update `.testaudit.yaml` with current analysis results.

### 9. Generate Report

```
Test Suite Optimization Report
==============================

Analyzed modules: <N>

Module Test Health:
  <module>: <tests> tests, <duration>s total, <avg>ms avg

Opportunities found: <N>
Issues created: <list>

Next: /work <issue-number>
```

## Options

- `--dry-run`: Report only, don't create issues or update state
- `<module-path>`: Analyze only specified module

## Error Handling

- No CLAUDE.md files: Suggest `/docsaudit`
- No just slowtests: Use direct test execution
- GitHub CLI missing: Suggest `--dry-run`

## Notes

- Requires CLAUDE.md files (run `/docsaudit` first)
- Works best with justfile Level 1 (`just slowtests`)
- Target: all unit tests <50ms each
- Safe to run repeatedly (checks for changes, avoids duplicates)
