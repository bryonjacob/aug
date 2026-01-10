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

Each subagent gets fresh context and full token budget. Main thread processes many issues because it only orchestrates.

**Agent types:**
- `general-purpose`: For `/work` execution and fixing review issues
- `superpowers:code-reviewer`: For code review against acceptance criteria

## Instructions

### 1. Validate Inputs

Require: one or more valid GitHub issue numbers (space-separated)

Check `gh` CLI available. If missing, exit with install link.

### 2. Process Issues Sequentially

For each issue number:

**Step 2.1: Fetch Issue Details**

`gh issue view <issue-number> --json number,title,body`

**Step 2.2: Execute /work in Subagent**

```
Task(
  subagent_type: "general-purpose",
  description: "Execute work command for issue {issue-number}",
  prompt: "Execute the /work {issue-number} command.
  Report back: Success/failure, Branch name, PR number, PR URL, Any errors"
)
```

If /work fails, stop and report error.

**Step 2.3: Launch Code Review in Subagent**

```
Task(
  subagent_type: "superpowers:code-reviewer",
  description: "Review PR for issue {issue-number}",
  prompt: "Review PR #{pr-number} against issue #{issue-number}

  Review checklist:
  - [ ] All acceptance criteria from issue met?
  - [ ] No additional features added (YAGNI)?
  - [ ] Tests exist and pass?
  - [ ] Coverage >= 96%?
  - [ ] just check-all passes?
  - [ ] No security vulnerabilities introduced?
  - [ ] Breaking changes documented (if any)?

  Report: findings, recommendation (APPROVE/REQUEST_CHANGES)"
)
```

**Step 2.4: Process Review Results**

**If REQUEST_CHANGES:**

Track iterations: `{attempt, mypy_count, pytest_count, lint_count, actions}`

Fix loop (until check-all passes, blocked, or 10 attempts):
- Spawn fix subagent with review findings
- Track error counts per attempt

Objective rules:
- **check-all passes** -> Re-review
- **Same error 3x + unchanged count + different approaches** -> BLOCKED
- **Error count decreased** -> CONTINUE
- **N >= 10** -> LIMIT

**If APPROVE:** Proceed to merge.

**Step 2.5: Merge PR**

```bash
gh pr merge <pr-number> -s -d
```

### 3. Generate Summary

```
Autocommit Summary
==================

Processed: <N> issues

Successful:
  - #123: Add user validation -> PR #456 merged

Failed:
  - #125: Update API -> Review found issues

Total merged: <N>
Total failed: <N>
```

## Review Agent Behavior

**Critical constraints:**

1. **No subjective preferences:**
   - Don't request style changes if linters pass
   - Don't request architecture changes unless acceptance criteria require

2. **DRY vs YAGNI balance:**
   - One or two similar blocks != automatic DRY requirement
   - Three+ similar blocks = suggest DRY

## Example Flow

```bash
$ /autocommit 123

Processing issue #123: Add email validation

Step 1: Running /work 123
  -> Branch: feat/123/email-validation
  -> PR #456 created

Step 2: Reviewing PR #456
  -> All criteria met
  -> Recommendation: APPROVE

Step 3: Merging PR #456
  -> Squash merge complete
  -> Status: Merged

Issue #123 complete
```

## Error Handling

- Work through quality check failures systematically
- Only stop on genuine blockers (repeated identical errors) or iteration limits
- Objective metrics (error counts, iteration limits) over subjective assessment
