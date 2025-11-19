---
name: code-patterns
description: Learn project conventions, detect patterns, suggest consistency improvements
---

# Code Patterns - Learning Assistant

Analyze codebase to learn conventions, detect patterns, suggest consistency improvements.

## Purpose

**Learn:** Analyze how project does things (error handling, testing, naming, architecture)

**Detect:** Find patterns via statistical analysis (80% do X = convention)

**Suggest:** Compare code to conventions, recommend consistency improvements

## Core Principle

"What's the convention here?" - Derive from code, not impose external standards.

## Pattern Types

### 1. Error Handling

**Analyze:**
- try/except vs if/else vs result types
- Error classes used
- Logging patterns
- Error propagation (raise vs return None vs result)

**Example patterns:**
```python
# Pattern A (80% adoption)
try:
    result = do_something()
except Exception as e:
    raise ErrorWrapper(e, context="operation_name")

# Pattern B (15% adoption)
if not valid:
    return None

# Pattern C (5% adoption)
# Mix of approaches
```

**Convention:** 80% = standard pattern to follow

### 2. Testing Conventions

**Analyze:**
- Test file naming (`test_*.py` vs `*_test.py` vs `*Test.java`)
- Test function naming (`test_function_scenario` vs `testFunctionScenario`)
- Fixture usage (conftest.py, beforeEach, @Before)
- Mock patterns (@patch, jest.mock, Mockito)
- Assertion style (assert x == y, expect(x).toBe(y), assertEqual)

**Example patterns:**
```python
# Naming pattern (90% adoption)
test_<function>_<scenario>

# Fixture pattern (85% adoption)
@pytest.fixture
def user():
    return User(name="Test")

def test_user_validation(user):
    assert user.validate()

# Mock pattern (80% adoption)
@patch('module.external_call')
def test_function(mock_call):
    ...
```

### 3. Code Organization

**Analyze:**
- Import style (absolute vs relative)
- Import grouping (stdlib, external, internal)
- Module structure (flat vs nested)
- File/directory naming

**Example patterns:**
```python
# Import style (95% adoption)
from myapp.models import User  # Absolute
from ..models import User      # Relative (5%)

# Import grouping (90% adoption)
import os  # stdlib
import sys

import requests  # external
import pytest

from myapp.models import User  # internal
from myapp.utils import helpers
```

### 4. Naming Conventions

**Analyze:**
- Functions: snake_case vs camelCase
- Classes: PascalCase vs snake_case
- Constants: UPPER_SNAKE_CASE vs camelCase
- Private: _leading vs trailing_
- Booleans: is_valid vs has_value vs valid

**Example patterns:**
```python
# Function naming (98% adoption)
def get_user_data():  # snake_case

# Class naming (100% adoption)
class UserValidator:  # PascalCase

# Constant naming (95% adoption)
MAX_RETRY_COUNT = 3  # UPPER_SNAKE_CASE

# Private naming (90% adoption)
def _internal_helper():  # _leading underscore

# Boolean naming (85% adoption)
is_valid, has_permission, can_edit  # is_/has_/can_ prefix
```

### 5. Architecture Patterns

**Analyze:**
- Dependency injection (constructor vs setter vs framework)
- Layer separation (controllers → services → repositories)
- Return types (objects vs dictionaries vs tuples)
- Configuration access (env vars, config files, DI)

**Example patterns:**
```python
# DI pattern (80% adoption)
class UserController:
    def __init__(self, auth_service: AuthService):
        self.auth_service = auth_service  # Constructor injection

# Layer pattern (75% adoption)
Controller → Service → Repository
(API layer) (Business logic) (Data access)

# Return type pattern (70% adoption)
def get_user() -> User:  # Return objects, not dicts
    return User(...)
```

### 6. Code Style

**Analyze:**
- Line length limits
- Quote style (single vs double)
- Trailing commas (multiline)
- Whitespace (around operators, blank lines)

**Note:** Many captured by formatters (Black, Prettier), but some choices remain.

## Analysis Method

