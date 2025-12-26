# Aug Plugin Marketplace

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

Workflow patterns and development standards for Claude Code.

## What is Aug?

Aug is a collection of workflow patterns for software development with Claude Code. It provides:

- **Epic planning workflows** - idea → architecture → tasks → implementation
- **Maturity models** - progressive capability addition with YAGNI
- **Quality automation** - coverage, complexity, and security gates
- **Development standards** - justfile interface, stack configurations

### The Foundation: Code Quality First

**The tools don't matter nearly as much as the quality of the codebase you're developing in.**

There's nothing magic about Aug. These workflows only work because they assume a high-quality codebase with:

- Comprehensive test coverage (96% threshold)
- Automated quality gates (format, lint, typecheck, coverage)
- Clear documentation (CLAUDE.md files for AI context)
- Consistent patterns (one way to do things)

The justfile commands, the opinionated stack configurations, the maturity model—all of that exists to establish and maintain this foundation. The first thing I do in any project is tidy up: get quality gates in place, fix existing issues, establish patterns. That's hands-on, intensive work.

Once you have that foundation, autonomous execution becomes reliable. Without it, no amount of clever tooling will help. And with it, many different approaches to AI-assisted development would work well—Aug is just one way.

### Why I'm Sharing This

I built these tools for myself, not as a polished reusable framework. They're the workflows I use every day for my own projects. As I've talked to more people about how I work with Claude Code, I realized these patterns have value worth sharing.

This is provided as-is. I welcome input and might accept pull requests, but I'm not trying to build a community project or promote widespread adoption. I'm open-sourcing it so I can share it with people who've asked, and hopefully the ideas are useful. That said, if this stack works great for you, I won't be surprised—this is literally how I work all day, every day.

**Opinionated:** Aug makes specific technology choices (uv for Python, pnpm for JavaScript, justfile for builds). These choices work well together but aren't universal.

**Adaptable:** The workflow patterns transfer to any stack. Swap tools while keeping the structure. See [ADAPTATION.md](docs/ADAPTATION.md).

## Installation

```bash
# Add marketplace from GitHub
/plugin marketplace add bryonjacob/aug

# Install all plugins
/plugin install aug-dev@aug aug-core@aug aug-just@aug aug-web@aug
```

## How I Use Aug

The core idea: **spend your synchronous time on planning, let the machine execute autonomously**.

### Epic Planning Workflow

This is where I do all my interactive work with Claude. The goal is to front-load my knowledge and decisions into planning documents, then let autonomous execution handle the implementation.

**`/plan-chat "Add JWT authentication"`** — Start an interactive session where we discuss the feature, architecture, and testing approach. This is where I'm putting my knowledge into the system about how things should work. Claude asks questions, proposes approaches, and we converge on a design. Output: planning documents in `/tmp/devplan/`.

**`/plan-breakdown`** — Take the plan and break it into bite-sized tasks. A good task is something a human developer could do in a day or less—that's usually something Claude can do in a few minutes with proper context. Each task becomes a self-contained unit of work.

**`/plan-create`** — Create GitHub issues from the breakdown. (Opinionated: I use GitHub issues, but you could adapt to Jira, Linear, or markdown files.) Now I have an epic with trackable tasks.

**`/work 123`** — Take issue #123 and work it autonomously: create branch, implement, test, ensure quality gates pass, create PR. No interaction needed. I review the PR when it's ready.

See [WORKFLOWS.md](docs/WORKFLOWS.md) for detailed usage.

### Automating Any Command

**`/automate /command`** — Run any interactive command autonomously. When the command asks questions, a "user-standin" agent analyzes project context (CLAUDE.md, existing code, config files) and answers on your behalf.

**`/autocommit 123 124 125`** — The full autonomous loop: work the issue, self-review, merge. Useful for grinding through a backlog of well-specified tasks.

### Workflow Orchestration

**`/workflow-run epic-development`** — Execute a multi-command workflow. Combines `/automate` with workflow definitions to run entire sequences autonomously.

**`/workflow-status`** — Check where you are in a workflow.

### Session Management

Claude's auto-compact doesn't always preserve context well. These are a quick-and-dirty alternative:

**`/notetoself`** — Save current session context to a temp file (directory-isolated). Use when switching tasks or before a long break.

**`/futureme`** — Resume from saved context. Faster and often more reliable than relying on auto-compact.

### Justfile Standards

I use justfile as the standard interface for all projects. Aug provides a maturity model for progressive capability addition:

**`/just-init python`** — Generate a baseline justfile for your stack. Level 0: format, lint, typecheck, test, coverage, check-all.

**`/just-assess`** — Analyze your current justfile. What level are you at? What's missing? What's next?

**`/just-upgrade 1`** — Add the next maturity level (quality gates, security scanning, etc.) when you actually need it.

The maturity model enforces YAGNI: Level 0 is mandatory, higher levels added only when there's a real need.

## Philosophy

Core principles independent of tool choices:

- **Assessment-driven** - Know current state before advancing
- **YAGNI with structure** - Mandatory baseline, optional higher levels
- **Quality as foundation** - Automate gates, enforce thresholds
- **Autonomous execution** - Human planning, machine implementation

See [PHILOSOPHY.md](docs/PHILOSOPHY.md) for details.

## Opinionated Choices

Technology decisions in this marketplace:

| Category | Choice | Alternatives |
|----------|--------|--------------|
| Build tool | justfile | Makefile, npm scripts |
| Python | uv, ruff, mypy, pytest | poetry, black, flake8 |
| JavaScript | pnpm, prettier, eslint, vitest | npm, jest |
| Java | maven, spotless, spotbugs, junit5 | gradle |
| Web | Next.js 15+, React 19, Tailwind v4 | Remix, Vue, CSS modules |
| Git workflow | Flat branches (all PRs to main) | Gitflow |
| Documentation | CLAUDE.md hierarchy, MkDocs | ADRs, wiki |
| Coverage | 96% | 80%, 90%, 100% |

See plugin READMEs for rationale and [ADAPTATION.md](docs/ADAPTATION.md) for how to swap tools.

## Plugins

### aug-dev

Core development workflows and tooling standards.

- Epic planning (plan-chat → breakdown → create)
- Autonomous task execution (work, autocommit)
- Stack configuration (Python, JavaScript, Java)
- Documentation standards (CLAUDE.md, MkDocs)

[View details](aug-dev/README.md)

### aug-core

AI-enhancement capabilities for Claude Code.

- Session management (notetoself, futureme)
- Concise prompts (hemingway)
- Autonomous commands (automate)
- Workflow orchestration

[View details](aug-core/README.md)

### aug-just

Justfile standard interface with maturity model.

- 5-level maturity model (baseline → polyglot)
- Assessment-driven progression
- YAGNI enforcement

[View details](aug-just/README.md)

### aug-web

Web development patterns for Next.js.

- Next.js 15+ App Router
- Tailwind v4 + CVA design systems
- Static site deployment

[View details](aug-web/README.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Reporting issues
- Sharing adaptations
- Adding language stacks
- Creating plugins

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

Copyright 2025 Bryon Jacob
