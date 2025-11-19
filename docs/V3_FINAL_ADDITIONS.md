# V3 Final Additions - Implementation Plan

**Status:** Approved for implementation
**Date:** 2025-11-19

## Confirmed Additions

### 1. /autocommit - Autonomous Work + Review + Merge

**Location:** `aug-core/commands/autocommit.md` (automation capability)

**Purpose:** Complete autonomous workflow - work → review → merge

**Flow:**
```bash
/autocommit 123              # Single issue
/autocommit 123 124 125      # Multiple issues (sequential)

→ For each issue:
  1. Run /work <issue-number>
  2. Wait for PR creation
  3. Launch Task(subagent_type='code-reviewer')
  4. Review agent checks:
     - Acceptance criteria from issue met?
     - DRY violations?
     - YAGNI violations (scope creep)?
     - Tests exist and pass?
     - Coverage ≥96%?
     - Complexity within limits?
     - just check-all passes?
  5. If issues: Comment on PR, report to user
  6. If perfect: gh pr merge -s -d
```

**Key constraint:** Review ONLY against original issue acceptance criteria. No new requirements.

**Integration:**
- Uses aug-dev's `/work` command
- Uses existing code-reviewer agent pattern
- Fits aug-core's automation theme

---

### 2. jscpd Integration - Copy-Paste Detection

**Location:** `aug-just/skills/justfile-quality-patterns/SKILL.md` (Level 1)

**Justfile additions:**

**Python:**
```just
# Find duplicate code blocks
duplicates:
    jscpd . --threshold 30 --min-lines 5 --reporters console
```

**JavaScript:**
```just
# Find duplicate code blocks
duplicates:
    jscpd . --threshold 30 --min-lines 5 --reporters console
```

**Java:**
```just
# Find duplicate code blocks
duplicates:
    jscpd . --threshold 30 --min-lines 5 --reporters console
```

**Config file:** `.jscpd.json`
```json
{
  "threshold": 30,
  "minLines": 5,
  "minTokens": 50,
  "ignore": [
    "node_modules/**",
    "dist/**",
    "build/**",
    "**/*.test.js",
    "**/*.test.ts",
    "**/*_test.py",
    "**/*Test.java"
  ],
  "reporters": ["console", "json"],
  "format": ["javascript", "typescript", "python", "java"]
}
```

**Integration with /refactor:**

Update `aug-dev/commands/refactor.md` step 4 (Metrics Analysis):
```markdown
**Duplicates:**
```bash
just duplicates  # or direct jscpd call if no justfile
```
Parse output, find files with >30% duplicate code.
Add to candidate files list.
```

**Don't add to check-all yet** - let teams opt-in via `/just-upgrade 1`

---

### 3. Test Suite Optimization

#### 3a. Justfile Enhancements (Level 1)

**Update:** `aug-just/skills/justfile-quality-patterns/SKILL.md`

**Python:**
```just
# Run unit tests with timing (show 10 slowest)
test:
    pytest -v -m "not integration" --durations=10

# Show tests slower than N milliseconds
slowtests N="50":
    pytest -v --durations=0 | python -c "import sys; [print(l) for l in sys.stdin if any(int(t.split('.')[0]) > int('{{N}}') for t in l.split() if t.endswith('s'))]"

# Profile all tests with detailed timing
test-profile:
    pytest -v --durations=0 --cov=. --cov-report=term-missing
```

**JavaScript:**
```just
# Run unit tests with timing
test:
    vitest run --reporter=verbose

# Show tests slower than N milliseconds
slowtests N="50":
    vitest run --reporter=verbose --reporter=json --outputFile=.test-results.json && \
    jq -r '.testResults[].assertionResults[] | select(.duration > {{N}}) | "\(.title): \(.duration)ms"' .test-results.json

# Profile all tests
test-profile:
    vitest run --reporter=verbose --coverage
```

