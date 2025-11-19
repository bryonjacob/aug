---
name: suggest
description: Compare file to project conventions, suggest improvements
---

# Suggest - Consistency Analysis

Compare file to project conventions, identify inconsistencies, suggest improvements.

## Usage

```bash
/suggest [file-path]
```

**Examples:**
```bash
/suggest src/features/new-auth.py
/suggest tests/test_new_feature.py
/suggest src/api/routes.ts
```

## Purpose

Answer: "Does this file follow project conventions?"

Analyze file against detected conventions, suggest consistency improvements.

## Instructions

### 1. Validate File Path

**Check file exists:**
```bash
test -f <file-path>
```

**If missing:**
```
Error: File not found: <file-path>

Usage: /suggest [file-path]

Example: /suggest src/features/new_feature.py
```

**Check file is code:**
- Must be .py, .js, .ts, .tsx, .java, or similar
- Exclude: README.md, CHANGELOG.md, etc.

### 2. Detect Project Conventions

**Run pattern detection** (same as `/learn` but for all patterns):

1. Error handling conventions
2. Testing conventions (if test file)
3. Import conventions
4. Naming conventions
5. Architecture conventions (if applicable)

**Result:** Convention database
```python
{
  'error_handling': {'pattern': 'ErrorWrapper', 'adoption': 0.80},
  'imports': {'style': 'absolute', 'adoption': 0.95},
  'naming': {
    'functions': 'snake_case',
    'classes': 'PascalCase',
    'constants': 'UPPER_SNAKE_CASE',
  },
  ...
}
```

### 3. Analyze Target File

**For each pattern type:**

#### Import Analysis

**Detect imports in file:**
```python
# Absolute
from myapp.models import User

# Relative
from ..models import User
```

**Compare to convention:**
```python
if convention['imports']['style'] == 'absolute':
    # Check if file uses absolute
    # If uses relative → inconsistency
```

#### Error Handling Analysis

**Detect error handling patterns:**
```python
# ErrorWrapper pattern
try:
    result = operation()
except Exception as e:
    raise ErrorWrapper(e, context="...")

# Status code pattern
if not valid:
    return 400, "Invalid"

# Return None pattern
if not valid:
    return None
```

**Compare to convention:**
- If convention is ErrorWrapper (80%), flag other patterns

#### Naming Analysis

**Extract names:**
- Function names
- Class names
- Constants
- Variables (private, public, boolean)

**Check against convention:**
```python
# Convention: functions are snake_case (98%)
def getUserData():  # ← Inconsistent (camelCase)
    pass

# Should be:
def get_user_data():
    pass
```

#### Testing Analysis (if test file)

**Detect test patterns:**
- Test function naming
- Fixture usage
- Mock patterns
- Assertion style

**Compare to convention.**

#### Architecture Analysis

**Detect patterns:**
- Dependency injection
- Layer violations (controller calling repository directly)
- Return types (dict vs object)

**Compare to convention.**

### 4. Identify Inconsistencies

**For each deviation:**

```python
{
  'type': 'import_style',
  'line': 3,
  'severity': 'high',  # high, medium, low
  'current': 'from ..models import User',
  'expected': 'from myapp.models import User',
  'convention_adoption': 0.95,
  'fix': 'Use absolute imports',
}
```

**Severity calculation:**
- High: >90% adoption, clear deviation
- Medium: 70-90% adoption
- Low: 60-70% adoption or minor issue

### 5. Categorize Issues

**Group by type:**
- Import issues
- Error handling issues
- Naming issues
- Testing issues (if test file)
- Architecture issues

**Sort by severity:**
- High first
- Then medium
- Then low

### 6. Generate Suggestions

**For each issue:**

**High severity:**
```
1. Import style (lines 1-8)
   Current: from ..models import User
   Convention: from myapp.models import User (95% adoption)
   Severity: High
   Fix: Convert to absolute imports

   Before:
     from ..models import User
     from ..utils import helpers

   After:
     from myapp.models import User
     from myapp.utils import helpers
```

**Medium severity:**
```
2. Error handling (line 45)
   Current: if not valid: return None
   Convention: raise ErrorWrapper (80% adoption)
   Severity: Medium
   Fix: Use ErrorWrapper for validation errors

   Before:
     if not is_valid(data):
         return None

   After:
     if not is_valid(data):
         raise ErrorWrapper(
             ValidationError("Invalid data"),
             context="data_validation"
         )
```

**Low severity:**
```
3. Test file location
   Current: tests/new_auth_test.py
   Convention: tests/features/test_new_auth.py (85% adoption)
   Severity: Low
   Fix: Move to match source structure
```

### 7. Summary and Recommendation

**Count by severity:**
```
Summary:
  2 high severity issues
  1 medium severity issue
  1 low severity issue

Total: 4 inconsistencies found
```

**Recommendation:**
```
Recommendation:
  Address high severity issues before merge.

  Quick wins (automated):
    - Convert imports to absolute (formatter/linter)
    - Rename getUserData → get_user_data

  Manual fixes required:
    - Refactor error handling to use ErrorWrapper
```

