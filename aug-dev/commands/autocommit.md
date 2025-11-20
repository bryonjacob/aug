---
name: autocommit
description: Autonomous work + review + merge workflow
---

# Autocommit - Autonomous Work to Merge

Complete autonomous workflow: execute issue → review → merge.

## Usage

```bash
/autocommit 123              # Single issue
/autocommit 123 124 125      # Multiple issues (sequential)
```

## Purpose

Fully autonomous task execution from issue to merged PR:
1. Run `/work <issue>` in subagent (implementation)
2. Automated code review in subagent
3. Fix issues in subagent (if needed, objective iteration rules)
4. Auto-merge if review passes

**Key principles:**
- Review ONLY checks against original issue acceptance criteria (no scope creep)
- Work through quality check failures systematically (default to continuing)
- Stop only on objective blockers (same error 3x) or iteration limits (10 attempts)
- Capture error metrics each iteration for objective continuation assessment

## Token Management Strategy

**CRITICAL: Main thread orchestrates, subagents execute.**

Main thread (lightweight orchestration):
- Parse issue numbers
- Fetch issue metadata via `gh` CLI
- Spawn Task subagents for heavy work
- Merge PRs if approved
- Generate summary

Subagents (fresh token budgets):
- **Work agent:** Execute `/work {issue}` (development)
- **Review agent:** Code review against acceptance criteria
- **Fix agent:** Address review feedback (if needed)

**Why:** Each subagent gets fresh context and full token budget. Main thread can process many issues because it only orchestrates, not develops/reviews.

**Agent types:**
- `general-purpose`: For `/work` execution and fixing review issues
- `superpowers:code-reviewer`: For code review against acceptance criteria

Both are standard built-in agents. The `/work` command provides sufficient guidance for the general-purpose agent.

## Instructions

### 1. Validate Inputs

**Check issue numbers provided:**
- At least one issue number required
- All must be valid GitHub issue numbers
- Can be space-separated list

**Check GitHub CLI available:**
```bash
gh --version
```

If not available:
```
Error: GitHub CLI (gh) not found

This command requires GitHub CLI.
Install: https://cli.github.com/
```

### 2. Process Issues Sequentially

For each issue number in order:

**Step 2.1: Fetch Issue Details**
```bash
gh issue view <issue-number> --json number,title,body
```

Parse JSON, extract:
- Issue number
- Issue title
- Issue body (contains acceptance criteria)

**Step 2.2: Execute /work in Subagent**

**CRITICAL: Use Task tool to spawn subagent for /work (token management).**

Launch general-purpose agent via Task tool:

```
Task(
  subagent_type: "general-purpose",
  description: "Execute work command for issue {issue-number}",
  prompt: "Execute the /work {issue-number} command.

  This will:
  - Fetch issue details
  - Create feature branch
  - Implement changes
  - Run tests
  - Fix format/lint/type errors (convergence-based)
  - Run just check-all
  - Create PR

  Report back:
  - Success/failure status
  - Branch name
  - PR number
  - PR URL
  - Any errors encountered
  "
)
```

**Agent will report back:**
- Branch name
- PR number
- PR URL
- Success/failure status

**If /work fails:**
```
Error: /work <issue-number> failed

Reason: <failure-reason>

Stopping autocommit workflow.
Review and fix manually.
```

Stop processing remaining issues.

**Step 2.3: Launch Code Review in Subagent**

**Use Task tool to spawn code-reviewer subagent:**

```
Task(
  subagent_type: "superpowers:code-reviewer",
  description: "Review PR for issue {issue-number}",
  prompt: "Review PR #{pr-number} against original issue #{issue-number}

  Issue acceptance criteria:
  {paste-acceptance-criteria-from-issue}

  Review checklist:
  - [ ] All acceptance criteria from issue met?
  - [ ] No additional features added (YAGNI)?
  - [ ] No unnecessary abstractions (DRY not over-applied)?
  - [ ] Tests exist for new/changed code?
  - [ ] Tests pass (just test)?
  - [ ] Coverage ≥96% (just coverage)?
  - [ ] Complexity within limits (just complexity)?
  - [ ] just check-all passes?
  - [ ] No security vulnerabilities introduced?
  - [ ] Breaking changes documented (if any)?

  Provide detailed review with:
  - Acceptance criteria status (met/not met)
  - Code quality issues (if any)
  - YAGNI violations (if any)
  - Recommendation: APPROVE or REQUEST_CHANGES
  "
)
```

