---
name: learn
description: Analyze codebase for pattern conventions
---

**Uses:** code-patterns skill

# Learn - Pattern Analysis

Analyze codebase to discover conventions for specific pattern type.

## Usage

```bash
/learn [pattern-type]
```

**Pattern types:**
- `error-handling` - Exception handling, error classes, logging
- `testing` - Test naming, fixtures, mocks, assertions
- `imports` - Import style, grouping, absolute vs relative
- `naming` - Function/class/constant/variable naming
- `architecture` - DI, layers, return types, config

## Purpose

Answer: "How does this project do X?"

Analyze code statistically to find conventions (80%+ adoption = convention).

## Instructions

### 1. Validate Pattern Type

If missing or invalid argument, show usage:
```
Usage: /learn [pattern-type]

Available patterns:
  error-handling  - Exception handling and error classes
  testing         - Test conventions and patterns
  imports         - Import style and organization
  naming          - Naming conventions
  architecture    - Architectural patterns (DI, layers)

Example: /learn error-handling
```

### 2. Analyze Using code-patterns Skill

Use the code-patterns skill to:
1. Scan codebase for relevant files
2. Detect patterns via statistical analysis
3. Calculate adoption rates
4. Identify conventions (80%+ = strong, 60-79% = weak)
5. Find non-conforming files

### 3. Generate Report

**Output format:**
```
[Pattern Type] Patterns
=======================

Analyzed: <N> [pattern instances]

Pattern Distribution:
  [Pattern A]: <count> (<percent>%) <- Convention
  [Pattern B]: <count> (<percent>%)

Convention: [Pattern A] (<percent>% adoption)
Status: Strong|Weak|None

Example:
  [code example showing convention]

Module Adoption:
  [module]: [percent]% ([count]/[total])
  ...

Non-conforming files:
  [file]: [reason]

Recommendation:
  [What to do based on findings]
```

### 4. Provide Recommendations

**Strong convention (>=80%):** Follow in new code, refactor non-conforming files.

**Weak convention (60-79%):** Standardize, document in CONVENTIONS.md.

**No convention (<60%):** Team decision needed - choose, document, refactor gradually.

## Integration

- `/suggest [file]` - Check if file follows conventions discovered here
- `/patterns` - Show all detected conventions
- `/refactor` - Create issues to standardize non-conforming modules

## Notes

- Statistical analysis (not semantic)
- Project-specific (derives from code, doesn't impose external standards)
- Sampling for performance (100-200 files for large codebases)
- AST parsing when available, regex fallback
