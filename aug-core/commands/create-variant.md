---
name: create-variant
description: Create team-specific workflow variant by adapting aug marketplace content to existing tools and processes
---

# Create Variant

Generate customized workflow files in `.claude/` by adapting aug marketplace commands/skills/workflows to team's existing tools, processes, and conventions.

## Usage

```bash
/create-variant [team-name]

# Interactive wizard:
# 1. Discovers team context (git, CI, build tools)
# 2. Asks clarifying questions
# 3. Selects components to adapt
# 4. Generates files to .claude/
```

## Purpose

Create prescriptive workflows adapted to team context. Not runtime-flexible generic tools, but opinionated workflows customized for specific team's reality.

**Use when:**
- Onboarding aug workflows to existing team
- Team has established tools/processes to preserve
- Need GitHub-to-Jira adaptation
- Need just-to-make adaptation
- Need gitflow-to-trunk adaptation
- Want prescriptive team-specific commands

## Process

### Phase 1: Find Aug Marketplace Source

**Critical:** Must locate aug source files to copy/adapt.

**Steps:**

1. **Check known marketplaces:**
```bash
if [ -f ~/.claude/plugins/known_marketplaces.json ]; then
  jq -r '.aug.installLocation // empty' ~/.claude/plugins/known_marketplaces.json
fi
```

2. **Try common paths:**
```bash
~/.claude/marketplaces/aug
~/aug
/opt/aug
```

3. **Verify by checking for:**
```bash
$AUG_PATH/aug-dev/commands/plan-chat.md
$AUG_PATH/aug-just/skills/justfile-interface/SKILL.md
```

4. **If not found, ask user:**
```
Cannot locate aug marketplace installation.
Please provide path to aug marketplace:
```

**Store location for session:**
```bash
AUG_SOURCE_PATH="/path/to/aug"
```

### Phase 2: Discover Team Context

Use creating-variants skill patterns. Detect automatically, ask to confirm.

#### 2a. Git & Version Control

**Auto-detect:**
```bash
# Check git config
git config --get remote.origin.url
# Sample: git@github.com:org/repo.git → GitHub
# Sample: https://gitlab.com/org/repo.git → GitLab

# Analyze branch patterns
git branch -a | grep -E "(feature|hotfix|release|develop)"
```

**Questions:**
```
Detected: GitHub repository with trunk-based workflow (main branch)

Git workflow?
[ ] Trunk-based (main + feature/* branches)
[ ] Gitflow (develop/main + feature/release/hotfix)
[ ] GitHub Flow (main + PR workflow)
[ ] Custom (describe)
```

**Follow-up for custom:**
```
What branch do you develop features from? (main, develop, master)
What branch do PRs target? (main, develop)
What branch naming pattern? (feature/*, user/*, {ticket}-*)
```

#### 2b. Issue Tracking

**Auto-detect:**
```bash
# Check for GitHub CLI
gh auth status 2>/dev/null && echo "GitHub Issues available"

# Check for Jira CLI
jira version 2>/dev/null && echo "Jira available"

# Check for config files
[ -d .github ] && echo "GitHub workflows present"
[ -f .jira/config ] && echo "Jira config present"
```

**Questions:**
```
Detected: GitHub CLI authenticated

Issue tracking?
[ ] GitHub Issues (detected, recommended)
[ ] Jira (requires jira CLI or API token)
[ ] Linear (requires linear CLI)
[ ] Markdown files (no external system)
[ ] None (manual tracking)
```

**Follow-up for Jira:**
```
Jira project key? (e.g., PROJ for PROJ-123)
Create epics automatically? (yes/no)
Required fields: (e.g., component, assignee)
```

**Follow-up for file-based:**
```
Where to save planning? (.planning/, issues/, docs/planning/)
```

#### 2c. CI/CD Platform

**Auto-detect:**
```bash
[ -d .github/workflows ] && echo "GitHub Actions"
[ -f Jenkinsfile ] && echo "Jenkins"
[ -f .gitlab-ci.yml ] && echo "GitLab CI"
[ -f .circleci/config.yml ] && echo "CircleCI"
```

