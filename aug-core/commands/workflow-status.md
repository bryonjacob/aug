---
name: workflow-status
description: Show current workflow position, completed phases, and next steps
---

Display workflow progress. Shows which phases complete, current position, next command to run.

**Example Workflow:** See `../workflows/epic-development.md` for reference workflow this command tracks.

## Usage

```bash
/workflow-status [workflow-name]
```

## Examples

```bash
/workflow-status epic-development
/workflow-status database-migration
```

## Instructions

1. **Load workflow document**
   ```bash
   Read workflows/[workflow-name].md
   ```

   Search order:
   - aug-core/workflows/
   - Current plugin/workflows/
   - aug-dev/workflows/

2. **Parse workflow phases**
   Extract:
   - Phase names
   - Commands
   - Phase order
   - Dependencies

3. **Detect current position**

   For each phase's command, check if artifacts exist:

   **Planning workflows:**
   - `/plan-chat` → Check for `/tmp/devplan/` files
   - `/plan-breakdown` → Check for task specs in devplan
   - `/plan-create` → Check GitHub issues (search for epic label/number)
   - `/work` → Check for feature branches, PRs

   **Other workflows:**
   - Check for phase-specific outputs
   - Look for markers in git history
   - Examine file timestamps
   - Search for phase artifacts

4. **Display status**

   ```
   ════════════════════════════════════════════════════
   Workflow: [workflow-name]
   ════════════════════════════════════════════════════

   Progress: [X/Y phases complete]

   ✓ Phase 1: [Name] (/command-name)
     Completed: [evidence or timestamp]

   ✓ Phase 2: [Name] (/command-name)
     Completed: [evidence]

   → Phase 3: [Name] (/command-name)  ← YOU ARE HERE
     Status: In progress / Not started
     Next: /command-name [args if known]

   ○ Phase 4: [Name] (/command-name)
     Status: Pending (requires Phase 3)

   ════════════════════════════════════════════════════
   Next Step: /[next-command] [args]

   To automate remaining phases:
   /workflow-run [workflow-name] --from-phase [X]
   ════════════════════════════════════════════════════
   ```

5. **Suggest next action**
   - If workflow incomplete: show next command
   - If workflow complete: suggest related workflows
   - If error detected: suggest fix

## Status Indicators

- `✓` Complete - Phase finished, artifacts exist
- `→` Current - Currently at this phase
- `○` Pending - Not yet started
- `✗` Failed - Error detected, needs attention

## Detection Heuristics

### Epic Development Workflow

See `../workflows/epic-development.md` for full workflow definition.

**Phase 1: Design (/plan-chat)**
- ✓ Complete if: `/tmp/devplan/` exists with files
- Evidence: "Design complete [timestamp]"

**Phase 2: Breakdown (/plan-breakdown)**
- ✓ Complete if: Task specs in `/tmp/devplan/tasks/`
- Evidence: "5 tasks defined"

**Phase 3: Create Issues (/plan-create)**
- ✓ Complete if: GitHub issues exist with epic label
- Evidence: "Issues #45-49 created"
- Check: `gh issue list --label epic:[name]`

**Phase 4: Execute (/work)**
- ✓ Complete if: All epic issues closed
- Current if: Some issues open, branches/PRs exist
- Evidence: "3/5 tasks complete"
- Check: `gh issue list --label epic:[name] --state open`

### Generic Heuristics

**When detection unclear:**
- Check git history for commit messages
- Look for dated files matching phase
- Search for command-specific markers
- Default to "Status unknown - verify manually"

## Example Output

```
════════════════════════════════════════════════════
Workflow: epic-development
════════════════════════════════════════════════════

Progress: 2/4 phases complete

✓ Phase 1: Design (/plan-chat)
  Completed: 2025-11-16 14:30
  Output: /tmp/devplan/architecture.md

✓ Phase 2: Breakdown (/plan-breakdown)
  Completed: 2025-11-16 14:45
  Output: 5 tasks defined in /tmp/devplan/tasks/

→ Phase 3: Create Issues (/plan-create) ← YOU ARE HERE
  Status: Not started
  Next: /plan-create

○ Phase 4: Execute (/work)
  Status: Pending (requires issues)
  Next: /work [issue-number]

════════════════════════════════════════════════════
Next Step: /plan-create

To automate remaining phases:
/workflow-run epic-development --from-phase 3
════════════════════════════════════════════════════
```

## When Evidence is Unclear

If can't determine phase status:

```
Phase X: [Name] (/command-name)
  Status: Unknown - verify manually
  Check: [what to look for]
```

Be honest about detection limits. Better to say "unknown" than guess wrong.

## Notes

- **Best effort detection:** Uses heuristics, not perfect tracking
- **No state file:** Status inferred from artifacts (git, files, GitHub)
- **Context-dependent:** Different workflows need different detection logic
- **User verification:** Status shown but user validates correctness

## Future Enhancement: State Tracking

**Not in v1, but could add:**
- `/tmp/workflow-state-[hash].json` tracking file
- Records phase completion explicitly
- Updated by /workflow-run automatically
- Enables perfect resume capability

For now: rely on artifact detection.

## Integration

Works with:
- Workflow documents - Defines phases to check
- `/workflow-run` - Can resume from current phase
- Git, GitHub, filesystem - Sources of evidence