### Statistical Pattern Detection

**For each pattern type:**

1. **Scan codebase:**
   - Find all instances of pattern (e.g., error handling blocks)
   - Categorize by approach
   - Count occurrences

2. **Calculate adoption:**
   ```
   adoption_rate = count(pattern) / count(all_instances)
   ```

3. **Determine convention:**
   - ≥80% adoption = strong convention
   - 60-79% adoption = weak convention
   - <60% adoption = no clear convention

4. **Examples:**
   - Strong: "95% of functions use snake_case"
   - Weak: "65% use ErrorWrapper, 35% use custom exceptions"
   - None: "33% use A, 33% use B, 34% use C"

### AST Parsing

**For code structure analysis:**

**Python:**
```python
import ast

tree = ast.parse(source_code)

# Find function definitions
functions = [node for node in ast.walk(tree) if isinstance(node, ast.FunctionDef)]

# Analyze naming
snake_case = sum(1 for f in functions if '_' in f.name)
camel_case = sum(1 for f in functions if f.name[0].islower() and any(c.isupper() for c in f.name))
```

**JavaScript/TypeScript:**
```javascript
// Use babel parser or typescript compiler API
const ast = parser.parse(sourceCode);

// Traverse AST
traverse(ast, {
  FunctionDeclaration(path) {
    // Analyze function patterns
  }
});
```

**Java:**
```java
// Use JavaParser or similar
CompilationUnit cu = StaticJavaParser.parse(sourceCode);

cu.findAll(MethodDeclaration.class).forEach(method -> {
  // Analyze method patterns
});
```

### Regex Pattern Matching

**For simple patterns:**

**Error handling:**
```python
try_except = len(re.findall(r'try:.*?except', code, re.DOTALL))
if_return_none = len(re.findall(r'if.*?return None', code))
```

**Imports:**
```python
absolute = len(re.findall(r'from \w+\.\w+', code))
relative = len(re.findall(r'from \.', code))
```

### Diff Analysis

**Compare file to conventions:**

1. **Analyze file** using same methods
2. **Compare to project conventions**
3. **Identify deviations:**
   - Using pattern B when 90% use pattern A
   - Mixing patterns within same file
   - Inconsistent with nearby code

## Command Integration

### /learn [pattern-type]

Analyze codebase for specific pattern type.

**Usage:**
```bash
/learn error-handling
/learn testing
/learn naming
/learn imports
/learn architecture
```

**Output:**
```
Error Handling Patterns
=======================

Analyzed: 156 error handling blocks

Pattern Distribution:
  ErrorWrapper class: 125 (80%) ← Convention
  Status codes: 23 (15%)
  Mixed approaches: 8 (5%)

Convention: ErrorWrapper class

Example:
  try:
      result = do_something()
  except Exception as e:
      raise ErrorWrapper(e, context="validation")

Adoption:
  src/auth: 100% (45/45)
  src/api: 85% (40/47)
  src/utils: 60% (15/25) ← Needs improvement

Non-conforming files:
  src/utils/helpers.py (mixes status codes and exceptions)
  src/legacy/old_api.py (uses status codes throughout)
```

### /suggest [file]

Compare file to project conventions, recommend improvements.

**Usage:**
```bash
/suggest src/features/new-auth.py
/suggest tests/test_new_feature.py
```

**Output:**
```
Consistency Analysis: src/features/new-auth.py
=============================================

Inconsistencies found: 4

1. Import style (lines 1-8)
   Current: from ..models import User
   Convention: from myapp.models import User (95% adoption)
   Severity: High
   Fix: Use absolute imports

2. Error handling (line 45)
   Current: if not valid: return None
   Convention: raise ErrorWrapper (80% adoption)
   Severity: Medium
   Fix: Replace with ErrorWrapper pattern

3. Function naming (line 67)
   Current: def getUserData()
   Convention: snake_case (98% adoption)
   Severity: High
   Fix: Rename to get_user_data

4. Test location
   Current: tests/new_auth_test.py
   Convention: tests/features/test_new_auth.py (85% adoption)
   Severity: Low
   Fix: Move to match source structure

Summary:
  2 high severity (imports, naming)
  1 medium severity (error handling)
  1 low severity (file location)

Recommendation: Address high severity issues before merge.
```