**Questions:**
```
Detected: GitHub Actions workflows

CI/CD platform?
[ ] GitHub Actions (detected)
[ ] Jenkins
[ ] GitLab CI
[ ] CircleCI
[ ] None / Manual
```

**Follow-up:**
```
What's the quality gate? (tests + coverage, tests only, manual)
Generate CI config? (yes/no)
```

#### 2d. Build Tool

**Auto-detect:**
```bash
[ -f justfile ] && echo "just"
[ -f Makefile ] && echo "make"
[ -f package.json ] && echo "npm/pnpm/yarn"
[ -f build.gradle ] && echo "gradle"
[ -f pom.xml ] && echo "maven"
```

**Questions:**
```
Detected: Maven (pom.xml)

Build tool?
[ ] Maven (detected, keep)
[ ] just (replace Maven? not recommended)
[ ] Hybrid (Maven + just wrapper)
```

**Important:** If team has working build tool, KEEP IT. Adapt commands to call it, don't replace.

**If no build tool:**
```
No build automation detected.

Install build tool?
[ ] just (recommended for new projects)
[ ] make (if team prefers)
[ ] npm scripts (for JS projects)
[ ] None (manual commands)
```

#### 2e. Stack & Languages

**Auto-detect:**
```bash
# Languages
find . -name "*.py" | head -1 && echo "Python"
find . -name "*.ts" | head -1 && echo "TypeScript"
find . -name "*.java" | head -1 && echo "Java"

# Tools
[ -f pyproject.toml ] && echo "Python: uv/poetry/pdm"
[ -f package.json ] && jq -r '.devDependencies | keys[]' package.json | grep -E "(eslint|prettier|vitest)"
[ -f pom.xml ] && grep -E "(spotless|spotbugs|jacoco)" pom.xml
```

**Questions per language:**

**Python:**
```
Detected: Python project with pytest

Current tools:
- pytest (keep)
- coverage.py (keep)

Add from aug?
[ ] ruff (linting + formatting)
[ ] mypy (type checking)
[ ] uv (fast dependency management)
```

**JavaScript:**
```
Detected: TypeScript project with npm

Current tools:
- vitest (keep)
- eslint (keep)

Add from aug?
[ ] prettier (formatting)
[ ] pnpm (faster than npm)
```

**Java:**
```
Detected: Java project with Maven + JUnit

Current tools:
- Maven (keep)
- JUnit 5 (keep)

Add from aug?
[ ] Spotless (code formatting)
[ ] SpotBugs (static analysis)
[ ] JaCoCo (coverage, 96% threshold)
```

#### 2f. Team Conventions

**Auto-detect:**
```bash
# Commit message patterns
git log --oneline -20

# PR naming patterns
gh pr list --state all --limit 20 2>/dev/null | cut -f2
```

**Questions:**
```
Detected: Conventional Commits format (feat:, fix:, chore:)

Commit message format?
[ ] Conventional Commits (detected, recommended)
[ ] Jira prefix ({KEY}: description)
[ ] Custom (describe)
```

### Phase 3: Select Components

**Questions:**
```
Which workflows to adapt?

Planning:
[ ] Epic planning (/plan-chat, /plan-breakdown, /plan-create)
[ ] Task execution (/work, /quicktask)

Quality:
[ ] Refactoring workflow (/refactor)
[ ] Documentation audit (/docsaudit)
[ ] Test optimization (/test-optimize)

Setup:
[ ] Project initialization (/start-project, /devinit)
[ ] Build interface (justfile or equivalent)
[ ] Stack configuration (language-specific)

All:
[ ] Select all (recommended for full adoption)

Custom:
[ ] Let me choose specific commands
```

**If custom, show command list with checkboxes.**

### Phase 4: Adapt & Generate

For each selected component:

#### 4a. Read Source

```bash
# Example: Read plan-chat command
cat "$AUG_SOURCE_PATH/aug-dev/commands/plan-chat.md"
```

#### 4b. Apply Adaptations

