# Documentation Auditing System

**Date:** 2025-11-19
**Status:** Approved
**Implementation:** aug-dev skill + command

## Purpose

Automated system to ensure documentation stays complete, comprehensive, accurate, and up-to-date across all projects. Focuses on CLAUDE.md hierarchy but handles all documentation files.

## Problem

Documentation drifts from code:
- Code changes, docs don't update
- New modules lack documentation
- Docs become obsolete or redundant
- Manual audits are expensive and error-prone

## Solution

**Automated auditor** that:
1. Ensures every meaningful directory has CLAUDE.md
2. Tracks documentation freshness via git commits + timestamps
3. Automatically updates stale docs when code changes
4. Recommends structural improvements (consolidate/move/delete)
5. Uses git for review/approval (commit or revert)

---

## Architecture

### State Tracking: `.docsaudit.yaml`

**Format:**
```yaml
version: 1

# Gitignore-style patterns for directories to skip
ignore:
  - node_modules/**
  - .git/**
  - dist/**
  - build/**
  - __pycache__/**
  - "*.pyc"

# Optional: time-based staleness threshold
max_age_days: 90

# Audit records for each documented file
audits:
  README.md:
    commit: abc123def456      # Git commit when last audited
    date: 2025-01-18T10:30:00Z  # ISO timestamp
    scope: ["**/*"]           # Files this doc describes

  docs/architecture.md:
    commit: 789ghi012jkl
    date: 2025-01-15T14:20:00Z
    scope: ["src/**/*"]

  src/auth/CLAUDE.md:
    commit: 345mno678pqr
    date: 2025-01-10T09:00:00Z
    # No scope = directory-based default (src/auth/**/*)

  CONTRIBUTING.md:
    commit: 901stu234vwx
    date: 2025-01-18T10:30:00Z
    scope: []  # Explicit empty = no code dependencies
```

**Bootstrap (first run):**
- Creates `.docsaudit.yaml` if missing
- Scans project for all docs
- Initializes with current HEAD commit
- Sets dates to now
- Infers scopes (directory-based)
- Adds sensible ignore patterns

---

## Scope Rules

**Scope = glob patterns defining which files a doc describes**

### Default Scope (directory-based)

Every doc automatically scopes to its directory:
- `README.md` (at root) → `**/*` (whole project)
- `src/auth/CLAUDE.md` → `src/auth/**/*`
- `docs/api.md` → `docs/**/*`

Consistent, predictable, no special cases.

### Explicit Override

```yaml
docs/api.md:
  scope: ["src/api/**/*"]  # Override: track API code, not docs dir
```

### Truly Independent

```yaml
CONTRIBUTING.md:
  scope: []  # Must be explicit - no code dependencies
```

### Staleness Detection

Doc is stale if EITHER:
1. **Code changed**: Files in scope modified since `commit`
2. **Time passed**: More than `max_age_days` since `date`

---

## Audit Process

**Command: `/docsaudit`**

### Step 1: Coverage Check

Find all directories (excluding hidden):
- Check against ignore patterns
- For non-ignored dirs without CLAUDE.md:
  - Analyze contents (meaningful code/content?)
  - **If yes**: Auto-create CLAUDE.md
  - **If no**: Add to ignore list

**Decision criteria:**
- Would a CLAUDE.md help understand this part?
- Even 2-line CLAUDE.md beats nothing
- Consider ALL file types, not just code
- Data/assets might need docs too

### Step 2: Ignore List Review

For each ignored directory:
- Analyze current contents
- Has it grown meaningful?
- **If yes**: Un-ignore + create CLAUDE.md
- **If no**: Keep ignored

### Step 3: Freshness Check

For each doc in `audits`:
- Get scope (explicit or directory default)
- Check staleness:
  - `git diff <last-commit>..HEAD -- <scope-patterns>`
  - `days_since(date) > max_age_days`
- **If stale**: Automatically update doc
- Update `audits` with new commit/date

### Step 4: Sanity Check

Analyze doc structure, **present recommendations**:
- **Consolidate**: Multiple docs with 70%+ overlap
- **Move**: Doc location vs scope mismatch
- **Delete**: Scope matches zero files (obsolete)
- **Split**: Oversized doc (>500 lines, multiple topics)
- **Merge**: Multiple tiny docs (<50 lines) with related scope

Don't auto-apply - bigger decisions need human judgment.

### Step 5: Update State

