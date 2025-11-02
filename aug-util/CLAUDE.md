# Module: Aug-Util Plugin

## Purpose

Provides personal productivity utilities for managing working context across Claude Code sessions. Enables saving and resuming work to avoid conversation compacting overhead when token usage is high.

## Responsibilities

- Capture current working context to persistent storage
- Resume previous sessions with saved context
- Maintain session isolation per directory
- Provide context verification on resume

## Key Files

### Commands (`commands/`)
- `notetoself.md` - Capture current working context to `/tmp` for later resumption
- `futureme.md` - Resume work from previous session using saved context

## Public Interface

### Commands
- `/notetoself` - Save current session context to `/tmp/notetoself-{dir-hash}.md`
- `/futureme` - Load and resume from previously saved context

## Dependencies

- **Uses:** Unix `/tmp` filesystem for context storage
- **Used by:** Developers managing long-running or high-token sessions

## Architecture Decisions

**Context Storage:**
- Files stored in `/tmp/notetoself-{sha256-hash}.md`
- Hash based on current directory (`pwd | sha256sum | head -c 16`)
- Isolated per directory - multiple projects don't interfere
- System temp cleanup handles file lifecycle

**Context Format:**
- Markdown structure for readability
- Sections: Current Task, Progress, Current State, Next Steps, Important Context, Blockers
- Includes git branch, file paths, stack info, open issues
- Concise focus on actionable context (<500 lines)

**Resume Workflow:**
- Display full saved context first
- Verify current state matches saved context (branch, files)
- Warn if significant changes detected
- Ask before deleting note (user may want to reference)

**Use Cases:**
- Context usage approaching limits
- Need to switch projects temporarily
- End of work session with incomplete tasks
- Complex multi-step work requiring multiple sessions

## Testing

Commands tested through:
- Real-world session management scenarios
- Directory isolation verification
- Context save/resume round-trips

## Plugin Metadata

Defined in `.claude-plugin/plugin.json`:
- Name: `aug-util`
- Version: `1.2.0`
- Category: `productivity`
- Keywords: productivity, session, context

## Implementation Notes

**Why /tmp?**
- Standard Unix location for temporary files
- System handles cleanup automatically
- Fast filesystem access
- No permission concerns in user space

**Hash-based naming:**
- Prevents conflicts between projects
- Deterministic - same directory = same file
- Short hash (16 chars) balances uniqueness vs readability

**Not a replacement for git:**
- This is for session context, not code state
- Code should still be committed regularly
- Context notes are ephemeral working memory
