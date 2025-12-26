# Aug Philosophy

Core principles independent of tool choices. These patterns transfer to any stack.

## Assessment-Driven Development

Know where you are before advancing.

**Principle:** Assess current state, identify gaps, then act. Don't guess.

**Pattern:**
```
assess → identify gaps → plan improvement → implement → verify
```

**Examples:**
- `/just-assess` before `/just-upgrade`
- Read existing code before modifying
- Check test coverage before adding features

**Why it matters:** Blind changes break things. Assessment creates informed decisions.

## YAGNI with Structure

Add capabilities only when needed. But have a structure for when you do.

**Principle:** Level 0 is mandatory. Higher levels are optional. Add when evidence demands.

**The Maturity Model:**
```
Level 0: Baseline (every project)
Level 1: Quality gates (when shipping to users)
Level 2: Security (when handling sensitive data)
Level 3: Advanced (when scale demands)
Level 4: Polyglot (when multiple languages)
```

**When to advance:**
- Level 1: First production deployment
- Level 2: First security audit or compliance requirement
- Level 3: First performance bottleneck
- Level 4: First cross-language dependency

**Anti-pattern:** Adding Level 3 capabilities to a weekend project. Stop at appropriate maturity.

## Quality as Foundation

Automate quality gates. Make passing easy, failing visible.

**The check-all Pattern:**
```just
check-all: format-check lint typecheck coverage
```

**Principle:** One command runs all checks. CI runs same command. No surprises.

**Components:**
1. **Format** - Consistent code style (automated, no debates)
2. **Lint** - Catch common errors (static analysis)
3. **Typecheck** - Type safety (where language supports)
4. **Coverage** - Test completeness (threshold enforced)

**Why high coverage (96%):**
- Forces testing decisions (what's the 4%?)
- Catches regressions
- Documents behavior
- Not 100% (edge cases exist)

**Transfer to your stack:** Keep the pattern, swap the tools.

## Autonomous Execution

Interactive planning, autonomous implementation.

**Principle:** Spend human attention on design decisions. Automate implementation.

**The Split:**
```
Human time: plan-chat → plan-breakdown (architecture, requirements, tradeoffs)
Machine time: work → autocommit (implementation, testing, PR creation)
```

**Properties of autonomous work:**
1. **Idempotent** - Safe to re-run if interrupted
2. **Quality-gated** - Must pass checks before PR
3. **Self-healing** - Auto-fix format/lint/type errors
4. **Incremental** - Commit and push regularly (recoverable)

**Why this split:** Humans good at ambiguity and tradeoffs. Machines good at repetition and consistency.

## Context Over Configuration

Read the codebase. Understand patterns. Act consistently.

**Principle:** Decisions based on evidence (existing code, config files, CLAUDE.md), not templates.

**CLAUDE.md Hierarchy:**
```
project/CLAUDE.md           # Project-wide context
project/src/CLAUDE.md       # Module-specific context
project/src/auth/CLAUDE.md  # Component-specific context
```

**What CLAUDE.md contains:**
- Purpose (what this does)
- Key files (where to look)
- Architecture decisions (why it's this way)
- Public interface (how to use)

**User-standin principle:** "What would the user do given THIS codebase?" Answer by reading context, not guessing.

## Flat Git Workflow

All branches from main. All PRs to main. No nesting.

**Pattern:**
```
main
├── epic/auth/task-1
├── epic/auth/task-2
└── epic/payments/task-1
```

**Why flat:**
- LLMs handle flat structures better
- No merge conflicts between epic branches
- Clear lineage (every branch has one parent: main)
- Simpler mental model

**Trade-off:** No epic branch integration. Each task stands alone. Design tasks to be independently mergeable.

## Documentation Strategy

Two audiences: humans and Claude.

**README.md** - For humans:
- What is this?
- How do I use it?
- What are the options?

**CLAUDE.md** - For Claude:
- What does this module do?
- What are the key files?
- What patterns should I follow?

**Hemingwayesque principle:** Economy of language. Every word earns its place. Show, don't tell.

## Summary

These principles transfer regardless of tools:

| Principle | Pattern |
|-----------|---------|
| Assessment-driven | Assess → Plan → Act → Verify |
| YAGNI with structure | Mandatory baseline, optional higher levels |
| Quality as foundation | check-all gate, high coverage |
| Autonomous execution | Human planning, machine implementation |
| Context over configuration | Read codebase, act consistently |
| Flat git workflow | All branches from main |
| Two-audience docs | README for humans, CLAUDE.md for Claude |

Tools change. Patterns persist.
