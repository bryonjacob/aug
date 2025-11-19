---
name: refactor
description: Autonomous code quality analysis - find refactoring opportunities, create GitHub issues
---

# Refactoring Analysis

Autonomous analysis to find refactoring opportunities and create detailed GitHub issues.

## Usage

```bash
/refactor              # Analyze changed modules
/refactor src/auth     # Analyze specific module only
/refactor --force      # Re-analyze all, ignore state
/refactor --dry-run    # Report only, don't create issues
```

## Instructions

### 1. Bootstrap State (if needed)

**Check for `.refactoraudit.yaml`:**

**If missing:**
- Create with template
- Find all CLAUDE.md directories (these are modules)
- Initialize each module with current HEAD commit
- Set dates to now

```yaml
version: 1

modules:
  src/auth:
    last_analyzed_commit: <current-HEAD>
    last_analyzed_date: <now-ISO8601>

  src/api:
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

**If specific module provided:** (`/refactor src/auth`)
- Analyze only that module
- Update only that module's state

**If `--force` flag:**
- Analyze ALL modules
- Ignore last_analyzed_commit

**Otherwise (normal mode):**
- For each module, check if changed:
  ```bash
  git diff <last-analyzed-commit>..HEAD -- <module-path>
  ```
- If diff non-empty → analyze
- If no diff → skip
- If never analyzed (not in state) → analyze

**Track:**
- Modules to analyze
- Modules skipped (unchanged)

### 4. Metrics Analysis (Cheap)

For each module to analyze:

**Complexity:**
```bash
just complexity
```
Parse output, find files with complexity >10:
- Python: radon cc output
- JavaScript: eslint complexity output
- Java: checkstyle/PMD output

**File size:**
```bash
just loc
```
Parse output, find files >500 lines.

**Duplicates:**
```bash
# Prefer justfile command if available
just duplicates
# Or direct: jscpd <module-path> --threshold 30
```
Parse output, find files with >30% duplicate code.

**TODOs/FIXMEs:**
```bash
# Find TODO/FIXME/HACK comments
grep -rn "TODO\|FIXME\|HACK" <module-path> --include="*.py" --include="*.js" --include="*.ts" --include="*.tsx" --include="*.java"
```
Count per file, add to metrics.

**Result:** List of candidate files per module with metrics (complexity, LOC, duplicates, TODOs).

### 5. Deep Code Analysis (Expensive)

For each candidate file:

**Read file contents.**

**Detect common smells:**

- **Long functions:**
  - Parse file, find functions >50 lines
  - Estimate extraction opportunities

- **Long parameter lists:**
  - Find functions with >5 parameters
  - Assess if parameters should be objects

- **Deeply nested conditionals:**
  - Find if/else nesting >3 levels
  - Identify guard clause opportunities

- **Repeated code blocks:**
  - Find similar code patterns in same file
  - Estimate extraction potential

- **Magic numbers/strings:**
  - Find hardcoded values
  - Assess if should be constants

**Detect architectural smells:**

- **God objects:**
  - Classes with >10 methods or >10 responsibilities
  - Assess split opportunities

- **Feature envy:**
  - Methods using other class more than own
  - Identify potential moves

- **Leaky abstractions:**
  - Implementation details exposed in interface
  - Assess encapsulation improvements

- **Tight coupling:**
  - High import/dependency count
  - Identify decoupling opportunities

- **Circular dependencies:**
  - Module A imports B imports A
  - Identify break points

**For each smell found, create opportunity record:**
```python
{
  'file': 'src/auth/validate.py',
  'type': 'complexity',
  'current': 18,
  'target': 10,
  'issues': ['long_function', 'nested_conditionals', 'magic_strings'],
  'todos': 3,  # count of TODO/FIXME/HACK comments
  'duplicates_pct': 15,  # percentage of duplicate code
  'approach': ['extract_email_validation', 'guard_clauses', 'extract_constants'],
  'scope': 'single file',
  'coupling': 15,  # call sites
  'module_criticality': 'high'  # auth is critical
}
```

### 6. Prioritization

For each opportunity, calculate:

**Impact score (0-10):**
- Complexity reduction: (current - target) / current × 10
- Maintainability: subjective assessment
- Code reuse: number of similar patterns eliminated
- Performance: estimated improvement

**Risk score (0-10):**
- Scope: single function (2) < file (5) < module (8) < cross-module (10)
- Current complexity: higher = riskier
- Coupling: more call sites = riskier
- Module criticality: auth/security (10) > api (7) > util (3)

**Priority:**
```
priority = impact / (risk + 1)  # +1 to avoid division by zero
```

**Sort opportunities by priority (high to low).**

**No filtering** - create issues for all opportunities, let GitHub handle queue.

### 7. Check Existing Issues

**Search GitHub for open refactoring issues:**
```bash
gh issue list --search "is:open [refactoring]" --json number,title,body
```

**Parse results, extract:**
- Issue numbers
- File paths mentioned
- Types of refactoring

**For each opportunity:**
- Check if similar issue already exists
- If yes: skip, log "Similar to #N"
- If no: proceed to create

### 8. Create GitHub Issues

For each new opportunity:

**Format:**
```markdown
[refactoring] <Short description>

