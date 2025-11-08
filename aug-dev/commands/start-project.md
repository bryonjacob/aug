---
name: start-project
description: Initialize new project with complete development setup
argument-hint: <project-name>
---

# start-project

## Task
$ARGUMENTS

## Purpose

Initialize new project with full development workflow setup.

## Steps

**1. Create GitHub Repo:**
```bash
gh repo create [PROJECT_NAME] --public --clone
cd [PROJECT_NAME]
```

**2. Create CLAUDE.md:**

Use `documenting-with-claude-md` skill:

```markdown
# [Project Name]

## Purpose
[Description]

## Architecture Overview
[High-level decisions]

## Module Index
- `src/` - Main source
  - Add module links as created

## Tech Stack
- [Language/framework]
- [Dependencies]

## Development Setup
1. Install: `just dev`
2. Hooks: `just hooks`
3. Test: `just test`

## Development Workflow
See ~/.claude/CLAUDE.md
Use `/plan` to break down, `/work` to execute
```

**3. Create Justfile:**

Use `creating-justfiles` skill for appropriate template

**4. Initialize Language Stack:**

Python (`configuring-python-stack`):
```bash
uv venv .venv
source .venv/bin/activate
# Create pyproject.toml with standard config
```

JavaScript (`configuring-javascript-stack`):
```bash
pnpm init
# Create package.json, tsconfig.json, configs
```

**5. Install Hooks:**

Use `installing-git-hooks`:
```bash
just hooks
```

**6. GitHub Actions:**

Use `configuring-github-actions` for `.github/workflows/pr-checks.yml`

**7. Initial Commit:**
```bash
git add .
git commit -m "chore: Initial project setup

- Add CLAUDE.md
- Add justfile
- Configure toolchain
- Set up hooks
- Add PR checks

🤖 Generated with Claude Code"
git push -u origin main
```

**8. GitHub Project (Optional):**

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
    projectV2 { id url }
  }
}' --jq '.data.copyProjectV2.projectV2.id')

gh api graphql -f query='
mutation {
  linkProjectV2ToRepository(input: {
    projectId: "'$PROJECT_ID'"
    repositoryId: "'$REPO_ID'"
  }) {
    repository { name }
  }
}'
```

## Notes

- Use language-specific skills for stack
- Use creating-justfiles for tooling
- Set up hooks before first commit
- Ensure quality gates work before done
