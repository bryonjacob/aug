---
name: autocommit
description: Autonomous work + review + merge workflow
---

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

## Token Management Strategy

**CRITICAL: Main thread orchestrates, subagents execute.**

**Why:** Each subagent gets fresh context and full token budget. Main thread can process many issues because it only orchestrates, not develops/reviews.

**Agent types:**
- `general-purpose`: For `/work` execution and fixing review issues
- `superpowers:code-reviewer`: For code review against acceptance criteria

## Instructions

### 1. Validate Inputs

Require: one or more valid GitHub issue numbers (space-separated)

Check `gh` CLI available (`gh --version`). If missing, exit with install link.

### 2. Process Issues Sequentially

For each issue number in order:

**Step 2.1: Fetch Issue Details**

`gh issue view <issue-number> --json number,title,body`

Extract: number, title, body (acceptance criteria).

**Step 2.2: Execute /work in Subagent**

**CRITICAL: Use Task tool to spawn subagent for /work.**

```
Task(
  subagent_type: "general-purpose",
  description: "Execute work command for issue {issue-number}",
  prompt: "Execute the /work {issue-number} command.

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

  Report: findings, recommendation (APPROVE/REQUEST_CHANGES)
  "
)
```

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

Manual action required.
```

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

1. **No subjective preferences:**
   - Don't request style changes if they pass linters
   - Don't request "better" naming if current is clear
   - Don't request architecture changes unless acceptance criteria require

2. **DRY vs YAGNI balance:**
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

## Error Handling

**Philosophy:**
- Work through quality check failures systematically (they're just work, not blockers)
- Only stop on genuine blockers (repeated identical errors) or iteration limits
- Default to continuing, not stopping
- Objective metrics (error counts, iteration limits) over subjective assessment