**Branch pattern replacement:**
```markdown
# Original (aug)
Branch: epic/{epic-slug}/{task-slug}

# Adapted (gitflow team)
Branch: feature/{epic-slug}-{task-slug} (from develop)
```

**Issue tracker replacement:**
```markdown
# Original (aug)
gh issue create --title "..." --body "..."

# Adapted (Jira team)
jira issue create --project PROJ --type Epic --summary "..."
```

**Build tool replacement:**
```markdown
# Original (aug)
just check-all

# Adapted (Maven team)
mvn verify
```

**Terminology replacement:**
```markdown
# Original (aug)
/plan-chat → /plan-breakdown → /plan-create

# Adapted (team using "feature" not "epic")
/plan-feature → /plan-tasks → /create-feature
```

#### 4c. Generate Files

Write to `.claude/` in current directory:

```bash
mkdir -p .claude/{commands,skills,workflows}

# Example: Adapted command
cat > .claude/commands/plan-feature.md <<EOF
---
name: plan-feature
description: Interactive architecture session for new feature
---

# Plan Feature

**[Adapted from aug-dev /plan-chat for {TEAM}]**

## Purpose
...
EOF
```

**File naming:**
- Keep semantic names (plan-feature, not plan-chat)
- Match team terminology
- Preserve intent

**Generated files:**

For **Epic Planning workflow:**
```
.claude/
├── commands/
│   ├── plan-feature.md      # From plan-chat
│   ├── plan-tasks.md        # From plan-breakdown
│   ├── create-feature.md    # From plan-create
│   ├── plan-status.md       # From plan-status (if selected)
│   └── save-plan.md         # From plan-commit (if selected)
└── workflows/
    └── feature-delivery.md  # From epic-development
```

For **Task Execution:**
```
.claude/
└── commands/
    ├── implement.md         # From work
    └── quick-task.md        # From quicktask
```

For **Build Interface:**
```
.claude/
├── commands/
│   ├── build-init.md        # From just-init (adapted for their tool)
│   └── build-check.md       # From just-assess (adapted)
└── skills/
    └── team-build-interface/
        └── SKILL.md         # From justfile-interface (adapted)
```

For **Stack:**
```
.claude/
└── skills/
    └── team-{lang}-stack/
        └── SKILL.md         # Merged from aug + their tools
```

#### 4d. Document Variant

Create `.claude/VARIANT.md`:

```markdown
# {TEAM} Workflow Variant

Generated: {date}
Based on: aug marketplace v3.0.0

## Adaptations

**Git workflow:** Gitflow (develop/main)
- Adapted branch patterns in all commands
- PR target: develop (not main)

**Issue tracking:** Jira (project: PROJ)
- Replaced `gh issue` with `jira issue` commands
- Issue references: PROJ-123 (not #123)

**Build tool:** Maven (keep existing)
- Adapted commands to call `mvn` (not `just`)
- Added quality gates: verify, test, jacoco:report

**Stack: Java**
- Kept: Maven, JUnit 5, Mockito
- Added: Spotless, SpotBugs, JaCoCo (96% threshold)

## Components

From aug-dev:
- plan-feature (from plan-chat)
- plan-tasks (from plan-breakdown)
- create-feature (from plan-create)
- implement (from work)

From aug-just:
- team-build-interface (from justfile-interface, adapted for Maven)

Custom:
- team-java-stack (merged aug + team tools)

## Maintenance

These files are static copies. To update:
1. Check aug RELEASE_NOTES for changes
2. Manually review updated aug source
3. Apply relevant changes to variant files

Or re-run: `/create-variant {TEAM}`

## Usage

Commands available in this directory:
- /plan-feature [description]
- /plan-tasks
- /create-feature
- /implement {JIRA-KEY}

See .claude/commands/ for all available commands.
```

### Phase 5: Summary

