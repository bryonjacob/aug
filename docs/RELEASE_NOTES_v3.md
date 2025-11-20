# Aug Marketplace v3.0.0 Release Notes

**Release Date:** TBD
**Status:** Release Candidate

## Overview

Major architectural evolution introducing autonomous workflows, quality automation, and maturity-based capability progression. V3 transforms aug from a collection of development tools into an intelligent, context-aware development partner.

## Core Philosophy Shifts

### 1. Autonomous by Default
Move from assisted to autonomous execution:
- **Before:** Commands required user interaction and decision-making
- **After:** Commands execute autonomously using project context
- **Enabler:** User-standin agent analyzes CLAUDE.md, code, configs to make informed decisions

### 2. Assessment-Driven Progression
Replace "install everything" with maturity-based growth:
- **Before:** Full-featured from day one (unused capabilities)
- **After:** Start minimal (level 0), grow as needed
- **Enabler:** Assessment commands show current level, gaps, next steps with YAGNI guidance

### 3. Quality Through Automation
Shift from manual to autonomous quality maintenance:
- **Before:** Manual code reviews, refactoring identification, doc updates
- **After:** Automated analysis creating GitHub issues for execution
- **Enabler:** Documentation auditing, refactoring analysis with state tracking

### 4. Workflow Orchestration
Move from isolated commands to coordinated workflows:
- **Before:** User runs commands in sequence, tracks progress manually
- **After:** Define workflows once, execute end-to-end with progress tracking
- **Enabler:** Workflow system with status tracking and resumption

## Major Changes

### New Plugin: aug-just

Justfile standard interface management with maturity model.

**Commands:**
- `/just-init [stack]` - Generate baseline justfile (python/javascript/java/polyglot)
- `/just-assess` - Analyze current justfile maturity and gaps
- `/just-refactor` - Conform existing justfile to standard
- `/just-upgrade [level|pattern]` - Add capabilities incrementally

**Features:**
- 5-level maturity model (baseline → quality → security → advanced → polyglot)
- Exact command interface specification
- Stack-specific implementations
- Assessment-driven progression with YAGNI enforcement

**Level 1 Enhancements (Quality Gates):**
- **Test timing** - All `test` commands show durations by default
- **`just slowtests N`** - Identify tests slower than N milliseconds
- **`just test-profile`** - Detailed test timing and coverage
- **`just duplicates`** - Copy-paste detection with jscpd (≥30% threshold)
- **`just complexity`** - Per-function/class complexity reporting (>10 threshold)
- **`just loc N`** - Show N largest files by lines of code

**Philosophy:**
- Level 0 non-negotiable for all projects
- Add levels only when "when" criteria met
- Complete current level before advancing
- Can add specific patterns without full level

### Renamed Plugin: aug-util → aug-core

Expanded from session management to AI-enhancement capabilities.

**New Commands:**
- `/hemingway [content]` - Ruthlessly concise prompt writing
- `/automate /command` - Run commands autonomously via user proxy
- `/workflow-run [workflow]` - Execute multi-command workflows
- `/workflow-status [workflow]` - Check progress and resume
- `/learn [pattern-type]` - Analyze codebase for conventions
- `/suggest [file]` - Compare file to project conventions
- `/patterns` - Show all detected conventions
- `/create-variant [team-name]` - Generate team-specific workflow variants

**New Agent:**
- `user-standin` - Context-aware proxy that answers questions by analyzing:
  - CLAUDE.md hierarchy (project architecture)
  - Directory structure (code organization)
  - Configuration files (tool choices)
  - Existing code patterns (style decisions)

**New Skills:**
- `workflow-design` - Discover, design, document, refactor workflows
- `hemingwayesque` - Concise prompt writing principles
- `code-patterns` - Learn project conventions, detect patterns, suggest consistency
- `creating-variants` - Team-specific workflow variant generation patterns

