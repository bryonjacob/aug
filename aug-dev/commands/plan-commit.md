---
name: plan-commit
description: Persist planning artifacts to repository (optional)
---

# Plan Commit - Persist Planning to Repo

Optionally persist ephemeral planning artifacts from `/tmp/devplan/` to `.devplan/` in the repository.

**Purpose**: Keep a historical record of planning sessions in the repository. This is **optional** - GitHub issues are the source of truth.

**Prerequisites**: Run `/plan-create` first so planning artifacts include GitHub issue references.

---

## When to Use This

**Use `/plan-commit` when:**
- You want to keep planning history in the repo
- Team wants to review architecture decisions later
- You're documenting a complex design for reference

**Skip it when:**
- You prefer minimal repo artifacts (default)
- GitHub issues contain all needed information
- Planning was exploratory/experimental

---

## Workflow

### Step 1: Verify Prerequisites

1. **Check planning directory exists**
   ```bash
   [ -d /tmp/devplan ] || exit "No planning sessions found"
   ```

2. **List available epics**
   ```bash
   find /tmp/devplan -maxdepth 1 -type d -not -path /tmp/devplan
   ```

3. **If multiple epics, ask which to commit**
   - Show epic IDs and titles
   - Let user select one or all

### Step 2: Prepare for Commit

For each selected epic:

1. **Create target directory**
   ```bash
   mkdir -p .devplan/{epic-id}/tasks
   ```

2. **Copy planning artifacts**
   ```bash
   cp /tmp/devplan/{epic-id}/chat.md .devplan/{epic-id}/
   cp /tmp/devplan/{epic-id}/metadata.json .devplan/{epic-id}/
   cp /tmp/devplan/{epic-id}/tasks/*.md .devplan/{epic-id}/tasks/
   ```

3. **Create EPIC.md with GitHub references**

   Read metadata.json to get epic and task issue numbers, then create:

   ```markdown
   # Epic: {TITLE}

   **Epic Issue**: #{EPIC_ISSUE_NUMBER}
   **Created**: {DATE}
   **Status**: {STATUS}

   ## GitHub Issues

   Epic: https://github.com/{owner}/{repo}/issues/{EPIC_ISSUE}

   Tasks:
   - #{TASK_1}: {TITLE} - https://github.com/{owner}/{repo}/issues/{TASK_1}
   - #{TASK_2}: {TITLE} - https://github.com/{owner}/{repo}/issues/{TASK_2}

   ## Artifacts

   Planning session artifacts are preserved in this directory for reference:
   - `chat.md` - Architecture and design decisions
   - `tasks/*.md` - Detailed task specifications
   - `metadata.json` - Epic metadata

   **Note**: GitHub issues are the source of truth for execution.
   These artifacts are for historical reference only.

   ## Workflow

   Execute tasks:
   ```bash
   /work {TASK_ISSUE_NUMBER}
   ```
   ```

### Step 3: Commit to Repository

```bash
git add .devplan/{epic-id}/

git commit -m "docs: Add planning for epic #${EPIC_ISSUE}

Persists planning session for {EPIC_TITLE}.
All execution details in GitHub issue #${EPIC_ISSUE}."
```

### Step 4: Optional Cleanup

Ask user:
```
Planning committed to .devplan/{epic-id}/

Remove /tmp/devplan/{epic-id}/?
[yes/no]
```

If yes: `rm -rf /tmp/devplan/{epic-id}/`

### Step 5: Report Completion

Output:
```
✅ Planning Committed

Location: .devplan/{epic-id}/
Commit: {HASH}

Files:
  - EPIC.md (GitHub issue links)
  - chat.md (architecture)
  - tasks/*.md (task specs)
  - metadata.json (epic metadata)

This is for historical reference.
All actionable content in GitHub issues.

Epic Issue: #{EPIC_ISSUE}
Task Issues: #{TASK_1}, #{TASK_2}, ...
```

---

## Directory Structure After Commit

```
.devplan/
  jwt-auth/                    # Epic directory
    EPIC.md                    # GitHub issue references
    chat.md                    # Architecture session
    metadata.json              # Epic metadata
    tasks/
      task-1.md                # Task spec for #124
      task-2.md                # Task spec for #125
      task-3.md                # Task spec for #126
```

---

## Git Ignore Considerations

**.devplan/ should NOT be in .gitignore** if you want to commit planning.

However, if you prefer ephemeral planning by default, add to `.gitignore`:
```gitignore
# Ephemeral planning (use /plan-commit to persist)
.devplan/
```

Then use `git add -f .devplan/{epic-id}/` to force-add when explicitly committing.

---

## Example Usage

```bash
$ /plan-commit

Found planning sessions:
1. jwt-auth - JWT Authentication (5 tasks)
2. api-cache - API Caching Layer (3 tasks)

Commit which epic? [1/2/all]: 1

Copying planning artifacts...
✓ .devplan/jwt-auth/EPIC.md created
✓ .devplan/jwt-auth/chat.md copied
✓ .devplan/jwt-auth/tasks/*.md copied (5 files)
✓ .devplan/jwt-auth/metadata.json copied

Committing to repository...
✓ Committed: docs: Add planning for epic #123

Remove /tmp/devplan/jwt-auth/? [yes/no]: yes
✓ Cleaned up /tmp/devplan/jwt-auth/

✅ Planning Committed

Location: .devplan/jwt-auth/
Commit: a1b2c3d

Files:
  - EPIC.md (GitHub issue #123)
  - chat.md (architecture)
  - tasks/*.md (5 task specs)
  - metadata.json

This is for historical reference.
All actionable content in GitHub issue #123.
```

---

## Quality Checks

Before committing:
- [ ] EPIC.md created with GitHub issue links
- [ ] All planning artifacts copied
- [ ] Commit message references epic issue number
- [ ] Planning directory structure matches standard layout
- [ ] User confirmed they want to persist (optional step)
