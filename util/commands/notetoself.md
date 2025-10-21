# notetoself

## Task
Capture current working context for future sessions.

## Purpose
When context usage is high, quickly save working state to pick up later without expensive conversation compacting.

## Instructions

### 1. Determine File Path
```bash
# Generate unique filename based on current directory
NOTETOSELF_FILE="/tmp/notetoself-$(pwd | sha256sum | cut -d' ' -f1 | head -c 16).md"
echo "Saving to: $NOTETOSELF_FILE"
```

### 2. Analyze Current Session

Review the conversation and extract:

**Current Task/Goal**
- What are we working on right now?
- What is the main objective?

**Recent Progress**
- What have we accomplished in this session?
- What files were created/modified?
- What decisions were made?

**Current State**
- Git branch (if applicable)
- Key file paths being worked on
- Any local issues being tracked (ISSUES.LOCAL)
- Tools/stack being used

**Next Steps**
- What needs to happen next?
- Any open questions or blockers?
- Specific tasks queued up?

**Important Context**
- Key decisions or constraints
- Gotchas discovered
- Patterns or approaches being followed
- References to agents or standards

### 3. Write Note

Create markdown file with structure:

```markdown
# Working Context - [Date/Time]

## Current Task
[Brief description of what we're working on]

## Progress This Session
- [Accomplishment 1]
- [Accomplishment 2]
- [etc]

## Current State
- **Directory:** [pwd]
- **Git Branch:** [branch name if applicable]
- **Key Files:**
  - [file1]
  - [file2]
- **Stack:** [language/framework being used]

## Next Steps
1. [Next action item]
2. [Following action]
3. [etc]

## Important Context
- [Key decision or constraint]
- [Gotcha or learning]
- [Pattern being followed]

## Blockers/Questions
- [Any open issues]

## References
- Skills used: [skill-name, skill-name]
- Related issues: [#123, LOCAL001, etc]
```

### 4. Save File

```bash
cat > "$NOTETOSELF_FILE" << 'EOF'
[generated content]
EOF

echo "✅ Context saved to: $NOTETOSELF_FILE"
echo "📝 Resume later with: /futureme"
```

## Execution Notes
- Be concise - focus on actionable context
- Capture enough detail to resume work immediately
- Include specific file paths and line numbers where relevant
- Note any environment setup needed
- Keep it under 500 lines - this should be quick context
- File persists until explicitly deleted or system temp cleanup