---
name: workflow-run
description: Execute complete workflow automated using /automate for each phase
---

**Uses:** workflow-design skill, /automate command

Execute entire workflow autonomously. Each phase runs via `/automate`, with user-standin handling interactive prompts.

## Usage

```bash
/workflow-run [workflow-name]
```

## Instructions

1. **Load workflow document**
   - Try: `workflows/[workflow-name].md` in aug-core, current plugin, aug-dev

2. **Parse workflow phases**
   - Extract phase names, commands, dependencies, repeatability flags

3. **Validate workflow**
   - All commands exist, dependencies clear, at least 2 phases

4. **Execute phases sequentially**
   For each phase:
   - Display phase info (X/Y, name, command)
   - Execute via `/automate /[command-name] [args]`
   - Stop on errors, report which phase failed
   - For repeatable phases: loop until done

5. **Report completion**
   - List executed phases
   - Note decisions made by user-standin
   - Suggest next steps

## Repeatable Phases

When phase marked `Repeatable: yes`:
1. Execute once
2. Ask "Run again?" or check context for more work
3. Loop until done

## Error Handling

On failure: Stop workflow, report failed phase with error details, suggest manual continuation.

## When to Use

**Good for:** Established workflows, good CLAUDE.md context, trust user-standin.

**Not for:** First-time workflows, creative decisions, lacking context, critical operations.

## Integration

- `/automate` - Executes each phase
- `workflow-design` skill - Creates workflows
- `/workflow-status` - Check progress (future)
