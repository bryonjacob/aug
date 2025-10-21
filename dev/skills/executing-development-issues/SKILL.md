---
name: executing-development-issues
description: Use when implementing GitHub or local issues through complete development lifecycle - covers branch creation, implementation, testing, PR creation, and merge workflow with quality gates
---

# Executing Development Issues

## Overview

Complete workflow for implementing issues from start to finish: branch → code → tests → PR → review → merge. Works for both GitHub issues and local issues (ISSUES.LOCAL/).

**Core principle:** One issue at a time, full lifecycle before moving to next.

## Quick Reference

```bash
# 1. Get issue details
gh issue view [NUMBER]              # GitHub
cat ISSUES.LOCAL/LOCAL###-Title.md  # Local

# 2. Create branch (if not in worktree)
git checkout -b [ISSUE_ID]-description

# 3. Implement with tests
just test-watch  # Keep running

# 4. Quality checks
just check-all

# 5. Create PR (GitHub only)
gh pr create --draft
gh pr ready  # When complete

# 6. Merge
gh pr merge --squash --delete-branch  # GitHub
git checkout main && git merge --squash BRANCH  # Local
```

## Working Directory: Worktree vs Main

**Check if in worktree:**
```bash
git rev-parse --git-dir  # Shows .git or ../path/.git/worktrees/name
```

**If IN worktree (parallel work):**
- You're already on your feature branch
- No need to checkout or create branch
- Work normally, worktree is isolated
- After merge, worktree cleaned up by orchestrator

**If NOT in worktree (sequential work):**
```bash
git checkout main
git pull origin main
git checkout -b [ISSUE_ID]-description
```

## Branch Naming

- **GitHub issues:** `[issue-number]-[brief-description]`
  - Example: `42-add-user-auth`
- **Local issues:** `LOCAL###-[brief-description]`
  - Example: `LOCAL001-fix-parser`

## Implementation Workflow

**1. Read acceptance criteria carefully**
- Understand what "done" means
- Note all requirements
- Identify edge cases

**2. Follow TDD:**
- Write test for expected behavior
- Implement to satisfy test
- Refactor while green
- Commit frequently

**3. Commit messages:**
```bash
git commit -m "feat: specific change description

Refs #42"  # or "Refs LOCAL###"
```

**4. Create draft PR early (GitHub):**
```bash
git push -u origin HEAD

gh pr create \
  --title "feat: description" \
  --body "Closes #42

## Changes
- Change 1
- Change 2

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2" \
  --draft
```

## Definition of Done

Before marking complete:

- ✅ All acceptance criteria met
- ✅ Tests written and passing
- ✅ Coverage >= 80% (90%+ before refactoring)
- ✅ `just check-all` passes
- ✅ Documentation updated
- ✅ Code clean and maintainable
- ✅ PR created (GitHub) / branch pushed (local)
- ✅ CI passing (GitHub)
- ✅ Self-review completed
- ✅ Merged to main
- ✅ Issue closed

**If any incomplete, work is not done.**

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Working on multiple issues | One at a time, full lifecycle |
| Skipping tests | Write tests as you implement |
| Ignoring quality checks | `just check-all` must pass |
| Unclear commits | Explain what and why |
| Forgetting documentation | Update docs with code |
| Rushing to merge | Self-review with fresh eyes |

## Quality Gates

```bash
just check-all  # Must pass:
```
- Code formatted
- No lint errors
- Type checking passes
- All tests pass
- Coverage meets threshold

## Merging

**GitHub:**
```bash
gh pr ready  # Mark ready for review
# After approval:
gh pr merge --squash --delete-branch
```

**Local:**
```bash
# Update issue status BEFORE merge
sed -i '' 's/^status: ready$/status: closed/' ISSUES.LOCAL/LOCAL###-Title.md

git checkout main
git merge --squash BRANCH
git add ISSUES.LOCAL/LOCAL###-Title.md
git commit -m "feat: description

Closes LOCAL###"
git branch -d BRANCH
```

## When to Ask for Help

- Acceptance criteria unclear
- Quality checks failing mysteriously
- Scope larger than issue suggests
- Making assumptions about requirements
- Considering architectural changes
- Tests flaky or slow
