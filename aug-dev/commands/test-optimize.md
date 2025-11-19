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
- Set dates to now

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

**If exists:**
- Load current state
- Proceed with analysis

### 2. Module Discovery

**Find all directories with CLAUDE.md:**
```bash
find . -name "CLAUDE.md" -type f -exec dirname {} \; | sort
```

These define modules for analysis.

**If no CLAUDE.md files found:**
```
Error: No modules found (no CLAUDE.md files)

This command requires CLAUDE.md files to define module boundaries.
Run '/docsaudit' first to create CLAUDE.md hierarchy.
```

### 3. Determine Modules to Analyze

**If specific module provided:** (`/test-optimize src/auth`)
- Analyze only that module
- Update only that module's state

**Otherwise (normal mode):**
- Analyze all modules with tests
- Update all module states

### 4. Speed Analysis

For each module to analyze:

**Run slowtests to identify bottlenecks:**
```bash
just slowtests 50
```

If `just slowtests` not available, run tests directly:

**Python:**
```bash
pytest -v --durations=0 -m "not integration"
```
Parse output, find tests >50ms.

**JavaScript:**
```bash
vitest run --reporter=verbose --reporter=json --outputFile=.test-results.json
```
Parse JSON, find tests >50ms.

**Java:**
```bash
mvn test
```
Parse output, find tests >50ms.

**For each slow test:**
1. Read test file
2. Analyze why slow:
   - Database calls? → Mock with fixtures
   - External API calls? → Mock responses
   - File I/O? → Use in-memory or fixtures
   - Complex computation? → Cache or simplify
   - Sleep/wait? → Mock time
3. Categorize: mock_opportunities, in_memory_db, fixture_optimization, computation_simplification

### 5. Redundancy Analysis

For each test file in module:

**Semantic overlap detection:**
- Parse test functions
- Compare test inputs and assertions
- Identify tests with >70% similar assertions
- Example:
  ```python
  # Test A: validates email with 5 formats
  # Test B: validates email with 3 formats (subset of A)
  # → Test B is subsumed by Test A
  ```

**Logical subsumption:**
- Identify integration tests
- Check if integration test already validates what unit test checks
- Example:
  ```python
  # Integration test: POST /users validates email
  # Unit test: validate_email() checks formats
  # → If integration test covers all formats, unit test may be redundant
  ```

**Copy-paste detection:**
- Similar test structure (>70% code similarity)
- Repeated setup code
- Duplicate assertions

### 6. DRY Analysis

For each test file:

**Repeated setup code:**
- Find code patterns repeated across tests
- Categorize:
  - Fixture candidates (pytest fixtures, beforeEach)
  - Test helpers (common assertion functions)
  - Parameterization opportunities (similar tests with different inputs)

**Example:**
```python
# Current: Repeated setup in each test
def test_user_valid_email():
    user = User(name="Test", email="test@test.com")
    assert user.validate()

def test_user_invalid_email():
    user = User(name="Test", email="invalid")
    assert not user.validate()

# Suggested: Parameterize
@pytest.mark.parametrize("email,expected", [
    ("test@test.com", True),
    ("invalid", False),
])
def test_user_email_validation(email, expected):
    user = User(name="Test", email=email)
    assert user.validate() == expected
```

### 7. Create Optimization Opportunities

For each issue found, create opportunity record:

```python
{
  'module': 'src/auth',
  'type': 'speed',  # or 'redundancy' or 'dry'
  'test_file': 'tests/test_validation.py',
  'issues': {
    'slow_tests': [
      {'name': 'test_user_validation', 'duration_ms': 245, 'cause': 'database_calls'},
    ],
    'redundant_tests': [
      {'subsumed': 'test_email_valid', 'by': 'test_user_create_endpoint'},
    ],
    'dry_opportunities': [
      {'type': 'parameterize', 'tests': ['test_email_valid', 'test_email_invalid']},
    ],
  },
  'approach': [
    'Mock database calls with fixtures',
    'Use in-memory SQLite for DB tests',
    'Parameterize email validation tests',
    'Extract common setup to conftest.py',
  ],
  'expected_improvement': {
    'speed': '245ms → <50ms (80% reduction)',
    'maintainability': '5 tests → 2 parameterized tests',
    'lines_saved': 45,
  },
}
```

