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

**1. Fetch issue**

```bash
ISSUE_NUM=$ARGUMENTS
ISSUE_DATA=$(gh issue view $ISSUE_NUM --json title,body)
```

**2. Extract and switch to branch**

```bash
# Extract from issue body: "**Branch:** `feature/user-auth`"
BRANCH=$(echo "$ISSUE_DATA" | jq -r '.body' | grep -oP '(?<=\*\*Branch:\*\* `)[^`]+')

git fetch origin
git checkout "$BRANCH"
git pull origin "$BRANCH"
```

**3. Verify artifacts exist**

```bash
[ -f ai_working/ddd/plan.md ] || { echo "❌ Missing plan.md - was /dddplan run?"; exit 1; }
[ -f ai_working/ddd/code_plan.md ] || { echo "❌ Missing code_plan.md"; exit 1; }
```

**4. Run DDD phases 4-5**

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

**5. Create PR**

```bash
git push -u origin "$BRANCH"

PR_URL=$(gh pr create \
  --base main \
  --head "$BRANCH" \
  --title "$(echo "$ISSUE_DATA" | jq -r '.title')" \
  --body "Closes #$ISSUE_NUM

$(echo "$ISSUE_DATA" | jq -r '.body' | head -20)

---
Implemented via /dddwork")
```

**6. Output**

```
✅ DDD Implementation Complete

Branch: feature/user-auth
Issue: #123 (closes on merge)
PR: https://github.com/user/repo/pull/456

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
