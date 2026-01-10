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

```bash
just complexity    # Find files with complexity >10
just loc           # Find files >500 lines
just duplicates    # Find >30% duplicate code (if available)
```

Also find TODO/FIXME/HACK comments per file.

**Result:** List of candidate files with metrics (complexity, LOC, duplicates, TODOs).

### 5. Deep Code Analysis (Expensive)

For each candidate file, read contents and detect code smells using `refactoring` skill knowledge.

Create opportunity record for each finding with:
- File path, type, current/target metrics
- Identified issues and suggested approach
- Scope and coupling assessment

### 6. Prioritization

Use `refactoring` skill to prioritize by impact/risk. Sort by priority (high to low). Create issues for all opportunities.

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

This command requires aug-just plugin with justfile Level 1+ (quality patterns).
Install: /plugin install aug-just@aug
Then run: /just-init [stack] or /just-upgrade quality
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

## Example

```bash
$ /refactor

Modules: 5 total (2 changed, 3 skipped)
Opportunities found: 3

Creating issues...
  ✓ #109: [refactoring] Reduce complexity in src/auth/validate.py
  ✓ #110: [refactoring] Split god object in src/api/routes.py
  ✓ #111: [refactoring] Remove duplicates in src/api/middleware.py

Next: /work 109
```

## Notes

- Requires CLAUDE.md files (run `/docsaudit` first)
- Requires aug-just plugin with Level 1+ (quality patterns)
- Requires 96% test coverage (prerequisite for refactoring)
- Uses GitHub CLI for issue creation
- Module-level state tracking (lightweight)
- Creates issues for all opportunities (no artificial limits)
- Execution via `/work` uses existing refactoring skill
- Safe to run repeatedly (checks for changes, avoids duplicates)