**Philosophy:**
- Meta-capabilities for making Claude more powerful
- Context-driven decisions (not learning-based)
- "What would the user do?" principle

### Enhanced Plugin: aug-dev

Complete overhaul of planning and execution workflows.

#### Epic Planning Workflow

Replaced single `/plan` command with phased workflow:

**Old:** `/plan` (monolithic, interactive)

**New:**
- `/plan-chat [epic]` - Interactive architecture and design
- `/plan-breakdown` - Decompose into tasks with specs
- `/plan-create` - Generate GitHub issues
- `/plan-status` - Check planning progress
- `/plan-commit` - (Optional) Persist to repo

**Philosophy:**
- All interactive time in planning phase
- Planning artifacts ephemeral by default (`/tmp/devplan/`)
- GitHub issues are source of truth
- Optional persistence via `/plan-commit`

#### Autonomous Task Execution

Enhanced `/work` command:
- Fully autonomous from issue → branch → implementation → tests → PR
- Self-healing: auto-fixes format/lint/type errors (max 3 attempts)
- Incremental commits and pushes (recoverable if interrupted)
- Quality-gated: must pass `just check-all` before PR
- Idempotent: safe to re-run

#### Quality Automation

**Documentation Auditing** (`/docsaudit`):
- Ensures every meaningful directory has CLAUDE.md
- Automatically updates stale docs when code changes
- Tracks via `.docsaudit.yaml` state file
- Git-based review (commit or revert)

**Refactoring Analysis** (`/refactor`):
- Autonomous code quality analysis (metrics + smells)
- Creates detailed GitHub issues with:
  - Current state and target improvements
  - Specific approach steps
  - Risk-adjusted prioritization
  - Ready for `/work` execution
- Tracks via `.refactoraudit.yaml` state file
- Module-level analysis using CLAUDE.md boundaries
- Enhanced with TODO/FIXME scanning and duplicate detection (jscpd)

**Test Suite Optimization** (`/test-optimize`):
- Analyze test suite for speed and redundancy
- Identify slow tests (>50ms target)
- Detect redundant tests (semantic overlap, logical subsumption)
- Find DRY opportunities (fixtures, parameterization)
- Create detailed optimization issues with expected improvements
- Tracks via `.testaudit.yaml` state file

**Autonomous Work + Review + Merge** (aug-dev `/autocommit`):
- Complete workflow: `/work` → code review → auto-merge
- Review checks against original issue acceptance criteria only
- Enforces YAGNI (no scope creep)
- Squash merge + branch cleanup
- Sequential processing of multiple issues
- Fail-fast on review or merge issues

**Learning Assistant** (Code Patterns):
- `/learn [pattern-type]` - Analyze codebase for conventions
  - error-handling, testing, imports, naming, architecture
  - Statistical pattern detection (≥80% = convention)
  - Per-module adoption rates
- `/suggest [file]` - Compare file to project conventions
  - Identify inconsistencies with severity ratings
  - Suggest fixes with before/after examples
- `/patterns` - Show all detected conventions
  - Comprehensive overview for onboarding
  - Code consistency scoring

**Team Workflow Variants** (`/create-variant`):
- Generate team-specific workflow files adapted to existing tools
- Interactive discovery of team context:
  - Git workflow (trunk-based, gitflow, custom)
  - Issue tracking (GitHub, Jira, Linear, file-based, none)
  - CI/CD platform (GitHub Actions, Jenkins, GitLab CI, etc.)
  - Build tools (just, make, npm, maven, gradle)
  - Stack and existing tooling
- Adaptation strategies:
  - Keep working tools team likes
  - Add opinionated defaults for gaps
  - Replace painful tools (with permission)
- Output: Customized commands/skills/workflows in `.claude/`
- Philosophy: Prescriptive tools adapted to context, not generic runtime-flexible tools

#### Development Standards

