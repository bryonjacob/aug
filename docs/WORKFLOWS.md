# Aug Workflows: Detailed Usage Guide

This guide explains how to use Aug's workflow commands in practice.

## The Core Principle

**Front-load your thinking into planning. Let autonomous execution handle implementation.**

Interactive time is expensive—it requires your attention. The goal is to capture your knowledge, requirements, and decisions during planning, then let Claude work autonomously through implementation. You review the output (PRs), not the process.

## Epic Planning Workflow

The complete flow from idea to merged code:

```
/plan-chat → /plan-breakdown → /plan-create → /work → review PR → merge
```

### Step 1: /plan-chat

```bash
/plan-chat "Add JWT authentication with refresh tokens"
```

This starts an interactive design session. Claude will:

1. **Ask clarifying questions** — What's the token lifetime? Where are tokens stored? What triggers refresh?
2. **Explore your codebase** — Find existing auth patterns, database models, API structure
3. **Propose approaches** — Usually 2-3 options with tradeoffs
4. **Converge on a design** — Architecture, data flow, error handling, testing strategy

**Your job:** Bring your domain knowledge. Answer questions. Make decisions. This is where you shape the implementation.

**Output:** Planning documents saved to `/tmp/devplan/{epic-name}/`:
- `architecture.md` — High-level design
- `decisions.md` — Key choices and rationale
- `testing.md` — Test strategy

This is your synchronous time. Invest it here.

### Step 2: /plan-breakdown

```bash
/plan-breakdown
```

Takes the planning documents and breaks them into implementable tasks.

**What makes a good task?**
- Something a human developer could complete in a day or less
- Self-contained: can be implemented and tested independently
- Clear acceptance criteria
- All context needed for autonomous execution

Claude typically produces 3-8 tasks depending on epic complexity. Each task includes:
- Summary and scope
- Implementation steps
- Code examples where helpful
- Testing requirements
- Dependencies on other tasks

**Output:** Task specifications in `/tmp/devplan/{epic-name}/tasks/`

### Step 3: /plan-create

```bash
/plan-create
```

Creates GitHub issues from the breakdown:

1. **Epic issue** — Full architecture, links to all tasks
2. **Task issues** — Complete specifications, labeled and linked

**After this:** GitHub becomes the source of truth. The `/tmp/devplan/` artifacts can be deleted (or kept for reference).

**Adaptation:** This command is opinionated toward GitHub. You could modify it to create Jira tickets, Linear issues, or plain markdown files.

### Step 4: /work

```bash
/work 123
```

Autonomous execution of task issue #123:

1. **Branch creation** — `epic/{epic-name}/task-{number}`
2. **Documentation update** — Retcon-style (update docs before implementing)
3. **Implementation** — In chunks, with tests for each chunk
4. **Quality gates** — `just check-all` after each chunk
5. **Self-healing** — Auto-fix format/lint/type errors (max 3 attempts)
6. **PR creation** — When all gates pass

**No interaction needed.** You review the PR when it's ready.

**Properties:**
- **Idempotent** — Safe to re-run if interrupted
- **Incremental** — Commits and pushes after each chunk (recoverable)
- **Quality-gated** — Must pass `just check-all` before PR

## Automation Commands

### /automate

```bash
/automate /plan-chat "Add caching layer"
/automate /plan-breakdown
/automate /refactor src/auth/
```

Run any interactive command autonomously. When the command asks questions:

1. A "user-standin" agent activates
2. Reads CLAUDE.md hierarchy for project context
3. Analyzes existing code patterns
4. Checks configuration files
5. Makes decisions based on evidence

**Best for:** Commands where project context provides clear answers.

**Not ideal for:** Commands requiring creative/strategic decisions or domain knowledge that isn't in the codebase.

### /autocommit

```bash
/autocommit 123
/autocommit 123 124 125
```

Full autonomous loop for one or more issues:

1. `/work {issue}` — Implement and create PR
2. Self-review — Check for obvious issues
3. Merge — If review passes

