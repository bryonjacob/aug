---
name: automate
description: Execute commands autonomously with user-standin agent handling interactive prompts
---

Run any command autonomously. When target command asks interactive questions, user-standin agent analyzes context and responds.

## Usage

```bash
/automate /command-name [arguments]
```

## How It Works

1. Launch Task tool subagent (general-purpose type)
2. Subagent executes target command
3. When command prompts for input, subagent acts as user-standin:
   - Reads CLAUDE.md, analyzes directory structure, searches for patterns
   - Makes informed decision based on project context
   - Responds and continues
4. Reports results with decisions made

## Instructions

1. **Parse command and arguments** from user input

2. **Launch subagent** with Task tool (general-purpose type) and prompt:
   ```
   Execute `[command-name] [arguments]` autonomously.

   When command asks questions, act as user-standin:
   - Read CLAUDE.md for project context
   - Analyze directory structure and existing code
   - Search for relevant patterns and configuration
   - Make decision based on evidence, respond with choice and reasoning

   User-standin principles:
   - Ask "What would the user do given THIS codebase?"
   - Base decisions on evidence (CLAUDE.md, existing code, config)
   - Maintain consistency with existing patterns
   - Choose simplicity when evidence is ambiguous
   ```

3. **Report results:** Summarize execution, note decisions made, show output

## When NOT to Use

- Commands requiring strategic/creative decisions
- Domain knowledge input (not project context)
- First-time workflows needing human judgment
- Destructive operations without safeguards

## Integration

Enables `/workflow-run` by handling each phase autonomously.
