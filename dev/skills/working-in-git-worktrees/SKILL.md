---
name: working-in-git-worktrees
description: Use when working in parallel with other agents or when assigned a worktree directory - explains worktree isolation, how to work normally, and what's different from regular branches
---

# Working in Git Worktrees

## Overview

Git worktrees allow parallel work by creating isolated working directories on separate branches. Each worktree has its own files, but shares git history.

**Why you might be in a worktree:**
- Working in parallel with other agents
- Each agent needs isolated directory
- Prevents race conditions during tests/linting
- Your branch independent from other parallel work

## Identifying Worktree

```bash
# Check if in worktree
git rev-parse --git-dir
# Output .git → main repo
# Output ../path/.git/worktrees/name → in worktree

# Or check current directory
pwd
# Contains "worktree" → likely in worktree

# Verify current branch
git branch  # Shows your feature branch
```

## Working in Worktree

**Good news: Everything works normally!**

You can:
- Make commits as usual
- Run tests in isolation
- Push/pull to remote
- Create PRs
- All git operations work

**What's different:**
- Working directory is NOT the main repo location
- Your changes don't affect other parallel work
- Tests run independently
- Lint/format see only your changes

## Typical Workflow

```bash
# You're delegated: "Work in ../worktree-42"
cd ../worktree-42

# Verify setup
git branch  # Should show feature-branch-42
git status  # Should be clean

# Work normally
# Edit files
git add .
git commit -m "feat: implement feature"

# Run tests (isolated from other work)
just test

# Quality checks (see only your changes)
just check-all

# Push when ready
git push -u origin HEAD

# Create PR
gh pr create --draft
```

## Key Differences

| Aspect | Main Repo | Worktree |
|--------|-----------|----------|
| Location | Original clone path | Separate directory |
| Branch | Checked out in main | Checked out in worktree |
| Tests | Might conflict with parallel work | Fully isolated |
| Files | Shared with worktrees | Independent |
| Git history | Shared | Shared (same repo) |

## After Work Complete

**Don't manually delete worktree!**

After PR merge:
- Orchestrator cleans up worktree
- Just switch back to main repo
- Continue with next task

```bash
# After your PR merges
cd ../main-repo  # Or original location
git checkout main
git pull
# Worktree cleanup handled elsewhere
```

## Common Patterns

**Checking out to worktree from main:**
```bash
# Usually done by orchestrator, but FYI:
git worktree add ../worktree-42 -b feature-42
cd ../worktree-42
# Now on feature-42 in isolated directory
```

**Listing all worktrees:**
```bash
git worktree list
# Shows all active worktrees and their branches
```

**Removing worktree (orchestrator does this):**
```bash
git worktree remove ../worktree-42
```

## Troubleshooting

**"Can't checkout branch, already checked out"**
- Branch is checked out in another worktree
- Switch to different branch in other worktree first
- Or use different branch name

**Changes not showing up:**
- Make sure you're in correct worktree directory
- Check `pwd` and `git branch`

**Tests failing unexpectedly:**
- Verify worktree has latest changes
- `git pull` or `git fetch` if needed

## Benefits

**Why use worktrees:**
- Work on multiple branches simultaneously
- No stashing required when switching context
- Each branch isolated - tests don't interfere
- Perfect for parallel agent work
- Safe experimentation without affecting main work

**When NOT to use:**
- Sequential work on single branch
- Personal development without parallel tasks
- Simple bug fixes on main branch
