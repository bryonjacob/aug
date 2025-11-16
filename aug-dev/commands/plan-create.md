---
name: plan-create
description: Create comprehensive GitHub issues from planning artifacts
---

# Plan Create - Generate GitHub Issues

Transform planning artifacts from `/plan-chat` and `/plan-breakdown` into comprehensive GitHub issues.

**Purpose**: Create epic and task issues with complete specifications, making GitHub the source of truth for execution.

**Prerequisites**:
- Run `/plan-chat` to create architecture
- Run `/plan-breakdown` to create task specs

**Next Command**: Execute tasks with `/work <issue-number>`

---

## Workflow

### Phase 1: Load Planning Artifacts

1. **Find Active Epic**
   - Check `/tmp/devplan/` for complete planning sessions
   - Verify status is "breakdown-complete"
   - Read all artifacts:
     - `chat.md` (architecture)
     - `metadata.json` (epic info, task list)
     - `tasks/task-*.md` (all task specs)

### Phase 2: Create Epic Issue

Use `gh issue create` to create the epic issue with this structure:

```markdown
<!-- AUTO-PARSED METADATA -->
EPIC_ID: {epic-id}
EPIC_STATUS: planning-complete
CREATED: {YYYY-MM-DD}
TASKS_COUNT: {N}

---

# Epic: {TITLE}

## Problem Statement
{FROM_CHAT_MD}

## Architecture & Design
{FULL_ARCHITECTURE_FROM_CHAT_MD}

### Chosen Approach
{DESIGN_DESCRIPTION}

### Key Design Decisions
1. **{DECISION}**: {RATIONALE}
{ALL_DECISIONS_FROM_CHAT_MD}

### Module Structure
```
{MODULE_DEFINITIONS_FROM_CHAT_MD}
```

### Interface Definitions
```language
{CODE_EXAMPLES_FROM_CHAT_MD}
```

## Philosophy Alignment

### Ruthless Simplicity
{HOW_DESIGN_STAYS_SIMPLE_FROM_CHAT_MD}

### Modular Design
{CLEAR_BOUNDARIES_FROM_CHAT_MD}

## Task Breakdown
<!-- TASK_LIST_START -->
- [ ] Task 1: {TITLE} (issue: #TBD, branch: `epic/{id}/task-1`)
- [ ] Task 2: {TITLE} (issue: #TBD, branch: `epic/{id}/task-2`)
<!-- TASK_LIST_END -->

## Success Criteria
Epic complete when:
- [ ] All task issues closed
- [ ] All PRs merged
- [ ] Integration tests passing

## Workflow
Execute any task: `/work {TASK_ISSUE_NUMBER}`
```

**Save the epic issue number** for referencing in task issues.

### Phase 3: Create Task Issues

For each task in `tasks/task-*.md`, create a task issue with this structure:

```markdown
<!-- AUTO-PARSED METADATA -->
TASK_ID: {task-id}
EPIC_ID: {epic-id}
EPIC_ISSUE: #{EPIC_NUMBER}
BRANCH_NAME: epic/{epic-id}/{task-slug}
MERGE_TARGET: main
DEPENDS_ON: {#ISSUE_NUMBERS or "none"}
BLOCKS: {#ISSUE_NUMBERS or "none"}

---

# Task: {TITLE}

**Epic**: #{EPIC_ISSUE}
**Branch**: `epic/{epic-id}/{task-slug}`

## Overview
{FROM_TASK_MD}

## User Value
{FROM_TASK_MD}

## Scope
### In Scope
{FROM_TASK_MD}

### Out of Scope
{FROM_TASK_MD}

## Architecture Context
{FROM_TASK_MD}

## Implementation Guidance

### Files to Change
{COMPLETE_SECTION_FROM_TASK_MD}

### Step-by-Step Approach

#### Phase 1: Documentation
{FROM_TASK_MD}

#### Phase 2: Implementation Chunks
{ALL_CHUNKS_FROM_TASK_MD}

#### Phase 3: Test Review
{FROM_TASK_MD}

### Code Examples
```language
{ALL_EXAMPLES_FROM_TASK_MD}
```

## Acceptance Criteria
{ALL_CRITERIA_FROM_TASK_MD}

## Testing Strategy
{COMPLETE_STRATEGY_FROM_TASK_MD}

## Quality Checks
```bash
just check-all   # Full quality gate (format, lint, typecheck, test, coverage 96%)
```

## Execute
```bash
/work {THIS_ISSUE_NUMBER}
```
```

