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
1. Run `/work <issue>` (implementation)
2. Automated code review
3. Auto-merge if review passes

**Key constraint:** Review ONLY checks against original issue acceptance criteria. No scope creep.

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

**Step 2.2: Execute /work**

Launch `/work <issue-number>` via normal command execution (not Task tool).

Wait for `/work` to complete. It will:
- Create feature branch
- Implement changes
- Run tests
- Fix format/lint/type errors (up to 3 attempts)
- Run `just check-all`
- Create PR

**Output from /work will include:**
- Branch name
- PR number
- PR URL

**If /work fails:**
```
Error: /work <issue-number> failed

Reason: <failure-reason>

Stopping autocommit workflow.
Review and fix manually.
```

Stop processing remaining issues.

**Step 2.3: Launch Code Review Agent**

Use Task tool to launch code-reviewer subagent:

```
Prompt: Review PR #<pr-number> against original issue #<issue-number>

Issue acceptance criteria:
<paste-acceptance-criteria-from-issue>

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
```

**Agent response will include:**
- Review findings
- Recommendation (APPROVE or REQUEST_CHANGES)

**Step 2.4: Process Review Results**

**If recommendation is REQUEST_CHANGES:**
```
Review found issues for PR #<pr-number>:

<paste-review-findings>

Action: Commented on PR, NOT merging.

Manual fix required:
1. Address review comments
2. Push updates to branch
3. Re-run: /autocommit <issue-number> (will re-review)
```

Stop processing remaining issues.

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
- `/work` command (aug-dev) - Implementation
- Task tool with code-reviewer subagent - Review
- GitHub CLI (`gh`) - Issue/PR operations

**Workflow:**
```
/autocommit 123
  ↓
/work 123 (aug-dev)
  ↓
Task(code-reviewer) (superpower or aug-dev agent)
  ↓
gh pr merge (if approved)
```

## Error Handling

**Work fails:**
- Report error
- Stop processing
- User fixes manually

**Review finds issues:**
- Comment on PR
- Stop processing
- User addresses and re-runs /autocommit

**Merge fails:**
- Report error
- Leave PR open
- User investigates (conflicts, checks, rules)

**All errors stop batch processing** - don't continue to next issue if current failed.

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
