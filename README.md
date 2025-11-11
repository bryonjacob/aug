# Aug Plugin Marketplace

A collection of plugins for Claude Code providing development workflows, tooling standards, and productivity utilities.

## Available Plugins

### dev

Development workflows and tooling for software engineering projects.

**Location:** `dev/`

**Contents:**
- 15 skills covering stack configuration, web UI development, development standards, and workflows
- 6 commands for issue management, refactoring, and project initialization

[View plugin details](dev/README.md)

### util

Personal productivity utilities for session management.

**Location:** `util/`

**Contents:**
- 2 commands for saving and resuming working context across sessions

[View plugin details](util/README.md)

## Installation

### From GitHub (once published)

```bash
/plugin marketplace add owner/aug
```

### Local Development

```bash
# Symlink to local development directory
/plugin marketplace add /app/bryon/aug

# Or use absolute path
/plugin marketplace add ~/path/to/aug
```

### Installing Plugins

After adding the marketplace, install individual plugins:

```bash
# Install dev plugin
/plugin install dev@aug

# Install util plugin
/plugin install util@aug

# Install both
/plugin install dev@aug util@aug
```

## Plugin Structure

Each plugin follows the standard Claude Code plugin structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json    # Plugin metadata (required)
├── README.md          # Plugin documentation
├── skills/            # Skills directory (optional)
│   └── skill-name/
│       └── SKILL.md
├── commands/          # Commands directory (optional)
│   └── command.md
├── agents/            # Agents directory (optional)
│   └── agent.md
└── hooks/             # Hooks directory (optional)
    └── hooks.json
```

## Usage

After installation, all skills and commands from installed plugins are available in Claude Code:

```bash
# Use a command
/work 123

# Reference a skill in context
@executing-development-issues
```

## Contributing

To add new plugins to this marketplace:

1. Create plugin directory with appropriate structure
2. Add README.md documenting the plugin
3. Update this marketplace README
4. Test plugin installation and usage

## License

[Specify license]
