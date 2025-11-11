---
name: dddwork
description: DDD-powered implementation - executes ddd phases 4-5, creates PR from feature branch
argument-hint: <issue-number>
---

# dddwork

## Task
$ARGUMENTS

## Purpose

Execute DDD implementation workflow from GitHub issue, create PR when complete.

**Assumes:** `ddd` plugin installed, `/dddplan` already run for this issue

## Workflow

**1. Fetch issue and extract branch**

```bash
ISSUE_NUM=$ARGUMENTS
ISSUE_DATA=$(gh issue view $ISSUE_NUM --json title,body,number)

# Extract branch name from issue body: "**Branch:** `branch-name`"
BRANCH=$(echo "$ISSUE_DATA" | jq -r '.body' | grep -oP '(?<=\*\*Branch:\*\* `)[^`]+')

if [ -z "$BRANCH" ]; then
  echo "❌ No branch found in issue #$ISSUE_NUM"
  echo "   Expected '**Branch:** \`branch-name\`' in issue body"
  echo "   Was /dddplan run for this issue?"
  exit 1
fi

echo "Found branch: $BRANCH"
```

**2. Checkout feature branch**

```bash
# Fetch and checkout the branch
git fetch origin
git checkout "$BRANCH"
git pull origin "$BRANCH"

echo "Checked out $BRANCH"
```

**3. Verify planning artifacts exist**

```bash
[ -f ai_working/ddd/plan.md ] || {
  echo "❌ Missing ai_working/ddd/plan.md"
  echo "   Was /dddplan run for issue #$ISSUE_NUM?"
  exit 1
}

[ -f ai_working/ddd/code_plan.md ] || {
  echo "❌ Missing ai_working/ddd/code_plan.md"
  echo "   Did /dddplan complete phase 3?"
  exit 1
}

echo "✓ Planning artifacts found"
```

**4. Update ./ai_working/CLAUDE.md for implementation phase**

```bash
cat > ai_working/CLAUDE.md << 'EOF'
# DDD Implementation Session Context

**Session Type:** /dddwork - Implementation Phase
**GitHub Issue:** #ISSUE_NUM
**Feature Branch:** BRANCH_NAME

## Your Mission

You are conducting an **implementation session**. Your goal is to execute the plan created during /dddplan (phases 1-3) and complete DDD phases 4-5.

**The planning is done.** Now it's time to implement.

## Context Available

All planning work from /dddplan is available:
- `ai_working/ddd/plan.md` - Complete design decisions and architecture
- `ai_working/ddd/code_plan.md` - Step-by-step implementation plan
- GitHub issue #ISSUE_NUM - Full formatted plan

**Read these files before starting implementation.** They contain all the context from the planning session.

## Workflow Checklist

- [ ] Phase 4: Implementation (ddd:4-code)
  - [ ] Read plan.md and code_plan.md thoroughly
  - [ ] Implement according to code_plan.md
  - [ ] Write tests (TDD when possible)
  - [ ] Iterate with user feedback
  - [ ] User authorizes commits
  - [ ] Continue until user confirms "ready"
- [ ] Phase 5: Finish (ddd:5-finish)
  - [ ] Run final verification (`just check-all`)
  - [ ] Clean up ai_working/ directory
  - [ ] User authorizes push
  - [ ] Create PR linking to issue

## Key Rules

1. **Follow the plan** - Don't deviate without discussing with user
2. **Test everything** - Must pass `just check-all` before finishing
3. **User authorization** - Get approval before commits, push, and PR
4. **Iterate until ready** - Phase 4 repeats until user satisfied
5. **Clean before PR** - Phase 5 removes ai_working/ so it doesn't appear in PR diff

## During Phase 4 (ddd:4-code)

This phase iterates:
1. Implement next chunk from code_plan.md
2. Write/update tests
3. Run `just check-all`
4. If passing → user reviews → commit (with authorization)
5. If failing → debug and fix
6. Get user feedback
7. Repeat until user says "ready for phase 5"

**Don't rush to phase 5.** Make sure everything works first.

## During Phase 5 (ddd:5-finish)

Final cleanup:
1. Final `just check-all` verification
2. Remove ai_working/ directory (git rm -rf ai_working/)
3. Commit cleanup
4. Push to origin (with user authorization)
5. Create PR with `Closes #ISSUE_NUM`

## After PR Creation

Output:
- Branch name
- Issue number (will close on merge)
- PR URL
- Reminder: Review PR, then merge to close issue

## Remember

This CLAUDE.md will be automatically loaded whenever any file in ./ai_working is read. Use it to stay focused on implementation and remember that the planning work is already done - just follow the plan!
EOF

# Replace placeholders
sed -i "s/ISSUE_NUM/$ISSUE_NUM/g" ai_working/CLAUDE.md
sed -i "s/BRANCH_NAME/$BRANCH/g" ai_working/CLAUDE.md

echo "✓ Updated ai_working/CLAUDE.md for implementation phase"
```

**5. Execute DDD phases 4-5**

Context automatically loaded:
- `ai_working/CLAUDE.md` - Session context (auto-loaded when reading ai_working files)
- `ai_working/ddd/plan.md` - Design decisions
- `ai_working/ddd/code_plan.md` - Implementation plan

Execute:
```bash
/ddd:4-code    # Implement, test, iterate with user feedback
/ddd:5-finish  # Cleanup ai_working/, final verification
```

Phase 4 iterates:
- User provides feedback on implementation
- Tests until working
- User authorizes each commit
- Continues until user confirms "ready"

Phase 5 cleanup:
- Removes ai_working/ directory
- Final verification
- User authorizes push and PR creation

**6. Create PR**

```bash
# Push branch (if not already pushed)
git push -u origin "$BRANCH"

# Create PR with issue reference
PR_URL=$(gh pr create \
  --base main \
  --head "$BRANCH" \
  --title "$(echo "$ISSUE_DATA" | jq -r '.title')" \
  --body "Closes #$ISSUE_NUM

$(echo "$ISSUE_DATA" | jq -r '.body' | head -20)

---
Implemented via /dddwork")

echo "$PR_URL"
```

**7. Output**

```
✅ DDD Implementation Complete

Branch: $BRANCH
Issue: #$ISSUE_NUM (closes on merge)
PR: $PR_URL

Review PR, then merge to close issue.
ai_working/ cleaned before PR creation.
```

## Notes

- Requires feature branch from /dddplan
- ddd:4-code iterates until user satisfied
- ddd:5-finish cleans ai_working/ before PR (so it doesn't appear in PR diff)
- PR auto-closes issue on merge via "Closes #N"
- Must pass `just check-all` (enforced by ddd:4-code)
- All git operations require user authorization
- No local issue support (GitHub only)