## Current State
- Complexity: <current> (target: <target>)
- Lines: <line-count>
- TODOs: <count> unaddressed
- Duplicates: <percentage>% (if >30%)
- Issues: <smell-list>

## Impact
<Why this matters - maintainability, testing, performance>
<Mention TODOs as incomplete implementation if present>

## Approach
1. <Step 1>
2. <Step 2>
3. <Step 3>
...

## Acceptance Criteria
- [ ] Complexity reduced to <<target>>
- [ ] All tests pass (just test)
- [ ] Coverage maintained at 96% (just coverage)
- [ ] No behavior changes (RED-GREEN-REFACTOR)
- [ ] just check-all passes

## Estimated Impact
Risk: <Low|Medium|High> (<reason>)
Impact: <Low|Medium|High> (<reason>)
Priority: <score>/10

## Notes
- Test coverage: <percentage>
- Call sites: <count>
- Related issues: <if any>
```

**Create issue via GitHub CLI:**
```bash
gh issue create \
  --title "[refactoring] <title>" \
  --body "<formatted-body>" \
  --label "refactoring"
```

**Track created issue numbers.**

### 9. Update State File

**Update `.refactoraudit.yaml`:**

For each analyzed module:
```yaml
modules:
  <module-path>:
    last_analyzed_commit: <current-HEAD>
    last_analyzed_date: <now-ISO8601>
```

**If module deferred, keep note:**
```yaml
src/legacy:
  last_analyzed_commit: abc123
  last_analyzed_date: 2025-11-19T10:00:00Z
  deferred: "Being replaced Q1 2026"
```

**Write updated file.**

### 10. Generate Report

**Format:**
```
Refactoring Analysis Report
===========================

Analyzed modules: <N> (<changed>, <unchanged>)

Module status:
  ✓ <module> (changed, analyzed)
  ✓ <module> (changed, analyzed)
  - <module> (unchanged, skipped)
  × <module> (deferred: <reason>)

Opportunities found: <N>

High Priority (8-10):
  1. <file>
     Complexity: <current> → <<target>>
     Issues: <smell-list>

  2. <file>
     Issues: <smell-list>

Medium Priority (5-7):
  3. <file>
     Issues: <smell-list>

Low Priority (3-4):
  4. <file>
     Issues: <smell-list>

Checking GitHub for existing [refactoring] issues...
Found: <N> open refactoring issues

