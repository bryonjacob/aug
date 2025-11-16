# Aug-Core Capabilities - v3 Design

**Date:** 2025-11-16
**Status:** Approved

## Overview

Major v3 overhaul adding AI-enhancement capabilities to the aug plugin marketplace. Renames aug-util to aug-core and adds three core capabilities: hemingwayesque (concise prompt writing), automate (autonomous command execution), and workflow system (multi-command workflow definition and execution).

## Plugin Reorganization

### Current State
- aug-dev: Development workflows and tooling
- aug-web: Web-specific patterns
- aug-util: Session management only

### V3 Structure
- **aug-dev**: Development workflows and tooling (unchanged)
- **aug-core**: AI-enhancement capabilities (aug-util renamed and expanded)
- **aug-web**: Web-specific patterns (unchanged)

### Rationale
- "util" implies miscellaneous helpers
- "core" signals fundamental AI capabilities
- Expands from session management to meta-capabilities
- Better matches scope: tools for making Claude more powerful

### Migration
- Rename `aug-util/` → `aug-core/`
- Update `.claude-plugin/marketplace.json` plugin entry
- Update `aug-core/.claude-plugin/plugin.json` metadata
- Existing commands (notetoself/futureme) remain unchanged

## Capability 1: Hemingwayesque

### Purpose
Ruthless concision for AI prompts and context. Embodies "Not One Word Wasted" philosophy.

### Components

**Skill:** `aug-core/skills/hemingwayesque/SKILL.md`
- Principles for concise AI prompt writing
- Anti-patterns (verbose exposition, unnecessary adjectives)
- Referenced by other skills when generating content
- Establishes consistent voice across toolkit

**Command:** `aug-core/commands/hemingway.md`
- Takes user input (text or description)
- Applies hemingwayesque skill principles
- Returns rewritten version
- Usage: `/hemingway [content or description]`

### Example Usage
```bash
/hemingway "Rewrite this skill description to be more concise"
/hemingway "Write a prompt for extracting key concepts from an article"
```

### Integration
- Workflow skill references hemingwayesque when generating workflow docs
- Other skills writing prompts invoke hemingwayesque principles
- Creates consistent, concise voice across all generated content

## Capability 2: Automate

### Purpose
Run interactive commands autonomously via context-aware proxy agent.

### Components

**Agent:** `aug-core/agents/user-standin.md`
- Persona: Proxy for human user in automated workflows
- Core principle: "What would the user do?"
- Context gathering strategy:
  - Read CLAUDE.md hierarchy for project context
  - Analyze current directory structure
  - Search relevant code/docs/content
  - Make informed decisions based on available evidence
- Purely context-driven (not learning-based)

**Command:** `aug-core/commands/automate.md`
- Launches Task tool subagent
- Subagent executes target command
- When target command asks interactive questions:
  - Subagent switches to user-standin agent mode
  - Analyzes context and responds
- Usage: `/automate /command-name [args]`

### Example Flow
```
User: /automate /plan-breakdown
→ Launches subagent
→ Subagent runs /plan-breakdown
→ Plan-breakdown asks: "Which testing framework?"
→ Subagent (as user-standin): reads CLAUDE.md, sees pytest used
→ Responds: "pytest"
→ Continues until complete
```

## Capability 3: Workflow System

### Purpose
Define, document, and execute multi-command workflows.

### Directory Structure
```
aug-core/
├── workflows/
│   └── epic-development.md        # Example workflow doc
├── skills/
│   └── workflow-design/SKILL.md   # Workflow creation/analysis skill
└── commands/
    ├── workflow-run.md             # Execute workflow automated
    └── workflow-status.md          # Show current position in workflow
```

### Workflow Document Format

Location: `aug-core/workflows/[workflow-name].md`

Structure (narrative + metadata):
```markdown
# [Workflow Name]

## Overview
[High-level description]

## Phases

### 1. [Phase Name] (interactive/automated)
- **Command:** /command-name
- **Purpose:** What this phase accomplishes
- **Output:** What it produces
- **Requires:** Dependencies (optional)
- **Repeatable:** yes/no (optional)

### 2. [Next Phase]
...
```

Example: `workflows/epic-development.md`
```markdown
# Epic Development Workflow

## Overview
End-to-end workflow from epic planning to task execution.

## Phases

### 1. Design (interactive)
- **Command:** /plan-chat
- **Purpose:** Architecture and design session
- **Output:** Design decisions, component breakdown

### 2. Breakdown (interactive)
- **Command:** /plan-breakdown
- **Purpose:** Decompose into deliverable tasks
- **Requires:** Design complete
- **Output:** Task specifications

### 3. Create Issues
- **Command:** /plan-create
- **Purpose:** Generate GitHub issues
- **Requires:** Tasks defined

### 4. Execute
- **Command:** /work [issue-number]
- **Purpose:** Autonomous task implementation
- **Repeatable:** Yes, per task
```

### Command-Workflow Integration

Commands reference workflows via structured metadata BELOW frontmatter:

Example: `aug-dev/commands/plan-chat.md`
```markdown
---
name: plan-chat
description: Interactive architecture and design session
---

**Workflow:** [epic-development](../../aug-core/workflows/epic-development.md) • **Phase:** design (step 1/4) • **Next:** /plan-breakdown

[rest of command content]
```

Key aspects:
- Metadata below frontmatter (preserves Anthropic schema)
- Link to workflow doc for context
- Phase and step number for orientation
- Next command suggestion for guidance
- Supports cross-plugin references (aug-dev → aug-core)

### Workflow Skill

Location: `aug-core/skills/workflow-design/SKILL.md`

Modes:

**1. Discovery Mode** - Analyze existing commands
- Input: Set of related commands
- Identifies phases and dependencies
- Generates workflow doc

**2. Design Mode** - Create new workflow
- Input: Workflow description
- Helps design phases
- Identifies decision points
- Scaffolds workflow doc + command stubs

**3. Refactor Mode** - Improve existing workflow
- Input: Existing workflow
- Analyzes structure
- Suggests improvements (missing phases, better ordering)
- Updates workflow doc + command metadata

### Workflow Execution Commands

**Command:** `/workflow-run [workflow-name]`
- Reads `workflows/[workflow-name].md`
- Parses phases and commands
- Executes full workflow using `/automate` for each command
- Handles sequential dependencies
- Usage: `/workflow-run epic-development`

**Command:** `/workflow-status [workflow-name]`
- Shows current state of workflow execution
- Which phases completed, which pending
- Suggests next command to run
- Useful for manual step-through
- Usage: `/workflow-status epic-development`

### Execution Models

1. **Fully automated:** `/workflow-run epic-development` (uses automate)
2. **Manual step-through:** User runs `/plan-chat` → `/plan-breakdown` etc.
3. **Hybrid:** `/workflow-status` to check position, then manual commands

## Implementation Order

1. **Plugin reorganization** - Rename aug-util to aug-core
2. **Hemingwayesque** - Skill + command (simplest, no dependencies)
3. **User-standin + automate** - Agent + command (medium complexity)
4. **Workflow system** - Skill + commands + example workflow (most complex)

## Litmus Test

Retrofit existing `/plan-*` and `/work` commands in aug-dev into the epic-development workflow:
- Create `workflows/epic-development.md`
- Add workflow metadata to plan-chat.md, plan-breakdown.md, plan-create.md, work.md
- Verify `/workflow-status epic-development` works
- Test `/workflow-run epic-development` with /automate

Success criteria: Epic-development workflow demonstrably improves discoverability and execution of the plan/work commands.
