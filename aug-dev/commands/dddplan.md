---
name: dddplan
description: DDD-powered planning - orchestrates ddd phases 1-3, creates GitHub issue with complete plan
argument-hint: <feature-description>
---

# dddplan

## Task
$ARGUMENTS

## Purpose

Orchestrate DDD planning workflow, create GitHub issue with complete design/docs/code-plan.

**Assumes:** `ddd` plugin installed (from amplifier-marketplace)

## Workflow

**1. Check ai_working**

```bash
grep -q "ai_working" .gitignore 2>/dev/null
```

If found:
- Prompt: "ai_working/ in .gitignore - remove for DDD workflow? (y/n)"
- If yes: remove line from .gitignore
- If no: abort

Why: DDD artifacts must be committed to feature branch, cleaned up by ddd:5-finish before PR merge

**2. Create feature branch**

```bash
# Generate from feature description
BRANCH="feature/$(echo "$ARGUMENTS" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | cut -c1-50)"
git checkout -b "$BRANCH"
```

**3. Run DDD phases 1-3**

```bash
/ddd:1-plan $ARGUMENTS    # Interactive planning, creates ai_working/ddd/plan.md
/ddd:2-docs               # Update docs, user reviews/commits when satisfied
/ddd:3-code-plan          # Generate code plan, creates ai_working/ddd/code_plan.md
```

User interaction required:
- Phase 1: design review and approval
- Phase 2: docs review, iterate, user commits when satisfied
- Phase 3: code plan review and approval

**4. Create GitHub issue**

Read artifacts:
```bash
cat ai_working/ddd/plan.md
cat ai_working/ddd/code_plan.md
```

Create via `gh`:
```bash
REPO_ID=$(gh repo view --json id -q .id)

ISSUE=$(gh api graphql -f query="mutation {
  createIssue(input: {
    repositoryId: \"$REPO_ID\"
    title: \"[conventional prefix + title from plan]\"
    body: \"[formatted body below]\"
  }) {
    issue { number url }
  }
}")
```

**Issue body format:**
```markdown
# [Feature Title]

**Branch:** `feature/user-auth`

## Summary
[From plan.md: Problem Statement + Proposed Solution]

## Architecture
[From plan.md: Architecture & Design section]

## Files to Change
[From plan.md: Files to Change section]

## Implementation Plan
[From code_plan.md: Complete code plan]

## Success Criteria
[From plan.md: Success Criteria]

---
Created by /dddplan
DDD artifacts in branch: ai_working/ddd/
```

**5. Output**

```
✅ DDD Planning Complete

Branch: feature/user-auth
Issue: #123
URL: https://github.com/user/repo/issues/123

All planning artifacts committed to feature branch.

Next: /dddwork 123
```

## Notes

- Requires GitHub remote (`gh` CLI)
- User must commit docs during phase 2
- All ai_working/ artifacts committed to feature branch
- Issue references branch containing full context
- ddd:5-finish will clean ai_working/ before PR merge
- No local issue fallback (GitHub only)
