---
name: work
description: Autonomous task execution from GitHub issue to PR
argument-hint: <issue-number>
---

**Workflow:** [epic-development](../workflows/epic-development.md) • **Phase:** execute (step 4/4, repeatable)

# Work - Autonomous Task Execution

Execute GitHub issue through to PR. Fully autonomous.

**Purpose**: Implement task from issue spec with incremental commits, quality gates, and self-healing.

**Prerequisites**: Task issue created by `/plan-create` with complete specification.

**Skills Used**:
- `software-development` - Implementation with chunk testing
- `software-debugging` - Self-healing when quality checks fail
- `software-quality` - Test coverage review

---

## Key Principles

- **Idempotent**: Safe to re-run if interrupted
- **Incremental**: Commits and pushes after each chunk
- **Self-healing**: Auto-fixes format/lint/type errors (convergence-based)
- **Quality-gated**: Must pass `just check-all` before PR
- **Autonomous**: No user interaction

---

## Workflow

Use TodoWrite to track progress.

### Phase 0: Load & Verify

1. **Fetch Issue**: `gh issue view {ISSUE_NUMBER} --json body`

2. **Parse Metadata** from issue body:
   - EPIC_ID, TASK_ID, BRANCH_NAME, DEPENDS_ON, EPIC_ISSUE

3. **Verify Dependencies**: If DEPENDS_ON != "none", check each dependency issue is closed.

4. **Check Branch State**:
   - If branch exists with merged PR: exit (task complete)
   - If branch exists with open PR: resume
   - If no branch: create from main

### Phase 1: Documentation

Use retcon writing: document as if feature exists (present tense).

1. Parse documentation files from issue "Files to Change" section
2. Update each file with new functionality
3. Verify and commit: `just check-all`, then push

### Phase 2: Implementation

**Use `software-development` skill.**

For each chunk in "Implementation Guidance":
- Implement chunk following issue guidance
- Write tests for chunk
- Verify: `just check-all`
- Commit and push incrementally

### Phase 3: Test Review

**Use `software-quality` skill.**

1. Run `just check-all` with coverage
2. Must reach >= 96% coverage
3. Add edge case and integration tests as needed
4. Commit and push

### Phase 4: Final Verification

1. Run `just check-all`
2. **Self-healing**: If failing, use `software-debugging` skill with convergence tracking
   - Keep trying if: error count decreasing, different errors, clear path
   - Stop if: same error repeatedly, no new hypotheses, spinning
3. Run user acceptance tests from issue

### Phase 5: PR Creation

**Success Path** (quality checks pass):
- Create PR with verification report
- Comment on epic issue
- Output success with PR URL

**Blocked Path** (quality checks fail after attempts):
- Create draft PR with diagnostic report
- Comment on task issue
- Output blocked status with guidance

---

## Idempotent Guarantees

Re-running `/work <issue>` is safe:
- Checks branch/PR state and resumes appropriately
- Skips completed commits
- Interrupt anytime and restart

---

## Quality Checks

Before PR:
- [ ] Documentation updated
- [ ] All chunks implemented with tests
- [ ] Coverage >= 96%
- [ ] `just check-all` passing
- [ ] User acceptance tests verified

---

## Example

```bash
$ /work 124

Loading task #124...
✓ Metadata parsed: Epic #123, Branch: epic/jwt-auth/task-1

Phase 1: Documentation ✓
Phase 2: Implementation ✓ (2 chunks)
Phase 3: Test Review ✓ (98% coverage)
Phase 4: Final Verification ✓
Phase 5: PR Creation ✓

✅ Task #124 Complete!
PR: https://github.com/user/repo/pull/45
Coverage: 98%

Next: Review and merge PR #45
```
