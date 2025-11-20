# Module: Aug-Core Plugin

## Purpose

AI-enhancement capabilities for Claude Code. Provides tools for making Claude more powerful: session management, concise prompt writing, autonomous command execution, and workflow orchestration.

## Responsibilities

- Session context management across conversations
- Concise prompt and context writing (hemingwayesque)
- Autonomous command execution with user proxy (automate)
- Multi-command workflow definition and orchestration
- Workflow design and analysis
- Code pattern detection and consistency suggestions
- Team workflow variant generation (marketplace customization)

## Key Files

### Commands (`commands/`)
- `notetoself.md` - Save current session context to `/tmp` for later resumption
- `futureme.md` - Resume work from previous session using saved context
- `hemingway.md` - Apply hemingwayesque principles to rewrite content concisely
- `automate.md` - Execute commands autonomously with user-standin agent
- `workflow-run.md` - Execute complete workflow automated
- `workflow-status.md` - Show current workflow position and next steps
- `learn.md` - Analyze codebase for pattern conventions
- `suggest.md` - Compare file to conventions, suggest improvements
- `patterns.md` - Show all detected project conventions
- `create-variant.md` - Generate team-specific workflow variant from aug marketplace

### Skills (`skills/`)
- `hemingwayesque/` - Ruthless concision for AI prompts and context
- `workflow-design/` - Design, discover, and refactor multi-command workflows
- `code-patterns/` - Learn project conventions, detect patterns, suggest consistency
- `creating-variants/` - Create team-specific workflow variants adapted to existing tools

### Agents (`agents/`)
- `user-standin.md` - Context-aware proxy for user in automated workflows

## Public Interface

### Session Management
- `/notetoself` - Save session context to `/tmp/notetoself-{dir-hash}.md`
- `/futureme` - Resume from previously saved context

### Prompt Crafting
- `/hemingway [content]` - Rewrite content using hemingwayesque principles
- Skills can reference hemingwayesque for consistent voice

### Automation
- `/automate /command [args]` - Run command autonomously with user-standin agent

### Workflows
- `/workflow-run [workflow-name]` - Execute full workflow automated
- `/workflow-status [workflow-name]` - Show workflow progress and next step

### Code Patterns
- `/learn [pattern-type]` - Analyze codebase for conventions (error-handling, testing, imports, naming, architecture)
- `/suggest [file]` - Compare file to project conventions
- `/patterns` - Show all detected conventions

### Team Variants
- `/create-variant [team-name]` - Generate team-specific workflow files adapted to existing tools/processes

### Skills
All skills available for use via `Skill` tool.

## Dependencies

- **Uses:** Claude Code plugin system, Task tool for subagents
- **Used by:** Developers enhancing Claude's capabilities
- **Related:** aug-dev commands can reference aug-core workflows

## Architecture Decisions

**Session Management:**
- Files stored in `/tmp/notetoself-{sha256-hash}.md`
- Directory-isolated (hash based on pwd)
- Ephemeral working memory, not git replacement

**Hemingwayesque Philosophy:**
- "Not One Word Wasted"
- Economy of language for AI context efficiency
- Skill provides principles, command applies them
- Other skills reference for consistent voice

**Automate Strategy:**
- Uses Task tool to launch subagent
- User-standin agent asks "What would the user do?"
- Context-driven: reads CLAUDE.md, analyzes structure, searches content
- Not learning-based, purely contextual each invocation

**Workflow System:**
- Workflows define phases with commands
- Commands reference workflows (not duplicate)
- Metadata below frontmatter (preserves Anthropic schema)
- Three execution modes: automated, manual, hybrid
- Workflow skill helps discover/design/refactor

**Cross-Plugin Integration:**
- aug-dev commands can reference aug-core workflows
- Workflows can orchestrate commands across plugins
- Enables reusable workflow patterns

## Testing

Capabilities tested through:
- Real-world usage in development workflows
- Epic-development workflow as litmus test
- Workflow design skill on existing command sets

## Plugin Metadata

Defined in `.claude-plugin/plugin.json`:
- Name: `aug-core`
- Version: `3.0.0`
- Category: `productivity`
- Keywords: ai-enhancement, automation, workflows, session, prompts
