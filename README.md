# Aug Plugin Marketplace

A collection of plugins for Claude Code providing development workflows, tooling standards, and AI-enhancement capabilities.

## Available Plugins

### aug-dev

Core development workflows and tooling standards for software engineering projects.

**Location:** `aug-dev/`

**Version:** 3.0.0

**Contents:**
- Epic planning with architecture design and task breakdown
- Autonomous task execution from GitHub issues
- Project initialization and environment setup
- Systematic refactoring with coverage requirements
- Stack configuration (JavaScript/TypeScript, Python, Java)
- Development standards (justfile, git hooks, GitHub Actions, CLAUDE.md/MkDocs docs)

[View plugin details](aug-dev/README.md)

### aug-core

AI-enhancement capabilities for making Claude more powerful.

**Location:** `aug-core/`

**Version:** 3.0.0 (Major v3 overhaul)

**Contents:**
- Session management (save/resume context across sessions)
- Hemingwayesque (concise prompt writing)
- Automate (autonomous command execution with user proxy)
- Workflow orchestration (multi-command workflows)
- Workflow design skill (discover/design/refactor workflows)

**Key Features:**
- `/hemingway` - Ruthless concision for AI prompts
- `/automate /command` - Run commands autonomously
- `/workflow-run [workflow-name]` - Execute complete workflows
- User-standin agent for context-aware automation

[View plugin details](aug-core/README.md)

### aug-just

Justfile standard interface management with maturity model.

**Location:** `aug-just/`

**Version:** 3.0.0 (New in v3)

**Contents:**
- Justfile standard interface (baseline commands)
- 5-level maturity model (baseline → quality → security → advanced → polyglot)
- Assessment-driven progression with YAGNI enforcement
- Stack-specific implementations (Python, JavaScript, Java, Polyglot)
- Installation, assessment, refactoring, and upgrade commands

**Key Features:**
- `/just-init [stack]` - Generate baseline justfile for your stack
- `/just-assess` - Analyze current justfile maturity and gaps
- `/just-refactor` - Make existing justfile conform to standard
- `/just-upgrade [level|pattern]` - Add capabilities incrementally
- Level 0 non-negotiable, higher levels added as needed

[View plugin details](aug-just/README.md)

### aug-web

Web development patterns and Next.js-specific workflows.

**Location:** `aug-web/`

**Version:** 3.0.0

**Contents:**
- Next.js, static sites, Tailwind patterns
- Web-specific development standards

[View plugin details](aug-web/README.md)

## Installation

### From GitHub (once published)

```bash
/plugin marketplace add owner/aug
```

### Local Development

```bash
# Add marketplace locally
/plugin marketplace add /path/to/aug

# Install plugins
/plugin install aug-dev@aug
/plugin install aug-core@aug
/plugin install aug-just@aug
/plugin install aug-web@aug

# Or install all at once
/plugin install aug-dev@aug aug-core@aug aug-just@aug aug-web@aug
```

## Quick Start

### Epic Development Workflow

```bash
# Manual execution (step-by-step)
/plan-chat "Add JWT authentication"
/plan-breakdown
/plan-create
/work 123

# Automated execution (full workflow)
/workflow-run epic-development
```

### Session Management

```bash
# Save context before switching work
/notetoself

# Resume later
/futureme
```

### Concise Prompt Writing

```bash
# Rewrite verbose content
/hemingway "I would like you to please help me understand..."
```

### Automate Interactive Commands

```bash
# Run commands autonomously
/automate /plan-breakdown
/automate /refactor src/auth/
```

### Justfile Standards

```bash
# Initialize new project with justfile
/just-init python

# Assess existing justfile
/just-assess

# Upgrade to next maturity level
/just-upgrade 1  # Add quality gates
```

## Plugin Structure

Each plugin follows standard Claude Code plugin structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json    # Plugin metadata (required)
├── CLAUDE.md          # Architecture and implementation details
├── README.md          # User-facing documentation
├── skills/            # Skills directory (optional)
│   └── skill-name/
│       └── SKILL.md
├── commands/          # Commands directory (optional)
│   └── command.md
├── agents/            # Agents directory (optional)
│   └── agent.md
└── workflows/         # Workflows directory (optional)
    └── workflow.md
```

## Version 3.0 Highlights

**Major Changes:**
- Renamed `aug-util` → `aug-core` with expanded scope
- Added hemingwayesque skill for concise AI prompt writing
- Added automate command with user-standin agent
- Added workflow system (design, run, status commands)
- Integrated epic-development workflow across aug-dev and aug-core

**Philosophy:**
- Context-driven automation (reads CLAUDE.md, analyzes codebase)
- Cross-plugin integration (commands reference workflows)
- Three execution modes: manual, automated, hybrid
- "Not One Word Wasted" for all AI-facing content

## Contributing

To add new plugins to this marketplace:

1. Create plugin directory with appropriate structure
2. Add CLAUDE.md and README.md documentation
3. Update `.claude-plugin/marketplace.json`
4. Test plugin installation and usage
5. Follow hemingwayesque principles for concise documentation

## License

[Specify license]
