---
name: quicktask
description: Handle ad-hoc work with automatic issue creation and execution
argument-hint: <task-description>
---

# quicktask

## Task
$ARGUMENTS

## Purpose
Handle ad-hoc unplanned work with full issue tracking. Combines `/plan` + `/work` in one flow for tasks that weren't pre-planned.

## Issue Storage

**GitHub Issues:** If git remote origin points to GitHub, create via gh CLI.

**Local Issues:** If no GitHub remote, create in `ISSUES.LOCAL/LOCAL###-Title.md`.

Check:
```bash
git remote get-url origin 2>/dev/null | grep -q github.com && echo "GitHub" || echo "Local"
```

## Steps

### 1. Create Issue

**For GitHub:**
```bash
REPO_ID=$(gh repo view --json id -q .id)

ISSUE=$(gh api graphql --jq '.data.createIssue.issue' -f query="$(cat <<EOF
mutation {
  createIssue(input: {
    repositoryId: "$REPO_ID"
    title: "[TITLE]"
    body: "[DESCRIPTION]"
  }) {
    issue {
      id
      number
      url
    }
  }
}
EOF
)")

ISSUE_NUMBER=$(echo "$ISSUE" | jq -r '.number')
echo "Created issue #$ISSUE_NUMBER"
```

**For Local:**
```bash
mkdir -p ISSUES.LOCAL
NEXT=$(ls ISSUES.LOCAL/LOCAL*.md 2>/dev/null | sed 's/.*LOCAL0*\([0-9]*\)-.*/\1/' | sort -n | tail -1)
NEXT=$((NEXT + 1))
ISSUE_ID=$(printf "LOCAL%03d" $NEXT)

cat > ISSUES.LOCAL/${ISSUE_ID}-Title.md << EOF
---
number: ${ISSUE_ID}
status: open
created: $(date +%Y-%m-%d)
---

# [TITLE]

## Summary
[DESCRIPTION]

## Acceptance Criteria
- [ ] [Criteria]

## Technical Notes
[Notes]
EOF

echo "Created issue ${ISSUE_ID}"
```

### 2. Immediately Start Work

Follow `/work` workflow - adapts automatically based on whether using GitHub or local issues.

**Key steps:**
- Create branch named after issue (e.g., `123-fix-bug` or `LOCAL001-fix-bug`)
- Implement changes
- Run `just check-all` before merge
- For GitHub: create draft PR, get approval, merge
- For local: update issue status to closed, then squash merge to main
- Issue status change must be included in final merge commit

## When to Use

Use `/quicktask` for:
- Bug fixes discovered during development
- Small improvements not in the plan
- Quick refactoring opportunities
- Urgent fixes

Still requires:
- ✅ Issue created for tracking
- ✅ Branch and PR workflow
- ✅ All quality gates pass
- ✅ Proper commit messages

## Execution Notes
- Creates issue first for full traceability (GitHub or local)
- Follows same quality standards as planned work
- No shortcuts on testing or quality gates
- Keep scope small and focused
- Same SDLC rigor whether using GitHub or local issues
- Check for GitHub remote first - adapt workflow accordingly
- **IMPORTANT:** For local issues, update status to closed before final merge - status change must be in merge commit