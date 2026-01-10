---
name: test-optimization
description: Analyze test suites for speed bottlenecks, redundancy, and DRY violations. Use when tests are slow, duplicated, or need refactoring.
---

# Test Optimization

You analyze and optimize test suites for speed, maintainability, and clarity.

## Speed Analysis

### Slow Test Causes

| Cause | Symptom | Solution |
|-------|---------|----------|
| Database calls | >50ms, I/O wait | Mock with fixtures |
| External API calls | >100ms, network | Mock responses |
| File I/O | >20ms per operation | In-memory or fixtures |
| Complex computation | CPU-bound | Cache or simplify |
| Sleep/wait | Explicit delays | Mock time |

### Speed Targets

- Unit tests: <50ms each
- Integration tests: <500ms each
- Total suite: <30s for fast feedback

### Analysis Commands

```bash
# Python
pytest -v --durations=0 -m "not integration"

# JavaScript
vitest run --reporter=verbose

# Just command (if available)
just slowtests 50
```

## Redundancy Detection

### Semantic Overlap

Tests with >70% similar assertions:
```python
# Redundant: Test B is subset of Test A
# Test A: validates email with 5 formats
# Test B: validates email with 3 formats (subset of A)
# -> Test B is subsumed by Test A
```

### Logical Subsumption

Integration test covers unit test cases:
```python
# Integration test: POST /users validates email
# Unit test: validate_email() checks formats
# -> If integration covers all formats, unit may be redundant
```

### Copy-Paste Detection

- >70% code similarity between tests
- Repeated setup code across tests
- Duplicate assertions

## DRY Analysis

### Fixture Candidates

Repeated object creation:
```python
# Before: Repeated in each test
def test_user_valid():
    user = User(name="Test", email="test@test.com")
    ...

def test_user_invalid():
    user = User(name="Test", email="invalid")
    ...

# After: Fixture
@pytest.fixture
def base_user():
    return User(name="Test", email="test@test.com")
```

### Parameterization Opportunities

Similar tests with different inputs:
```python
# Before: Multiple tests
def test_email_valid():
    assert validate("test@test.com")

def test_email_invalid():
    assert not validate("invalid")

# After: Parameterized
@pytest.mark.parametrize("email,expected", [
    ("test@test.com", True),
    ("invalid", False),
])
def test_email_validation(email, expected):
    assert validate(email) == expected
```

### Helper Function Candidates

Repeated assertion patterns:
```python
# Before: Repeated assertions
def test_a():
    assert result.status == "success"
    assert result.data is not None
    assert result.errors == []

# After: Helper
def assert_success(result):
    assert result.status == "success"
    assert result.data is not None
    assert result.errors == []
```

## Categorization

### Speed Issues

- `mock_opportunities` - External calls to mock
- `in_memory_db` - Use SQLite in-memory
- `fixture_optimization` - Reduce setup time
- `computation_simplification` - Algorithm improvements

### Redundancy Issues

- `semantic_overlap` - Similar test coverage
- `logical_subsumption` - Integration covers unit
- `copy_paste` - Duplicated test code

### DRY Issues

- `fixture_candidates` - Repeated setup
- `parameterize_candidates` - Similar tests, different inputs
- `helper_candidates` - Repeated assertions

## Prioritization

**Impact Score (0-10):**
- Speed: `(current_ms - target_ms) / current_ms * 10`
- Maintainability: `lines_saved / 10`
- Test reduction: `tests_removed * 2`

**Complexity Score (0-10):**
- Speed fixes: Low (2-3) if mocking, High (7-8) if redesign
- Redundancy removal: Low (2-3) - just delete
- DRY improvements: Medium (4-6) - refactoring

**Priority:** `impact / (complexity + 1)`

## Output Format

```
Test Optimization Analysis
==========================

Module: {path}
Tests: {count} | Duration: {total}ms | Avg: {avg}ms

Speed Issues ({count}):
  - test_foo: 245ms (database calls) -> mock fixtures
  - test_bar: 180ms (external API) -> mock responses

Redundancy Issues ({count}):
  - test_email_valid subsumed by test_user_create
  - test_a and test_b: 85% similar assertions

DRY Opportunities ({count}):
  - Parameterize: test_format_* (5 tests -> 1)
  - Fixture: user setup in 8 tests
  - Helper: success assertion in 12 tests

Priority Order:
  1. [High] Mock database in test_validation.py
  2. [Medium] Parameterize format tests
  3. [Low] Extract user fixture
```

## Safeguards

When optimizing:
- Never remove tests without verifying coverage maintained
- Ensure all original assertions still pass
- Run `just check-all` after changes
- Maintain 96% coverage threshold
