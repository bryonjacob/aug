# Autonomous Refactoring Analysis System

**Date:** 2025-11-19
**Status:** Approved
**Implementation:** aug-dev command + skill update

## Purpose

Autonomous code quality analysis that identifies refactoring opportunities and creates detailed GitHub issues for execution.

## Problem

Finding refactoring opportunities is manual:
- Run `just complexity` manually
- Scan for issues manually
- Decide what to refactor manually
- Create issues manually

This is time-consuming and inconsistent.

## Solution

**`/refactor` command** that autonomously:
1. Analyzes codebase (metrics + code smells)
2. Identifies refactoring opportunities
3. Prioritizes by risk-adjusted impact
4. Creates comprehensive GitHub issues
5. Feeds into existing `/work` workflow

**Key insight:** Separate finding WHAT to refactor from executing HOW to refactor.

---

## Architecture

### Workflow

```
/refactor
  ↓ Discover modules (CLAUDE.md directories)
  ↓ Check which changed since last analysis
  ↓ Run metrics analysis (complexity, LOC, duplicates)
  ↓ Deep code analysis (smells, architectural issues)
  ↓ Prioritize by risk-adjusted impact
  ↓ Check GitHub for existing [refactoring] issues
  ↓ Create detailed issues for new opportunities
  ↓ Update .refactoraudit.yaml

/work 101  # Execute first refactoring
/work 102  # Execute second refactoring
```

### Module Boundaries

**Modules = directories with CLAUDE.md**

- Reuse existing documentation structure
- Examples: `src/auth/`, `src/api/`, `src/db/`
- Natural, meaningful divisions
- Already maintained via `/docsaudit`

### State Tracking: `.refactoraudit.yaml`

Lightweight module-level tracking to avoid redundant analysis.

```yaml
version: 1

modules:
  src/auth:
    last_analyzed_commit: abc123def456
    last_analyzed_date: 2025-11-19T10:30:00Z

  src/api:
    last_analyzed_commit: 789ghi012jkl
    last_analyzed_date: 2025-11-18T14:20:00Z

  src/db:
    last_analyzed_commit: 345mno678pqr
    last_analyzed_date: 2025-11-15T09:00:00Z
    deferred: "Planned rewrite Q1 2026, defer refactoring"
```

**Tracks:**
- Last analysis commit per module
- Analysis timestamp
- Optional deferral notes

**Bootstrap:**
- Auto-create if missing
- Initialize all CLAUDE.md modules at current commit
- No explicit `--init` flag needed

### Issue Tracking: GitHub

**All refactoring issues have `[refactoring]` prefix:**
- Easy to search: `is:open [refactoring]`
- Avoids duplicate issue creation
- GitHub is source of truth for queued work

**Before creating issue:**
```bash
gh issue list --search "is:open [refactoring]"
```

Check if similar opportunity already queued.

---

## Analysis Process

### Step 1: Module Discovery

Find all directories with CLAUDE.md:
```bash
find . -name "CLAUDE.md" -type f -exec dirname {} \;
```

These define modules for analysis.

### Step 2: Change Detection

For each module, check `.refactoraudit.yaml`:
```bash
git diff <last-commit>..HEAD -- <module-path>
```

**If changed** → analyze
**If unchanged** → skip
**If never analyzed** → analyze

Avoids redundant expensive analysis.

### Step 3: Metrics Analysis (Cheap)

For modules needing analysis:

**Complexity:**
```bash
just complexity
# Python: radon cc (>10)
# JavaScript: eslint complexity (>10)
# Java: checkstyle/PMD (>10)
```

**File size:**
```bash
just loc
# Files >500 lines
```

**Duplicates:**
```bash
# jscpd or language-specific duplicate detection
# Threshold: >30% duplicate code
```

This gives candidate list quickly.

### Step 4: Deep Code Analysis (Expensive)

For candidate files, detect smells:

**Common Smells:**
- **Long functions:** >50 lines
- **Long parameter lists:** >5 parameters
- **Deeply nested conditionals:** >3 levels
- **Repeated code blocks:** Similar patterns in same file
- **Magic numbers/strings:** Hardcoded values

**Architectural Smells:**
- **God objects:** Class with >10 responsibilities
- **Feature envy:** Method using other class more than its own
- **Leaky abstractions:** Implementation details exposed
- **Tight coupling:** High dependency count
- **Circular dependencies:** Module dependency cycles

