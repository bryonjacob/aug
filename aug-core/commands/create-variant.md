---
name: create-variant
description: Create team-specific workflow variant by adapting aug marketplace content to existing tools and processes
---

**Uses:** creating-variants skill

# Create Variant

Generate customized workflow files in `.claude/` by adapting aug marketplace content to team's existing tools and processes.

## Usage

```bash
/create-variant [team-name]
```

## Purpose

Create prescriptive workflows adapted to team context. Fork aug content, adapt to team reality, maintain opinionated workflows.

**Use when:**
- Onboarding aug workflows to existing team
- Need GitHub-to-Jira, just-to-make, or gitflow-to-trunk adaptation
- Want prescriptive team-specific commands

## Process

### Phase 1: Find Aug Marketplace Source

Locate aug source files using creating-variants skill discovery sequence:
1. Check `~/.claude/plugins/known_marketplaces.json`
2. Try common paths (`~/.claude/marketplaces/aug`, `~/aug`, `/opt/aug`)
3. Ask user if not found

### Phase 2: Discover Team Context

Use creating-variants skill patterns to detect and confirm:
- **Git workflow:** Trunk-based, Gitflow, GitHub Flow, custom
- **Issue tracking:** GitHub Issues, Jira, Linear, file-based, none
- **CI/CD:** GitHub Actions, Jenkins, GitLab CI, CircleCI
- **Build tool:** just, make, npm/pnpm, gradle, maven
- **Stack:** Languages, frameworks, linters, test tools
- **Conventions:** Commit format, PR naming, code style

**Principle:** If team has working tools, KEEP them. Adapt commands to use existing tools.

### Phase 3: Select Components

Offer workflow categories:
- **Planning:** /plan-chat, /plan-breakdown, /plan-create
- **Execution:** /work, /quicktask
- **Quality:** /refactor, /docsaudit, /test-optimize
- **Setup:** /start-project, /devinit, justfile

### Phase 4: Adapt & Generate

For each selected component:
1. Read source from aug marketplace
2. Apply adaptations (branch patterns, issue commands, build tools, terminology)
3. Write to `.claude/` with semantic names matching team terminology
4. Create `.claude/VARIANT.md` documenting adaptations

### Phase 5: Summary

Report generated files, adaptations applied, and next steps.

## Error Handling

- **Aug not found:** Prompt for manual path
- **No git repo:** Warn and offer to continue
- **File conflicts:** Offer overwrite/skip/backup

## Anti-Patterns

- Do not create runtime-flexible commands (defeats prescriptive purpose)
- Do not auto-sync with aug (static fork, manual updates)
- Do not replace working tools without asking

## Related

- Skill: creating-variants (discovery patterns, adaptation strategies)
- Skills: aug-dev stack configuration
- Skills: aug-just maturity model
