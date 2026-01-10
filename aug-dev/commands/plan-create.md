---
name: plan-create
description: Create comprehensive GitHub issues from planning artifacts
---

**Workflow:** [epic-development](../workflows/epic-development.md) • **Phase:** create-issues (step 3/4) • **Next:** /work

# Plan Create - Generate GitHub Issues

Transform planning artifacts from `/plan-chat` and `/plan-breakdown` into comprehensive GitHub issues.

**Purpose**: Create epic and task issues with complete specifications, making GitHub the source of truth for execution.

**Prerequisites**:
- Run `/plan-chat` to create architecture
- Run `/plan-breakdown` to create task specs

**Skills Used**: `software-architecture` skill for issue body templates and formatting.

**Next Command**: Execute tasks with `/work <issue-number>`

---

## Workflow

### Phase 1: Load Planning Artifacts

1. Check `/tmp/devplan/` for complete planning sessions
2. Verify status is "breakdown-complete"
3. Read `chat.md`, `metadata.json`, and `tasks/task-*.md`

### Phase 2: Create Epic Issue

Use `gh issue create` with structured metadata at top:
- EPIC_ID, EPIC_STATUS, CREATED, TASKS_COUNT
- Full architecture from chat.md
- Task breakdown with TBD issue numbers

### Phase 3: Create Task Issues

For each task in `tasks/task-*.md`, create issue with structured metadata:
- TASK_ID, EPIC_ID, EPIC_ISSUE, BRANCH_NAME, DEPENDS_ON, BLOCKS
- Full task spec from task-{n}.md
- Execute section: `/work {THIS_ISSUE_NUMBER}`

### Phase 4: Update Epic with Task Numbers

Edit epic issue to replace "#TBD" with actual task issue numbers.

### Phase 5: Optional Cleanup

Ask user if they want to clean up `/tmp/devplan/{epic-id}/` (default: yes, ephemeral).

### Phase 6: Report Completion

```
Epic Issue: #{EPIC_ISSUE}
Task Issues: {COUNT}
  #{TASK_1}: {TITLE}
  #{TASK_2}: {TITLE}

Ready to Execute: /work {TASK_1_ISSUE}
```

---

## Quality Checks

Before marking creation complete:
- [ ] Epic issue created with full architecture
- [ ] All task issues created with complete specs
- [ ] Epic updated with actual task issue numbers
- [ ] All issues have structured metadata at top
- [ ] Branch names follow pattern: `epic/{epic-id}/{task-slug}`
