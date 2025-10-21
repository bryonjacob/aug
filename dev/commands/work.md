# work

## Task
$ARGUMENTS

## Purpose
Autonomous execution of issue(s) from branch creation through PR merge (or merge to main if no GitHub), passing all quality gates.

This command handles development work using the `executing-development-issues` skill and related development skills to ensure complete, high-quality implementations.

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

**⚠️ NEVER run parallel tasks in the same working directory.**

When executing issues in parallel, each task MUST work in its own git worktree to prevent race conditions during testing, linting, and git operations.

### Why Worktrees Are Required

**Without worktrees (DANGEROUS):**
- Task A runs tests → Task B's code causes Task A's tests to fail
- Task A runs lint → sees errors from Task B's uncommitted changes
- Tasks conflict on file locks, git index, and test artifacts
- Unpredictable failures and corrupted work

**With worktrees (SAFE):**
- Each task has isolated working directory
- Independent test runs, lint checks, and git operations
- Clean separation of concerns
- Parallel work actually works

### Worktree Setup for Parallel Execution

**Before launching parallel tasks:**

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

# Now launch tasks, each working in their own worktree directory
```

**After tasks complete:**

```bash
# Remove worktrees (branches already merged via PR)
git worktree remove ../worktree-99
git worktree remove ../worktree-100
git worktree remove ../worktree-101

# Prune worktree references
git worktree prune
```

### Worktree Task Instructions

When delegating to Task tool for parallel work, include the worktree path:

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
- Execute using the `executing-development-issues` skill
- Handle complete lifecycle: branch → implementation → tests → docs → PR → review → merge
- Use relevant stack-specific skills as needed (Python, JavaScript, Next.js, etc.)

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
Set up git worktrees (one per issue)
Execute multiple issues in parallel using Task tool with general-purpose agents
Each task works independently on its issue in its own worktree
Each creates separate branches and PRs
Merges happen as each PR is approved
```

**If sequential is required:**
```
Execute issues one at a time in the main working directory
Complete issue 1 and merge before starting issue 2
Ensures clean linear development when needed
```

**If mixed (some parallel, some sequential):**
```
Group independent issues together
Set up worktrees for parallel group
Execute parallel group using Task tool
Wait for group to complete before starting dependent issues
```

## Task Instructions for Parallel or Delegated Work

When using the Task tool for parallel or complex work, provide complete context:

```
You are working on issue [NUMBER/ID].

[If in worktree:]
Working directory: [WORKTREE_PATH]
IMPORTANT: All git operations must be performed from within your worktree directory.
Your worktree is isolated from other parallel work. Test, lint, and commit freely.

Issue source: [GitHub/Local]
Issue details:
[Full issue content including acceptance criteria]

Your mission:
1. Create feature branch (if not in worktree)
2. Implement changes to satisfy all acceptance criteria
3. Write comprehensive tests
4. Update documentation
5. Ensure all quality gates pass (just check-all)
6. Create PR [if GitHub] with clear description
7. Review your work with fresh perspective
8. Mark PR ready when all checks pass
9. Merge after approval

CRITICAL: Use the `executing-development-issues` skill for complete development standards.
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

When running multiple issues in parallel, launch tasks using the Task tool:

```
# For issues 123, 124, 125 that are independent:
# Use a SINGLE message with multiple Task tool calls:

Task tool call 1: subagent_type=general-purpose, working on issue 123 in ../worktree-123
Task tool call 2: subagent_type=general-purpose, working on issue 124 in ../worktree-124
Task tool call 3: subagent_type=general-purpose, working on issue 125 in ../worktree-125

# Each task works independently in its own worktree
# Each creates its own branch and PR
# Merges happen as PRs are approved
```

## Sequential Execution Example

When issues have dependencies:

```
# For issues 123 (foundation), 124 (depends on 123):

Execute issue 123 directly using executing-development-issues skill
[Complete and merge]

Execute issue 124 directly using executing-development-issues skill
[Now builds on 123's merged changes]
```

## Monitoring Progress

When working on issues (directly or via Task tool):
- Work proceeds autonomously through the full development lifecycle
- Follow the `executing-development-issues` skill for complete workflow
- For parallel work, each task in its worktree handles git operations independently
- Tasks report back when their issue is complete

## Important Notes

**Execution Modes:**
- **Single/Sequential:** Execute directly using skills in main working directory
- **Parallel/Complex:** Use Task tool with worktrees for isolation
- **Token Efficiency:** Task tool conserves context; use for parallel or complex work

**Quality Assurance:**
- Must pass `just check-all` before merging
- Must satisfy all acceptance criteria
- Must create PR for review (GitHub) or clean commits (local)
- No shortcuts - quality is non-negotiable

**Parallel Safety:**
- Only run issues in parallel if truly independent
- When in doubt, run sequentially - merge conflicts waste more time than serial execution
- Complex features with shared components should run sequentially
- Git worktrees required for parallel execution

**Skill Usage:**
- Always use `executing-development-issues` skill as primary workflow
- Reference stack-specific skills for tooling standards
- Follow Definition of Done checklist completely

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
Execute directly using the executing-development-issues skill:
- Work in current directory (no worktree needed)
- Follow complete workflow from skill
- Use stack-specific skills as needed
- Complete all Definition of Done criteria

OR if delegating for token efficiency:
Launch one Task tool call:
- subagent_type: "general-purpose"
- description: "Complete issue [NUMBER]"
- prompt: [Full task instructions with issue details and skill references]
- Working directory: Current directory (no worktree needed)
```

**5. For Parallel Issues - Setup Worktrees**

**CRITICAL: Before launching parallel tasks, create worktrees**

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

**6. Execute Based on Strategy**

**For parallel execution:**
```
Single message with multiple Task tool calls:
- Task 1: subagent_type=general-purpose on issue 99 in ../worktree-99
- Task 2: subagent_type=general-purpose on issue 100 in ../worktree-100
- Task 3: subagent_type=general-purpose on issue 101 in ../worktree-101

All in one message to execute concurrently.

Each task must be told:
- Their worktree path
- To cd into worktree before any git operations
- That they're isolated from other parallel work
- To use executing-development-issues skill
```

**For sequential execution:**
```
Execute issue 99 directly using executing-development-issues skill
[Complete and merge]

Execute issue 100 directly using executing-development-issues skill
[Complete and merge]

Continue until all issues complete

OR if delegating for token efficiency:
Task tool call for issue 99 (in main directory, no worktree)
[Wait for completion and merge]
Task tool call for issue 100 (in main directory)
[Continue as needed]
```

**For mixed execution (parallel groups + sequential):**
```
Create worktrees for parallel group
Launch Task calls for parallel issues (in worktrees)
[Wait for group completion]
Clean up worktrees
Execute next sequential issue directly or via Task (in main directory)
[Continue as needed]
```

**7. Monitor and Cleanup**

```
As work completes:
- Collect reports (if using Task tool)
- Verify PRs merged (or commits to main for local)

After parallel tasks finish:
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
