---
name: start-project
description: Initialize new project with complete development setup
argument-hint: <project-name>
---

# start-project

## Task
$ARGUMENTS

## Purpose
Initialize a new project repository with full development workflow setup.

## Steps

### 1. Create GitHub Repository
```bash
# If creating new repo
gh repo create [PROJECT_NAME] --public --clone
cd [PROJECT_NAME]

# If repo already exists
cd [PROJECT_PATH]
```

### 2. Create Project CLAUDE.md
Use `configuring-python-stack` or `configuring-javascript-stack` skills to determine tech stack, and `documenting-with-claude-md` skill for documentation structure:

```markdown
# [Project Name]

## Purpose
[Brief description of what this project does]

## Architecture Overview
[High-level architecture decisions]

## Module Index
- `src/` - Main source code
  - Add module links as they are created (e.g., `src/auth/` - Authentication (see src/auth/CLAUDE.md))

## Tech Stack
- [Language/framework]
- [Key dependencies]

## Development Setup
1. Install dependencies: `just dev`
2. Install git hooks: `just hooks`
3. Run tests: `just test`

## Development Workflow
See ~/.claude/CLAUDE.md for standard workflow.
Use `/plan` to break down work, `/work` to execute issues.
```

### 3. Create Justfile
Use the `creating-justfiles` skill and create appropriate justfile for tech stack.

For Python projects, use Python template from `creating-justfiles` skill.
For JavaScript projects, use JavaScript template from `creating-justfiles` skill.

### 4. Initialize Language Stack
Use `configuring-python-stack` or `configuring-javascript-stack` skills and set up:

**Python:**
```bash
uv venv .venv
source .venv/bin/activate
# Create pyproject.toml with standard config (see configuring-python-stack skill)
```

**JavaScript:**
```bash
pnpm init
# Create package.json, tsconfig.json, .prettierrc, .eslintrc.json (see configuring-javascript-stack skill)
```

### 5. Install Git Hooks
Use `installing-git-hooks` skill:
```bash
just hooks
```

### 6. Create GitHub Actions Workflow
Use `configuring-github-actions` skill and create `.github/workflows/pr-checks.yml` with appropriate template.

### 7. Initial Commit
```bash
git add .
git commit -m "chore: Initial project setup

- Add project CLAUDE.md
- Add justfile with standard commands
- Configure language toolchain
- Set up git hooks
- Add GitHub Actions PR checks

🤖 Generated with Claude Code"
git push -u origin main
```

### 8. Create GitHub Project (Optional)
If user wants project board:
```bash
OWNER_ID=$(gh api user --jq .node_id)
REPO_ID=$(gh repo view --json id -q .id)

PROJECT_ID=$(gh api graphql -f query='
mutation {
  copyProjectV2(input: {
    ownerId: "'$OWNER_ID'"
    projectId: "PVT_kwHOAAIObc4BCgNX"
    title: "[PROJECT_NAME]"
    includeDraftIssues: false
  }) {
    projectV2 {
      id
      url
    }
  }
}' --jq '.data.copyProjectV2.projectV2.id')

gh api graphql -f query='
mutation {
  linkProjectV2ToRepository(input: {
    projectId: "'$PROJECT_ID'"
    repositoryId: "'$REPO_ID'"
  }) {
    repository {
      name
    }
  }
}'
```

## Execution Notes
- Use language-specific skills for stack setup (configuring-python-stack, configuring-javascript-stack)
- Use creating-justfiles skill for build tooling
- Set up git hooks before first commit
- Create comprehensive project CLAUDE.md for context
- Ensure all quality gates work before declaring setup complete