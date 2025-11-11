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

**2. Create GitHub issue**

Generate title from feature description:
```bash
# Extract meaningful title (first 50 chars, sanitized)
TITLE=$(echo "$ARGUMENTS" | cut -c1-50 | sed 's/[^a-zA-Z0-9 ]//g')

# Create issue with placeholder body
gh issue create \
  --title "feat: $TITLE" \
  --body "🚧 Planning in progress...

Full plan will be added after DDD phases 1-3 complete."

# Note: gh issue create returns URL like https://github.com/user/repo/issues/123
# Extract issue number from output
```

**3. Create linked feature branch**

```bash
# GitHub auto-generates branch name linked to issue
gh issue develop <ISSUE_NUM> --checkout

BRANCH=$(git branch --show-current)
echo "Created and checked out branch: $BRANCH"
```

**4. Create ./ai_working/CLAUDE.md**

Write planning session context:
```bash
mkdir -p ai_working
cat > ai_working/CLAUDE.md << 'EOF'
# DDD Planning Session Context

**Session Type:** /dddplan - Planning Phase Only
**GitHub Issue:** #ISSUE_NUM
**Feature Branch:** BRANCH_NAME

## Your Mission

You are conducting a **planning-only session**. Your goal is to complete DDD phases 1-3 and capture all context into GitHub issue #ISSUE_NUM.

**DO NOT implement code.** This is planning only.

## Workflow Checklist

- [ ] Phase 1: Design (ddd:1-plan) - Create ai_working/ddd/plan.md
- [ ] Phase 2: Documentation (ddd:2-docs) - Update non-code files
- [ ] Phase 3: Code Planning (ddd:3-code-plan) - Create ai_working/ddd/code_plan.md
- [ ] **CRITICAL:** Update GitHub issue #ISSUE_NUM with complete plan
- [ ] Commit all changes to feature branch
- [ ] Exit with "/dddwork ISSUE_NUM" instruction

## Key Rules

1. **Stay focused on planning** - No implementation (that's /dddwork's job)
2. **Update the GH issue** - After phase 3, you MUST update issue description with full plan
3. **Commit artifacts** - All ai_working/ and docs changes go to feature branch
4. **Session separation** - Planning (dddplan) and coding (dddwork) are separate sessions

## After Phase 3

Before finishing, you MUST:
1. Read ai_working/ddd/plan.md and ai_working/ddd/code_plan.md
2. Update GitHub issue #ISSUE_NUM with formatted plan (see format below)
3. Verify issue was updated successfully
4. Tell user to run `/dddwork ISSUE_NUM` when ready to implement

## GitHub Issue Update Format

Use `gh issue edit ISSUE_NUM --body "..."` with this format:

```markdown
# [Feature Title]

**Branch:** `BRANCH_NAME`

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
Created by /dddplan • DDD artifacts in branch at ai_working/ddd/
```

## Remember

This CLAUDE.md will be automatically loaded whenever any file in ./ai_working is read. Use it to stay focused on the planning workflow and remember to update the GitHub issue before finishing.
EOF

# Replace placeholders
sed -i "s/ISSUE_NUM/$ISSUE_NUM/g" ai_working/CLAUDE.md
sed -i "s/BRANCH_NAME/$BRANCH/g" ai_working/CLAUDE.md
```

**5. Run DDD phases 1-3**

```bash
/ddd:1-plan $ARGUMENTS    # Interactive planning, creates ai_working/ddd/plan.md
/ddd:2-docs               # Update docs, user reviews/commits when satisfied
/ddd:3-code-plan          # Generate code plan, creates ai_working/ddd/code_plan.md
```

User interaction required:
- Phase 1: design review and approval
- Phase 2: docs review, iterate, user commits when satisfied
- Phase 3: code plan review and approval

**6. Update GitHub issue with complete plan**

Read artifacts:
```bash
cat ai_working/ddd/plan.md
cat ai_working/ddd/code_plan.md
```

Format and update issue:
```bash
# Build formatted issue body from artifacts
ISSUE_BODY="[Format according to template in ai_working/CLAUDE.md]"

# Update the issue
gh issue edit $ISSUE_NUM --body "$ISSUE_BODY"

# Verify update
gh issue view $ISSUE_NUM
```

**7. Commit and output**

```bash
git add ai_working/ docs/
git commit -m "feat: planning complete for issue #$ISSUE_NUM"

echo "✅ DDD Planning Complete

Branch: $BRANCH
Issue: #$ISSUE_NUM
URL: $(gh issue view $ISSUE_NUM --json url -q .url)

All planning artifacts committed to feature branch.

Next: /dddwork $ISSUE_NUM"
```

## Notes

- Requires GitHub remote (`gh` CLI)
- User must commit docs during phase 2
- All ai_working/ artifacts committed to feature branch
- Issue references branch containing full context
- ddd:5-finish will clean ai_working/ before PR merge
- No local issue fallback (GitHub only)
