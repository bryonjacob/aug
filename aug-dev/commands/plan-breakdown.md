---
name: plan-breakdown
description: Break epic into deliverable tasks with detailed specs
---

**Workflow:** [epic-development](../workflows/epic-development.md) • **Phase:** breakdown (step 2/4) • **Next:** /plan-create

# Plan Breakdown - Task Decomposition

Decompose an epic into independently deliverable tasks with comprehensive implementation guidance.

**Purpose**: Break the architecture from `/plan-chat` into 3-8 concrete tasks, each with detailed specifications for autonomous execution.

**Prerequisites**: Run `/plan-chat` first to create the architecture.

**Next Command**: After breakdown, run `/plan-create` to generate GitHub issues.

---

## Workflow

Use the `software-architecture` skill in BREAKDOWN mode to guide this process.

### Phase 1: Load Planning Context

1. **Find Active Epic**
   - Check `/tmp/devplan/` for recent planning sessions
   - If multiple, ask user which epic to break down
   - Read `chat.md` and `metadata.json`

2. **Verify Prerequisites**
   - Confirm `chat.md` exists with complete architecture
   - Verify status is "chat-complete"

### Phase 2: Propose Task Breakdown

**Use the `software-architecture` skill:**

1. **Analyze Architecture**
   - Review module structure from chat.md
   - Identify natural boundaries for tasks
   - Consider dependencies between components

2. **Propose Tasks**
   - Generate 3-8 task proposals
   - Each task should be:
     - Independently deliverable
     - Single PR to main
     - **Includes implementation AND tests** (not separate tasks)
     - Clear acceptance criteria
     - Tests pass before task is complete

3. **Present to User**
   ```
   Proposed Task Breakdown:

   Task 1: {TITLE}
   - Scope: {WHAT_IT_COVERS}
   - Deliverable: {CONCRETE_OUTPUT}
   - Dependencies: {NONE_OR_TASK_IDS}

   Task 2: {TITLE}
   ...
   ```

4. **Iterate**
   - Get user feedback
   - Adjust breakdown as needed
   - Confirm final task list

### Phase 3: Create Detailed Task Specs

For each approved task, create `/tmp/devplan/{epic-id}/tasks/task-{n}.md`:

```markdown
# Task: {TITLE}

## Overview
{ONE_PARAGRAPH_DESCRIPTION}

## User Value
{WHY_THIS_MATTERS}

## Scope
### In Scope
- {SPECIFIC_ITEM}
- {SPECIFIC_ITEM}

### Out of Scope
- {WHAT_WERE_NOT_DOING}

## Architecture Context
{RELEVANT_SECTIONS_FROM_CHAT_MD}

## Implementation Guidance

### Files to Change

**Documentation:**
- `{FILE_PATH}` - {WHAT_TO_UPDATE}

**Code:**
- `{FILE_PATH}` - {WHAT_TO_IMPLEMENT}

**Tests:**
- `{FILE_PATH}` - {WHAT_TO_TEST}

### Step-by-Step Approach

#### Phase 1: Documentation
{SPECIFIC_DOCS_GUIDANCE}

#### Phase 2: Implementation Chunks

**IMPORTANT**: Each chunk includes BOTH implementation AND tests. Never separate "write code" and "write tests" into different chunks or tasks.

**Chunk 1: {DESCRIPTIVE_NAME}**
- Implement: {CONCRETE_STEPS}
- Write tests: {TEST_CASES}
- Verify tests pass: `just test`
- Verify: `just check-all`

**Chunk 2: {DESCRIPTIVE_NAME}**
- Implement: {CONCRETE_STEPS}
- Write tests: {TEST_CASES}
- Verify tests pass: `just test`
- Verify: `just check-all`

#### Phase 3: Final Verification
- Review all tests for completeness
- Ensure edge cases covered
- Run: `just check-all` (includes coverage check, 96% threshold)
- All tests must pass before task is complete

### Code Examples

```language
{CONCRETE_CODE_EXAMPLES_FROM_ARCHITECTURE}
```

## Acceptance Criteria
- [ ] {SPECIFIC_CRITERION}
- [ ] {SPECIFIC_CRITERION}
- [ ] Documentation updated (retcon style)
- [ ] All tests passing: `just check-all`
- [ ] Coverage >= 96%

## Testing Strategy

### Unit Tests
- Test {COMPONENT}: {SPECIFIC_SCENARIOS}
- Test {COMPONENT}: {SPECIFIC_SCENARIOS}

### Integration Tests
- Test {INTEGRATION_POINT}: {SCENARIO}

### User Verification
```bash
{COMMAND_TO_RUN}  # Expected: {OUTPUT}
```

## Quality Checks
```bash
just check-all   # Full quality gate (format, lint, typecheck, test, coverage 96%)
```

## Dependencies
- **Depends On**: {TASK_IDS or "none"}
- **Blocks**: {TASK_IDS or "none"}
```

