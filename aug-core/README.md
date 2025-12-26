# Aug-Core: AI Enhancement Capabilities

AI-enhancement toolkit for Claude Code. Tools for making Claude more powerful through session management, concise writing, automation, and workflow orchestration.

## Features

### Session Management
Save and resume working context across sessions to avoid conversation compacting overhead.

```bash
/notetoself              # Save current context
/futureme                # Resume from saved context
```

### Hemingwayesque: Concise Prompt Writing
Ruthless concision for AI prompts and context. "Not One Word Wasted."

```bash
/hemingway "Rewrite this skill to be more concise"
/hemingway "Write a prompt for analyzing code complexity"
```

### Automate: Autonomous Command Execution
Run interactive commands autonomously with context-aware user proxy.

```bash
/automate /plan-chat "Add authentication"
/automate /plan-breakdown
```

### Workflow Orchestration
Define and execute multi-command workflows.

```bash
/workflow-run epic-development
/workflow-status epic-development
```

### Code Pattern Learning
Analyze project conventions and suggest consistency improvements.

```bash
/learn error-handling      # Detect error handling patterns
/suggest src/auth.py       # Compare file to conventions
/patterns                  # Show all detected patterns
```

### Team Workflow Variants
Generate team-specific workflow files adapted to existing tools and processes.

```bash
/create-variant acme-corp
# Interactive wizard:
# - Discovers team's git workflow, issue tracker, build tools
# - Adapts aug workflows to team's existing practices
# - Generates customized commands/skills to .claude/
```

## Installation

```bash
# Add marketplace
/plugin marketplace add /path/to/aug

# Install plugin
/plugin install aug-core@aug
```

## Workflows

Workflows define sequences of commands for common patterns. Example: `epic-development`

**Manual execution:**
```bash
/plan-chat "Add JWT auth"    # Phase 1: Design
/plan-breakdown              # Phase 2: Break into tasks
/plan-create                 # Phase 3: Create GitHub issues
/work 124                    # Phase 4: Execute task
```

**Automated execution:**
```bash
/workflow-run epic-development
```

## Skills

- **hemingwayesque** - Concise prompt writing principles
- **workflow-design** - Design and analyze workflows
- **code-patterns** - Learn project conventions, detect patterns, suggest consistency
- **creating-variants** - Create team-specific workflow variants adapted to existing tools

## Agents

- **user-standin** - Context-aware user proxy for automation

## Documentation

See `CLAUDE.md` for architecture and implementation details.

## Opinionated Choices

This plugin makes specific design decisions:

| Choice | Rationale | Alternatives |
|--------|-----------|--------------|
| **Ephemeral session files** | `/tmp` storage, directory-isolated | Database, git-based |
| **Hemingwayesque style** | Economy for AI token efficiency | Verbose documentation |
| **CLAUDE.md context** | User-standin reads project structure | Config files, prompts |
| **Workflow YAML** | Simple phase definitions | DAG runners, CI tools |

### Adaptation Guide

**Session storage:** Change `/tmp/notetoself-{hash}.md` path in commands if you want persistent storage.

**User-standin behavior:** The agent reads CLAUDE.md hierarchy. Ensure your project has good CLAUDE.md files for best automation results.

**Workflow definitions:** Workflows are simple YAML with phases. Adapt to your team's command naming.

These patterns are general-purpose and transfer to most contexts without modification.

## Version

3.0.0 - Major v3 overhaul with automation and workflow capabilities
