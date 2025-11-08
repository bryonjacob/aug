# Module: Aug-Dev Plugin

## Purpose

Core development workflows and tooling standards for software engineering projects. Encompasses the complete software development lifecycle from project initialization through issue planning, execution, refactoring, and code review.

## Responsibilities

- Project initialization and environment setup
- Issue planning and management (GitHub or local)
- Autonomous issue execution with parallel/sequential strategies
- Systematic refactoring with coverage requirements
- Stack configuration (JavaScript/TypeScript, Python, Java)
- Development standards (justfile, git hooks, GitHub Actions, CLAUDE.md/MkDocs docs)

## Key Files

### Commands (`commands/`)
- `work.md` - Autonomous issue execution with sequential/parallel strategies and git worktree support
- `plan.md` - Break down work into GitHub or local issues with execution strategy analysis
- `refactor.md` - Systematic refactoring requiring 90%+ coverage before changes
- `quicktask.md` - Ad-hoc task workflow (combines plan + work)
- `start-project.md` - Initialize new project with full development setup
- `devinit.md` - Audit existing project and set up missing components

### Skills (`skills/`)

**Stack Configuration:**
- `configuring-javascript-stack/` - JavaScript/TypeScript toolchain (pnpm, prettier, eslint, vitest)
- `configuring-python-stack/` - Python toolchain (uv, ruff, mypy, pytest)
- `configuring-java-stack/` - Java toolchain (maven, spotless, spotbugs, junit5)
- `configuring-polyglot-stack/` - Multi-language project orchestration
- `justfile-standard-interface/` - Standard justfile commands

**Development Standards:**
- `installing-git-hooks/` - Pre-commit/pre-push hooks calling justfile
- `configuring-github-actions/` - CI/CD workflows calling `just check-all`
- `documenting-with-claude-md/` - Machine-readable context (CLAUDE.md hierarchy)
- `documenting-with-mkdocs/` - Project documentation (MkDocs Material)

**Development Workflows:**
- `executing-development-issues/` - Complete issue lifecycle (branch → PR → merge)
- `refactoring/` - Refactoring with coverage/complexity gates
- `self-reviewing-code/` - Self-review checklist before marking PR ready
- `working-in-git-worktrees/` - Parallel work with isolated directories
- `creating-agents/` - Agent definition patterns

## Public Interface

### Commands
- `/work [STRATEGY]` - Execute issues with execution strategy syntax
- `/plan [DESCRIPTION]` - Create GitHub/local issues with execution strategy
- `/refactor [SCOPE]` - Refactor with coverage gates
- `/quicktask [DESCRIPTION]` - Quick ad-hoc task with issue tracking
- `/start-project [NAME]` - Initialize new project
- `/devinit` - Audit and setup development environment

### Skills
All skills available for reference using `@skill-name` syntax.

## Dependencies

- **Uses:** Claude Code plugin system
- **Used by:** Software engineer agents, development workflows
- **Related:** aug-web extends JavaScript stack with web-specific patterns

## Architecture Decisions

**Issue Storage:**
- Prefer GitHub issues when git remote configured
- Fallback to `ISSUES.LOCAL/LOCAL###-Title.md` for local-only projects
- Same SDLC rigor regardless of storage mechanism

**Execution Strategies:**
- Visual syntax for parallel/sequential: `>` (sequential), `|` (parallel), `()` (grouping)
- Git worktrees required for parallel execution to avoid race conditions
- Conservative parallelization - only when clearly independent

**Quality Gates:**
- All workflows require `just check-all` passing before merge
- 96% coverage threshold (justfile-standard-interface)
- No shortcuts on testing or quality

**Tooling Standards:**
- `justfile` (not Makefile) for build commands
- Git hooks call justfile commands (DRY principle)
- GitHub Actions runs `just check-all` for PR checks

## Testing

Skills and commands are tested through:
- Real-world usage in development workflows
- Agent execution validation
- Quality gate enforcement in CI/CD

## Plugin Metadata

Defined in `.claude-plugin/plugin.json`:
- Name: `aug-dev`
- Version: `1.2.0`
- Category: `development`
- Keywords: development, workflow, ci-cd, testing, refactoring, git