**Analysis method:**
- Read file contents
- Parse structure (AST if available)
- Identify patterns
- Assess severity
- Estimate refactoring effort

### Step 5: Prioritization

Score each opportunity:

```
Priority = Impact / Risk

Impact factors:
  - Complexity reduction (18 → 8)
  - Maintainability improvement
  - Code reuse potential
  - Performance gains

Risk factors:
  - Scope of change (function vs module)
  - Current code complexity
  - Coupling level (call sites)
  - Module criticality (auth vs util)

Priority score: 0-10
```

**Create issues for all opportunities** - let GitHub handle queue management.

---

## GitHub Issue Format

**Comprehensive format for `/work` execution:**

```markdown
[refactoring] Reduce complexity in src/auth/validate.py

## Current State
- Complexity: 18
- Target: <10
- Lines: 245
- Issues: Long function, nested conditionals, magic strings

## Impact
- High complexity blocks maintenance
- Error-prone due to nested logic
- Difficult to test edge cases

## Approach
1. Extract email validation to separate function
2. Extract password validation to separate function
3. Replace nested if/else with guard clauses
4. Extract magic strings to constants
5. Add docstrings to extracted functions

## Acceptance Criteria
- [ ] Complexity reduced to <10
- [ ] All tests pass (just test)
- [ ] Coverage maintained at 96% (just coverage)
- [ ] No behavior changes (RED-GREEN-REFACTOR)
- [ ] just check-all passes

## Estimated Impact
Risk: Medium (well-tested module, clear extraction targets)
Impact: High (improves maintainability, enables future features)
Priority: 7.5/10

## Notes
- Module has 96% test coverage
- 15 call sites (check after refactoring)
- Related to issue #87 (authentication refactor)
```

**Structure matches `/plan-create` output** - ready for `/work` execution.

---

## Command Interface

**Syntax:**
```bash
/refactor              # Analyze changed modules (auto-init if needed)
/refactor src/auth     # Analyze specific module only
/refactor --force      # Re-analyze all, ignore last-analyzed state
/refactor --dry-run    # Report opportunities, don't create issues
```

**Output:**
```
Refactoring Analysis Report
===========================

Analyzed modules: 3 (2 changed, 1 unchanged)

Module status:
  ✓ src/auth (changed, analyzed)
  ✓ src/api (changed, analyzed)
  - src/db (unchanged, skipped)

Opportunities found: 5

High Priority (8-10):
  1. src/auth/validate.py
     Complexity: 18 → <10
     Issues: Long function, nested conditionals, magic strings

  2. src/api/routes.py
     Issues: God object (15 responsibilities), duplicate code 45%

Medium Priority (5-7):
  3. src/db/query.py
     Issues: Leaky abstraction (SQL exposed to callers)

  4. src/utils/parser.py
     Complexity: 12 → <10
     Issues: Nested conditionals (4 levels deep)

Low Priority (3-4):
  5. src/config/settings.py
     Issues: Magic strings (12 hardcoded values)

Checking GitHub for existing [refactoring] issues...
Found: 2 open refactoring issues (different targets)

Creating 5 new issues...
  ✓ #101: [refactoring] Reduce complexity in src/auth/validate.py
  ✓ #102: [refactoring] Split god object in src/api/routes.py
  ✓ #103: [refactoring] Encapsulate SQL in src/db/query.py
  ✓ #104: [refactoring] Simplify conditionals in src/utils/parser.py
  ✓ #105: [refactoring] Extract constants in src/config/settings.py

Updated .refactoraudit.yaml

Next steps:
  Review issues: gh issue list --search "[refactoring]"
  Execute: /work 101
```

---

## Integration with Existing Skill

**Current `refactoring` skill** - Execution guide
- HOW to refactor safely
- RED-GREEN-REFACTOR cycle
- Small steps with tests
- Quality gates (96% coverage, just check-all)

**New `/refactor` command** - Opportunity finder
- WHAT to refactor
- Autonomous analysis
- Issue creation
- Queue management

**Together:**
```
/refactor          # Find opportunities, create issues
  ↓
GitHub           # Review and prioritize
  ↓
/work 101        # Execute (uses existing refactoring skill)
  ↓
PR + merge       # Standard workflow
```