**Agent will report back:**
- Review findings
- Recommendation (APPROVE or REQUEST_CHANGES)

**Step 2.4: Process Review Results**

**If recommendation is REQUEST_CHANGES:**

Track iterations: `{attempt, mypy_count, pytest_count, lint_count, actions}`

**Fix loop (until check-all passes, blocked, or 10 attempts):**

```
Task(
  subagent_type: "general-purpose",
  description: "Fix PR {pr-number} attempt {N}",
  prompt: "Fix PR #{pr-number}

  Review findings:
  {paste-review-findings}

  Previous attempts (if N > 1):
  {list: attempt #, error counts, actions taken}

  Tasks:
  1. git checkout {branch-name}
  2. Fix all review issues
  3. just test
  4. just check-all
  5. git commit -am 'fix: address review feedback'
  6. git push

  Work through ALL issues. Fix systematic errors mechanically. Update tests to match refactoring.

  Report:
  - Actions: files changed, patterns applied
  - Counts: mypy errors, pytest failures, lint errors
  - Status: pass/fail
  "
)
```

**After fix, check rules (in order):**

1. **check-all passes** → Re-review (expect APPROVE)

2. **Same error 3x + unchanged count + different approaches** → BLOCKED
```
PR #{pr-number} blocked after {N} attempts.

{iteration history: attempt, counts, actions}

Blocking error (3x unchanged):
{error}

Branch: {branch-name}
PR: {pr-url}

Check out branch and investigate. Re-run: /autocommit {issue} when fixed.
```
Stop processing issues.

3. **Error count decreased** → CONTINUE
   **Error messages changed** → CONTINUE
   **N < 10** → CONTINUE

4. **N ≥ 10** → LIMIT
```
PR #{pr-number} incomplete after 10 attempts.

{iteration history: attempt, counts, actions}

Current: mypy {count}, pytest {count}, lint {count}

Branch: {branch-name}
PR: {pr-url}

Check out branch to continue. Re-run: /autocommit {issue} for 10 more.
```
Stop processing issues.

**If recommendation is APPROVE:**

Proceed to merge.

**Step 2.5: Merge PR**

```bash
gh pr merge <pr-number> -s -d
```

Flags:
- `-s`: Squash commits (clean history)
- `-d`: Delete branch after merge

**If merge succeeds:**
```
✓ PR #<pr-number> merged and branch deleted

Issue #<issue-number>: <title>
PR #<pr-number>: <pr-url>
Status: Merged ✓
```

**If merge fails:**
```
Error: Failed to merge PR #<pr-number>

Reason: <error-message>

Possible causes:
- PR checks still running (wait and retry)
- Conflicts with main branch (resolve manually)
- Protected branch rules (check settings)

Manual action required.
```

Stop processing remaining issues.

**Step 2.6: Continue to Next Issue**

If more issues in list, repeat from Step 2.1.

### 3. Generate Summary

After processing all issues:

```
Autocommit Summary
==================

Processed: <N> issues

Successful:
  ✓ #123: Add user validation → PR #456 merged
  ✓ #124: Fix email formatting → PR #457 merged

Failed:
  ✗ #125: Update API → Review found issues
     Reason: Added features not in acceptance criteria
     Action: Manual fix required

Total merged: <N>
Total failed: <N>

Review failed PRs:
  gh pr list --search "is:open [issue-125]"
```

## Review Agent Behavior

**Critical constraints:**

1. **Scope adherence:**
   - Review ONLY checks against original issue acceptance criteria
   - Any additional features = YAGNI violation = REQUEST_CHANGES
   - Any missing acceptance criteria = REQUEST_CHANGES

