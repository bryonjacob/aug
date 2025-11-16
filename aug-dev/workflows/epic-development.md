# Epic Development Workflow

## Overview

End-to-end workflow from epic planning through task execution. Combines architecture design, task breakdown, GitHub issue creation, and autonomous implementation.

## When to Use

- Planning new features or major changes
- Need structured approach from idea to implementation
- Want to break large work into tracked tasks
- Prefer all planning upfront, then execution

## Phases

### 1. Design (interactive)
- **Command:** /plan-chat
- **Purpose:** Interactive architecture and design session
- **Output:** Design decisions, component breakdown, technical approach
- **Notes:** Most creative phase, requires human judgment

### 2. Breakdown (interactive)
- **Command:** /plan-breakdown
- **Purpose:** Decompose epic into deliverable tasks with specifications
- **Requires:** Design complete
- **Output:** Task specifications, implementation guidance, test strategy
- **Notes:** Transforms design into actionable chunks

### 3. Create Issues
- **Command:** /plan-create
- **Purpose:** Generate GitHub issues from task specifications
- **Requires:** Tasks defined
- **Output:** GitHub issues with full context for autonomous execution
- **Notes:** Issues become source of truth for implementation

### 4. Execute (repeatable)
- **Command:** /work [issue-number]
- **Purpose:** Autonomous task implementation from issue to PR
- **Requires:** GitHub issue exists
- **Repeatable:** Yes, run for each task
- **Output:** Feature branch, implementation, tests, PR
- **Notes:** Fully autonomous, handles format/lint/type errors

## Execution

### Manual (step-by-step)

```bash
# Phase 1: Design
/plan-chat "Add JWT authentication"
# [Interactive design session]

# Phase 2: Breakdown
/plan-breakdown
# [Interactive task breakdown]

# Phase 3: Create Issues
/plan-create
# [GitHub issues created: #45, #46, #47]

# Phase 4: Execute (repeat per task)
/work 45
/work 46
/work 47
```

### Automated (full workflow)

```bash
# Run entire workflow autonomously
/workflow-run epic-development

# User-standin agent handles:
# - Testing framework choices (reads CLAUDE.md, checks config)
# - Coverage thresholds (reads justfile)
# - Code style decisions (matches existing patterns)
# - Implementation approaches (follows architecture in CLAUDE.md)
```

### Hybrid (check progress)

```bash
# See current position
/workflow-status epic-development

# Continue from where you left off
/plan-create  # If at phase 3
/work 45      # If at phase 4
```

## Decision Points

### During Design (/plan-chat)
- Architecture approach
- Component boundaries
- Technology choices
- Testing strategy

**Automation:** User-standin reads CLAUDE.md for architecture patterns, checks existing code for consistency.

### During Breakdown (/plan-breakdown)
- Task granularity
- Testing framework
- Coverage requirements
- Implementation order

**Automation:** User-standin checks justfile for standards, package.json/pyproject.toml for tools configured.

### During Execute (/work)
- Specific implementation details
- Edge case handling
- Performance optimizations

**Automation:** Fully autonomous, follows specifications in GitHub issue.

## Workflow Variants

### Quick Feature (skip planning phases)
When feature is simple and well-understood:

```bash
# Manually create GitHub issue with spec
gh issue create --title "Add logout button" --body "[spec]"

# Jump to execution
/work 123
```

### Planning Only (stop before execution)
When you want to plan but execute later:

```bash
/plan-chat "Feature description"
/plan-breakdown
/plan-create
# Stop here - issues created for later execution
```

### Resume After Interrupt
If workflow interrupted:

```bash
# Check where you are
/workflow-status epic-development

# Continue from current phase
/[next-command]
```

## Success Criteria

### After Design Phase
- Clear architecture documented
- Component boundaries defined
- Technical approach agreed
- Output: `/tmp/devplan/architecture.md`

### After Breakdown Phase
- Epic decomposed into 3-10 tasks
- Each task has specification and acceptance criteria
- Implementation guidance provided
- Output: `/tmp/devplan/tasks/*.md`

### After Create Issues Phase
- GitHub issues created with full context
- Issues labeled and organized
- Milestone set (if applicable)
- Output: Issues #45-#49

### After Execute Phase
- All tasks implemented
- Tests passing
- PRs merged
- Feature complete

## Common Pitfalls

### Skipping Design Phase
❌ Jump straight to breakdown
→ Vague tasks, unclear architecture

✅ Start with /plan-chat
→ Clear vision guides breakdown

### Tasks Too Large
❌ Tasks take multiple days
→ Hard to review, risky PRs

✅ Tasks take hours, not days
→ Small, reviewable PRs

### Insufficient Context in Issues
❌ Brief issue descriptions
→ /work lacks guidance

✅ Full specs from /plan-create
→ Autonomous execution succeeds

## Integration

### With aug-dev
Commands live in aug-dev:
- `/plan-chat` → `aug-dev/commands/plan-chat.md`
- `/plan-breakdown` → `aug-dev/commands/plan-breakdown.md`
- `/plan-create` → `aug-dev/commands/plan-create.md`
- `/work` → `aug-dev/commands/work.md`

Workflow lives in aug-core:
- Workflow doc → `aug-core/workflows/epic-development.md`

### With Automation
- `/automate` enables autonomous phase execution
- `user-standin` agent makes context-based decisions
- `/workflow-run` orchestrates full workflow

### With Planning System
- Uses `/tmp/devplan/` for ephemeral planning
- Optional: `/plan-commit` to persist to `.devplan/`
- GitHub issues become source of truth post-planning

## Notes

- **Planning is ephemeral:** `/tmp/devplan/` by default, optional persistence
- **Issues are truth:** After `/plan-create`, GitHub issues drive execution
- **Fully autonomous execution:** `/work` handles everything from branch to PR
- **Quality gates:** Must pass `just check-all` before merge
- **Flat branches:** All task branches from main, all PRs to main

## Related Workflows

- **quicktask:** Ad-hoc single tasks without full planning
- **refactor:** Systematic refactoring with coverage requirements
- **database-migration:** (future) Structured database changes