**New Stack Standards** (`development-stack-standards` skill):
- 5-level maturity model for development stacks
- Multi-dimensional assessment (foundation, quality, security, deployment, observability)
- Stack-specific specifications (Python, JavaScript, Java, Polyglot)

**Stack Management Commands:**
- `/stack-assess [stack]` - Analyze project against standards
- `/stack-guide create [stack]` - Generate stack definition
- `/stack-guide validate` - Check conformance
- `/stack-guide variant [base] [name]` - Create customized variant

#### New Core Skills

- `software-architecture` - Epic planning, design, task breakdown
- `software-development` - Implementation following specifications
- `software-debugging` - Systematic bug finding and fixing
- `software-quality` - Test coverage analysis and strategy

**Naming Convention Fix:**
- Skills named as activities (software-architecture) not personas (architect)
- Frontmatter names match file/directory names

## Plugin Architecture Changes

### Before (v2)
```
aug/
├── aug-dev/      # Development workflows
├── aug-util/     # Session management only
└── aug-web/      # Web patterns
```

### After (v3)
```
aug/
├── aug-dev/      # Development workflows (expanded)
├── aug-core/     # AI-enhancement capabilities (renamed + expanded)
├── aug-just/     # Justfile standards (NEW)
└── aug-web/      # Web patterns (unchanged)
```

## Shared Design Patterns

### Maturity Model Pattern

Applied across multiple domains:
- **aug-just:** Justfile capabilities (baseline → polyglot)
- **development-stack-standards:** Development stack dimensions
- **Pattern:** Level 0 required, add levels as needed, assessment-driven

Defined in `docs/TIERED_MATURITY_MODEL.md`:
- 5 levels with clear "when" criteria
- Assessment shows current state + gaps + next steps
- YAGNI enforcement ("stop at appropriate level")
- Non-linear progression allowed

### State Tracking Pattern

Lightweight module-level tracking:
- **Documentation:** `.docsaudit.yaml` (commit + date + scope per doc)
- **Refactoring:** `.refactoraudit.yaml` (commit + date per module)
- **Pattern:** Git-based change detection, auto-bootstrap if missing

### Autonomous Execution Pattern

Context-aware decision making:
- **Agent:** user-standin reads project context
- **Commands:** /automate, /workflow-run use user-standin
- **Pattern:** "What would the user do?" based on available evidence

### Workflow Pattern

Multi-command orchestration:
- **Definition:** Markdown docs in `workflows/` directories
- **Execution:** `/workflow-run [name]`
- **Tracking:** `/workflow-status [name]`
- **Pattern:** Phases (interactive/automated), resumable, repeatable

## File Organization

### New Files

**Documentation:**
- `docs/TIERED_MATURITY_MODEL.md` - Maturity model philosophy
- `docs/plans/2025-11-16-aug-core-capabilities.md` - Core v3 design
- `docs/plans/2025-11-19-documentation-auditing-design.md` - Docsaudit design
- `docs/plans/2025-11-19-refactoring-analysis-design.md` - Refactor design

**aug-core Plugin:**
- Complete plugin structure (8 files added)
- Commands: automate, hemingway, workflow-run, workflow-status
- Agent: user-standin
- Skills: hemingwayesque, workflow-design

**aug-just Plugin:**
- Complete plugin structure (15 files added)
- Commands: just-init, just-assess, just-refactor, just-upgrade
- 6 skills (interface, maturity, quality, security, advanced, polyglot)
- Workflow: justfile-adoption

**aug-dev Enhancements:**
- Commands: plan-chat, plan-breakdown, plan-create, plan-status, plan-commit
- Commands: docsaudit, refactor, test-optimize, autocommit
- Commands: stack-assess, stack-guide
- Skills: software-architecture, software-development, software-debugging, software-quality
- Skills: documenting-with-audit, development-stack-standards
- Workflow: epic-development

### Removed Files

