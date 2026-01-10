---
name: software-architecture
description: Analyze problems, design solutions, plan task breakdowns. Use for epic planning, architecture design, and task specification. Outputs planning artifacts for GitHub issue creation.
---

# Software Architecture

You analyze problems and design simple solutions for epic planning.

## Core Rule

Understand before building. Every abstraction must justify its existence.

## Working Directory

```
/tmp/devplan/{epic-id}/
  chat.md           # Architecture & design decisions
  metadata.json     # Epic info, task list
  tasks/
    task-1.md       # Detailed task specs
    task-2.md
```

All ephemeral. GitHub issues are source of truth after `/plan-create`.

## Modes

**ANALYZE** - Break problem into pieces, list 2-3 solutions with trade-offs, recommend one with rationale.

**ARCHITECT** - Define module boundaries, specify contracts (inputs/outputs/errors), document key decisions.

**BREAKDOWN** - Analyze architecture, propose 3-8 deliverable tasks, each independently testable with clear criteria.

## Decision Filter

Every choice must pass:
1. **Necessity**: Need this now?
2. **Simplicity**: Simplest solution?
3. **Directness**: More direct path?
4. **Value**: Worth the complexity?
5. **Maintenance**: Easy to change?

## Output Structure

### chat.md

Contains:
- Problem statement
- High-level architecture approach
- Module structure with boundaries
- Key decisions with rationale
- Interface examples (code)
- Simplicity and modularity alignment

### tasks/task-{n}.md

Contains:
- Overview (one paragraph)
- Scope (in/out)
- Architecture context (relevant bits from epic)
- Files to change (docs, code, tests)
- Implementation chunks with verify steps
- Code examples
- Acceptance criteria
- Testing strategy with user verification commands

### metadata.json

```json
{
  "epic_id": "{epic-id}",
  "title": "{TITLE}",
  "status": "breakdown-complete",
  "created": "YYYY-MM-DD",
  "tasks": [
    { "id": "task-1", "title": "{TITLE}", "depends_on": [] }
  ]
}
```

## Task Breakdown Principles

Each task must be:
- Single PR, single focus
- Clear acceptance criteria
- Independently testable
- Contains implementation guidance with chunks
- Includes code examples

## Quality Checks

Before task breakdown complete:
- [ ] Architecture addresses problem
- [ ] Design maximally simple
- [ ] Module boundaries clear
- [ ] Each task independently deliverable
- [ ] Implementation guidance concrete
- [ ] Code examples provided
- [ ] Test strategy defined

## Output Format

All planning artifacts structured for GitHub issue generation.
No local decision tracking - issues are source of truth.
