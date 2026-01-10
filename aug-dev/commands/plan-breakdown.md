---
name: plan-breakdown
description: Break epic into deliverable tasks with detailed specs
---

**Workflow:** [epic-development](../workflows/epic-development.md) • **Phase:** breakdown (step 2/4) • **Next:** /plan-create

# Plan Breakdown - Task Decomposition

Decompose an epic into independently deliverable tasks with comprehensive implementation guidance.

**Purpose**: Break the architecture from `/plan-chat` into 3-8 concrete tasks, each with detailed specifications for autonomous execution.

**Prerequisites**: Run `/plan-chat` first to create the architecture.

**Skills Used**: `software-architecture` skill in BREAKDOWN mode for task analysis and spec generation.

**Next Command**: Run `/plan-create` to generate GitHub issues.

---

## Workflow

Use the `software-architecture` skill to guide this process.

### Phase 1: Load Planning Context

1. Find active epic in `/tmp/devplan/`
2. Verify `chat.md` exists with status "chat-complete"

### Phase 2: Propose Task Breakdown

1. Analyze architecture for natural task boundaries
2. Generate 3-8 task proposals, each:
   - Independently deliverable (single PR to main)
   - Includes implementation AND tests together
   - Has clear acceptance criteria
3. Present to user and iterate on feedback

### Phase 3: Create Detailed Task Specs

For each approved task, create `/tmp/devplan/{epic-id}/tasks/task-{n}.md` using the `software-architecture` skill output structure.

### Phase 4: Update Metadata

Update `/tmp/devplan/{epic-id}/metadata.json` with task list and status "breakdown-complete".

### Phase 5: Report Completion

```
Epic: {TITLE}
Tasks: {COUNT}

Specs:
  - task-1.md: {TITLE}
  - task-2.md: {TITLE}

Next: /plan-create
```

---

## Quality Checks

Before marking breakdown complete:
- [ ] 3-8 tasks defined
- [ ] Each task independently deliverable
- [ ] Each task includes implementation AND tests (no separate testing tasks)
- [ ] Implementation guidance is concrete with code examples
- [ ] Dependencies identified
- [ ] All task specs written to tasks/*.md
- [ ] metadata.json updated

---

## Task Principles

Each task must be:
- **Concrete**: Exact files to change, exact functions to add
- **Chunked**: Broken into 2-4 verifiable implementation chunks
- **Testable**: Clear test cases for each chunk
- **Bounded**: Explicit out-of-scope to prevent scope creep

**Anti-pattern**: Never separate implementation and testing into different tasks. Tests are part of each implementation task.