Creating <N> new issues...
  ✓ #<num>: [refactoring] <title>
  ✓ #<num>: [refactoring] <title>
  - Skipped: <file> (similar to #<num>)

Updated .refactoraudit.yaml

Next steps:
  Review issues: gh issue list --search "[refactoring]"
  Execute: /work <issue-number>
```

**Symbols:**
- `✓` Analyzed/created
- `-` Skipped
- `×` Deferred/error

### 11. Exit

**If issues created:**
- Report count and links
- Suggest: `gh issue list --search "[refactoring]"`
- Suggest: `/work <issue-number>`

**If no opportunities:**
```
No refactoring opportunities found.

All analyzed modules meet quality standards:
- Complexity <10
- File sizes reasonable
- No significant code smells

Code quality: ✓ Excellent
```

**If errors:**
- Report clearly
- Exit code 1

## Options Handling

**`--dry-run`:**
- Run all analysis
- Generate report
- Don't create GitHub issues
- Don't update `.refactoraudit.yaml`
- Show what WOULD be created

**`--force`:**
- Ignore last_analyzed_commit
- Analyze all modules regardless of changes
- Useful after changing analysis algorithms
- Still check for duplicate issues

**`<module-path>`:**
- Analyze only specified module
- Must be a directory with CLAUDE.md
- Update only that module's state
- Example: `/refactor src/auth`

## Error Handling

**No CLAUDE.md files:**
```
Error: No modules found

This command requires CLAUDE.md files to define modules.
Run '/docsaudit' to create CLAUDE.md hierarchy.
```

**No justfile commands:**
```
Error: Required command not found: just complexity

This command requires justfile-standard-interface.
See: aug-dev/skills/justfile-standard-interface
```

**GitHub CLI not available:**
```
Error: GitHub CLI (gh) not found

Install: https://cli.github.com/
Or use --dry-run to see analysis without creating issues
```

**GitHub API rate limit:**
```
Warning: GitHub API rate limit reached

Created <N> issues before limit.
Remaining <N> opportunities saved to refactor-queue.yaml
Run again later to create remaining issues.
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
$ /refactor

Creating .refactoraudit.yaml...

Found 5 modules (directories with CLAUDE.md):
  src/auth
  src/api
  src/db
  src/utils
  tests

Initialized state, analyzing all modules...

[Analysis proceeds]

Opportunities found: 8

Created 8 GitHub issues (#101-108)
```

### Normal Run (Some Changed)

```bash
$ /refactor

Loading .refactoraudit.yaml...

Modules: 5 total
  2 changed since last analysis
  3 unchanged (skipped)

Analyzing: src/auth, src/api

Opportunities found: 3

High Priority (8-10):
  1. src/auth/validate.py (complexity 18, nested conditionals)

Medium Priority (5-7):
  2. src/api/routes.py (god object, 15 responsibilities)
  3. src/api/middleware.py (duplicate code 45%)

Checking GitHub...
Found 2 open [refactoring] issues (different targets)

Creating 3 new issues...
  ✓ #109: [refactoring] Reduce complexity in src/auth/validate.py
  ✓ #110: [refactoring] Split god object in src/api/routes.py
  ✓ #111: [refactoring] Remove duplicates in src/api/middleware.py

Next: /work 109
```

### No Changes

```bash
$ /refactor

No modules changed since last analysis.

All modules current:
  src/auth (last analyzed: 2025-11-18)
  src/api (last analyzed: 2025-11-18)
  src/db (last analyzed: 2025-11-17)

Use --force to re-analyze all modules.
```

### Specific Module

```bash
$ /refactor src/auth

Analyzing: src/auth only

Opportunities found: 1

High Priority (9/10):
  1. src/auth/validate.py (complexity 18)

Creating 1 issue...
  ✓ #112: [refactoring] Reduce complexity in src/auth/validate.py
```

### Dry Run

```bash
$ /refactor --dry-run

DRY RUN - No issues will be created

[Full analysis proceeds]

Would create 5 issues:
  1. #xxx: [refactoring] Reduce complexity in src/auth/validate.py
  2. #xxx: [refactoring] Split god object in src/api/routes.py
  ... (3 more)

Run without --dry-run to create these issues.
```

## Notes

- Requires CLAUDE.md files (run `/docsaudit` first)
- Requires justfile-standard-interface
- Requires 96% test coverage (prerequisite for refactoring)
- Uses GitHub CLI for issue creation
- Module-level state tracking (lightweight)
- Creates issues for all opportunities (no artificial limits)
- Execution via `/work` uses existing refactoring skill
- Safe to run repeatedly (checks for changes, avoids duplicates)