- `aug-dev/commands/plan.md` → Split into 5 phased commands
- `aug-dev/commands/dddplan.md` → Replaced by epic planning workflow
- `aug-dev/commands/dddwork.md` → Replaced by enhanced /work
- `aug-util/` plugin → Renamed to aug-core
- Old justfile interface design doc

**Total Change:** +11,629 lines, -960 lines

## Breaking Changes

### aug-util → aug-core Rename
- **Migration:** Reinstall as `aug-core@aug`
- **Commands:** `/notetoself` and `/futureme` unchanged
- **Impact:** Installation scripts need update

### /plan Command Split
- **Old:** `/plan [epic]` (monolithic)
- **New:** `/plan-chat` → `/plan-breakdown` → `/plan-create`
- **Migration:** Use new phased workflow
- **Impact:** Existing /plan usage patterns broken

### DDD Commands Removed
- **Old:** `/dddplan`, `/dddwork`
- **New:** Epic planning workflow (`/plan-chat` → `/plan-breakdown` → `/plan-create` → `/work`)
- **Migration:** Use new workflow instead
- **Impact:** DDD-specific commands no longer available

## Migration Guide

### For Existing Users

**1. Reinstall Plugins:**
```bash
# Remove old aug-util
/plugin uninstall aug-util@aug

# Install/update plugins
/plugin install aug-dev@aug aug-core@aug aug-just@aug
```

**2. Update Planning Workflows:**
```bash
# Old way
/plan "Add authentication"
/work 123

# New way
/plan-chat "Add authentication"
/plan-breakdown
/plan-create
/work 123

# Or fully automated
/workflow-run epic-development
```

**3. Add Justfile Standards:**
```bash
# Assess current justfile
/just-assess

# Fix to standard
/just-refactor

# Add capabilities as needed
/just-upgrade 1  # Quality gates
```

### For New Projects

**1. Initialize Stack:**
```bash
/start-project my-app
# Or for specific stack:
/just-init python
```

**2. Set Up Development:**
```bash
just dev-install
just check-all
```

**3. Plan and Execute:**
```bash
/plan-chat "Initial features"
/plan-breakdown
/plan-create
/work 1
```

## Example Workflows

### Epic Development (Full Automation)

```bash
# One command to rule them all
/workflow-run epic-development

# User-standin handles all decisions:
# - Architecture choices (reads CLAUDE.md)
# - Testing frameworks (checks config)
# - Style decisions (matches patterns)
# - Creates issues, implements, PRs
```

### Quality Improvement Sprint

```bash
# Document everything
/docsaudit
git diff
git commit -am "docs: automated audit"

# Find refactoring opportunities
/refactor
# Creates issues: #101, #102, #103

# Execute improvements
/work 101
/work 102
/work 103
```

### Stack Maturity Progression

```bash
# Start minimal
/just-init python
just check-all  # ✓ Level 0 complete

# Add quality gates
/just-assess    # Shows: Ready for level 1
/just-upgrade 1 # Adds: test-watch, complexity, integration-test

# Add security (when deploying)
/just-upgrade 2 # Adds: vulns, lic, sbom, doctor
```

## Success Metrics

This release succeeds if:

1. **Autonomous execution works** - Users can run `/workflow-run epic-development` end-to-end
2. **Assessment-driven growth** - Projects start at level 0, grow only as needed
3. **Quality automation delivers** - `/docsaudit` and `/refactor` find real issues
4. **Maturity models guide** - Clear progression paths, YAGNI respected
5. **Context-aware decisions** - User-standin makes reasonable choices based on project context

## Known Limitations

- User-standin decisions based on heuristics, not learning
- Workflow system doesn't handle complex branching/conditionals
- Refactoring analysis uses patterns, may miss domain-specific smells
- Documentation auditing can't verify accuracy, only freshness

## Future Directions

See "Additional v3 Ideas" section for potential enhancements.

## Credits

All components designed and implemented for Claude Code plugin architecture.
