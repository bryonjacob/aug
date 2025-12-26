# Contributing to Aug

Aug welcomes contributions. This guide covers how to contribute effectively.

## Ways to Contribute

### Report Issues
- Workflow problems or edge cases
- Documentation unclear or missing
- Skill behavior not matching description

### Share Adaptations
Adapted Aug to your stack? Share it:
- Open an issue describing your adaptation
- Include what you changed (tools, thresholds, patterns)
- Note what transferred directly vs. needed modification

### Add Language Stacks
Want Go, Rust, or another stack?
1. Study existing stack skills (`configuring-python-stack`, etc.)
2. Follow the maturity model pattern
3. Include baseline justfile recipes
4. Document tool choices and alternatives

### Improve Documentation
- Clarify confusing sections
- Add examples for complex workflows
- Fix typos and broken links

## Adapting to Your Stack

Aug is opinionated. Here's how to adapt while keeping patterns:

### Keep the Workflow Structure
```
plan-chat → plan-breakdown → plan-create → work
```
This sequence works regardless of tools. The interactive planning / autonomous execution split transfers to any stack.

### Swap Tool Commands
In your justfile, replace tool invocations:
- `uv run pytest` → `poetry run pytest`
- `pnpm test` → `npm test`
- `ruff format` → `black .`

### Maintain Quality Gates
Keep the check-all pattern:
```just
check-all: format-check lint typecheck coverage
```
Specific tools change; the gate pattern stays.

### Adjust Thresholds
Aug uses 96% coverage. Your project might use:
- 80% for legacy codebases
- 90% for typical projects
- 100% for critical systems

Document your rationale.

## Plugin Development

### Structure
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # Required: name, description, version, license
├── CLAUDE.md            # Architecture for Claude
├── README.md            # User documentation
├── skills/              # Skills (optional)
│   └── skill-name/
│       └── SKILL.md
└── commands/            # Commands (optional)
    └── command.md
```

### Documentation Style
Follow hemingwayesque principles:
- Economy of language
- Show, don't tell
- Examples over exposition
- One concept per section

### Maturity Model Pattern
For progressive capability skills:
1. Define levels (what capabilities at each)
2. Include assessment criteria
3. Add "when to advance" guidance
4. Enforce YAGNI (level 0 mandatory, higher optional)

### Opinionated Choices
When making technology choices:
1. Pick specific tools (not "use your favorite")
2. Document rationale
3. List alternatives
4. Explain what transfers vs. what's tool-specific

## Code of Conduct

- Be respectful and constructive
- Focus on workflow patterns, not tool wars
- Share what worked, acknowledge what didn't
- Help others adapt to their contexts

## Questions?

Open an issue for:
- Clarification on patterns
- Help adapting to your stack
- Suggestions for new workflows
