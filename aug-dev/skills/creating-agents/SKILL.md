---
name: creating-agents
description: Use when creating or editing agent definitions - ensures proper frontmatter, clear structure, validation of references, and no duplication with existing agents
---

# Creating Agents

## Purpose

Create well-formed agent definitions following established patterns. Avoid duplication, ensure proper structure.

## Agent Structure

```markdown
---
name: agent-name
description: Brief one-line description explaining WHEN to use
---

# Agent Title

## Purpose
Clear statement of what this agent does

[Main content sections...]
```

**Frontmatter:**
- `name`: kebab-case
- `description`: One line, action-oriented (~60 chars)
  - ✅ "Python toolchain setup and configuration standards"
  - ❌ "An agent that helps with Python"

## Before Creating

**1. Check existing:**
```bash
ls .claude/agents/ ~/.claude/agents/
grep -r "keyword" .claude/agents/
```

**2. Validate no overlap** - merge into existing if similar

**3. Location:**
- Project-specific → `.claude/agents/`
- User-global → `~/.claude/agents/` (only if requested)

## Agent Types

**Stack/Tooling** (`[language]-stack`):
- Toolchain and tools
- Configuration files
- Quality thresholds

**Workflow** (process name):
- Step-by-step process
- When to use / avoid
- Examples and anti-patterns

**Standards** (`[topic]-standards`):
- Rules and conventions
- Rationale
- Verification

**Setup** (`[tool]-setup`):
- Installation
- Configuration
- Verification

## Creation Steps

**1. Define:**
- What problem?
- Who uses it and when?
- Trigger for using?

**2. Scope:**
- IN scope (specific problem)
- OUT scope (reference other agents)

**3. Structure:**

Stack agents:
```markdown
## Toolchain
## Project Structure
## Setup Commands
## Configuration Files
## Quality Thresholds
## Common Patterns
```

Workflow agents:
```markdown
## Purpose
## When to Use
## Workflow Steps
## Examples
## Common Pitfalls
```

**4. Validate references:**
```bash
test -f .claude/agents/agent-name.md && echo "exists" || echo "missing"
```

**5. Checklist:**
- [ ] Frontmatter with name and description
- [ ] Name is kebab-case
- [ ] Description one line, action-oriented
- [ ] Purpose clearly stated
- [ ] Instructions actionable
- [ ] Code examples complete
- [ ] All @agent-name references validated
- [ ] No duplication

## Naming Patterns

- `[language]-stack` - python-stack, javascript-stack
- `[tool]-setup` - git-setup, docker-setup
- `[topic]-standards` - context-standards
- `[process]` - refactorer, software-engineer
- `[feature]-[aspect]` - design-system, website-forms

## Porting Patterns

When creating similar agents:

**1. Read references:**
```bash
cat .claude/agents/python-stack.md
cat .claude/agents/javascript-stack.md
```

**2. Extract:**
- Common sections?
- Universal principles?
- Domain-specific?

**3. Apply:**
- Research tools for target domain
- Match structure from references
- Adapt quality thresholds
- Maintain voice/detail level

Extract the **agentic skills/goals**, not just content.

## Editing Existing

**1. Read first:**
```bash
cat .claude/agents/agent-name.md
```

**2. Understand scope** - what it does, patterns

**3. Surgical changes:**
- Don't rewrite unnecessarily
- Preserve style
- Keep consistent with purpose

**4. Validate:**
- References still valid
- No conflicts
- Frontmatter correct

## Common Mistakes

❌ Overlapping agents - check existing first
❌ Vague descriptions - be specific about when
❌ Missing frontmatter
❌ Broken references
❌ Wrong location
❌ Duplicating content - reference instead
❌ Mega-agents - stay focused

## Verification

```bash
# Check frontmatter
head -5 .claude/agents/agent-name.md

# Validate references
grep -o '@[a-z-]*' .claude/agents/agent-name.md

# Check naming
echo "agent-name" | grep -E '^[a-z][a-z0-9-]*$'
```
