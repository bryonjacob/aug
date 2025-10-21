# work

## Task
$ARGUMENTS

## Purpose
Autonomous execution of issue(s) from branch creation through PR merge (or merge to main if no GitHub), passing all quality gates.

This command delegates actual development work to specialized software-engineer agents to conserve main thread tokens and enable parallel execution when appropriate.

## Execution Strategy Syntax

Use shorthand notation to specify sequential vs parallel execution:

- `>` = sequential (then)
- `|` = parallel (and)
- `()` = grouping
- `-` = range (e.g., `99-102` = issues 99, 100, 101, 102)

**Examples:**

```
/work 99>100>101           # Sequential: 99, then 100, then 101
/work 99|100|101           # Parallel: 99, 100, and 101 simultaneously
/work 99>(100|101)>102     # 99, then (100 and 101 in parallel), then 102
/work 99-101               # Issues 99, 100, 101 (strategy auto-determined)
/work 99 100 101           # Issues 99, 100, 101 (strategy auto-determined)
/work 99, 100, 101         # Issues 99, 100, 101 (strategy auto-determined)
```

**Complex example:**
```
/work 99>100>(101|102|(103>104))>(105|106)>107
```
Executes as:
1. Issue 99
2. Then issue 100
3. Then parallel: 101, 102, and (103 then 104)
4. Then parallel: 105 and 106
5. Then issue 107

**Conservative default:** When no strategy specified (simple list), analyze issues and create conservative execution plan. Only parallelize if clearly safe.

## CRITICAL: Git Worktrees for Parallel Execution

**⚠️ NEVER run parallel agents in the same working directory.**

When executing issues in parallel, each agent MUST work in its own git worktree to prevent race conditions during testing, linting, and git operations.

### Why Worktrees Are Required

**Without worktrees (DANGEROUS):**
- Agent A runs tests → Agent B's code causes Agent A's tests to fail
- Agent A runs lint → sees errors from Agent B's uncommitted changes
- Agents conflict on file locks, git index, and test artifacts
- Unpredictable failures and corrupted work

**With worktrees (SAFE):**
- Each agent has isolated working directory
- Independent test runs, lint checks, and git operations
- Clean separation of concerns
- Parallel work actually works

### Worktree Setup for Parallel Execution

**Before launching parallel agents:**

```bash
# Main repo stays on main branch
git checkout main
git pull origin main

# Create worktree for issue 99
git worktree add ../worktree-99 -b 99-feature-name

# Create worktree for issue 100
git worktree add ../worktree-100 -b 100-feature-name

# Create worktree for issue 101
git worktree add ../worktree-101 -b 101-feature-name

# Now launch agents, each working in their own worktree directory
```

**After agents complete:**

```bash
# Remove worktrees (branches already merged via PR)
git worktree remove ../worktree-99
git worktree remove ../worktree-100
git worktree remove ../worktree-101

# Prune worktree references
git worktree prune
```

### Worktree Delegation

When delegating to agents for parallel work, include the worktree path:

```
You are working on issue [NUMBER] in worktree directory: [WORKTREE_PATH]

IMPORTANT: All git operations must be performed from within your worktree directory:
cd [WORKTREE_PATH]

Your worktree is isolated from other parallel work. Test, lint, and commit freely.
```

## Issue Source

**GitHub Issues:** If git remote origin points to GitHub, use `gh issue view [NUMBER]`

**Local Issues:** If no GitHub remote, read from `ISSUES.LOCAL/LOCAL###-Title.md`

Check:
```bash
git remote get-url origin 2>/dev/null | grep -q github.com && echo "GitHub" || echo "Local"
```

## Execution Strategy

### Single Issue
For a single issue number (e.g., `/work 123` or `/work LOCAL001`):
- Delegate to one software-engineer agent
- Agent handles complete lifecycle: branch → implementation → tests → docs → PR → review → merge

### Multiple Issues
For multiple issue numbers (e.g., `/work 123 124 125` or `/work LOCAL001 LOCAL002`):

**1. Analyze for Parallel Execution Feasibility**

