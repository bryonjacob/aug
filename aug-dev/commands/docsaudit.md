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

Use skill's sanity check patterns to detect:
- Consolidation opportunities (>70% content overlap)
- Location mismatches (doc vs scope)
- Empty scopes (orphaned docs)
- Large docs to split (>500 lines)
- Small docs to merge (<50 lines, related scopes)

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

## Example

```bash
$ /docsaudit

Documentation Audit Report
=========================

Coverage: Created 3, Un-ignored 1
Freshness: Updated 5, Current 12
Recommendations: 2 (consolidate, split)

Files changed: 9
Review: git diff
Commit: git commit -am "docs: automated audit"
```

## Error Handling

Continues on recoverable errors (git failures, permission issues), reports clearly.

## Notes

- Audit is idempotent - safe to run multiple times
- First run bootstrap creates .docsaudit.yaml
- Regular audits keep docs fresh
- Git provides review mechanism
- Commit or revert based on git diff
- Use Task tool for parallel processing
- Fail gracefully, report errors clearly