**Java:**
```just
# Run unit tests with timing
test:
    mvn test -Dsurefire.printSummary=true

# Show tests slower than N milliseconds
slowtests N="50":
    mvn test | grep "Time elapsed:" | awk -v n={{N}} '{ split($4,a,"."); if(a[1]*1000+a[2] > n) print $0 }'

# Profile all tests
test-profile:
    mvn test -X
```

**Standard interface update:**
- `test` command now ALWAYS shows timing (10 slowest by default)
- `slowtests` is new Level 1 command
- `test-profile` is new Level 1 command

#### 3b. Test Optimization Analysis

**New command:** `aug-dev/commands/test-optimize.md`

**Purpose:** Analyze test suite for speed and redundancy, create optimization issues

**Analysis process:**

1. **Speed analysis:**
   ```bash
   just slowtests 50
   ```
   - Identify tests >50ms
   - Analyze why (DB calls, external services, file I/O, computation)
   - Categorize: mock opportunities, in-memory DB, fixture optimization

2. **Redundancy analysis:**
   - **Semantic overlap:** Similar test inputs/assertions
   - **Logical subsumption:** Integration test covers unit test
   - **Copy-paste:** Similar test structure (DRY opportunities)

3. **DRY analysis:**
   - Repeated setup code → Extract to fixtures
   - Similar test patterns → Parameterize
   - Duplicate assertions → Test helpers

4. **Create issues:**
   ```markdown
   [test-optimization] Speed up user validation tests

   ## Current State
   - 5 tests averaging 180ms (target: <50ms)
   - Cause: Database calls per test case
   - Redundancy: 2 tests have overlapping assertions

   ## Approach
   1. Mock database calls with fixtures
   2. Use in-memory SQLite for DB-dependent tests
   3. Parameterize overlapping test cases
   4. Extract common setup to conftest.py fixture

   ## Expected Improvement
   - Speed: 180ms → <50ms (72% reduction)
   - Maintainability: 5 tests → 2 parameterized tests
   - Lines: -45 lines (DRY improvements)

   ## Acceptance Criteria
   - [ ] All validation tests <50ms
   - [ ] Coverage maintained at 96%
   - [ ] All original assertions still pass
   - [ ] just check-all passes
   ```

**Command interface:**
```bash
/test-optimize              # Analyze all modules
/test-optimize src/auth     # Analyze specific module
/test-optimize --dry-run    # Report only, no issues
```

**State tracking:** `.testaudit.yaml`
```yaml
version: 1

modules:
  src/auth:
    test_count: 45
    total_duration_ms: 5400
    avg_duration_ms: 120
    slow_tests: 5
    last_analyzed_commit: abc123
    last_analyzed_date: 2025-11-19T10:00:00Z
```

**Integration:**
- Creates GitHub issues with `[test-optimization]` prefix
- Feeds into `/work` workflow
- Similar pattern to `/refactor` and `/docsaudit`

---

### 4. Learning Assistant - Pattern Detection

**New skill:** `aug-core/skills/code-patterns/SKILL.md`

**Purpose:** Learn project conventions, suggest consistency improvements

**Commands:** `aug-core/commands/`
- `learn.md` - Analyze pattern usage in codebase
- `suggest.md` - Compare file to conventions
- `patterns.md` - Show all detected patterns

#### Pattern Types

**Error handling:**
```python
# Analyzes: try/except patterns, error classes, logging
# Detects: ErrorWrapper used in 80% of modules
# Suggests: Standardize on ErrorWrapper pattern
```

**Testing conventions:**
```python
# Analyzes: Fixture usage, test naming, mock patterns
# Detects: All tests use conftest.py fixtures
# Suggests: New test should use existing user_fixture
```

**Code organization:**
```python
# Analyzes: Import styles, module structure
# Detects: Absolute imports only, grouped by type
# Suggests: Fix relative imports in new module
```

**Naming conventions:**
```python
# Analyzes: Function/class/variable naming
# Detects: snake_case functions, PascalCase classes
# Suggests: Rename getUserData → get_user_data
```

