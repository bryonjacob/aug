---
name: suggest
description: Compare file to project conventions, suggest improvements
---

**Uses:** code-patterns skill

# Suggest - Consistency Analysis

Compare file to project conventions, identify inconsistencies, suggest improvements.

## Usage

```bash
/suggest [file-path]
```

## Purpose

Answer: "Does this file follow project conventions?"

## Instructions

### 1. Validate Input

Check file exists and is a code file (.py, .js, .ts, .java, etc.). Show error if not found.

### 2. Detect Project Conventions

Use code-patterns skill to detect conventions for all relevant pattern types:
- Error handling, imports, naming, architecture
- Testing conventions (if test file)

### 3. Analyze Target File

For each pattern type, detect patterns used in the file and compare to project conventions.

### 4. Identify Inconsistencies

For each deviation, record:
- Type, line number(s), current pattern, expected pattern
- Severity: High (>90% adoption), Medium (70-90%), Low (60-70%)

### 5. Generate Report

**Format:**
```
Consistency Analysis: [file-path]
=================================

Inconsistencies found: <N>

1. [Type] (line X) [SEVERITY]
   Current: [what file uses]
   Convention: [project pattern] ([adoption]% adoption)
   Fix: [how to fix]

Summary:
  <N> high severity (must fix)
  <N> medium severity (should fix)
  <N> low severity (consider fixing)

Recommendation:
  [Action items]

Conforming patterns:
  [List patterns that match convention]
```

**If no issues:**
```
Consistency Analysis: [file-path]
=================================

No inconsistencies found

This file follows all project conventions:
  [List conforming patterns]
```

## Integration

- `/learn [pattern]` - Understand conventions before suggesting
- `/work` - Run suggest on implemented files before PR
- `/refactor` - Use inconsistencies as refactoring targets

## Notes

- Analyzes one file at a time
- Severity based on convention adoption rate
- Does not modify files (only suggests)
