---
name: docsaudit
description: Audit documentation - create missing CLAUDE.md files, update stale docs, recommend improvements
---

# Documentation Audit

Automated documentation auditing using `documenting-with-audit` skill.

## Usage

```bash
/docsaudit                    # Full audit
/docsaudit --init             # Bootstrap .docsaudit.yaml only
/docsaudit path/to/module     # Audit specific directory
/docsaudit --dry-run          # Report only, no changes
/docsaudit --max-age 30       # Override time threshold (days)
```

## Instructions

### 1. Load Skill

Use `documenting-with-audit` skill for all audit logic.

### 2. Check for .docsaudit.yaml

**If missing:**
- Run bootstrap process
- Create `.docsaudit.yaml` with:
  - Default ignore patterns for detected stack
  - `max_age_days: 90` default
  - Empty `audits:` section initially
- Scan project for existing docs
- Initialize each in `audits` with:
  - Current HEAD commit
  - Current timestamp
  - Inferred scope (directory-based)
- Report: "Initialized audit tracking for N files"

**If exists:**
- Load current state
- Proceed with audit

### 3. Parse Options

**`--init`:**
- Bootstrap only, exit after creating `.docsaudit.yaml`
- Don't run full audit

**`path/to/module`:**
- Limit audit to specified directory and below
- Only check docs within that scope
- Update only those audit records

**`--dry-run`:**
- Run all analysis
- Generate all reports
- Don't modify any files
- Don't update `.docsaudit.yaml`
- Report what WOULD change

**`--max-age N`:**
- Override `max_age_days` from config
- Use N days as time-staleness threshold

### 4. Run Coverage Check

Using skill's coverage logic:

**Find all directories:**
```bash
find . -type d \
  ! -path '*/\.*' \
  ! -path '*/node_modules/*' \
  ! -path '*/dist/*' \
  ! -path '*/build/*'
```

**For each directory:**
1. Check if in ignore list
2. If ignored: skip (handle in ignore review)
3. If not ignored and no CLAUDE.md:
   - Analyze directory contents
   - Decide: needs CLAUDE.md?
   - If yes:
     - Generate CLAUDE.md using skill
     - Write file
     - Add to `audits` with current commit/date
     - Track for report: "Created"
   - If no:
     - Add pattern to ignore list
     - Track for report: "Ignored"

**Parallel processing:**
- Use Task tool for multiple CLAUDE.md generations
- Each directory independent

### 5. Run Ignore Review

**For each pattern in ignore list:**
1. Find directories matching pattern
2. For each matched directory:
   - Analyze current contents
   - Should this be un-ignored now?
   - If yes:
     - Remove from ignore list
     - Generate CLAUDE.md
     - Add to `audits`
     - Track for report: "Un-ignored"
   - If no:
     - Keep in ignore list

### 6. Run Freshness Check

**For each file in `audits`:**

1. **Get scope:**
   - Explicit scope from config, OR
   - Directory-based default

2. **Check code staleness:**
   ```bash
   git diff <last-commit>..HEAD -- <scope-patterns>
   ```
   - If diff non-empty → code stale

3. **Check time staleness:**
   ```python
   days_since(date) > max_age_days
   ```
   - If exceeded → time stale

4. **If stale (either trigger):**
   - Use skill to update doc
   - Write updated doc
   - Update `audits` entry:
     - `commit: <current-HEAD>`
     - `date: <now>`
   - Track for report: "Updated"

5. **If current:**
   - No action
   - Track for report: "Already current"

**Parallel processing:**
- Use Task tool for multiple doc updates
- Each doc independent

### 7. Run Sanity Check

Using skill's sanity logic:

**Analyze all docs for structural issues:**

**Consolidate detection:**
- Compare doc scopes
- Calculate content similarity
- If >70% similar: recommend consolidation

**Move detection:**
- Compare doc location to scope patterns
- Example: `docs/api.md` with scope `src/api/**/*`
- If mismatch: recommend move

**Delete detection:**
- Check if scope patterns match any files
- If scope empty (no matches): recommend delete

**Split detection:**
- Check doc size (line count)
- If >500 lines + multiple topics: recommend split

**Merge detection:**
- Find small docs (<50 lines each)
- Check if related scopes
- If related: recommend merge