**Architecture patterns:**
```python
# Analyzes: Dependency injection, layer separation
# Detects: Services injected via constructor
# Suggests: New controller should inject AuthService
```

#### Implementation

**Analysis method:**
- AST parsing for code structure
- Statistical analysis (80% = convention)
- Diff analysis (how does this file differ?)

**Command: `/learn [pattern-type]`**

```bash
/learn error-handling

→ Scans codebase
→ Finds error handling patterns:
  - 80% use ErrorWrapper class
  - 15% use status codes
  - 5% inconsistent
→ Recommends: Standardize on ErrorWrapper

Pattern: ErrorWrapper class
Usage: 80% (45/56 modules)
Example:
  try:
      result = do_something()
  except Exception as e:
      raise ErrorWrapper(e, context="user_validation")

Non-conforming modules:
  src/legacy/old_api.py - Uses status codes
  src/utils/helpers.py - Inconsistent handling
```

**Command: `/suggest [file]`**

```bash
/suggest src/features/new-auth.py

→ Analyzes file
→ Compares to project conventions
→ Suggests improvements:

Inconsistencies found:

1. Import style (line 1-5)
   Current: from ..models import User
   Convention: from myapp.models import User
   Fix: Use absolute imports

2. Error handling (line 23)
   Current: if not valid: return None
   Convention: raise ErrorWrapper(ValidationError(...))
   Fix: Use ErrorWrapper for validation errors

3. Function naming (line 45)
   Current: def getUserData()
   Convention: snake_case (get_user_data)
   Fix: Rename to get_user_data

4. Test location (tests/new_auth_test.py)
   Convention: tests/features/test_new_auth.py
   Fix: Move test file to match source structure
```

**Command: `/patterns`**

```bash
/patterns

Detected Conventions
====================

Error Handling:
  Style: ErrorWrapper class (80% adoption)
  Logging: Always log exceptions with context

Testing:
  Naming: test_<function>_<scenario>
  Fixtures: conftest.py (pytest)
  Mocking: @patch decorator

Imports:
  Style: Absolute only
  Grouping: stdlib, external, internal

Naming:
  Functions: snake_case
  Classes: PascalCase
  Constants: UPPER_SNAKE_CASE
  Private: _leading_underscore

Architecture:
  DI: Constructor injection
  Layers: controllers → services → repositories

Code Style:
  Line length: 88 chars (Black)
  Quotes: Double quotes
  Trailing commas: Always in multiline
```

#### Integration Points

**In /work workflow:**
- After implementation, run `/suggest` on modified files
- Create follow-up issue if major inconsistencies found
- Or auto-fix simple issues (imports, naming)

**In code review:**
- Part of `/autocommit` review process
- Check consistency with project patterns
- Flag deviations

**In /refactor:**
- Inconsistency as code smell
- Create refactoring issues for non-conforming code

---

### 5. Enhance /refactor - Add TODO Scanning

**Update:** `aug-dev/commands/refactor.md`

**Step 4 enhancement (Metrics Analysis):**

```markdown
**TODOs/FIXMEs:**
```bash
# Find TODO/FIXME/HACK comments
grep -rn "TODO\|FIXME\|HACK" <module-path> --include="*.py" --include="*.js" --include="*.ts" --include="*.java"
```
Count per file, add to metrics.

**For each file:**
- Complexity score
- Line count
- Duplicate percentage
- TODO count  ← NEW

**Prioritization includes TODO count:**
- High complexity + many TODOs = higher priority
- TODOs without complexity issues = lower priority
```

**Issue format enhancement:**

```markdown
[refactoring] Reduce complexity in src/auth/validate.py

## Current State
- Complexity: 18 (target: <10)
- Lines: 245
- TODOs: 3 unaddressed  ← NEW
- Issues: Long function, nested conditionals, magic strings

## Impact
- High complexity blocks maintenance
- TODOs indicate incomplete implementation
...
```

