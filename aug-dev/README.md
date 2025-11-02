# Aug-Dev Plugin

Core development workflows and tooling standards for software engineering.

## Installation

```bash
/plugin install aug-dev@aug
```

## Skills

**Stack Configuration:**
- `configuring-javascript-stack` - JavaScript/TypeScript (pnpm, prettier, eslint, vitest)
- `configuring-python-stack` - Python (uv, ruff, mypy, pytest)
- `configuring-java-stack` - Java (maven, spotless, spotbugs, junit5)
- `configuring-polyglot-stack` - Multi-language orchestration
- `justfile-standard-interface` - Standard justfile commands

**Development Standards:**
- `installing-git-hooks` - Pre-commit/pre-push hooks calling justfile
- `configuring-github-actions` - CI/CD workflows calling `just check-all`
- `documenting-with-claude-md` - Machine-readable context (CLAUDE.md)
- `documenting-with-mkdocs` - Project documentation (MkDocs Material)

**Development Workflows:**
- `executing-development-issues` - Issue lifecycle (branch → PR → merge)
- `refactoring` - Refactoring with coverage/complexity gates
- `self-reviewing-code` - Self-review checklist before PR ready
- `working-in-git-worktrees` - Parallel work with isolated directories
- `creating-agents` - Agent definition patterns

## Commands

- `/work` - Execute issues sequentially through complete lifecycle
- `/plan` - Break down work into GitHub or local issues
- `/refactor` - Identify and execute refactoring with coverage gates
- `/quicktask` - Ad-hoc work with automatic issue creation
- `/start-project` - Initialize new project with full setup
- `/devinit` - Audit and setup missing components

## Related Plugins

- `aug-web` - Next.js, static sites, Tailwind (extends JavaScript stack)
