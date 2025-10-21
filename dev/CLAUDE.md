# Module: Dev Plugin

## Purpose

Provides comprehensive development workflows and tooling standards for software engineering projects. Encompasses the complete software development lifecycle from project initialization through issue planning, execution, refactoring, and code review.

## Responsibilities

- Project initialization and environment setup
- Issue planning and management (GitHub or local)
- Autonomous issue execution with parallel/sequential strategies
- Systematic refactoring with coverage requirements
- Stack configuration (JavaScript/TypeScript, Python)
- Web UI development patterns (Next.js, static sites, Tailwind+CVA)
- Development standards (justfile, git hooks, GitHub Actions, CLAUDE.md docs)

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
- `configuring-javascript-stack/` - JavaScript/TypeScript toolchain standards
- `configuring-python-stack/` - Python toolchain standards

**Web UI Development:**
- `building-with-nextjs/` - Next.js and TypeScript patterns
- `building-static-sites/` - Static site generation (marketing, docs, blogs)
- `styling-with-tailwind-cva/` - Tailwind CSS + CVA design system patterns
- `integrating-formspree-forms/` - Form handling for static sites

**Development Standards:**
- `creating-justfiles/` - Standard justfile commands and patterns
- `installing-git-hooks/` - Git hooks via justfile commands
- `configuring-github-actions/` - CI/CD workflow configuration
- `documenting-with-claude-md/` - Machine-readable context documentation
- `documenting-libraries-with-mkdocs/` - MkDocs documentation standards

**Development Workflows:**
- `executing-development-issues/` - Complete development lifecycle for issues
- `refactoring-with-coverage/` - Coverage-gated refactoring workflow
- `self-reviewing-code/` - Code review using specialized agents
- `working-in-git-worktrees/` - Git worktree management for parallel work
- `creating-agents/` - Creating well-formed agent definitions

## Public Interface

### Commands
- `/work [STRATEGY]` - Execute issues with execution strategy syntax
- `/plan [DESCRIPTION]` - Create GitHub/local issues with execution strategy
- `/refactor [SCOPE]` - Refactor with coverage gates
- `/quicktask [DESCRIPTION]` - Quick ad-hoc task with issue tracking
- `/start-project [NAME]` - Initialize new project
- `/devinit` - Audit and setup development environment

### Skills (referenced with @)
All 15 skills available for reference in agent prompts using `@skill-name` syntax.

## Dependencies

- **Uses:** Claude Code plugin system
- **Used by:** Software engineer agents, development workflows

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
- 90%+ coverage threshold for refactoring
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
- Name: `dev`
- Version: `1.0.0`
- Category: `development`
- Keywords: development, workflow, ci-cd, testing, refactoring, git