Read all issues and determine:
- Are they independent (no direct dependencies)?
- Do they likely touch different parts of the codebase (low merge conflict risk)?
- Can they be worked on simultaneously without blocking each other?

**Signs of independence (good for parallel):**
- Different features/modules
- Different files/directories
- No shared state or dependencies
- Each has clear, independent acceptance criteria

**Signs of dependency (must run sequentially):**
- Issue B depends on issue A's implementation
- Both modify the same core files
- Share database schema/API contracts that must be coordinated
- Acceptance criteria reference each other

**2. Execute Based on Analysis**

**If parallel is safe:**
```
Launch multiple software-engineer agents in parallel (one per issue)
Each agent works independently on its issue
Agents create separate branches and PRs
Merges happen as each PR is approved
```

**If sequential is required:**
```
Launch software-engineer agents one at a time
Wait for issue 1 to merge before starting issue 2
Ensures clean linear development when needed
```

**If mixed (some parallel, some sequential):**
```
Group independent issues together
Launch parallel agents for the group
Wait for group to complete before starting dependent issues
```

## Delegation Instructions

When delegating to software-engineer agent(s), provide complete context:

```
You are a software engineer working on issue [NUMBER/ID].

Issue source: [GitHub/Local]
Issue details:
[Full issue content including acceptance criteria]

Your mission:
1. Create feature branch
2. Implement changes to satisfy all acceptance criteria
3. Write comprehensive tests
4. Update documentation
5. Ensure all quality gates pass (just check-all)
6. Create PR [if GitHub] with clear description
7. Review your work with fresh perspective
8. Mark PR ready when all checks pass
9. Merge after approval

Use the `executing-development-issues` skill for complete development standards.
Use language-specific skills as needed:
- `configuring-python-stack` for Python projects
- `configuring-javascript-stack` for JavaScript/TypeScript
- `building-with-nextjs` for web UI projects

Report back when issue is complete and merged, including:
- PR URL [if GitHub] or commit SHA [if local]
- Summary of changes made
- Test coverage achieved
- Any challenges encountered
```

## Parallel Execution Example

When running multiple issues in parallel, launch agents using the Task tool:

```
# For issues 123, 124, 125 that are independent:
# Use a SINGLE message with multiple Task tool calls:

Task tool call 1: software-engineer working on issue 123
Task tool call 2: software-engineer working on issue 124
Task tool call 3: software-engineer working on issue 125

# Each agent works independently
# Each creates its own branch and PR
# Merges happen as PRs are approved
```

## Sequential Execution Example

When issues have dependencies:

```
# For issues 123 (foundation), 124 (depends on 123):

Task tool call: software-engineer working on issue 123
[Wait for completion and merge]

Task tool call: software-engineer working on issue 124
[Now builds on 123's merged changes]
```

## Monitoring Progress

When agents are running:
- Agents work autonomously through the full development lifecycle
- Each agent reports back when their issue is complete
- You can continue other work while agents execute
- Agents handle all git operations, testing, and quality checks

## Important Notes

**Token Efficiency:**
- Delegating to agents keeps main thread context small
- Each agent has fresh context focused only on its issue
- Agents handle all implementation details independently

**Quality Assurance:**
- Every agent must pass `just check-all` before merging
- Every agent must satisfy all acceptance criteria
- Every agent creates PR for review (GitHub) or clean commits (local)
- No shortcuts - quality is non-negotiable

**Parallel Safety:**
- Only run issues in parallel if truly independent
- When in doubt, run sequentially - merge conflicts waste more time than serial execution
- Complex features with shared components should run sequentially

**Agent Autonomy:**
- Agents handle complete workflow without intervention
- Agents make implementation decisions within issue scope
- Agents self-review before marking PR ready
- Agents report back only when complete

## Workflow Reference

See `executing-development-issues` skill for complete development workflow including:
- Issue analysis and planning
- Branch creation standards
- Test-driven development approach
- PR creation and review process
- Quality gate requirements
- Merge procedures for GitHub and local issues

## Implementation Steps

When you receive this command, follow these steps:

