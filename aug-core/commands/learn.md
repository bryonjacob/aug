---
name: learn
description: Analyze codebase for pattern conventions
---

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

**Check pattern-type argument:**
- Must be one of: error-handling, testing, imports, naming, architecture
- If missing or invalid:
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

### 2. Scan Codebase

**Find relevant files:**

**For error-handling:**
```bash
# Find files with try/except or error classes
find . -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.java" | \
  xargs grep -l "try\|except\|catch\|Error"
```

**For testing:**
```bash
# Find test files
find . -name "test_*.py" -o -name "*_test.py" -o -name "*.test.js" -o -name "*.spec.ts" -o -name "*Test.java"
```

**For imports:**
```bash
# Find files with imports
find . -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.java" | head -100
```

**For naming/architecture:**
```bash
# Sample of all code files
find . -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.java" | head -100
```

### 3. Analyze Patterns

**For each file in sample:**

#### error-handling

**Detect patterns:**
- Try/except with custom error class
- Try/except with logging
- If/else with return None
- If/else with status codes
- Result types (Ok/Err)

**Count occurrences:**
```python
{
  'error_wrapper': 125,      # try/except with ErrorWrapper
  'status_codes': 23,         # if/else with return status
  'return_none': 8,           # if/else with return None
  'result_types': 0,          # Ok/Err pattern
}

Total: 156 error handling blocks
```

**Calculate adoption:**
```python
error_wrapper_rate = 125 / 156 = 80%
status_codes_rate = 23 / 156 = 15%
return_none_rate = 8 / 156 = 5%
```

#### testing

**Detect patterns:**
- Test naming (`test_func_scenario` vs `testFuncScenario`)
- Fixture usage (pytest fixtures, beforeEach, @Before)
- Mock patterns (@patch, jest.mock, Mockito)
- Assertion style

**Count and calculate adoption rates.**

#### imports

**Detect patterns:**
- Absolute imports (`from myapp.models import User`)
- Relative imports (`from ..models import User`)
- Import grouping (stdlib, external, internal)
- Sorted imports

#### naming

**Detect patterns:**
- Function naming (snake_case vs camelCase)
- Class naming (PascalCase vs snake_case)
- Constant naming (UPPER_SNAKE_CASE vs camelCase)
- Private naming (_leading vs trailing_)
- Boolean naming (is_/has_/can_ prefix)

**Calculate adoption rates for each convention.**

#### architecture

**Detect patterns:**
- Dependency injection (constructor vs setter)
- Layer separation (controllers, services, repositories)
- Return types (objects vs dicts)
- Config access (env vars, files, DI)

### 4. Determine Convention

**For each pattern type found:**

**Strong convention (≥80%):**
```
Pattern: ErrorWrapper class
Adoption: 125/156 (80%) ← Convention
Status: Strong
```

**Weak convention (60-79%):**
```
Pattern: pytest fixtures
Adoption: 65/100 (65%) ← Weak convention
Status: Emerging
```

**No convention (<60%):**
```
Pattern distribution:
  ErrorWrapper: 45/120 (38%)
  Status codes: 40/120 (33%)
  Return None: 35/120 (29%)
Status: No clear convention
```

### 5. Per-Module Breakdown

**Analyze adoption per module:**

```bash
# Group by directory (module)
# Calculate adoption per module
```

**Example:**
```
Module adoption rates:
  src/auth: 100% (45/45) ✓
  src/api: 85% (40/47)
  src/db: 90% (27/30) ✓
  src/utils: 60% (15/25) ← Needs attention
  src/legacy: 20% (5/25) ← Non-conforming
```

### 6. Find Examples

**Extract representative examples:**

**Best example (most common pattern):**
```python
# From src/auth/validate.py
try:
    result = validate_email(email)
except ValidationError as e:
    raise ErrorWrapper(e, context="email_validation")
```

**Non-conforming example:**
```python
# From src/utils/helpers.py
if not is_valid(data):
    return None  # ← Inconsistent with project convention
```

### 7. Identify Non-Conforming Files

**List files that don't follow convention:**

```
Non-conforming files:
  src/utils/helpers.py
    - Uses return None (5 instances)
    - Uses status codes (3 instances)
    - Convention: ErrorWrapper (0 instances)

  src/legacy/old_api.py
    - Uses status codes throughout (15 instances)
    - Convention: ErrorWrapper (0 instances)
```

### 8. Generate Report

**Format:**
```
[Pattern Type] Patterns
=======================

Analyzed: <N> [pattern instances]

Pattern Distribution:
  [Pattern A]: <count> (<percent>%) ← Convention
  [Pattern B]: <count> (<percent>%)
  [Pattern C]: <count> (<percent>%)

Convention: [Pattern A] (<percent>% adoption)
Status: Strong|Weak|None

Example:
  [code example showing convention]

Module Adoption:
  [module]: [percent]% ([count]/[total]) ✓|⚠
  [module]: [percent]% ([count]/[total])
  ...

Non-conforming files:
  [file]: [reason]
  [file]: [reason]

Recommendation:
  [What to do based on findings]
```

