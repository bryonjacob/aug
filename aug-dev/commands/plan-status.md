---
name: plan-status
description: Show current planning session status and next steps
---

# Plan Status - View Planning Progress

Display status of all active planning sessions in `/tmp/devplan/`.

**Purpose**: Check progress of planning sessions and see what command to run next.

---

## Workflow

### Step 1: Check for Planning Directory

```bash
if [ ! -d /tmp/devplan ]; then
  echo "No active planning sessions."
  echo "Start one with: /plan-chat <description>"
  exit
fi
```

### Step 2: List All Epic Directories

```bash
find /tmp/devplan -maxdepth 1 -type d -not -path /tmp/devplan
```

### Step 3: Display Status for Each Epic

For each epic directory found:

1. **Read metadata.json**
   - Extract: epic_id, title, status, created, tasks count

2. **Check File Completeness**
   - ✅ chat.md exists
   - ✅ metadata.json exists
   - ✅ tasks/ directory exists
   - Count task-*.md files

3. **Determine Next Step**
   Based on status:
   - `"chat-complete"` → Next: `/plan-breakdown`
   - `"breakdown-complete"` → Next: `/plan-create`
   - Other → Show current status

### Step 4: Display Summary

Output format:

```
📋 Active Planning Sessions

Epic: JWT Authentication
  ID: jwt-auth
  Status: breakdown-complete
  Created: 2025-01-16

  Files:
  ✅ chat.md - Architecture complete
  ✅ tasks/ - 5 tasks defined

  Next: /plan-create

─────────────────────────────────

Epic: API Rate Limiting
  ID: api-rate-limit
  Status: chat-complete
  Created: 2025-01-15

  Files:
  ✅ chat.md - Architecture complete
  ⏳ tasks/ - Not yet broken down

  Next: /plan-breakdown

─────────────────────────────────

Active Planning Sessions: 2
```

---

## Example Outputs

### No Active Sessions

```
No active planning sessions.

Start a new epic:
  /plan-chat <epic-description>

Example:
  /plan-chat "Add JWT authentication with refresh tokens"
```

### Single Session Ready for Breakdown

```
📋 Active Planning Session

Epic: User Profile API
  ID: user-profile-api
  Status: chat-complete
  Created: 2025-01-16

  Files:
  ✅ chat.md - Architecture complete
  ✅ metadata.json - Epic info saved

  Next: /plan-breakdown
```

### Single Session Ready for Issue Creation

```
📋 Active Planning Session

Epic: Background Job Processing
  ID: background-jobs
  Status: breakdown-complete
  Created: 2025-01-16

  Files:
  ✅ chat.md - Architecture complete
  ✅ tasks/ - 4 tasks defined
    - task-1.md: Setup job queue infrastructure
    - task-2.md: Implement job processor
    - task-3.md: Add job monitoring
    - task-4.md: Add job retry logic

  Next: /plan-create
```

### Multiple Sessions at Different Stages

```
📋 Active Planning Sessions

1. Epic: JWT Authentication
   ID: jwt-auth
   Status: breakdown-complete
   Tasks: 5
   Next: /plan-create

2. Epic: API Rate Limiting
   ID: api-rate-limit
   Status: chat-complete
   Tasks: Not yet defined
   Next: /plan-breakdown

3. Epic: Caching Layer
   ID: caching-layer
   Status: chat-complete
   Tasks: Not yet defined
   Next: /plan-breakdown

─────────────────────────────────
Active Planning Sessions: 3

💡 Tip: Complete sessions in order, or use /plan-create
   to create issues before starting new planning.
```

---

## Status Values

- `chat-complete` - Architecture defined, ready for breakdown
- `breakdown-complete` - Tasks defined, ready to create issues
- `issues-created` - GitHub issues created (session complete)

---

## Error Handling

**Corrupted metadata.json:**
- Show warning with epic directory
- Display what files exist
- Suggest manual inspection or cleanup

**Missing expected files:**
- Indicate which files are missing
- Suggest appropriate recovery command
