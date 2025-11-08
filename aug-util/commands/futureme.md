---
name: futureme
description: Resume work from previously saved context
---

# futureme

## Task
Resume work from previous session using saved context.

## Purpose
Load working context saved by `/notetoself` to continue work without conversation compacting overhead.

## Instructions

### 1. Locate Note File
```bash
# Generate filename for current directory
NOTETOSELF_FILE="/tmp/notetoself-$(pwd | sha256sum | cut -d' ' -f1 | head -c 16).md"

# Check if file exists
if [ ! -f "$NOTETOSELF_FILE" ]; then
    echo "❌ No saved context found for this directory"
    echo "Expected: $NOTETOSELF_FILE"
    exit 1
fi
```

### 2. Read and Display Context
```bash
cat "$NOTETOSELF_FILE"
```

### 3. Verify Current State

Check that context is still valid:
- Is the git branch still the same? (if applicable)
- Do the referenced files still exist?
- Is the directory structure the same?

```bash
# Optional: Show current git status if in a repo
git status 2>/dev/null || echo "Not in a git repo"

# Optional: List key files mentioned in context
# (based on what was in the note)
```

### 4. Summarize for User

After reading the note, provide a brief summary:

```
📋 Resuming from previous session:

**Task:** [main task from note]

**Progress:** [key accomplishments]

**Next:** [immediate next steps]

**Current state verified:** [git branch, files exist, etc]

Ready to continue? [Ask user to confirm or provide updates]
```

### 5. Optional: Clean Up

Ask user if they want to keep or delete the note:

```bash
# After confirming resumption
read -p "Delete saved context? (y/n): " DELETE_NOTE

if [ "$DELETE_NOTE" = "y" ]; then
    rm "$NOTETOSELF_FILE"
    echo "✅ Cleaned up saved context"
else
    echo "📝 Context preserved at: $NOTETOSELF_FILE"
fi
```

## Execution Notes
- Display the full note contents first - user needs to see everything
- Verify current state matches saved context
- If significant changes occurred (different branch, files moved), warn user
- Don't automatically delete the note - user may want to reference it
- If multiple sessions saved notes, they're isolated by directory hash
- User can manually inspect `/tmp/notetoself-*.md` files if needed