- Write new `.docsaudit.yaml`
- All changes staged for git review
- User commits or reverts

---

## Command Interface

**Syntax:**
```bash
/docsaudit                    # Full audit
/docsaudit --init             # Bootstrap only
/docsaudit path/to/module     # Audit specific directory
/docsaudit --dry-run          # Report only, no changes
/docsaudit --max-age 30       # Override time threshold
```

**Output:**
```
Documentation Audit Report

Coverage (CLAUDE.md files):
  Created (5):
    + src/api/v2/CLAUDE.md
    + tests/integration/CLAUDE.md

  Un-ignored (2):
    + src/utils/legacy/CLAUDE.md (grew to 8 modules)

Freshness (content updates):
  Updated (7):
    ~ README.md
    ~ docs/architecture.md
    ~ src/auth/CLAUDE.md

  Already current (12):
    ✓ CONTRIBUTING.md
    ✓ docs/deployment.md

Recommendations:
  ⚠ Consolidate: docs/api.md + docs/endpoints.md
  ⚠ Move: docs/database.md → src/db/CLAUDE.md
  ⚠ Delete: docs/old-v1-api.md (no code in scope)

Files changed: 14
Review: git diff
Commit: git commit -am "docs: automated audit"
```

---

## Implementation

### Components

**Skill:** `aug-dev/skills/documenting-with-audit/`
- Core audit logic
- CLAUDE.md generation
- Doc update analysis
- Sanity check detection

**Command:** `aug-dev/commands/docsaudit.md`
- Orchestrates skill
- Handles git operations
- Manages `.docsaudit.yaml`
- Formats output

### CLAUDE.md Generation

Template for new files:
```markdown
# [Module Name]

## Purpose
[1-2 sentences: what this does]

## Key Components
- [file/class]: [purpose]

## Dependencies
- Uses: [other modules]
- Used by: [other modules]

## Notes
[Important context]
```

Analysis process:
1. Read filenames, directory structure
2. Sample code (imports, exports, signatures)
3. Check existing README/comments
4. Generate concise, contextual CLAUDE.md

### Doc Updates

Process:
1. `git diff <last-commit>..HEAD -- <scope>`
2. Summarize changes (added/removed/modified files)
3. Read current doc
4. Identify sections needing updates
5. Rewrite affected sections
6. Preserve doc structure/style

### Parallel Processing

Use Task tool to parallelize:
- Multiple doc updates simultaneously
- Each doc update is independent
- Faster for large projects

---

## Edge Cases

**Simple handling (YAGNI):**
- **Large repos**: Full audit always (repos not that huge)
- **Merge conflicts**: Manual resolution (rare)
- **Binary files**: Doc if meaningful, ignore if not
- **Generated docs**: Only audit checked-in files
- **Git errors**: Fail gracefully with clear message

---

## Future Enhancements

**Not in v1 (add later if needed):**
- Integration with `/work`, `/devinit`
- Pre-commit hook automation
- Incremental mode for huge repos
- Cache optimization
- CI/CD enforcement
- Slack/notification on staleness

**Start simple, grow as needed.**

---

## Success Criteria

Audit system working if:
1. **Coverage**: Every meaningful directory has CLAUDE.md
2. **Freshness**: Docs update automatically when code changes
3. **Sanity**: Structural issues flagged for review
4. **Workflow**: `git diff` → review → commit/revert
5. **Zero manual tracking**: System manages state automatically

---

## Design Decisions

**Why YAML over INI?**
- Structured data (commit + date + scope)
- Extensible (can add fields later)
- Standard, parseable, git-friendly

**Why directory-based scope default?**
- Predictable, consistent behavior
- Matches mental model (docs describe their location)
- Can override when needed

**Why automated updates vs recommendations?**
- Content updates: low-risk, easy to revert
- Structure changes: higher-risk, need judgment
- Git provides review mechanism for both

**Why track both commit and date?**
- Commit: Code change detection
- Date: Time-based audits (catch scope drift)
- Both: Complete freshness picture

**Why comprehensive CLAUDE.md coverage?**
- Context is cheap (text files)
- Missing context is expensive (confusion, mistakes)
- AI system prompt benefits from everywhere

---

## Implementation Plan

1. Create skill: `documenting-with-audit`
2. Create command: `/docsaudit`
3. Test on aug repo itself
4. Iterate on generation quality
5. Deploy to other projects

**Philosophy: Simple, automated, git-native.**
