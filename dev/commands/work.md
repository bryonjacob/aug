# work

## Task
$ARGUMENTS

## Purpose
Autonomous execution of issue(s) from branch creation through PR merge (or merge to main if no GitHub), passing all quality gates.

This command handles development work using the `executing-development-issues` skill and related development skills to ensure complete, high-quality implementations.

## Execution Strategy

Work on issues **sequentially**, one at a time, completing each fully before moving to the next.

**Examples:**

```
/work 99              # Work on issue 99
/work 99 100 101      # Work on issues 99, then 100, then 101
/work 99-101          # Work on issues 99, 100, 101 sequentially
```

**Why sequential:**
- Each issue gets complete attention and testing
- No race conditions or conflicts
- Clean git history with one issue per PR/commit
- Easier to review and debug
- Quality gates run without interference


## Issue Source

**GitHub Issues:** If git remote origin points to GitHub, use `gh issue view [NUMBER]`

**Local Issues:** If no GitHub remote, read from `ISSUES.LOCAL/LOCAL###-Title.md`

Check:
```bash
git remote get-url origin 2>/dev/null | grep -q github.com && echo "GitHub" || echo "Local"
```

## Implementation Approach

### Single Issue
For a single issue number (e.g., `/work 123` or `/work LOCAL001`):
- Execute using the `executing-development-issues` skill
- Handle complete lifecycle: branch → implementation → tests → docs → PR → review → merge
- Use relevant stack-specific skills as needed (Python, JavaScript, Java, Next.js, etc.)

### Multiple Issues
For multiple issue numbers (e.g., `/work 123 124 125` or `/work LOCAL001 LOCAL002`):

Work through issues **sequentially**, one at a time:

1. Read first issue and understand requirements
2. Execute using `executing-development-issues` skill
3. Complete full lifecycle: implement → test → review → merge
4. Move to next issue
5. Repeat until all issues complete

**Why sequential:**
- Each issue gets full attention and proper testing
- Clean git history with one feature per PR
- No merge conflicts between concurrent work
- Quality gates run reliably
- Easier to review and debug

## Execution Example

```
# For issues 123, 124, 125:

1. Work on issue 123
   - Read issue details
   - Create branch
   - Implement with tests
   - Pass quality gates
   - Create PR and merge

2. Work on issue 124
   - Read issue details
   - Create branch (now includes 123's changes)
   - Implement with tests
   - Pass quality gates
   - Create PR and merge

3. Work on issue 125
   - Read issue details
   - Create branch (now includes 123 and 124's changes)
   - Implement with tests
   - Pass quality gates
   - Create PR and merge
```

## Important Notes

**Quality Assurance:**
- Must pass `just check-all` before merging
- Must satisfy all acceptance criteria
- Must create PR for review (GitHub) or clean commits (local)
- No shortcuts - quality is non-negotiable

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

**1. Parse Arguments**

```
Arguments: $ARGUMENTS

Parse issue list:
- Range: "99-103" → [99, 100, 101, 102, 103]
- Simple list: "99 100 101" or "99, 100, 101"
- Narrative: "issues 99 through 101" → [99, 100, 101]
```

**2. Fetch Issue Details**

```bash
# For GitHub issues
gh issue view [NUMBER]

# For local issues
cat ISSUES.LOCAL/LOCAL###-Title.md
```

**3. Execute Issues Sequentially**

For each issue in order:

1. Read issue details and understand requirements
2. Use `executing-development-issues` skill
3. Create feature branch
4. Implement changes with tests
5. Pass all quality gates (`just check-all`)
6. Create PR (GitHub) or commit (local)
7. Review and merge
8. Pull latest changes before starting next issue

**4. Report Results**

```
Summarize to user:
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
