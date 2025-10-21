---
name: creating-agents
description: Use when creating or editing agent definitions - ensures proper frontmatter, clear structure, validation of references, and no duplication with existing agents
---

# Creating Agents

## Overview

Create well-formed agent definitions that follow established patterns, avoid duplication, and provide clear, actionable guidance.

## Agent Anatomy

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

**Frontmatter rules:**
- `name`: kebab-case, descriptive
- `description`: One line, action-oriented (~60 chars)
  - ✅ "Python toolchain setup and configuration standards"
  - ❌ "An agent that helps with Python"

## Before Creating

**1. Check for existing agents:**
```bash
ls .claude/agents/
ls ~/.claude/agents/
grep -r "keyword" .claude/agents/
```

**2. Validate no overlap:**
- Is there already an agent for this domain?
- Should this be merged into existing agent?

**3. Determine location:**
- Project-specific → `.claude/agents/`
- User-global → `~/.claude/agents/` (only if explicitly requested)

## Agent Categories

**Stack/Tooling agents** (`[language]-stack`):
- Language toolchain and tools
- Configuration files
- Quality thresholds

**Workflow agents** (process name):
- Step-by-step process
- When to use / when not to use
- Examples and anti-patterns

**Standards agents** (`[topic]-standards`):
- Rules and conventions
- Rationale for standards
- How to verify/enforce

**Setup agents** (`[tool]-setup`):
- Installation steps
- Configuration
- Verification

## Creation Workflow

**1. Understand the need:**
- What problem does this solve?
- Who uses it and when?
- What's the trigger for using this agent?

**2. Define scope:**
- What's IN scope (specific problem)
- What's OUT of scope (reference other agents)

**3. Choose appropriate structure:**

For **stack agents:**
```markdown
## Toolchain
## Project Structure
## Setup Commands
## Configuration Files
## Quality Thresholds
## Common Patterns
```

For **workflow agents:**
```markdown
## Purpose
## When to Use
## Workflow Steps
## Examples
## Common Pitfalls
```

**4. Validate references:**
```bash
# If agent includes @agent-name references, verify they exist
test -f .claude/agents/agent-name.md && echo "exists" || echo "missing"
```

**5. Quality checklist:**
- [ ] Frontmatter includes name and description
- [ ] Name is kebab-case
- [ ] Description is one line, action-oriented
- [ ] Purpose clearly stated
- [ ] Instructions are actionable
- [ ] Code examples are complete
- [ ] All @agent-name references validated
- [ ] No duplication of existing content

## Naming Conventions

**Format:** kebab-case

**Patterns:**
- `[language]-stack` - python-stack, javascript-stack
- `[tool]-setup` - git-setup, docker-setup
- `[topic]-standards` - context-standards
- `[process]` - refactorer, software-engineer
- `[feature]-[aspect]` - design-system, website-forms

## Porting Patterns

When creating similar agents (e.g., "java-stack like python-stack"):

**1. Read reference agents:**
```bash
cat .claude/agents/python-stack.md
cat .claude/agents/javascript-stack.md
```

**2. Extract common patterns:**
- What sections do they share?
- What principles are universal?
- What's domain-specific?

**3. Apply to new domain:**
- Research best-in-breed tools for target language
- Match the structure from reference agents
- Adapt quality thresholds (same principles, domain values)
- Maintain consistent voice and detail level

**Key:** Extract the **agentic skills/goals**, not just content.

## Editing Existing Agents

**1. Read the agent first:**
```bash
cat .claude/agents/agent-name.md
```

**2. Understand current scope:**
- What is it trying to do?
- What patterns does it follow?

**3. Make surgical changes:**
- Don't rewrite unnecessarily
- Preserve existing style
- Keep consistent with purpose
- Update references if changed

**4. Validate after editing:**
- Check @agent-name references still valid
- No conflicts introduced
- Frontmatter correct

## Common Mistakes

❌ **Creating overlapping agents** - Always check existing first
❌ **Vague descriptions** - Be specific about when to use
❌ **Missing frontmatter** - Every agent needs name and description
❌ **Broken references** - Validate all @agent-name references
❌ **Wrong location** - Project `.claude/agents/`, not `~/.claude/agents/`
❌ **Duplicating content** - Reference existing agents instead
❌ **Mega-agents** - Keep focused on one thing

## Verification

**After creating/editing:**

```bash
# Check frontmatter
head -5 .claude/agents/agent-name.md

# Validate references
grep -o '@[a-z-]*' .claude/agents/agent-name.md

# Check naming
echo "agent-name" | grep -E '^[a-z][a-z0-9-]*$'
```

## When to Use This Skill

✅ **Use when:**
- Creating a new agent definition
- Editing existing agents
- Porting patterns from existing agents
- Validating agent references
- Checking for conflicts/overlap

❌ **Don't use for:**
- General documentation (not agents)
- Project CLAUDE.md files