2. **Quality gates:**
   - Tests must exist for new/changed code
   - Coverage must be ≥96%
   - Complexity must be within limits
   - `just check-all` must pass

3. **No subjective preferences:**
   - Don't request style changes if they pass linters
   - Don't request "better" naming if current is clear
   - Don't request architecture changes unless acceptance criteria require

4. **DRY vs YAGNI balance:**
   - DRY is good, but not if it adds unnecessary abstraction
   - One or two similar code blocks ≠ automatic DRY requirement
   - Three+ similar blocks = suggest DRY

## Example Flows

### Success Case

```bash
$ /autocommit 123

Processing issue #123: Add email validation

Step 1: Running /work 123
  → Branch: feat/123/email-validation
  → Implementation complete
  → Tests added and passing
  → PR #456 created

Step 2: Reviewing PR #456
  → Checking acceptance criteria
  → All criteria met ✓
  → Tests exist and pass ✓
  → Coverage 97% ✓
  → Complexity within limits ✓
  → Recommendation: APPROVE

Step 3: Merging PR #456
  → Squash merge complete
  → Branch deleted
  → Status: Merged ✓

✓ Issue #123 complete
```

### Review Failure Case

```bash
$ /autocommit 124

Processing issue #124: Fix login bug

Step 1: Running /work 124
  → Branch: fix/124/login-bug
  → Implementation complete
  → PR #457 created

Step 2: Reviewing PR #457
  → Checking acceptance criteria

  Issues found:
  1. Added password strength meter (not in acceptance criteria)
     - YAGNI violation
     - Issue only requested bug fix

  2. Refactored entire auth module
     - Scope creep
     - Should be separate issue

  → Recommendation: REQUEST_CHANGES

✗ Review found issues

Action: Commented on PR #457
Manual fix required:
1. Revert password strength meter addition
2. Revert auth module refactoring
3. Keep only bug fix changes
4. Re-run: /autocommit 124
```

### Quality Check Failures (Systematic Fixes)

```bash
$ /autocommit 203

Processing issue #203: Update matching layer for type safety

Step 1: Running /work 203
  → Branch: epic/unified-schema/task-3
  → Implementation complete
  → PR #208 created (draft)

Step 2: Reviewing PR #208
  → Acceptance criteria: Update matchers for StudentProfile type
  → Quality checks: FAILED
    - 89 mypy errors (type safety)
    - 163 pytest failures (test updates needed)
  → Recommendation: REQUEST_CHANGES

Step 3: Fix iteration loop
  Attempt 1:
    → Fixed BaseMatcher to accept StudentProfile | dict
    → Updated 7 scorers to use direct attribute access
    → Updated 5 matchers with normalization
    → Result: 68 mypy errors (-21), 220 pytest failures
    → Rule: Error count decreased → CONTINUE

  Attempt 2:
    → Updated legacy matchers (v2.1, v2.3, matcher.py)
    → Fixed BaseMatcher helper methods
    → Updated test fixtures to use StudentProfile objects
    → Result: 34 mypy errors (-34), 180 pytest failures (-40)
    → Rule: Error count decreased → CONTINUE

  Attempt 3:
    → Cascaded fixes to all 19 child matchers
    → Updated remaining test cases
    → Fixed import statements
    → Result: 8 mypy errors (-26), 45 pytest failures (-135)
    → Rule: Error count decreased → CONTINUE

  Attempt 4:
    → Fixed edge case type assertions
    → Updated mock objects in tests
    → Result: 0 mypy errors (-8), 0 pytest failures (-45)
    → just check-all: PASS
    → Rule: SUCCESS → Re-review

Step 4: Re-reviewing PR #208
  → All acceptance criteria met ✓
  → Quality checks: PASS ✓
  → Recommendation: APPROVE

Step 5: Merging PR #208
  → Squash merge complete
  → Branch deleted
  → Status: Merged ✓

✓ Issue #203 complete (4 fix iterations)
```

### Multiple Issues