### Phase 4: Update Metadata

Update `/tmp/devplan/{epic-id}/metadata.json`:

```json
{
  "epic_id": "{epic-id}",
  "title": "{EPIC_TITLE}",
  "status": "breakdown-complete",
  "created": "YYYY-MM-DD",
  "tasks": [
    {
      "id": "task-1",
      "title": "{TITLE}",
      "depends_on": []
    },
    {
      "id": "task-2",
      "title": "{TITLE}",
      "depends_on": ["task-1"]
    }
  ]
}
```

### Phase 5: Report Completion

Output:
```
✅ Epic Breakdown Complete

Epic: {TITLE}
Tasks: {COUNT}

Specs:
  - task-1.md: {TITLE}
  - task-2.md: {TITLE}
  - task-3.md: {TITLE}

Next: /plan-create
```

---

## Skills to Use

- `software-architecture` - For task breakdown and validation (BREAKDOWN mode)

---

## Quality Checks

Before marking breakdown complete:
- [ ] 3-8 tasks defined
- [ ] Each task independently deliverable
- [ ] **Each task includes BOTH implementation AND tests** (no separate "testing" tasks)
- [ ] Each task has clear scope (in/out)
- [ ] Implementation guidance is concrete
- [ ] Code examples provided
- [ ] Dependencies identified
- [ ] Test strategy defined per task
- [ ] Acceptance criteria clear (includes passing tests)
- [ ] All task specs written to tasks/*.md
- [ ] metadata.json updated with task list
- [ ] **No tasks titled "Add tests" or "Write tests"** (tests are part of each task)

---

## Example Task Structure

A good task spec:
- **Is concrete**: Exact files to change, exact functions to add
- **Has examples**: Code snippets showing the interface
- **Is chunked**: Broken into 2-4 verifiable chunks
- **Is testable**: Clear test cases for each chunk
- **Is bounded**: Explicit out-of-scope to prevent scope creep
- **Tests included**: Each chunk has implementation + tests together

A bad task spec:
- Vague: "Improve error handling"
- Too big: "Implement entire authentication system"
- No guidance: "Add tests"
- No examples: Only prose descriptions
- **Tests separate**: "Task 1: Implement feature, Task 2: Write tests"

---

## Anti-Patterns to Avoid

**❌ NEVER separate implementation and testing into different tasks:**
```
Task 1: Implement user validation
Task 2: Implement email handling
Task 3: Implement password rules
Task 4: Write tests for all features  ← WRONG
```

**✅ ALWAYS include tests in each task:**
```
Task 1: Implement user validation (with tests)
Task 2: Implement email handling (with tests)
Task 3: Implement password rules (with tests)
```

**Definition of Done for EVERY task:**
- Code implemented
- Tests written
- Tests passing
- Coverage ≥96%
- `just check-all` passes

**If you find yourself creating a task titled "Add tests" or "Write tests for X", you're doing it wrong.** Tests are part of each implementation task, not a separate task.
