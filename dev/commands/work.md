---
name: work
description: Execute issue(s) through complete development lifecycle from branch creation to PR merge
argument-hint: <issue-numbers>
---

# work

## Task
$ARGUMENTS

## Purpose
Execute issues sequentially through complete lifecycle: branch → implement → test → review → merge.

Uses `executing-development-issues` skill for workflow.

## Execution

**Sequential only** - complete each issue fully before next:

```
/work 99              # Single issue
/work 99 100 101      # Multiple issues, one at a time
/work 99-101          # Range notation (99, 100, 101)
```

Why sequential:
- Clean git history (one issue per PR/commit)
- No conflicts between concurrent work
- Quality gates run reliably
- Each issue gets full attention

## Issue Source

**GitHub:** `gh issue view [NUMBER]`

**Local:** `ISSUES.LOCAL/LOCAL###-Title.md`

```bash
# Check source
git remote get-url origin 2>/dev/null | grep -q github.com
```

## Workflow Per Issue

1. Fetch issue details
2. Create feature branch
3. Implement with tests
4. Pass `just check-all`
5. Create PR (GitHub) or commit (local)
6. Review and merge
7. Pull latest before next issue

## Quality Requirements

- Must pass `just check-all`
- Must satisfy all acceptance criteria
- PR required for GitHub, clean commits for local
- No shortcuts

## When to Use

✅ Use `/work` for:
- Features with clear acceptance criteria
- Bug fixes with reproduction steps
- Refactoring with high coverage

❌ Don't use `/work` for:
- Exploration or research
- Issues without clear criteria
- Planning discussions

Use `/plan` for planning, `/quicktask` for ad-hoc work.
