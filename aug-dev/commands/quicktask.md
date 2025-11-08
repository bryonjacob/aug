---
name: quicktask
description: Handle ad-hoc work with automatic issue creation and execution
argument-hint: <task-description>
---

# quicktask

## Task
$ARGUMENTS

## Purpose

Ad-hoc unplanned work with full issue tracking. Combines `/plan` + `/work` for tasks not pre-planned.

## Issue Storage

**GitHub:** If remote origin → GitHub via gh CLI
**Local:** No GitHub → `ISSUES.LOCAL/LOCAL###-Title.md`

Check:
```bash
git remote get-url origin 2>/dev/null | grep -q github.com && echo "GitHub" || echo "Local"
```

## Steps

**1. Create Issue**

GitHub:
```bash
REPO_ID=$(gh repo view --json id -q .id)

ISSUE=$(gh api graphql --jq '.data.createIssue.issue' -f query="$(cat <<EOF
mutation {
  createIssue(input: {
    repositoryId: "$REPO_ID"
    title: "[TITLE]"
    body: "[DESCRIPTION]"
  }) {
    issue { id number url }
  }
}
EOF
)")

ISSUE_NUMBER=$(echo "$ISSUE" | jq -r '.number')
```

Local:
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
```

**2. Start Work**

Follow `/work` workflow:
- Branch named after issue (`123-fix-bug` or `LOCAL001-fix-bug`)
- Implement changes
- Run `just check-all`
- GitHub: draft PR → approval → merge
- Local: update status to closed → squash merge to main
- Status change in final merge commit

## When to Use

✅ Use for:
- Bug fixes during development
- Small improvements
- Quick refactoring
- Urgent fixes

Still requires:
- ✅ Issue created
- ✅ Branch/PR workflow
- ✅ Quality gates pass
- ✅ Proper commits

## Notes

- Create issue first for traceability
- Same quality standards as planned work
- No testing shortcuts
- Keep scope focused
- Same SDLC rigor (GitHub or local)
- Check GitHub remote - adapt workflow
- Local: update status before merge
