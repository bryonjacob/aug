---
name: plan
description: Break down work into GitHub or local issues with execution strategy
argument-hint: <description>
---

# plan

## Task
$ARGUMENTS

## Purpose
Break down work into actionable issues (GitHub preferred, local fallback) with execution order.

## Storage

**GitHub Issues (preferred):**
```bash
# Check if GitHub remote exists
git remote get-url origin 2>/dev/null | grep -q github.com
```

Use `gh` CLI to create issues. Support parent-child relationships via `parentIssueId` in mutation.

**Local Issues (fallback):**

Format: `ISSUES.LOCAL/LOCAL###-TitleInCamelCase.md`

```markdown
---
number: LOCAL001
status: open
created: 2025-11-01
---

# feat: Title

## Summary
What needs to be done

## Acceptance Criteria
- [ ] Requirement 1
- [ ] Requirement 2

## Technical Notes
Implementation guidance

## Dependencies
Related issues
```

## Issue Template

**Title:** Use conventional commit prefix (`feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`)

**Body:**
- **Summary** - What needs to be done
- **Acceptance Criteria** - Checkboxes defining "done"
- **Technical Notes** - Implementation guidance
- **Dependencies** - Related issues

## Execution Strategy

After creating issues, output recommended execution order:

```
## Recommended Execution Order

1. Issue #99 - Setup database
2. Issue #100 - Create API endpoints
3. Issue #101 - Add tests

To execute: /work 99 100 101
```

## Notes

- Atomic issues - one clear deliverable each
- Clear acceptance criteria - checkboxes defining "done"
- Include dependencies and technical context
- GitHub: create parent first, children with `parentIssueId`
- Local: auto-increment from existing `LOCAL###` files
- Sequential execution by default (respects dependencies)