### 8. Prioritization

For each opportunity, calculate:

**Impact score (0-10):**
- Speed improvement: (current_ms - target_ms) / current_ms × 10
- Maintainability: lines saved / 10
- Test count reduction: tests removed × 2

**Complexity score (0-10):**
- Speed fixes: low (2-3) if mocking, high (7-8) if redesign
- Redundancy removal: low (2-3) - just delete tests
- DRY improvements: medium (4-6) - refactoring needed

**Priority:**
```
priority = impact / (complexity + 1)
```

Sort opportunities by priority (high to low).

### 9. Check Existing Issues

**Search GitHub for open test-optimization issues:**
```bash
gh issue list --search "is:open [test-optimization]" --json number,title,body
```

**For each opportunity:**
- Check if similar issue already exists
- If yes: skip, log "Similar to #N"
- If no: proceed to create

### 10. Create GitHub Issues

For each new opportunity:

**Format:**
```markdown
[test-optimization] <Short description>

## Current State
- Test file: <file>
- Slow tests: <count> (avg: <ms>ms, target: <50ms)
- Redundant tests: <count>
- DRY opportunities: <count>

## Issues

### Slow Tests
- `test_user_validation`: 245ms (database calls)
- `test_email_check`: 180ms (external API)

### Redundancy
- `test_email_valid` subsumed by `test_user_create_endpoint`

### DRY Opportunities
- Parameterize 5 email validation tests → 1 test
- Extract repeated user setup to fixture

## Approach
1. Mock database calls with fixtures
2. Mock external API responses
3. Remove subsumed tests (ensure coverage maintained)
4. Parameterize similar tests
5. Extract common setup to conftest.py

## Expected Improvement
- Speed: 425ms → <100ms (76% reduction)
- Maintainability: 8 tests → 3 parameterized tests
- Lines: -45 lines (DRY improvements)

## Acceptance Criteria
- [ ] All tests run in <50ms each
- [ ] Coverage maintained at 96%
- [ ] All original assertions still pass
- [ ] just check-all passes
- [ ] No behavior changes

## Notes
- Module has 96% test coverage
- Current test runtime: 2.3s (target: <1s)
```

**Create issue via GitHub CLI:**
```bash
gh issue create \
  --title "[test-optimization] <title>" \
  --body "<formatted-body>" \
  --label "test-optimization"
```

**Track created issue numbers.**

### 11. Update State File

**Update `.testaudit.yaml`:**

For each analyzed module:
```yaml
modules:
  <module-path>:
    test_count: <count>
    total_duration_ms: <total>
    avg_duration_ms: <average>
    slow_tests: <count>
    last_analyzed_commit: <current-HEAD>
    last_analyzed_date: <now-ISO8601>
```

**Write updated file.**

### 12. Generate Report

**Format:**
```
Test Suite Optimization Report
==============================

Analyzed modules: <N>

Module Test Health:
  src/auth: 45 tests, 5.4s total, 120ms avg (5 >50ms)
  src/api: 32 tests, 2.1s total, 65ms avg (2 >50ms)
  src/db: 28 tests, 1.2s total, 43ms avg (0 >50ms) ✓

Total tests: 105
Total runtime: 8.7s (target: <5s)
Avg per test: 83ms (target: <50ms)

Opportunities found: 4

High Priority (8-10):
  1. src/auth/tests/test_validation.py
     Speed: 5 tests >50ms (database calls)
     Impact: 245ms → <50ms per test

Medium Priority (5-7):
  2. src/api/tests/test_routes.py
     Redundancy: 3 tests subsumed by integration tests
     DRY: Parameterize 6 similar tests

Low Priority (3-4):
  3. src/auth/tests/test_session.py
     DRY: Extract repeated setup to fixtures

Checking GitHub for existing [test-optimization] issues...
Found: 1 open test-optimization issue (different target)

Creating 3 new issues...
  ✓ #201: [test-optimization] Speed up validation tests
  ✓ #202: [test-optimization] Remove redundant route tests
  ✓ #203: [test-optimization] DRY up session test setup

Updated .testaudit.yaml

Next steps:
  Review issues: gh issue list --search "[test-optimization]"
  Execute: /work <issue-number>
```

