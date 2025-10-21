# dev

Development workflows and tooling for software engineering projects.

## Skills

**Stack Configuration:**
- `configuring-javascript-stack` - JavaScript/TypeScript toolchain setup and configuration standards
- `configuring-python-stack` - Python toolchain setup and configuration standards

**Web UI Development:**
- `building-with-nextjs` - Modern web UI development with Next.js and TypeScript
- `building-static-sites` - Static site generation patterns for marketing sites, documentation, and blogs
- `styling-with-tailwind-cva` - Tailwind CSS + CVA design system architecture and component styling patterns
- `integrating-formspree-forms` - Form handling for static websites using Formspree

**Development Standards:**
- `creating-justfiles` - Standard justfile commands and patterns for all projects
- `installing-git-hooks` - Git hooks configuration using justfile commands
- `configuring-github-actions` - GitHub Actions CI/CD workflow configuration
- `documenting-with-claude-md` - Radical documentation standards for machine-readable context
- `documenting-libraries-with-mkdocs` - Opinionated MkDocs-based documentation standards for library projects

**Development Workflows:**
- `executing-development-issues` - Autonomous software engineer executing issues through complete development lifecycle
- `refactoring-with-coverage` - Systematic refactoring workflow with coverage requirements
- `self-reviewing-code` - Code review workflow using specialized agents
- `working-in-git-worktrees` - Git worktree management for parallel development
- `creating-agents` - Creating and editing well-formed agent definitions following established patterns

## Commands

- `/work` - Autonomous execution of issues from branch creation through PR merge, with support for sequential and parallel execution strategies
- `/plan` - Break down work into concrete, actionable GitHub issues (or local issues) with proper hierarchy and execution strategy
- `/refactor` - Systematic refactoring workflow that ensures 90%+ test coverage before changes
- `/quicktask` - Handle ad-hoc unplanned work with full issue tracking (combines /plan + /work in one flow)
- `/start-project` - Initialize new project repository with full development workflow setup (justfile, git hooks, CI/CD)
- `/devinit` - Audit project and set up missing development workflow components