**1. Parse Arguments and Determine Strategy**

```
Arguments: $ARGUMENTS

Parse execution strategy:
- Explicit strategy: "99>100>(101|102)>103"
- Range: "99-103" → [99, 100, 101, 102, 103]
- Simple list: "99 100 101" or "99, 100, 101"
- Narrative: "issues 99 through 101" → [99, 100, 101]

If no explicit strategy (simple list/range):
  → Read all issues and analyze for safe parallelization
  → Be conservative - only parallelize if clearly independent
```

**2. Fetch Issue Details**

```bash
# For GitHub issues
gh issue view [NUMBER]

# For local issues
cat ISSUES.LOCAL/LOCAL###-Title.md

# Fetch ALL issues to understand dependencies
```

**3. Analyze for Parallelization (if no explicit strategy)**

```
For each pair of issues, check:
- Do they modify the same files/directories?
- Does one reference the other in acceptance criteria?
- Do they share database schemas or API contracts?
- Are they in the same module/feature area?

Conservative decision matrix:
- Same module → Sequential
- Different modules → Parallel (if no other dependencies)
- Shared dependencies → Sequential
- Unclear → Sequential (safe default)

Output strategy in visual syntax:
"Analysis: Issues 99 and 100 are independent → 99|100
         Issue 101 depends on 100 → (99|100)>101"
```

**4. For Single Issue (No Parallelization Needed)**

```
Launch one Task tool call:
- subagent_type: "general-purpose"
- description: "Complete issue [NUMBER]"
- prompt: [Full delegation instructions with issue details and @software-engineer reference]
- Working directory: Current directory (no worktree needed)
```

**5. For Parallel Issues - Setup Worktrees**

**CRITICAL: Before launching parallel agents, create worktrees**

```bash
# Ensure main is up to date
git checkout main
git pull origin main

# For each parallel issue, create worktree
git worktree add ../worktree-99 -b 99-brief-description
git worktree add ../worktree-100 -b 100-brief-description
git worktree add ../worktree-101 -b 101-brief-description

# List worktrees to verify
git worktree list
```

**6. Launch Agents Based on Strategy**

**For parallel execution:**
```
Single message with multiple Task tool calls:
- Task 1: software-engineer on issue 99 in ../worktree-99
- Task 2: software-engineer on issue 100 in ../worktree-100
- Task 3: software-engineer on issue 101 in ../worktree-101

All in one message to execute concurrently.

Each agent must be told:
- Their worktree path
- To cd into worktree before any git operations
- That they're isolated from other parallel work
```

**For sequential execution:**
```
Task tool call for issue 99 (in main directory, no worktree)
[Wait for agent to complete and report back]
Task tool call for issue 100 (in main directory)
[Wait for agent to complete and report back]
Continue until all issues complete
```

**For mixed execution (parallel groups + sequential):**
```
Create worktrees for parallel group
Launch Task calls for parallel issues (in worktrees)
[Wait for group completion]
Clean up worktrees
Launch next sequential issue (in main directory)
[Continue as needed]
```

**7. Monitor and Cleanup**

```
As agents complete:
- Collect their reports
- Verify PRs merged (or commits to main for local)

After parallel agents finish:
- Remove worktrees:
  git worktree remove ../worktree-99
  git worktree remove ../worktree-100
  git worktree remove ../worktree-101
- Prune worktree metadata:
  git worktree prune

Update main branch:
  git checkout main
  git pull origin main
```

**8. Report Results**

```
Summarize to user:
- Execution strategy used
- Issues completed
- PRs merged (with URLs)
- Test coverage achieved
- Any challenges encountered
```

## When to Use This Command

✅ **Use `/work` for:**
- Implementing features with clear acceptance criteria
- Bug fixes with reproduction steps
- Refactoring with high test coverage
- Any issue ready for autonomous execution

❌ **Don't use `/work` for:**
- Exploration or research tasks
- Issues without clear acceptance criteria
- Planning or architecture discussions
- Issues requiring human decision-making

For planning work, use `/plan` instead.
For quick ad-hoc tasks, use `/quicktask` instead.
