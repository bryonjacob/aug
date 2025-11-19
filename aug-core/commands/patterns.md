---
name: patterns
description: Show all detected project conventions
---

# Patterns - Convention Overview

Display all detected conventions across pattern types.

## Usage

```bash
/patterns                  # Standard report
/patterns --summary        # Conventions only, no examples
/patterns --detailed       # Include per-module adoption rates
```

## Purpose

Answer: "What are the conventions in this project?"

Comprehensive overview of all detected patterns for reference and onboarding.

## Instructions

### 1. Detect All Patterns

Run pattern detection for all types:
1. Error handling
2. Testing
3. Imports
4. Naming
5. Architecture
6. Code style

**For each pattern type**, perform same analysis as `/learn`.

### 2. Filter by Convention Strength

**Include if:**
- Adoption ≥60% (weak or strong convention)
- Clear examples available

**Exclude if:**
- Adoption <60% (no clear convention)
- Note absence in report

### 3. Generate Report

**Format depends on flags:**

#### Standard Report (default)

**For each pattern type:**
```
[Pattern Type]:
  [Attribute]: [Convention] ([adoption]% adoption)
  Example:
    [code example]
```

**Full structure:**
```
Project Conventions
===================

Error Handling:
  Style: [convention] ([adoption]% adoption)
  Logging: [convention]
  Example:
    [code]

Testing:
  Naming: [convention] ([adoption]% adoption)
  Fixtures: [convention] ([adoption]% adoption)
  Mocking: [convention] ([adoption]% adoption)
  Example:
    [code]

Imports:
  Style: [convention] ([adoption]% adoption)
  Grouping: [convention] ([adoption]% adoption)
  Example:
    [code]

Naming:
  Functions: [convention] ([adoption]% adoption)
  Classes: [convention] ([adoption]% adoption)
  Constants: [convention] ([adoption]% adoption)
  Private: [convention] ([adoption]% adoption)
  Booleans: [convention] ([adoption]% adoption)

Architecture:
  DI: [convention] ([adoption]% adoption)
  Layers: [convention] ([adoption]% adoption)
  Returns: [convention] ([adoption]% adoption)

Code Style:
  Line length: [limit] ([adoption]% adoption)
  Quotes: [style] ([adoption]% adoption)
  Trailing commas: [convention] ([adoption]% adoption)

Summary:
  Strong conventions (≥80%): <N>
  Weak conventions (60-79%): <N>
  No conventions (<60%): <N>

Coverage:
  [N]/[total] pattern types have clear conventions
  Code consistency: [percentage]%
```

#### Summary Report (--summary)

**Just conventions, no examples:**
```
Project Conventions Summary
===========================

Error Handling:
  Style: ErrorWrapper (80%)
  Logging: Always with context

Testing:
  Naming: test_func_scenario (90%)
  Fixtures: conftest.py (85%)
  Mocking: @patch (80%)

Imports:
  Style: Absolute (95%)
  Grouping: stdlib/external/internal (90%)

Naming:
  Functions: snake_case (98%)
  Classes: PascalCase (100%)
  Constants: UPPER_SNAKE_CASE (95%)
  Private: _leading (90%)
  Booleans: is_/has_/can_ (85%)

Architecture:
  DI: Constructor injection (80%)
  Layers: controller→service→repository (75%)
  Returns: Objects not dicts (70%)

Code Style:
  Line length: 88 chars (100%)
  Quotes: Double (95%)
  Trailing commas: Always multiline (90%)

Conventions: 15 strong, 3 weak, 2 none
```

#### Detailed Report (--detailed)

**Include per-module adoption:**
```
Project Conventions
===================

Error Handling:
  Style: ErrorWrapper class (80% overall)

  Module adoption:
    src/auth: 100% (45/45) ✓
    src/api: 85% (40/47)
    src/db: 90% (27/30) ✓
    src/utils: 60% (15/25) ⚠
    src/legacy: 20% (5/25) ⚠

  Example:
    try:
        result = operation()
    except Exception as e:
        raise ErrorWrapper(e, context="...")

  [Continue for all patterns]
```

### 4. Handle Missing Conventions

**If pattern type has no convention (<60%):**

```
Error Handling:
  Status: No clear convention

  Pattern distribution:
    ErrorWrapper: 45% (38/85)
    Status codes: 33% (28/85)
    Return None: 22% (19/85)

  Recommendation:
    Team decision needed. Consider standardizing.
```

### 5. Calculate Code Consistency Score

**Overall consistency metric:**

```python
# Count strong conventions (≥80%)
strong = len([p for p in patterns if p.adoption >= 0.80])

# Count all pattern types analyzed
total = len(patterns)

# Calculate percentage
consistency_score = strong / total × 100
```

**Interpretation:**
- 90-100%: Excellent consistency
- 70-89%: Good consistency
- 50-69%: Fair consistency (some gaps)
- <50%: Poor consistency (many gaps)

### 6. Generate Recommendations

**Based on findings:**

