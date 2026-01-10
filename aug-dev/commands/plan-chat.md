---
name: plan-chat
description: Interactive architecture and design session for epic planning
argument-hint: <epic-description>
---

**Workflow:** [epic-development](../workflows/epic-development.md) • **Phase:** design (step 1/4) • **Next:** /plan-breakdown

# Plan Chat - Interactive Epic Design

Start an interactive architecture and design session for a new epic.

**Purpose**: Collaborate on high-level architecture, explore alternatives, and make key design decisions. Creates planning artifacts in `/tmp/devplan/{epic-id}/`.

**Skills Used**: `software-architecture` skill in ANALYZE and ARCHITECT modes.

**Next Command**: Run `/plan-breakdown` to decompose the epic into tasks.

---

## Workflow

Use TodoWrite to track progress.

### Phase 1: Understanding

Use the `software-architecture` skill to:
1. Clarify the problem - ask questions about scope, constraints, goals
2. Explore codebase for related code and existing patterns
3. Review project philosophy for simplicity alignment

### Phase 2: Architecture Design

Use the `software-architecture` skill to:
1. Propose 2+ architectural approaches with trade-offs
2. Get user decision and document rationale
3. Define architecture: module boundaries, interfaces, data flow
4. Create interface examples

### Phase 3: Save Planning Session

1. Create epic ID (slug from title, e.g., "jwt-auth")
2. Write artifacts to `/tmp/devplan/{epic-id}/`:
   - `chat.md` - Architecture and design decisions
   - `metadata.json` - Epic info with status "chat-complete"

### Phase 4: Report Completion

```
Epic: {TITLE}
Planning: /tmp/devplan/{epic-id}/chat.md

Key Decisions:
- {DECISION_1}
- {DECISION_2}

Next: /plan-breakdown
```

---

## Quality Checks

Before marking session complete:
- [ ] Problem clearly defined
- [ ] Architecture addresses problem
- [ ] Design maximally simple
- [ ] Module boundaries clear
- [ ] Key decisions documented with rationale
- [ ] Interface examples provided
- [ ] All artifacts written to /tmp/devplan/{epic-id}/

---

## Example

```bash
/plan-chat "Add JWT authentication with refresh tokens"
```

Starts interactive session: clarifying questions, codebase exploration, 2-3 approach proposals, chosen approach design, and saved architecture to `/tmp/devplan/jwt-auth/`.
