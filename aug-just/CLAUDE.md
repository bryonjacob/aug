# Module: Aug-Just Plugin

## Purpose

Justfile standard interface management. Install, assess, refactor, upgrade justfiles following maturity model. Every project implements baseline. Advanced projects add security, deployment, polyglot patterns.

## Responsibilities

- Define justfile standard interface (exact commands, comment strings)
- Maturity model (5 levels: baseline → polyglot)
- Assessment (which level, what's missing, what's next)
- Installation (generate standard justfiles per stack)
- Refactoring (make existing justfiles conform)
- Upgrade paths (add next level capabilities)

## Key Files

### Skills (`skills/`)
- `justfile-interface/` - Baseline commands (level 0)
- `justfile-maturity-model/` - 5 levels, assessment criteria, progression
- `justfile-quality-patterns/` - Level 1 (test-watch, integration-test, complexity)
- `justfile-security-patterns/` - Level 2 (vulns, lic, sbom, doctor)
- `justfile-advanced-patterns/` - Level 3 (test-smart, deploy, migrate)
- `justfile-polyglot-patterns/` - Level 4 (multi-language orchestration)

### Commands (`commands/`)
- `just-init.md` - Install baseline interface for stack
- `just-assess.md` - Assess current justfile, show level and gaps
- `just-refactor.md` - Make existing justfile standard-conformant
- `just-upgrade.md` - Add next maturity level or specific pattern

### Workflows (`workflows/`)
- `justfile-adoption.md` - Full adoption workflow (assess → init → verify → upgrade)

## Public Interface

### Commands
- `/just-init [stack]` - Generate level 0 justfile (python/javascript/java/polyglot)
- `/just-assess` - Analyze current justfile (level, gaps, recommendations)
- `/just-refactor` - Fix existing justfile (add missing, fix comments, preserve logic)
- `/just-upgrade [level|pattern]` - Add capabilities (level 2, test-smart, deploy, etc)

### Skills
All skills available via `Skill` tool.

## Dependencies

- **Uses:** justfile syntax, stack-specific tools (uv, pnpm, maven)
- **Used by:** Projects needing standard build interface
- **Related:** aug-dev stack configuration skills have implementation details

## Architecture Decisions

**Maturity Model:**
- Level 0 (baseline): EVERY project
- Levels 1-4: Add as needed, YAGNI enforcement
- Assessment-driven: know current level, see next step
- Non-linear: can add specific patterns without full level

**Specification Style:**
- Terse examples, exact comment strings
- No exposition, show by example
- One command per line
- Hemingwayesque throughout

**Command Strategy:**
- `/just-init` - Fresh start, level 0
- `/just-refactor` - Fix existing (preserve implementations)
- `/just-upgrade` - Incremental addition (level or pattern)
- `/just-assess` - Before all operations (know where you are)

**Skills Organization:**
- Interface skill: baseline spec
- Maturity model: assessment and progression logic
- Pattern skills: grouped by maturity level (quality, security, advanced, polyglot)
- Commands reference skills (DRY, no duplication)

**Validation:**
- Exact comment string matching
- All baseline commands present
- check-all dependencies correct
- Stack-appropriate implementations

## Testing

Skills and commands tested through:
- Generating justfiles for each stack
- Assessment on known-good and known-bad justfiles
- Refactoring existing justfiles to conformance
- Upgrade path validation (level 0 → 1 → 2 → 3 → 4)

## Plugin Metadata

Defined in `.claude-plugin/plugin.json`:
- Name: `aug-just`
- Version: `3.0.0`
- Category: `development`
- Keywords: justfile, build, quality, maturity-model