**Collect recommendations** (don't apply).

### 8. Generate Report

**Format:**
```
Documentation Audit Report
=========================

Coverage (CLAUDE.md files):
  Created (N):
    + path/to/new.md (reason)
    + path/to/new2.md (reason)

  Un-ignored (N):
    + path/to/unignored.md (reason)

  Ignored (N):
    - path/to/ignored/ (reason)

Freshness (content updates):
  Updated (N):
    ~ path/to/updated.md (change summary)
    ~ path/to/updated2.md (change summary)

  Already current (N):
    ✓ path/to/current.md
    ✓ path/to/current2.md
    ... (show all)

Recommendations (review these):
  ⚠ Consolidate: path/A + path/B (70% overlap)
  ⚠ Move: path/C → suggested/location (scope mismatch)
  ⚠ Delete: path/D (no code in scope)
  ⚠ Split: path/E (850 lines, 5 topics)
  ⚠ Merge: path/F, path/G, path/H (related, <50 lines each)

Files changed: N
Review: git diff
Commit: git commit -am "docs: automated audit updates"
```

**Counts:**
- Total created
- Total un-ignored
- Total ignored (new)
- Total updated
- Total current
- Total recommendations

**Details:**
- List all created/updated files with reasons
- Show all recommendations with specifics
- Provide git commands for review/commit

### 9. Update .docsaudit.yaml

**If not --dry-run:**

Write updated `.docsaudit.yaml`:
```yaml
version: 1

ignore:
  # Updated ignore list
  - node_modules/**
  - .git/**
  # ... (including any new ignores)

max_age_days: 90

audits:
  # Updated audit records
  path/to/doc.md:
    commit: <new-commit>
    date: <new-date>
    scope: [...]
  # ... all docs
```

**If --dry-run:**
- Don't write file
- Report: "Dry run - no changes made"

### 10. Exit

**If changes made:**
- Exit code 0
- User reviews via `git diff`
- User commits or reverts

**If no changes:**
- Report: "Documentation up to date ✓"
- Exit code 0

**If errors:**
- Report errors clearly
- Exit code 1

## Examples

### First Run (Bootstrap)

```bash
$ /docsaudit --init

Creating .docsaudit.yaml...

Found 15 existing documentation files:
  README.md
  CONTRIBUTING.md
  docs/architecture.md
  ... (12 more)

Initialized audit tracking with:
  - Sensible ignore patterns (node_modules, .git, dist, etc.)
  - All existing docs at current commit
  - Default scope inferred for each
  - max_age_days: 90

Next: Run '/docsaudit' for full audit
```

### Full Audit (Changes Found)

```bash
$ /docsaudit

Documentation Audit Report
=========================

Coverage (CLAUDE.md files):
  Created (5):
    + src/api/v2/CLAUDE.md (new API module, 3 endpoints)
    + tests/integration/CLAUDE.md (integration test suite)
    + scripts/deployment/CLAUDE.md (deployment utilities)
    + src/utils/validators/CLAUDE.md (validation functions)
    + migrations/CLAUDE.md (database migrations)

  Un-ignored (2):
    + src/utils/legacy/CLAUDE.md (grew to 8 modules, needs docs)
    + data/seeds/CLAUDE.md (production seed data)

Freshness (content updates):
  Updated (7):
    ~ README.md (project structure changed, added new sections)
    ~ docs/architecture.md (auth system refactored to OAuth)
    ~ docs/api.md (3 new endpoints, updated error responses)
    ~ src/auth/CLAUDE.md (OAuth provider integration)
    ~ src/db/CLAUDE.md (migration system rewritten)
    ~ tests/CLAUDE.md (added performance test category)
    ~ .github/workflows/CLAUDE.md (CI updated for new checks)

  Already current (12):
    ✓ CONTRIBUTING.md
    ✓ docs/deployment.md
    ✓ docs/testing.md
    ✓ src/api/v1/CLAUDE.md
    ... (8 more)

Recommendations (review these):
  ⚠ Consolidate: docs/api.md + docs/endpoints.md (95% overlap)
  ⚠ Move: docs/database.md → src/db/CLAUDE.md (better location)
  ⚠ Consider deleting: docs/old-v1-api.md (no code in scope)
  ⚠ Split: README.md (847 lines, extract setup guide)

Files changed: 14
Review: git diff
Commit: git commit -am "docs: automated audit updates"
```

### Specific Directory

```bash
$ /docsaudit src/auth

Documentation Audit Report
=========================

Scope: src/auth

Coverage (CLAUDE.md files):
  Already exists: src/auth/CLAUDE.md

Freshness (content updates):
  Updated (1):
    ~ src/auth/CLAUDE.md (OAuth refactor, new providers)

Recommendations:
  None

Files changed: 1
Review: git diff src/auth/
```

### Dry Run

```bash
$ /docsaudit --dry-run

Documentation Audit Report (DRY RUN)
===================================

Coverage (CLAUDE.md files):
  Would create (3):
    + src/new-module/CLAUDE.md
    + tests/e2e/CLAUDE.md
    + scripts/monitoring/CLAUDE.md

Freshness (content updates):
  Would update (5):
    ~ README.md
    ~ docs/api.md
    ... (3 more)

Recommendations:
  ⚠ Consolidate: docs/api.md + docs/endpoints.md

DRY RUN - No changes made
Run without --dry-run to apply changes
```

### No Changes Needed

```bash
$ /docsaudit

Documentation Audit Report
=========================

Coverage: ✓ Complete (all directories documented)
Freshness: ✓ Current (no stale docs)
Recommendations: None

Documentation up to date ✓
```

## Error Handling

**Git errors:**
```
Error: git diff failed for docs/api.md
  Reason: <error message>
  Skipping this file, continuing audit...
```

**File access errors:**
```
Error: Cannot write to src/new/CLAUDE.md
  Reason: Permission denied
  Skipping, please check permissions
```

**Parse errors:**
```
Warning: Cannot parse .docsaudit.yaml
  Attempting to fix common issues...
  If persists, delete and re-run with --init
```

**Continue on recoverable errors, report clearly.**

## Notes

- Audit is idempotent - safe to run multiple times
- First run bootstrap creates .docsaudit.yaml
- Regular audits keep docs fresh
- Git provides review mechanism
- Commit or revert based on git diff
- Use Task tool for parallel processing
- Fail gracefully, report errors clearly
