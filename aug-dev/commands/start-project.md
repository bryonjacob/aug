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

Use `documenting-with-claude-md` skill to create root CLAUDE.md with purpose, architecture overview, module index, tech stack, and development setup sections.

**3. Create Justfile:**

Use `creating-justfiles` skill for appropriate template.

**4. Initialize Language Stack:**

Use the appropriate stack skill:
- Python: `configuring-python-stack`
- JavaScript/TypeScript: `configuring-javascript-stack`
- Java: `configuring-java-stack`
- Polyglot: `configuring-polyglot-stack`

**5. Install Hooks:**

Use `installing-git-hooks` skill.

**6. GitHub Actions:**

Use `configuring-github-actions` skill for `.github/workflows/pr-checks.yml`.

**7. Initial Commit:**
```bash
git add .
git commit -m "chore: Initial project setup"
git push -u origin main
```

## Notes

- Use language-specific skills for stack configuration
- Use creating-justfiles skill for tooling
- Set up hooks before first commit
- Ensure quality gates work before done