**Save each task issue number** for updating the epic.

### Phase 4: Update Epic with Task Numbers

Edit the epic issue to replace "issue: #TBD" with actual task issue numbers:

```markdown
## Task Breakdown
<!-- TASK_LIST_START -->
- [ ] Task 1: {TITLE} (issue: #{ACTUAL_NUMBER}, branch: `epic/{id}/task-1`)
- [ ] Task 2: {TITLE} (issue: #{ACTUAL_NUMBER}, branch: `epic/{id}/task-2`)
<!-- TASK_LIST_END -->
```

Also update task issue dependencies with actual issue numbers.

### Phase 5: Optional Cleanup

Ask user:
```
Planning artifacts created successfully!

Clean up /tmp/devplan/{epic-id}/?
- All content is now in GitHub issues
- Choose 'yes' for ephemeral (default)
- Choose 'no' to keep, or use /plan-commit to persist to repo

[yes/no]
```

If yes: `rm -rf /tmp/devplan/{epic-id}/`

### Phase 6: Report Completion

Output:
```
✅ Epic Planning Complete!

📋 Epic Issue: #{EPIC_ISSUE}
   {EPIC_URL}

✅ Task Issues: {COUNT}
   #{TASK_1}: {TITLE}
   #{TASK_2}: {TITLE}
   #{TASK_3}: {TITLE}

🌳 Git Branches:
   epic/{epic-id}/task-1  → PR to main (closes #{TASK_1})
   epic/{epic-id}/task-2  → PR to main (closes #{TASK_2})

🚀 Ready to Execute:
   /work {TASK_1_ISSUE}

💡 Tip: Use /plan-commit to persist planning to .devplan/ (optional)
```

---

## GitHub CLI Usage

```bash
# Create epic issue
gh issue create \
  --title "Epic: {TITLE}" \
  --body "$(cat epic-body.md)"

# Create task issue
gh issue create \
  --title "Task: {TITLE}" \
  --body "$(cat task-body.md)"

# Update epic issue
gh issue edit {EPIC_NUMBER} --body "$(cat updated-epic-body.md)"
```

---

## Quality Checks

Before marking creation complete:
- [ ] Epic issue created with full architecture
- [ ] All task issues created with complete specs
- [ ] Epic updated with actual task issue numbers
- [ ] Task dependencies reference actual issue numbers
- [ ] All issues have structured metadata at top
- [ ] All code examples included
- [ ] Branch names follow pattern: `epic/{epic-id}/{task-slug}`
- [ ] All issues reference `/work` command

---

## Error Handling

**If GitHub CLI not available:**
- Instruct user to install `gh` CLI
- Provide issue templates for manual creation

**If git remote not configured:**
- Ask user if they want to use local issue tracking
- Fall back to creating `.github/issues/` directory structure
- Use sequential numbering for local issues

---

## Example Output

```bash
$ /plan-create

Loading planning from /tmp/devplan/jwt-auth/...
✓ chat.md loaded
✓ metadata.json loaded
✓ 5 task specs loaded

Creating GitHub issues...

Creating epic issue...
✓ Epic issue created: #123
  https://github.com/user/repo/issues/123

Creating task issues...
✓ Task 1 created: #124 - Setup JWT dependencies
✓ Task 2 created: #125 - Implement token generation
✓ Task 3 created: #126 - Implement token validation
✓ Task 4 created: #127 - Add refresh token flow
✓ Task 5 created: #128 - Add token expiry handling

Updating epic with task numbers...
✓ Epic #123 updated with task links

Clean up /tmp/devplan/jwt-auth/?
> yes

✅ Epic Planning Complete!

📋 Epic Issue: #123
   https://github.com/user/repo/issues/123

✅ Task Issues: 5
   #124: Setup JWT dependencies
   #125: Implement token generation
   #126: Implement token validation
   #127: Add refresh token flow
   #128: Add token expiry handling

🌳 Git Branches:
   epic/jwt-auth/task-1  → PR to main (closes #124)
   epic/jwt-auth/task-2  → PR to main (closes #125)
   epic/jwt-auth/task-3  → PR to main (closes #126)
   epic/jwt-auth/task-4  → PR to main (closes #127)
   epic/jwt-auth/task-5  → PR to main (closes #128)

🚀 Ready to Execute:
   /work 124
```