**Symbols:**
- `✓` High adoption (>90%)
- `⚠` Low adoption (<70%)

### 9. Provide Recommendations

**Based on convention strength:**

**Strong convention (≥80%):**
```
Recommendation:
  Follow ErrorWrapper pattern in all new code.
  Refactor non-conforming files to use ErrorWrapper.

  See non-conforming files above for refactoring targets.
```

**Weak convention (60-79%):**
```
Recommendation:
  Consider standardizing on dominant pattern.
  Document choice in CONVENTIONS.md.
  Apply consistently in new code.
```

**No convention (<60%):**
```
Recommendation:
  No clear convention detected.
  Team decision needed:
    1. Choose preferred approach
    2. Document in CONVENTIONS.md
    3. Refactor gradually to standard

  Current state allows flexibility but may hinder consistency.
```

## Example Outputs

### Strong Convention

```bash
$ /learn error-handling

Error Handling Patterns
=======================

Analyzed: 156 error handling blocks

Pattern Distribution:
  ErrorWrapper class: 125 (80%) ← Convention
  Status codes: 23 (15%)
  Return None: 8 (5%)

Convention: ErrorWrapper class (80% adoption)
Status: Strong

Example:
  try:
      result = validate_data(input)
  except ValidationError as e:
      raise ErrorWrapper(e, context="validation")

Module Adoption:
  src/auth: 100% (45/45) ✓
  src/api: 85% (40/47)
  src/db: 90% (27/30) ✓
  src/utils: 60% (15/25) ⚠
  src/legacy: 20% (5/25) ⚠

Non-conforming files:
  src/utils/helpers.py
    - Uses status codes (5 instances)
    - Uses return None (3 instances)

  src/legacy/old_api.py
    - Uses status codes throughout (15 instances)

Recommendation:
  Strong convention detected.
  Follow ErrorWrapper pattern in all new code.
  Refactor non-conforming modules (utils, legacy).

  Create refactoring issues:
    /refactor src/utils
    /refactor src/legacy
```

### Weak Convention

```bash
$ /learn testing

Testing Patterns
================

Analyzed: 89 test files, 450 test functions

Pattern Distribution:
  test_func_scenario naming: 58 files (65%) ← Weak convention
  testFuncScenario naming: 31 files (35%)

Convention: test_func_scenario (65% adoption)
Status: Weak (not fully adopted)

Example:
  def test_user_validation_valid_email(user):
      assert user.validate_email("test@test.com")

  def test_user_validation_invalid_email(user):
      assert not user.validate_email("invalid")

Module Adoption:
  tests/auth: 100% (25/25) ✓
  tests/api: 80% (20/25)
  tests/utils: 50% (10/20) ⚠
  tests/integration: 30% (8/26) ⚠

Fixture patterns:
  conftest.py fixtures: 75 (85%)
  Inline fixtures: 13 (15%)

Mock patterns:
  @patch decorator: 72 (80%)
  Direct mocking: 18 (20%)

Recommendation:
  Weak convention - not fully adopted.

  Actions:
    1. Document test_func_scenario as standard
    2. Refactor non-conforming tests gradually
    3. Enforce in code review

  Focus areas:
    - tests/integration (only 30% conforming)
    - tests/utils (50% conforming)
```

### No Convention

```bash
$ /learn imports

Import Patterns
===============

Analyzed: 234 Python files

Pattern Distribution:
  Absolute imports: 89 files (38%)
  Relative imports: 78 files (33%)
  Mixed (both styles): 67 files (29%)

Convention: NONE (no dominant pattern)
Status: Inconsistent

Examples:

  Absolute:
    from myapp.models import User
    from myapp.utils.helpers import validate

  Relative:
    from ..models import User
    from .helpers import validate

  Mixed:
    from myapp.models import User  # Absolute
    from ..utils import helpers     # Relative

Recommendation:
  No clear convention detected.

  Team decision required:
    1. Choose: Absolute (recommended) or Relative
    2. Document in CONVENTIONS.md
    3. Configure linters to enforce
    4. Refactor gradually

  Absolute imports recommended:
    - More explicit
    - Easier to refactor
    - Better IDE support
    - Python community standard

  Next step: Create CONVENTIONS.md with team decision
```

## Integration

**Standalone:**
```bash
/learn error-handling
# Understand project conventions
```

**With /suggest:**
```bash
/learn naming
# Learn conventions

/suggest src/new_feature.py
# Check if new code follows conventions
```

**With /refactor:**
```bash
/learn error-handling
# Find non-conforming modules

/refactor src/utils
# Create issues to standardize
```

## Notes

- Statistical analysis (not semantic)
- Project-specific (doesn't import external standards)
- Sampling for performance (100-200 files for large codebases)
- AST parsing when available, regex fallback
- Convention = ≥80% adoption by default