**Use case:** Grinding through a backlog of well-specified tasks. Each task must be self-contained and well-defined.

**Caution:** Only use on tasks where autonomous merge is appropriate. Review-required tasks should use `/work` instead.

## Workflow Orchestration

### Defining Workflows

Workflows are YAML files that define command sequences:

```yaml
name: epic-development
phases:
  - name: design
    command: /plan-chat
  - name: breakdown
    command: /plan-breakdown
  - name: create
    command: /plan-create
  - name: execute
    command: /work
    repeat: for-each-task
```

### Running Workflows

```bash
/workflow-run epic-development "Add user preferences"
```

Executes each phase using `/automate`. The workflow tracks progress and can resume if interrupted.

```bash
/workflow-status epic-development
```

Shows current phase, completed phases, and next steps.

## Session Management

### The Problem

Claude's auto-compact loses context. Important details from earlier in a conversation may be summarized away or lost entirely.

### The Solution

```bash
/notetoself
```

Saves current session context to `/tmp/notetoself-{hash}.md`:
- What you're working on
- Key decisions made
- Current state
- Next steps

The hash is based on your working directory, so different projects get different files.

```bash
/futureme
```

Reads the saved context and brings Claude up to speed. Often faster and more reliable than auto-compact.

**When to use:**
- Before switching to a different task
- Before a long break
- When context is getting long and you want a clean slate
- When auto-compact has clearly lost important context

## Justfile Standards

### The Standard Interface

Every project gets the same command interface:

```bash
just format      # Format code
just lint        # Lint code
just typecheck   # Type checking
just test        # Run tests
just coverage    # Tests with coverage threshold
just check-all   # All of the above
```

Consistency across projects. Same commands whether Python, JavaScript, or Java.

### Maturity Model

**Level 0: Baseline** — Every project

```bash
/just-init python
```

Generates justfile with standard commands for your stack.

**Level 1: Quality Gates** — When shipping to users

```bash
/just-upgrade 1
```

Adds: `test-watch`, `integration-test`, `complexity`

**Level 2: Security** — When handling sensitive data

```bash
/just-upgrade 2
```

Adds: `vulns`, `lic`, `sbom`, `doctor`

**Level 3: Advanced** — When scale demands

```bash
/just-upgrade 3
```

Adds: `test-smart` (git-aware testing), `deploy`, `migrate`

**Level 4: Polyglot** — Multiple languages

```bash
/just-upgrade 4
```

Adds: cross-language orchestration

### Assessment-Driven

Always know where you are:

```bash
/just-assess
```

Output:
```
Level: 1 (Quality Gates)
Missing for Level 2: vulns, lic, sbom
Recommendation: Add Level 2 when you have production deployment
```

Don't upgrade until there's a real need. YAGNI applies.

## Typical Day

A realistic example of using these workflows:

**Morning: Planning session**
```bash
/plan-chat "Add export to CSV feature"
# 20 minutes of interactive design discussion
/plan-breakdown
# Review task breakdown, approve
/plan-create
# Issues created: #45 (epic), #46-49 (tasks)
```

**Let it work:**
```bash
/work 46
# Go get coffee, review PR when notification arrives
```

**Batch processing:**
```bash
/autocommit 47 48 49
# Three tasks, autonomous work + merge
```

**Context switch:**
```bash
/notetoself
# Saved, can resume later
```

**Next day:**
```bash
/futureme
# Context restored, continue where you left off
```

## Tips

**Plan more than you think you need.** The interactive planning phase is cheap compared to fixing autonomous execution that went wrong.

**Keep tasks small.** A task Claude can complete in 5-10 minutes is better than one that takes an hour. Smaller tasks mean faster feedback and easier recovery.

**Trust but verify.** Autonomous execution is good, but review PRs before merging anything significant.

**Use /notetoself liberally.** Context is precious. Save it often.

**Assess before upgrading.** The maturity model prevents over-engineering. Use `/just-assess` to know what you actually need.
