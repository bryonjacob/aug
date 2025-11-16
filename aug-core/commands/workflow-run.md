---
name: workflow-run
description: Execute complete workflow automated using /automate for each phase
---

Execute entire workflow autonomously. Each phase runs via `/automate`, with user-standin agent handling interactive prompts.

## Usage

```bash
/workflow-run [workflow-name]
```

## Examples

```bash
/workflow-run epic-development
/workflow-run database-migration
/workflow-run feature-release
```

## Instructions

1. **Load workflow document**
   ```bash
   Read workflows/[workflow-name].md
   ```

   If not found in aug-core:
   ```bash
   # Try current plugin
   Read [current-plugin]/workflows/[workflow-name].md

   # Try aug-dev
   Read aug-dev/workflows/[workflow-name].md
   ```

2. **Parse workflow phases**
   Extract from workflow doc:
   - Phase names
   - Commands for each phase
   - Dependencies/requirements
   - Repeatability flags

3. **Validate workflow**
   - All referenced commands exist?
   - Dependencies clear?
   - At least 2 phases?

4. **Execute phases sequentially**

   For each phase:

   a. **Display phase info**
   ```
   ═══════════════════════════════════════
   Phase [X/Y]: [Phase Name]
   Command: /[command-name]
   ═══════════════════════════════════════
   ```

   b. **Execute via /automate**
   ```bash
   /automate /[command-name] [args if any]
   ```

   c. **Check for errors**
   - If phase fails, stop workflow
   - Report which phase failed
   - Show error details

   d. **For repeatable phases**
   - Ask user: "Run [command] again? (y/n)"
   - If automated mode: check context for more work
   - Loop until done

5. **Report completion**
   ```
   ═══════════════════════════════════════
   Workflow Complete: [workflow-name]
   ═══════════════════════════════════════

   Phases executed:
   ✓ [Phase 1 name]
   ✓ [Phase 2 name]
   ✓ [Phase 3 name]

   Decisions made by user-standin:
   - [Decision 1]
   - [Decision 2]

   Next steps:
   [Suggested follow-up if any]
   ```

## Example Execution

**Command:** `/workflow-run epic-development`

**Workflow loads:** `workflows/epic-development.md`

**Phases parsed:**
1. Design - `/plan-chat`
2. Breakdown - `/plan-breakdown`
3. Create Issues - `/plan-create`
4. Execute - `/work` (repeatable)

**Execution:**

```
═══════════════════════════════════════
Phase 1/4: Design
Command: /plan-chat
═══════════════════════════════════════

[Runs: /automate /plan-chat]
[User-standin handles interactive questions]
[Design session complete]

✓ Phase 1 complete

═══════════════════════════════════════
Phase 2/4: Breakdown
Command: /plan-breakdown
═══════════════════════════════════════

[Runs: /automate /plan-breakdown]
[Breakdown creates task specifications]

✓ Phase 2 complete

═══════════════════════════════════════
Phase 3/4: Create Issues
Command: /plan-create
═══════════════════════════════════════

[Runs: /automate /plan-create]
[GitHub issues created: #45, #46, #47]

✓ Phase 3 complete

═══════════════════════════════════════
Phase 4/4: Execute (repeatable)
Command: /work
═══════════════════════════════════════

[Runs: /automate /work 45]
[Task #45 complete, PR created]

Run /work again for next task? (y/n)
```

## Handling Repeatable Phases

When phase marked `Repeatable: yes`:

1. Execute once
2. Ask: "Run [command] again?"
3. If yes, determine next iteration:
   - Check workflow doc for iteration logic
   - Ask user for next argument
   - Or check context (e.g., more GitHub issues)
4. Repeat until user says no or no more work

## Error Handling

If phase fails:

```
✗ Phase [X/Y] failed: [Phase Name]

Error: [error details]

Workflow stopped at phase [X].

To resume:
1. Fix the issue
2. Run: /workflow-run [workflow-name] --from-phase [X]

Or continue manually:
/[next-command]
```

## Resume Support (Future Enhancement)

**Not in v1, but designed for:**

```bash
/workflow-run epic-development --from-phase 2
```

For now: if workflow fails, user manually runs remaining phases.

## Notes

- **Fully autonomous:** No user interaction unless phase fails
- **Context-driven:** User-standin makes all decisions
- **Transparent:** Shows what's happening at each phase
- **Safe:** Stops on errors, doesn't continue blindly
- **Repeatable:** Can run same workflow multiple times

## When to Use

✅ **Good for:**
- Workflows you've run before
- Well-established processes
- CLAUDE.md has good context
- Trust user-standin decisions

❌ **Not for:**
- First-time workflows (use manual)
- Creative/strategic decisions needed
- Codebase lacks context
- Critical operations needing human judgment

For those: run phases manually with interactive input.

## Integration

Works with:
- `/automate` - Executes each phase
- `user-standin` agent - Makes decisions
- `workflow-design` skill - Creates workflows
- `/workflow-status` - Check progress (future)