**Output:**
```
✅ Created {TEAM} workflow variant in .claude/

Generated files:
  Commands: 8 files
  Skills: 2 files
  Workflows: 1 file

Adaptations:
  - Git workflow: Gitflow (develop/main branches)
  - Issues: Jira (PROJ-* format)
  - Build: Maven (existing tool preserved)
  - Stack: Java (Maven + Spotless + SpotBugs + JaCoCo)

Documentation: .claude/VARIANT.md

Next steps:
1. Review generated files: ls -la .claude/
2. Test a command: /plan-feature "Add login"
3. Customize as needed: edit .claude/commands/*.md
4. Share with team: commit .claude/ directory

To regenerate: /create-variant {TEAM}
```

## Implementation Notes

**Use Skill tool:**
```markdown
Use creating-variants skill for:
- Finding aug marketplace source
- Discovery patterns
- Adaptation strategies
- File generation conventions
```

**Use Task tool if complex:**
- If discovery is very complex, launch explore agent
- If many files to adapt, launch general-purpose agent
- Otherwise handle inline

**Read source files directly:**
```bash
# Must read actual markdown files
cat "$AUG_SOURCE_PATH/aug-dev/commands/plan-chat.md"

# NOT just execute them
# We need file CONTENT to copy/adapt
```

**Preserve markdown structure:**
- Keep frontmatter (adapt name/description)
- Keep section headings
- Adapt content within sections
- Add attribution comment at top

**Handle missing aug source:**
- If aug marketplace not found, give clear error
- Provide manual path input
- Suggest running: /plugin marketplace add

## Error Handling

**Aug marketplace not found:**
```
❌ Cannot locate aug marketplace installation.

Checked:
  - ~/.claude/plugins/known_marketplaces.json
  - ~/.claude/marketplaces/aug
  - ~/aug

Please install aug marketplace:
  /plugin marketplace add owner/aug

Or provide path manually:
  /create-variant --aug-path /path/to/aug
```

**No git repository:**
```
⚠️  Not a git repository.

/create-variant works best in a git repository.
Continue anyway? (y/n)
```

**No write permission:**
```
❌ Cannot write to .claude/ directory.

Check permissions: ls -la .claude
```

**Component conflicts:**
```
⚠️  .claude/commands/plan-feature.md already exists.

Overwrite? (y/n/backup)
  y - Overwrite
  n - Skip this file
  backup - Rename existing to .bak
```

## Examples

### Example 1: Java Team with Jira + Gitflow

```bash
/create-variant acme-backend

→ Detected: Java (Maven), Jira, Gitflow, GitHub Actions
→ Selected: Epic planning + Task execution + Build interface
→ Generated: 12 files to .claude/

Commands created:
  - /plan-feature → Jira epic creation
  - /implement {JIRA-KEY} → Gitflow branches
  - /build-check → Maven verify
```

### Example 2: Python Team with GitHub + Trunk

```bash
/create-variant startup-api

→ Detected: Python (uv), GitHub Issues, Trunk-based
→ Selected: Full workflow (planning + quality + setup)
→ Generated: 18 files to .claude/

Commands created:
  - /plan-epic → GitHub issue
  - /work {issue} → main branch
  - /refactor → with ruff + mypy
```

### Example 3: Legacy Team with File-Based Planning

```bash
/create-variant legacy-monolith

→ Detected: Java (Ant), No issue tracker, Custom git
→ Selected: Epic planning only
→ Generated: 6 files to .claude/

Commands created:
  - /plan-feature → Save to .planning/
  - /plan-tasks → Generate task files
  - /list-tasks → Read from .planning/
```

## Anti-Patterns

**Don't:**
- ❌ Create runtime-flexible commands (defeats prescriptive purpose)
- ❌ Try to maintain automatic sync with aug (static fork)
- ❌ Replace working tools without asking
- ❌ Over-generalize variant for "any team"

**Do:**
- ✅ Create specific variant for THIS team
- ✅ Keep team's working tools, add for gaps
- ✅ Adapt aug workflows to team reality
- ✅ Document why each adaptation was made
- ✅ Make opinionated choices based on team context

## Related

- Skill: creating-variants (adaptation patterns)
- Skills: aug-dev stack configuration (base patterns)
- Skills: aug-just maturity model (build interface patterns)