```bash
$ /autocommit 123 124 125

Processing 3 issues sequentially...

Issue #123: Add validation
  ✓ Work complete
  ✓ Review passed
  ✓ Merged

Issue #124: Fix formatting
  ✓ Work complete
  ✓ Review passed
  ✓ Merged

Issue #125: Update API
  ✓ Work complete
  ✗ Review found issues (scope creep)
  → Stopping workflow

Summary:
  2 merged successfully
  1 requires manual fix
```

## Integration Points

**Uses:**
- Task tool with general-purpose subagent - Implementation (`/work`)
- Task tool with code-reviewer subagent - Review
- Task tool with general-purpose subagent - Fixes (if needed)
- GitHub CLI (`gh`) - Issue/PR operations (main thread only)

**Workflow:**
```
/autocommit 123 124 125 (main thread)
  ↓
For each issue:
  ↓
  Fetch issue via gh CLI (main thread)
  ↓
  Task(general-purpose: /work {issue}) → PR created (subagent)
  ↓
  Task(code-reviewer: review PR) → APPROVE/REQUEST_CHANGES (subagent)
  ↓
  If REQUEST_CHANGES (iterate with objective rules):
    Loop (max 10 iterations or until success/blocked):
      Task(general-purpose: fix issues) → push fixes (subagent)
      Capture error snapshot (mypy, pytest, lint counts)
      Apply objective continuation rules:
        - check-all passes → re-review, expect APPROVE
        - Same error 3x unchanged → HARD STOP (blocked)
        - Error count decreased → CONTINUE
        - Error messages changed → CONTINUE (different errors)
        - Iteration < 10 → CONTINUE
        - Iteration ≥ 10 → ITERATION LIMIT (stop)
  ↓
  If APPROVE:
    gh pr merge (main thread)
  ↓
  Next issue

Summary (main thread)
```

## Error Handling

**Work fails (/work subagent returns failure):**
- Report error with diagnostics
- Stop processing remaining issues
- User investigates and fixes manually

**Review finds issues (REQUEST_CHANGES):**
- Enter fix iteration loop (objective rules)
- Continue up to 10 iterations or until:
  - SUCCESS: check-all passes (re-review → APPROVE → merge)
  - HARD STOP: Same error 3x with different approaches (blocked)
  - ITERATION LIMIT: 10 attempts exhausted
- If stopped before success: Report diagnostics, stop processing remaining issues

**Merge fails:**
- Report error with reason
- Leave PR open with diagnostic info
- Stop processing remaining issues
- User investigates (conflicts, CI checks, branch protection rules)

**Philosophy:**
- Work through quality check failures systematically (they're just work, not blockers)
- Only stop on genuine blockers (repeated identical errors) or iteration limits
- Default to continuing, not stopping
- Objective metrics (error counts, iteration limits) over subjective assessment

## Safety Features

1. **Sequential processing** - One issue at a time, not parallel
2. **Fail-fast** - Stop on first error
3. **Review gate** - Can't merge without approval
4. **Squash merge** - Clean history
5. **Branch cleanup** - Auto-delete after merge
6. **Scope enforcement** - Review catches scope creep

## When to Use

**Good for:**
- Batch of well-specified issues
- Backlog clearing
- Routine refactorings
- Bug fixes with clear acceptance criteria

**Not good for:**
- Exploratory work
- Vague requirements
- Issues requiring design decisions
- Cross-cutting changes affecting multiple issues

## Performance

**Sequential execution** ensures:
- No merge conflicts between issues
- Clean review per issue
- Main branch always up-to-date

**Typical timing:**
- /work: 5-15 minutes
- Review: 1-2 minutes
- Merge: <1 minute
- Total per issue: 6-18 minutes

For 10 issues: ~1-3 hours autonomous execution.

## Notes

- Requires GitHub CLI authenticated
- Requires repo with PRs enabled
- Review agent must be available (code-reviewer subagent)
- Main branch must not have required PR reviews (or bot must be approved reviewer)
- All quality gates (tests, coverage, linters) must be configured