**The existing skill remains the execution guide.** The command adds autonomous opportunity identification.

---

## Prerequisites

**From justfile-standard-interface:**
- `just complexity` - Detect high complexity
- `just loc` - Find large files
- `just coverage` - Verify 96% coverage
- `just test` - Run tests
- `just check-all` - Quality gate

**From CLAUDE.md hierarchy:**
- Module boundaries defined
- Existing documentation structure

**From existing refactoring skill:**
- Execution methodology (RED-GREEN-REFACTOR)
- Coverage requirement (96%)
- Quality gates

**Everything already in place.**

---

## Design Decisions

**Why module-level tracking, not per-file?**
- Simpler, less state
- CLAUDE.md defines natural boundaries
- `git diff` on module shows all changes
- Avoids state file bloat

**Why GitHub for issue tracking, not state file?**
- GitHub is source of truth for work queue
- Issues have rich UI (labels, assignees, milestones)
- Avoid duplicating GitHub in state file
- `[refactoring]` prefix enables easy filtering

**Why both metrics and code smells?**
- Metrics find candidates quickly (cheap)
- Code smells assess quality deeply (expensive but necessary)
- Together give complete picture

**Why risk-adjusted prioritization?**
- Balances impact and safety
- High-impact, low-risk = do first
- High-impact, high-risk = do carefully
- Acknowledges refactoring carries risk

**Why comprehensive issue format?**
- Matches `/plan-create` detail level
- Ready for `/work` execution
- Clear acceptance criteria
- Explicit approach steps

**Why 96% coverage prerequisite?**
- From existing refactoring skill
- Tests prove behavior preserved
- Non-negotiable safety requirement
- Already enforced via `just coverage`

---

## Edge Cases

**Module never analyzed:**
- Treat as "changed"
- Do full analysis
- Add to `.refactoraudit.yaml`

**Module deferred:**
```yaml
src/legacy:
  deferred: "Being replaced in Q1 2026"
```
- Skip analysis
- Keep in state file
- Remove deferral when ready

**No CLAUDE.md files:**
- Error: "No modules found. Run /docsaudit first"
- Requires documentation structure

**No changes since last analysis:**
- Skip module
- Report in output
- Option: `--force` to re-analyze anyway

**GitHub API rate limits:**
- Cache search results
- Batch issue creation
- Fail gracefully with clear error

**Duplicate detection:**
- Search existing open issues
- If similar found, skip creation
- Log: "Skipped, similar to #99"

---

## Future Enhancements

**Not in v1 (add if needed):**
- Auto-prioritize issues in GitHub (labels, milestones)
- Integration with project boards
- Performance profiling integration
- Security vulnerability detection
- Code coverage analysis integration
- AI-suggested refactoring implementation
- Refactoring impact predictions

**Start simple, grow as needed.**

---

## Success Criteria

System working if:
1. **Autonomous analysis** - Finds opportunities without manual scanning
2. **Accurate detection** - Identifies real issues, low false positives
3. **Good prioritization** - High-value refactorings ranked first
4. **Comprehensive issues** - Ready for `/work` execution
5. **No duplicate work** - Avoids re-analyzing unchanged code
6. **Integrates smoothly** - Works with existing `/work` workflow

---

## Implementation

**Components:**

1. **Command:** `aug-dev/commands/refactor.md`
   - Orchestrates analysis
   - Manages state file
   - Creates GitHub issues
   - Formats output

2. **Skill update:** `aug-dev/skills/refactoring/SKILL.md`
   - Add integration notes
   - Link to `/refactor` command
   - Keep execution guide

**No new skill needed** - command handles analysis, existing skill guides execution.

---

## Philosophy

**Autonomous but supervised:**
- AI finds opportunities
- Human reviews and executes
- GitHub provides oversight

**Metrics + judgment:**
- Quantitative (complexity, LOC)
- Qualitative (smells, architecture)
- Both necessary for complete picture

**State tracking only when useful:**
- Module-level prevents redundant work
- Lightweight, doesn't become burden
- YAGNI - no per-file tracking

**Integrate with existing workflow:**
- Uses CLAUDE.md boundaries
- Uses justfile commands
- Uses `/work` execution
- Minimal new concepts

**Quality first:**
- 96% coverage prerequisite
- RED-GREEN-REFACTOR cycle
- Test after every change
- Never compromise on safety