**Excellent consistency (≥90%):**
```
Recommendations:
  ✓ Strong conventions across all areas
  ✓ Maintain current standards
  ✓ Use /suggest to check new code
  ✓ Document in CONVENTIONS.md for team reference
```

**Good consistency (70-89%):**
```
Recommendations:
  ✓ Most areas have clear conventions
  ⚠ Address weak conventions:
    - [pattern]: [adoption]%
    - [pattern]: [adoption]%
  → Run /learn [pattern] for details
  → Create refactoring issues to standardize
```

**Fair consistency (50-69%):**
```
Recommendations:
  ⚠ Significant inconsistency in multiple areas
  → Priority areas:
    1. [pattern]: No convention
    2. [pattern]: Weak convention ([adoption]%)
  → Actions:
    - Team meeting to establish standards
    - Document decisions in CONVENTIONS.md
    - Create refactoring plan
```

**Poor consistency (<50%):**
```
Recommendations:
  ✗ Major consistency issues across codebase
  → Critical actions:
    1. Establish core conventions (error handling, naming)
    2. Document in CONVENTIONS.md
    3. Configure linters to enforce
    4. Create refactoring backlog
  → Consider architecture review
```

## Example Outputs

### Well-Established Project

```bash
$ /patterns

Project Conventions
===================

Error Handling:
  Style: ErrorWrapper class (85% adoption)
  Logging: Always with context
  Example:
    try:
        result = validate_data(input)
    except ValidationError as e:
        raise ErrorWrapper(e, context="validation")

Testing:
  Naming: test_func_scenario (92% adoption)
  Fixtures: conftest.py (88% adoption)
  Mocking: @patch decorator (83% adoption)
  Example:
    @pytest.fixture
    def user():
        return User(name="Test")

    def test_user_validation(user):
        assert user.validate()

Imports:
  Style: Absolute only (96% adoption)
  Grouping: stdlib, external, internal (91% adoption)
  Example:
    import os

    import requests

    from myapp.models import User

Naming:
  Functions: snake_case (99% adoption)
  Classes: PascalCase (100% adoption)
  Constants: UPPER_SNAKE_CASE (97% adoption)
  Private: _leading_underscore (93% adoption)
  Booleans: is_/has_/can_ prefix (87% adoption)

Architecture:
  DI: Constructor injection (84% adoption)
  Layers: controller→service→repository (78% adoption)
  Returns: Objects not dicts (75% adoption)

Code Style:
  Line length: 88 chars (Black) (100% adoption)
  Quotes: Double quotes (96% adoption)
  Trailing commas: Always in multiline (92% adoption)

Summary:
  Strong conventions (≥80%): 15
  Weak conventions (60-79%): 3
  No conventions (<60%): 0

Code consistency: 93% (Excellent)

Recommendations:
  ✓ Excellent consistency across all areas
  ✓ Continue using /suggest for new code
  ✓ Document these conventions in CONVENTIONS.md

  Minor improvements:
    - Architecture layers (78%) could be stronger
    - Consider documenting layer boundaries explicitly
```

### Emerging Project

```bash
$ /patterns

Project Conventions
===================

Error Handling:
  Style: ErrorWrapper class (68% adoption)
  Status: Weak convention

  Recommendation: Standardize on ErrorWrapper

Testing:
  Status: No clear convention

  Pattern distribution:
    test_func_scenario: 45%
    testFuncScenario: 35%
    test_func: 20%

  Recommendation: Choose naming standard

Imports:
  Style: Absolute (92% adoption)
  Grouping: Yes (85% adoption)

Naming:
  Functions: snake_case (95% adoption)
  Classes: PascalCase (100% adoption)

Architecture:
  Status: No clear convention

  Recommendation: Define architecture patterns

Code Style:
  Line length: 88 chars (Black) (100% adoption)

Summary:
  Strong conventions (≥80%): 5
  Weak conventions (60-79%): 2
  No conventions (<60%): 3

Code consistency: 56% (Fair)

Recommendations:
  ⚠ Several areas lack clear conventions

  Priority actions:
    1. Testing: Establish naming convention
    2. Error handling: Strengthen ErrorWrapper adoption
    3. Architecture: Document patterns

  Next steps:
    /learn testing
    /learn error-handling
    Team discussion on architecture
```

## Output Destination

**To console (default):**
```bash
/patterns
```

**To file (future):**
```bash
/patterns > docs/CONVENTIONS.md
# Document for team reference
```

## Integration

**Onboarding:**
```bash
# New developer:
/patterns
# Quick overview of all conventions
```

**Documentation:**
```bash
/patterns --summary > docs/CONVENTIONS.md
# Document conventions for team
```

**With /learn:**
```bash
/patterns
# Identify weak areas

/learn [weak-pattern]
# Deep dive into specific area
```

**With /suggest:**
```bash
/patterns
# Know conventions

/suggest src/new_file.py
# Check compliance
```

## Notes

- Runs all pattern detection (may take 30-60 seconds)
- Caches results for session (re-run with --refresh to update)
- Sampling for large codebases (100-200 files per pattern type)
- Statistical analysis (adoption rates approximate)
- Best for projects with ≥50 files (smaller projects may have no patterns yet)
