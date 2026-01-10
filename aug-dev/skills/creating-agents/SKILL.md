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
  - Good: "Python toolchain setup and configuration standards"
  - Bad: "An agent that helps with Python"

## Location Guidelines

- Project-specific: `.claude/agents/`
- User-global: `~/.claude/agents/` (only if requested)
- Always check existing agents first to avoid overlap

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

## Naming Patterns

- `[language]-stack` - python-stack, javascript-stack
- `[tool]-setup` - git-setup, docker-setup
- `[topic]-standards` - context-standards
- `[process]` - refactorer, software-engineer
- `[feature]-[aspect]` - design-system, website-forms

## Design Principles

**Scope clearly:** Define what's IN scope (specific problem) and OUT of scope (reference other agents).

**Define the trigger:** What problem does this solve? Who uses it and when?

**Match structure to type:**

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

## Porting Principles

When creating similar agents from references:
- Extract the **agentic skills/goals**, not just content
- Identify common sections and universal principles
- Adapt quality thresholds for target domain
- Match structure from references
- Maintain consistent voice/detail level

## Editing Guidelines

- Read existing agent first to understand scope and patterns
- Make surgical changes - don't rewrite unnecessarily
- Preserve style and maintain consistency with purpose
- Validate references still work after changes

## Common Mistakes

- Overlapping agents - check existing first
- Vague descriptions - be specific about when to use
- Missing frontmatter
- Broken references
- Wrong location
- Duplicating content - reference instead
- Mega-agents - stay focused

## Verification

```bash
# Check frontmatter
head -5 .claude/agents/agent-name.md

# Validate references
grep -o '@[a-z-]*' .claude/agents/agent-name.md

# Check naming
echo "agent-name" | grep -E '^[a-z][a-z0-9-]*$'
```
