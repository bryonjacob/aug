---
name: plan-chat
description: Interactive architecture and design session for epic planning
argument-hint: <epic-description>
---

**Workflow:** [epic-development](../workflows/epic-development.md) • **Phase:** design (step 1/4) • **Next:** /plan-breakdown

# Plan Chat - Interactive Epic Design

Start an interactive architecture and design session for a new epic.

**Purpose**: Collaborate on high-level architecture, explore alternatives, and make key design decisions. Creates planning artifacts in `/tmp/devplan/{epic-id}/`.

**Next Commands**: After completing this session, run `/plan-breakdown` to decompose the epic into tasks.

---

## Workflow

Use the `software-architecture` skill to guide this interactive session.

### Phase 1: Understanding

**Use TodoWrite to track progress through these steps:**

1. **Clarify the Problem**
   - Ask questions about scope, constraints, and goals
   - Understand what we're solving and why
   - Identify any similar functionality in the codebase

2. **Explore Codebase**
   - Use the built-in Explore agent to find related code
   - Review existing patterns and approaches
   - Understand current architecture

3. **Review Philosophy**
   - Check against project philosophy documents
   - Ensure alignment with simplicity principles
   - Review modular design patterns

### Phase 2: Architecture Design

**Use the `software-architecture` skill in ANALYZE and ARCHITECT modes:**

1. **Propose Alternatives**
   - Present at least 2 different architectural approaches
   - List pros/cons for each approach
   - Include trade-offs and complexity considerations

2. **Get User Decision**
   - Present options clearly
   - Get user to choose approach
   - Document rationale for choice

3. **Define Architecture**
   - Module boundaries ("bricks")
   - Public interfaces ("studs")
   - Data flow and dependencies
   - Key design decisions with rationale

4. **Create Examples**
   - Interface code examples
   - Usage patterns
   - Integration points

### Phase 3: Save Planning Session

1. **Create Epic ID**
   - Generate slug from epic title (e.g., "jwt-auth", "api-caching")
   - Create directory: `/tmp/devplan/{epic-id}/`

2. **Write chat.md**
   ```markdown
   # Epic: {TITLE}

   ## Problem Statement
   {WHAT_WE_RE_SOLVING}

   ## Architecture
   {HIGH_LEVEL_APPROACH}

   ### Module Structure
   {MODULE_DEFINITIONS}

   ### Key Decisions
   1. **{DECISION}**: {RATIONALE}

   ### Interface Examples
   ```language
   {CODE_EXAMPLES}
   ```

   ## Philosophy Alignment
   ### Ruthless Simplicity
   {HOW_DESIGN_STAYS_SIMPLE}

   ### Modular Design
   {CLEAR_BOUNDARIES}
   ```

3. **Write metadata.json**
   ```json
   {
     "epic_id": "{epic-id}",
     "title": "{TITLE}",
     "status": "chat-complete",
     "created": "YYYY-MM-DD",
     "tasks": []
   }
   ```

### Phase 4: Report Completion

Output:
```
✅ Epic Planning Session Complete

Epic: {TITLE}
Planning: /tmp/devplan/{epic-id}/chat.md

Key Decisions:
- {DECISION_1}
- {DECISION_2}

Next: /plan-breakdown
```

---

## Skills to Use

- `software-architecture` - For architecture analysis and design
- Built-in `Explore` agent - For codebase reconnaissance

---

## Quality Checks

Before marking session complete:
- [ ] Problem clearly defined
- [ ] Architecture addresses problem
- [ ] Design maximally simple
- [ ] Module boundaries clear
- [ ] Key decisions documented with rationale
- [ ] Interface examples provided
- [ ] Philosophy alignment verified
- [ ] All artifacts written to /tmp/devplan/{epic-id}/

---

## Example Usage

```bash
/plan-chat "Add JWT authentication with refresh tokens"
```

This starts an interactive session where Claude will:
1. Ask clarifying questions about the authentication requirements
2. Explore existing auth patterns in your codebase
3. Propose 2-3 different approaches (e.g., library-based vs custom)
4. Help you choose the best approach
5. Design the module structure and interfaces
6. Save complete architecture documentation to /tmp/devplan/jwt-auth/