### 8. Generate Report

**Format:**
```
Consistency Analysis: [file-path]
=================================

Inconsistencies found: <N>

[List of inconsistencies with details]

Summary:
  <N> high severity (must fix)
  <N> medium severity (should fix)
  <N> low severity (consider fixing)

Recommendation:
  [Action items based on findings]

Conforming patterns:
  ✓ [Pattern] follows convention
  ✓ [Pattern] follows convention

Notes:
  [Additional context or edge cases]
```

**If no issues found:**
```
Consistency Analysis: [file-path]
=================================

✓ No inconsistencies found

This file follows all project conventions:
  ✓ Imports: Absolute style (95% convention)
  ✓ Error handling: ErrorWrapper pattern (80% convention)
  ✓ Naming: snake_case functions, PascalCase classes (98% convention)
  ✓ Testing: test_func_scenario pattern (if test file)

Code quality: Excellent
```

## Examples

### File with Inconsistencies

```bash
$ /suggest src/features/new-auth.py

Consistency Analysis: src/features/new-auth.py
==============================================

Inconsistencies found: 4

1. Import style (lines 1-8) [HIGH]
   Current: from ..models import User
   Convention: Absolute imports (95% adoption)
   Fix: Use from myapp.models import User

2. Error handling (line 45) [MEDIUM]
   Current: if not valid: return None
   Convention: ErrorWrapper (80% adoption)
   Fix: Raise ErrorWrapper for validation errors

3. Function naming (line 67) [HIGH]
   Current: def getUserData()
   Convention: snake_case (98% adoption)
   Fix: Rename to get_user_data

4. Test location [LOW]
   Current: tests/new_auth_test.py
   Convention: tests/features/test_new_auth.py (85% adoption)
   Fix: Move to match source structure

Summary:
  2 high severity (imports, naming)
  1 medium severity (error handling)
  1 low severity (file location)

Recommendation:
  Address high severity issues before merge.

  Automated fixes:
    - ruff --fix (imports, some naming)
    - Rename function manually

  Manual fixes:
    - Refactor error handling
    - Move test file (optional)

Conforming patterns:
  ✓ Class naming (PascalCase)
  ✓ Constants (UPPER_SNAKE_CASE)
```

### Clean File

```bash
$ /suggest src/api/users.py

Consistency Analysis: src/api/users.py
======================================

✓ No inconsistencies found

This file follows all project conventions:
  ✓ Imports: Absolute style (95% convention)
  ✓ Error handling: ErrorWrapper pattern (80% convention)
  ✓ Naming: snake_case functions (98% convention)
  ✓ Naming: PascalCase classes (100% convention)
  ✓ Architecture: Constructor DI (80% convention)

Code quality: Excellent
```

### Test File Analysis

```bash
$ /suggest tests/test_validation.py

Consistency Analysis: tests/test_validation.py
==============================================

Inconsistencies found: 2

1. Test naming (lines 15, 23, 31) [MEDIUM]
   Current: testEmailValid, testEmailInvalid
   Convention: test_email_valid (90% adoption)
   Fix: Use snake_case for test functions

   Examples to fix:
     testEmailValid → test_email_valid
     testEmailInvalid → test_email_invalid

2. Repeated setup code [LOW]
   Lines: 15-18, 24-27, 32-35
   Convention: Use fixtures (85% adoption)
   Fix: Extract to conftest.py fixture

   Before:
     def test_user_valid():
         user = User(name="Test", email="test@test.com")
         assert user.validate()

     def test_user_invalid():
         user = User(name="Test", email="invalid")
         assert not user.validate()

   After:
     @pytest.fixture
     def make_user():
         return lambda name, email: User(name=name, email=email)

     def test_user_valid(make_user):
         user = make_user("Test", "test@test.com")
         assert user.validate()

Summary:
  0 high severity
  1 medium severity (naming)
  1 low severity (DRY)

Recommendation:
  Rename test functions to snake_case.
  Consider extracting fixture for repeated setup.

Conforming patterns:
  ✓ Assertion style (pytest assert)
  ✓ Test file location (tests/)
```

## Integration

**With /work:**
```bash
/work 123
# Implementation complete

/suggest src/features/new_feature.py
# Check consistency

# If issues found:
# Fix before creating PR or create follow-up issue
```

**With /autocommit:**
```bash
/autocommit 123

→ Review agent uses /suggest on modified files
→ Flags consistency issues in review
→ Blocks merge if high severity issues
```

**With /learn:**
```bash
/learn naming
# Understand conventions

/suggest src/new_file.py
# Apply conventions to new file
```

## Options

**Future enhancements (not in v3):**

```bash
/suggest --fix [file]       # Auto-fix issues
/suggest --severity high    # Only show high severity
/suggest --format json      # Machine-readable output
```

## Notes

- Analyzes one file at a time
- Compares against project-wide conventions
- Severity based on convention adoption rate
- Some fixes automated (imports, naming), others manual
- Does not modify files (only suggests changes)
- False positives possible (context matters)
