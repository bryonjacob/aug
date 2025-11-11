# Aug Plugin Marketplace

## Purpose

A plugin marketplace for Claude Code providing development workflows, tooling standards, and productivity utilities. Organizes reusable skills and commands into installable plugin packages following the official Claude Code plugin architecture.

## Architecture Overview

This marketplace provides a centralized distribution point for Claude Code plugins. Each plugin is a self-contained package with its own manifest, skills, commands, and documentation.

**Key Components:**
- `.claude-plugin/marketplace.json` - Marketplace registry defining available plugins
- Individual plugin directories with their own `.claude-plugin/plugin.json` manifests
- Skills and commands organized within each plugin

**Design Decisions:**
- Simple two-plugin structure (dev/util) for initial organization
- Local development support via `/plugin marketplace add` with absolute paths
- Git-ready structure for future GitHub distribution
- Each plugin is independently installable

## Module Index

- `dev/` - Development workflows and tooling (see dev/CLAUDE.md)
- `util/` - Personal productivity utilities (see util/CLAUDE.md)
- `.claude-plugin/` - Marketplace metadata (marketplace.json)

## Tech Stack

- **Format:** JSON for plugin manifests, Markdown for skills/commands/docs
- **Distribution:** Claude Code plugin system
- **Installation:** Local filesystem or GitHub repository
- **Dependencies:** Claude Code v1.0+

## Development

### Installation

```bash
# Add marketplace locally
/plugin marketplace add /app/bryon/aug

# Install plugins
/plugin install aug-dev@aug
/plugin install util@aug
```

### Directory Structure

```
aug/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace registry
├── CLAUDE.md                      # This file
├── README.md                      # User-facing documentation
├── dev/                           # Dev plugin
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── CLAUDE.md
│   ├── README.md
│   ├── skills/
│   └── commands/
└── util/                          # Util plugin
    ├── .claude-plugin/
    │   └── plugin.json
    ├── CLAUDE.md
    ├── README.md
    └── commands/
```

### Adding New Plugins

1. Create plugin directory: `mkdir -p new-plugin/.claude-plugin`
2. Create plugin manifest: `new-plugin/.claude-plugin/plugin.json`
3. Add to marketplace registry in `.claude-plugin/marketplace.json`
4. Create plugin CLAUDE.md and README.md
5. Add skills/commands/agents as needed

### Workflow

Standard development workflow per ~/.claude/CLAUDE.md applies when modifying this marketplace.
