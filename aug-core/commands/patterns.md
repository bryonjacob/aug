---
name: patterns
description: Show all detected project conventions
---

**Uses:** code-patterns skill

# Patterns - Convention Overview

Display all detected conventions across pattern types.

## Usage

```bash
/patterns                  # Standard report with examples
/patterns --summary        # Conventions only, no examples
/patterns --detailed       # Include per-module adoption rates
```

## Purpose

Answer: "What are the conventions in this project?"

## Instructions

### 1. Detect All Patterns

Use code-patterns skill to analyze all pattern types:
- Error handling, testing, imports, naming, architecture, code style

### 2. Filter by Convention Strength

Include patterns with >=60% adoption. Note absence for patterns with no clear convention (<60%).

### 3. Generate Report

**Standard format:**
```
Project Conventions
===================

[Pattern Type]:
  [Attribute]: [Convention] ([adoption]% adoption)
  Example:
    [code example]

...

Summary:
  Strong conventions (>=80%): <N>
  Weak conventions (60-79%): <N>
  No conventions (<60%): <N>

Code consistency: [percentage]% ([rating])

Recommendations:
  [Based on consistency score]
```

**--summary:** Conventions only, no examples.

**--detailed:** Add per-module adoption breakdown.

### 4. Calculate Consistency Score

`consistency_score = strong_conventions / total_patterns * 100`

- 90-100%: Excellent
- 70-89%: Good
- 50-69%: Fair
- <50%: Poor

### 5. Generate Recommendations

Based on consistency score:
- **Excellent:** Maintain standards, use /suggest for new code
- **Good:** Address weak conventions, create refactoring issues
- **Fair:** Prioritize standardization, document decisions
- **Poor:** Establish core conventions, configure linters

## Integration

- `/learn [pattern]` - Deep dive into specific pattern type
- `/suggest [file]` - Check file compliance with conventions

## Notes

- May take 30-60 seconds for large codebases
- Sampling used for performance (100-200 files per pattern)
- Best for projects with >=50 files
