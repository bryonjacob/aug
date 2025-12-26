# Aug-Dev Plugin

Core development workflows and tooling standards for software engineering.

## Installation

```bash
/plugin install aug-dev@aug
```

## Epic Planning Workflow

The complete workflow from idea to execution:

### 1. Interactive Planning Phase

All your interactive time happens here. Claude helps you design the architecture and break it into tasks.

```bash
# Start with architecture and design
/plan-chat "Add JWT authentication with refresh tokens"

# Interactive session where Claude will:
# - Ask clarifying questions
# - Explore your codebase for patterns
# - Propose 2-3 architectural approaches
# - Help you choose and design the solution
# - Save complete architecture to /tmp/devplan/jwt-auth/
```

```bash
# Break the architecture into deliverable tasks
/plan-breakdown

# Claude will:
# - Propose 3-8 tasks based on the architecture
# - Create detailed specs for each task
# - Include implementation guidance and code examples
# - Save task specs to /tmp/devplan/jwt-auth/tasks/
```

```bash
# Generate comprehensive GitHub issues
/plan-create

# Creates:
# - Epic issue with full architecture
# - Task issues with complete specifications
# - GitHub becomes source of truth
# - Optionally cleans up /tmp/devplan/
```

### 2. Autonomous Execution Phase

Execute tasks without any user interaction needed.

```bash
# Execute a task from its GitHub issue
/work 124

# Fully autonomous:
# - Creates branch: epic/jwt-auth/task-1
# - Updates documentation (retcon style)
# - Implements in chunks with tests
# - Runs `just check-all` after each chunk
# - Self-heals format/lint/type errors
# - Ensures 96% coverage
# - Creates PR when all quality gates pass
```

**Key Features:**
- **Idempotent**: Safe to re-run if interrupted
- **Incremental**: Commits and pushes after each chunk
- **Self-healing**: Auto-fixes errors (max 3 attempts)
- **Quality-gated**: Must pass `just check-all`

### Optional Commands

```bash
/plan-status      # Show current planning sessions
/plan-commit      # Persist planning to .devplan/ (optional)
```

## Git Workflow

**Flat structure only** - all task branches from `main`:

```
main (protected)
  ↓
  ├─ epic/jwt-auth/task-1  → PR to main (closes #124)
  ├─ epic/jwt-auth/task-2  → PR to main (closes #125)
  └─ epic/jwt-auth/task-3  → PR to main (closes #126)
```

**Why flat?**
- Simpler for LLMs to handle
- No merge cascades
- Standard GitHub flow
- Clear dependency tracking

## Project Management

```bash
# Initialize new project with full setup
/start-project my-app

# Audit existing project and add missing components
/devinit

# Quick ad-hoc task (combines planning + execution)
/quicktask "Add input validation to login form"

# Systematic refactoring with coverage gates
/refactor src/auth/
```

## Skills

### Core Development Skills

- **`software-architecture`** - Epic planning, architecture design, task breakdown
- **`software-development`** - Implementation following specifications
- **`software-debugging`** - Systematic bug finding and fixing
- **`software-quality`** - Test coverage analysis and strategy

### Stack Configuration

- **`configuring-javascript-stack`** - JavaScript/TypeScript (pnpm, prettier, eslint, vitest)
- **`configuring-python-stack`** - Python (uv, ruff, mypy, pytest)
- **`configuring-java-stack`** - Java (maven, spotless, spotbugs, junit5)
- **`configuring-polyglot-stack`** - Multi-language orchestration

Note: Justfile standards defined in aug-just plugin (install with `/plugin install aug-just@aug`)

### Development Standards

- **`installing-git-hooks`** - Pre-commit/pre-push hooks calling justfile
- **`configuring-github-actions`** - CI/CD workflows calling `just check-all`
- **`documenting-with-claude-md`** - Machine-readable context (CLAUDE.md)
- **`documenting-with-mkdocs`** - Project documentation (MkDocs Material)

### Development Workflows

- **`executing-development-issues`** - Issue lifecycle (branch → PR → merge)
- **`refactoring`** - Refactoring with coverage/complexity gates
- **`self-reviewing-code`** - Self-review checklist before PR ready
- **`working-in-git-worktrees`** - Parallel work with isolated directories
- **`creating-agents`** - Agent definition patterns

## Architecture Principles

**Epic Planning:**
- All interactive time in planning
- Planning artifacts ephemeral (`/tmp/devplan/`)
- GitHub issues are source of truth
- Optional persistence to `.devplan/`

**Task Execution:**
- Fully autonomous from issue to PR
- Idempotent and recoverable
- Quality-gated (`just check-all`)
- 96% coverage threshold

**Issue Structure:**
- Structured metadata (parseable, not labels)
- Complete specifications with examples
- Step-by-step implementation guidance
- All context for autonomous execution

## Example Workflow

```bash
# 1. Planning (interactive)
/plan-chat "Add background job processing"
# → Designs architecture with you
# → Saves to /tmp/devplan/background-jobs/

/plan-breakdown
# → Proposes 4 tasks
# → You approve breakdown
# → Saves detailed specs to /tmp/devplan/background-jobs/tasks/

/plan-create
# → Creates Epic #123 with full architecture
# → Creates Task issues #124, #125, #126, #127
# → Cleans up /tmp/devplan/background-jobs/

# 2. Execution (autonomous)
/work 124
# → Implements task autonomously
# → Creates PR #45
# → Updates epic checklist

/work 125
# → Implements next task
# → Creates PR #46
# → Updates epic checklist

# 3. Merge and repeat
# Review/merge PRs, then continue with next tasks
```

## Quality Standards

All workflows enforce:
- `just check-all` must pass before PR
- 96% test coverage threshold
- Format/lint/typecheck/test all passing
- No shortcuts on quality

## Opinionated Choices

This plugin makes specific technology decisions:

| Choice | Rationale | Alternatives |
|--------|-----------|--------------|
| **uv** (Python) | Fast, handles venv + install, modern | poetry, pip-tools |
| **pnpm** (JavaScript) | Fast, strict, good monorepo support | npm, yarn, bun |
| **maven** (Java) | Declarative, widely supported | gradle |
| **justfile** | Simple syntax, cross-platform | Makefile, npm scripts |
| **96% coverage** | High bar, allows 4% for edge cases | 80%, 90%, 100% |
| **Flat git branches** | LLMs handle flat better, no cascades | gitflow, trunk-based |
| **CLAUDE.md** | Machine-readable context for AI | ADRs, wiki |
| **MkDocs Material** | Clean, searchable, Python-based | Sphinx, Docusaurus |

### Adaptation Guide

**To use different Python tools:**
Replace in justfile: `uv run` → `poetry run`

**To use npm instead of pnpm:**
Replace in justfile: `pnpm` → `npm`

**To use different coverage threshold:**
Change `--cov-fail-under=96` to your threshold

**To use gitflow:**
Modify `/work` command to target develop branch, add release workflow

See [ADAPTATION.md](../docs/ADAPTATION.md) for detailed examples.

## Related Plugins

- **`aug-web`** - Next.js, static sites, Tailwind (extends JavaScript stack)
