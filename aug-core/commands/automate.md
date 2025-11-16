---
name: automate
description: Execute commands autonomously with user-standin agent handling interactive prompts
---

Run any command autonomously. When target command asks interactive questions, user-standin agent analyzes context and responds.

## How It Works

1. Launch Task tool subagent with general-purpose type
2. Subagent executes target command
3. When target command prompts for input:
   - Subagent switches to user-standin agent mode
   - Reads CLAUDE.md, analyzes directory structure, searches relevant content
   - Makes informed decision based on project context
   - Responds and continues
4. Complete command execution

## Usage

```bash
/automate /command-name [arguments]
```

## Examples

```bash
# Automate interactive planning
/automate /plan-chat "Add JWT authentication"

# Automate breakdown (may ask about testing approach)
/automate /plan-breakdown

# Automate any interactive command
/automate /refactor src/auth/
```

## Instructions

1. **Parse command and arguments from user input**
   - Extract target command (e.g., `/plan-chat`)
   - Extract any arguments (e.g., `"Add JWT authentication"`)

2. **Launch subagent with Task tool**
   ```
   Use Task tool with:
   - subagent_type: "general-purpose"
   - description: "Automate [command-name]"
   - prompt: Detailed instructions below
   ```

3. **Subagent prompt structure:**
   ```markdown
   You are automating the execution of `[command-name] [arguments]`.

   Execute this command autonomously. When the command asks interactive questions:

   1. Switch to user-standin agent mode
   2. Read CLAUDE.md for project context
   3. Analyze directory structure and existing code
   4. Search for relevant patterns and configuration
   5. Make informed decision based on evidence
   6. Respond concisely with your choice and brief reasoning

   **User-standin principles:**
   - Ask "What would the user do given THIS codebase?"
   - Base decisions on evidence (CLAUDE.md, existing code, config files)
   - Maintain consistency with existing patterns
   - Choose simplicity when evidence is ambiguous
   - Never introduce new tools/patterns mid-automation

   **Context gathering:**
   - Read CLAUDE.md hierarchy
   - Check configuration files (package.json, pyproject.toml, etc.)
   - Grep for existing patterns related to questions
   - Review recent commits for direction

   Execute: [command-name] [arguments]
   ```

4. **Monitor execution**
   - Subagent completes command or reports issues
   - If errors occur, report to user

5. **Report results**
   - Summarize what was executed
   - Note any decisions made by user-standin
   - Show final output/state

## Example Execution Flow

**User:** `/automate /plan-breakdown`

**Subagent executes:**
1. Runs `/plan-breakdown` command
2. Command asks: "Which testing framework?"
3. Subagent (as user-standin):
   - Reads CLAUDE.md
   - Checks package.json: sees vitest configured
   - Greps existing tests: sees vitest patterns
   - Responds: "vitest - already configured in package.json"
4. Command asks: "Coverage threshold?"
   - Checks justfile: sees 96% threshold
   - Responds: "96% - set in justfile"
5. Command completes breakdown

**Reports back:**
- "Plan breakdown complete"
- "Decisions made: vitest (existing), 96% coverage (justfile)"
- [Shows breakdown output]

## Notes

- **Context is key:** User-standin quality depends on CLAUDE.md quality
- **Works best with:** Commands that ask about project-specific choices
- **Less useful for:** Commands needing creative/strategic decisions
- **Safe defaults:** User-standin chooses conservative, consistent options
- **Transparency:** Always report what decisions were made

## When NOT to Use

Don't automate:
- Commands requiring strategic/creative decisions beyond pattern-matching
- Commands where user input is domain knowledge (not project context)
- First-time workflows where human judgment needed
- Destructive operations without safeguards

For those: run command interactively.

## Integration with Workflows

Automate enables `/workflow-run` command by handling each workflow phase autonomously.

```bash
# Manual workflow
/plan-chat → [answer questions] → /plan-breakdown → [answer questions]

# Automated workflow
/workflow-run epic-development  # Uses /automate for each phase
```