**No separate tech debt tracker needed** - folded into `/refactor`.

---

## Implementation Priority

1. **jscpd integration** (quickest win)
   - Add to justfile-quality-patterns
   - Integrate into /refactor
   - Document in skills

2. **Test timing enhancements** (justfile changes)
   - Update test commands to show durations
   - Add slowtests command
   - Add test-profile command

3. **Enhance /refactor with TODOs** (simple addition)
   - Add grep step
   - Update issue format

4. **/test-optimize command** (moderate complexity)
   - New command file
   - Analysis logic
   - Issue creation
   - State tracking

5. **/autocommit command** (workflow orchestration)
   - New command
   - Integration with /work
   - Code review agent invocation
   - Merge automation

6. **Learning assistant** (most complex)
   - New skill: code-patterns
   - Three new commands: learn, suggest, patterns
   - AST parsing and analysis
   - Pattern detection logic

---

## File Structure

**New files:**

```
aug-core/
├── commands/
│   ├── autocommit.md          # NEW
│   ├── learn.md               # NEW
│   ├── suggest.md             # NEW
│   └── patterns.md            # NEW
└── skills/
    └── code-patterns/         # NEW
        └── SKILL.md

aug-dev/
└── commands/
    └── test-optimize.md       # NEW

aug-just/
└── skills/
    └── justfile-quality-patterns/
        └── SKILL.md           # UPDATED (add duplicates, slowtests)
```

**Updated files:**

```
aug-dev/commands/refactor.md              # Add TODO scanning
aug-just/skills/justfile-interface/       # Update test command specs
aug-just/commands/just-init.md            # Generate with new commands
docs/RELEASE_NOTES_v3.md                  # Add these features
```

---

## Testing Plan

**jscpd integration:**
- Generate justfiles with new commands
- Run on known codebases
- Verify duplicate detection

**Test timing:**
- Test on all three stacks (Python, JS, Java)
- Verify slowtests output parsing
- Ensure timing doesn't break tests

**TODO scanning:**
- Run /refactor on codebases with TODOs
- Verify counts in issues
- Check prioritization adjustment

**/test-optimize:**
- Run on test suites with known slow tests
- Verify issue creation
- Check recommendations quality

**/autocommit:**
- Run full workflow on test issue
- Verify review catches issues
- Test merge automation

**Learning assistant:**
- Run on codebases with clear conventions
- Verify pattern detection accuracy
- Test suggestions on new code

---

## Documentation Updates

**README files:**
- aug-core/README.md - Add new commands
- aug-just/README.md - Update Level 1 description
- Root README.md - Mention new capabilities

**CLAUDE.md files:**
- aug-core/CLAUDE.md - Add commands and skills
- aug-dev/CLAUDE.md - Add test-optimize
- aug-just/CLAUDE.md - Update Level 1 patterns

**Release notes:**
- Update docs/RELEASE_NOTES_v3.md with final additions

---

## Success Criteria

V3 final additions succeed if:

1. ✅ **/autocommit completes full workflow** - issue → PR → merge without user interaction
2. ✅ **jscpd finds real duplicates** - identifies code that should be DRY'd
3. ✅ **slowtests identifies bottlenecks** - surfaces tests that need optimization
4. ✅ **/test-optimize creates actionable issues** - clear path to faster test suite
5. ✅ **Learning assistant detects conventions** - accurately identifies project patterns
6. ✅ **/suggest provides useful guidance** - helps maintain consistency

---

## Philosophy Alignment Check

All additions align with v3 core themes:

- ✅ **Autonomous execution** - /autocommit, /test-optimize create issues
- ✅ **Assessment-driven** - /learn analyzes before suggesting
- ✅ **Quality automation** - All create actionable improvements
- ✅ **Context-aware** - Learning assistant reads project context
- ✅ **Maturity-based** - jscpd/slowtests in Level 1 (opt-in)
- ✅ **YAGNI-enforced** - No mandatory complexity, add as needed

Ready for implementation.