### /patterns

Show all detected patterns in project.

**Usage:**
```bash
/patterns
/patterns --summary    # Just conventions, no examples
/patterns --detailed   # Include adoption rates per module
```

**Output:**
```
Project Conventions
===================

Error Handling:
  Style: ErrorWrapper class (80% adoption)
  Logging: Always log with context
  Example:
    try:
        result = operation()
    except Exception as e:
        raise ErrorWrapper(e, context="operation")

Testing:
  Naming: test_<function>_<scenario> (90% adoption)
  Fixtures: conftest.py (pytest) (85% adoption)
  Mocking: @patch decorator (80% adoption)
  Example:
    @pytest.fixture
    def user():
        return User(name="Test")

    def test_user_validation(user):
        assert user.validate()

Imports:
  Style: Absolute only (95% adoption)
  Grouping: stdlib, external, internal (90% adoption)
  Example:
    import os

    import requests

    from myapp.models import User

Naming:
  Functions: snake_case (98% adoption)
  Classes: PascalCase (100% adoption)
  Constants: UPPER_SNAKE_CASE (95% adoption)
  Private: _leading_underscore (90% adoption)
  Booleans: is_/has_/can_ prefix (85% adoption)

Architecture:
  DI: Constructor injection (80% adoption)
  Layers: controllers → services → repositories (75% adoption)
  Returns: Objects not dicts (70% adoption)

Code Style:
  Line length: 88 chars (Black) (100% adoption)
  Quotes: Double quotes (95% adoption)
  Trailing commas: Always in multiline (90% adoption)
```

## Integration with Other Tools

### With /work

After implementation, check consistency:
```bash
/work 123
# Implementation complete

/suggest src/features/new_feature.py
# Check consistency

# If major issues found:
# Create follow-up issue or fix before PR
```

### With /autocommit

Part of code review:
```bash
/autocommit 123

→ Review includes:
  - Acceptance criteria ✓
  - Tests ✓
  - Coverage ✓
  - Consistency check (/suggest on modified files)
    - Imports: Non-standard ✗
    - Recommendation: Fix before merge
```

### With /refactor

Inconsistency as code smell:
```bash
/refactor

→ Finds:
  - Complexity issues
  - Duplicate code
  - Inconsistent patterns ← NEW
    - src/utils/helpers.py uses 3 different error handling styles

→ Creates issue:
  [refactoring] Standardize error handling in src/utils/helpers.py
```

## Limitations

**Statistical, not semantic:**
- Can't understand *intent*, only *usage*
- 80% might be wrong (technical debt)
- Doesn't validate quality, just consistency

**Language-specific:**
- AST parsing requires language-specific parsers
- Some patterns harder to detect (architecture)

**No learning across repos:**
- Each project analyzed independently
- Doesn't bring external conventions
- Pure project-specific pattern detection

## Best Practices

**Regular analysis:**
```bash
# After major features
/patterns --detailed
# Check if conventions changed

# Before merging
/suggest <modified-files>
# Ensure consistency
```

**Convention documentation:**
```bash
/patterns > docs/CONVENTIONS.md
# Document for team reference
```

**Onboarding:**
```bash
# New developer:
/learn error-handling
/learn testing
/learn naming
# Quick convention overview
```

## Success Metrics

Works well if:
- Detects real conventions (80%+ adoption)
- Suggests actionable improvements
- Identifies genuine inconsistencies
- Doesn't flag false positives
- Helps maintain codebase consistency

## Philosophy

**Descriptive, not prescriptive** - Learn from code, don't impose external rules.

**Statistical, not dogmatic** - 80% = convention, but context matters.

**Consistency over perfection** - Better to have clear convention than "best" approach.

**Team-specific** - Each project defines its own conventions through usage.