**Symbols:**
- `✓` Healthy (all tests <50ms)
- `⚠` Needs optimization (tests >50ms)

### 13. Exit

**If issues created:**
- Report count and links
- Suggest: `gh issue list --search "[test-optimization]"`
- Suggest: `/work <issue-number>`

**If no opportunities:**
```
No test optimization opportunities found.

All test suites are healthy:
- All tests <50ms
- No redundancy detected
- Minimal DRY opportunities

Test suite health: ✓ Excellent
```

**If errors:**
- Report clearly
- Exit code 1

## Options Handling

**`--dry-run`:**
- Run all analysis
- Generate report
- Don't create GitHub issues
- Don't update `.testaudit.yaml`
- Show what WOULD be created

**`<module-path>`:**
- Analyze only specified module
- Must be a directory with CLAUDE.md
- Update only that module's state
- Example: `/test-optimize src/auth`

## Error Handling

**No CLAUDE.md files:**
```
Error: No modules found

This command requires CLAUDE.md files to define modules.
Run '/docsaudit' to create CLAUDE.md hierarchy.
```

**No justfile commands:**
```
Warning: just slowtests not found

Using direct test execution for analysis.
Consider adding Level 1 quality patterns: /just-upgrade 1
```

**GitHub CLI not available:**
```
Error: GitHub CLI (gh) not found

Install: https://cli.github.com/
Or use --dry-run to see analysis without creating issues
```

**Git errors:**
```
Error: git diff failed for module: <module>
Reason: <error>
Skipping this module, continuing with others...
```

## Examples

### First Run (Bootstrap)

```bash
$ /test-optimize

Creating .testaudit.yaml...

Found 3 modules (directories with CLAUDE.md):
  src/auth
  src/api
  src/db

Initialized state, analyzing all modules...

[Analysis proceeds]

Opportunities found: 4

Created 4 GitHub issues (#201-204)
```

### Normal Run

```bash
$ /test-optimize

Loading .testaudit.yaml...

Analyzing 3 modules with tests...

Test Suite Health:
  src/auth: 5 slow tests (>50ms)
  src/api: 2 slow tests, 3 redundant
  src/db: ✓ All healthy

Opportunities found: 3

Creating 3 new issues...
  ✓ #205: [test-optimization] Speed up auth validation tests
  ✓ #206: [test-optimization] Remove redundant API tests
  ✓ #207: [test-optimization] DRY up API test fixtures

Next: /work 205
```

### Specific Module

```bash
$ /test-optimize src/auth

Analyzing: src/auth only

Test Health:
  45 tests, 5.4s total, 120ms avg
  5 tests >50ms (target: 0)

Opportunities found: 2

High Priority:
  1. Speed up validation tests (245ms → <50ms)
  2. Parameterize email format tests (5 → 1)

Creating 2 issues...
  ✓ #208: [test-optimization] Speed up validation tests
  ✓ #209: [test-optimization] Parameterize email tests
```

### Dry Run

```bash
$ /test-optimize --dry-run

DRY RUN - No issues will be created

[Full analysis proceeds]

Would create 3 issues:
  1. #xxx: [test-optimization] Speed up validation tests
  2. #xxx: [test-optimization] Remove redundant tests
  3. #xxx: [test-optimization] DRY up fixtures

Run without --dry-run to create these issues.
```

## Notes

- Requires CLAUDE.md files (run `/docsaudit` first)
- Works best with justfile Level 1 (`just slowtests`)
- Target: all unit tests <50ms each
- Safe to run repeatedly (checks for changes, avoids duplicates)
- Execution via `/work` uses RED-GREEN-REFACTOR cycle
- Never removes tests without verifying coverage maintained
