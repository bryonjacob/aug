# Module: Aug-Dev Plugin

## Purpose

Core development workflows and tooling standards for software engineering projects. Encompasses the complete software development lifecycle from epic planning through autonomous task execution.

## Responsibilities

- Epic planning with architecture design and task breakdown
- Autonomous task execution from GitHub issues
- Project initialization and environment setup
- Systematic refactoring with coverage requirements
- Stack configuration (JavaScript/TypeScript, Python, Java)
- Development standards (justfile, git hooks, GitHub Actions, CLAUDE.md/MkDocs docs)

## Key Files

### Commands (`commands/`)

**Epic Planning Workflow:**
- `plan-chat.md` - Interactive architecture and design session
- `plan-breakdown.md` - Decompose epic into deliverable tasks
- `plan-create.md` - Generate comprehensive GitHub issues
- `plan-status.md` - Show current planning progress
- `plan-commit.md` - Optional: persist planning to repo

**Task Execution:**
- `work.md` - Autonomous task execution from GitHub issue to PR

**Project Setup:**
- `start-project.md` - Initialize new project with full development setup
- `devinit.md` - Audit existing project and set up missing components
- `quicktask.md` - Ad-hoc task workflow (quick one-off tasks)
- `refactor.md` - Systematic refactoring requiring 96%+ coverage

### Skills (`skills/`)

**Core Development Skills:**
- `software-architecture/` - Epic planning, architecture design, task breakdown
- `software-development/` - Implementation following specifications
- `software-debugging/` - Systematic bug finding and fixing
- `software-quality/` - Test coverage analysis and strategy

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

### Epic Planning Workflow

**Interactive Planning (all planning time here):**
```bash
/plan-chat "Add JWT authentication"     # Architecture & design session
/plan-breakdown                         # Break into tasks with specs
/plan-create                            # Generate GitHub issues
```

**Optional:**
```bash
/plan-status                            # Check planning progress
/plan-commit                            # Persist planning to repo
```

**Autonomous Execution:**
```bash
/work 124                               # Execute task issue autonomously
```

### Project Management

```bash
/start-project [NAME]                   # Initialize new project
/devinit                                # Audit and setup development environment
/quicktask [DESCRIPTION]                # Quick ad-hoc task with issue tracking
/refactor [SCOPE]                       # Refactor with coverage gates
```

### Skills

All skills available for use via `Skill` tool.

## Dependencies

- **Uses:** Claude Code plugin system
- **Used by:** Software engineer agents, development workflows
- **Related:** aug-web extends JavaScript stack with web-specific patterns

## Architecture Decisions

**Epic Planning Philosophy:**
- All interactive time in planning phase
- Planning artifacts ephemeral by default (`/tmp/devplan/`)
- GitHub issues are source of truth after `/plan-create`
- Optional persistence to `.devplan/` via `/plan-commit`

**Git Workflow:**
- Flat branch structure only: all task branches from `main`
- All PRs directly to `main`
- Branch naming: `epic/{epic-id}/{task-slug}`
- No nested branches (LLMs handle flat structures better)

**Task Execution:**
- Fully autonomous from issue to PR
- Idempotent: safe to re-run if interrupted
- Incremental commits and pushes (recoverable)
- Self-healing: auto-fixes format/lint/type errors (max 3 attempts)
- Quality-gated: must pass `just check-all` before PR

**Issue Structure:**
- Structured metadata at top (parseable, not labels)
- Complete specifications with code examples
- Implementation guidance with step-by-step chunks
- Testing strategy and acceptance criteria
- All needed context for autonomous execution

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
- Idempotent behavior validation
- Quality gate enforcement in CI/CD

## Plugin Metadata

Defined in `.claude-plugin/plugin.json`:
- Name: `aug-dev`
- Version: `2.0.0`
- Category: `development`
- Keywords: development, workflow, ci-cd, testing, refactoring, git, planning
