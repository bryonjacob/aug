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

---

## Key Principles

- **Idempotent**: Safe to re-run if interrupted
- **Incremental**: Commits and pushes after each chunk
- **Self-healing**: Auto-fixes format/lint/type errors (max 3 attempts)
- **Quality-gated**: Must pass `just check-all` before PR
- **Autonomous**: No user interaction

---

## Workflow

Use TodoWrite to track progress.

### Phase 0: Load & Verify

**Ensures resumption after interruption.**

1. **Fetch Issue**
   ```bash
   gh issue view {ISSUE_NUMBER} --json body
   ```

2. **Parse Metadata**
   Extract from issue body:
   ```bash
   EPIC_ID=$(grep "^EPIC_ID:" | cut -d: -f2 | xargs)
   TASK_ID=$(grep "^TASK_ID:" | cut -d: -f2 | xargs)
   BRANCH_NAME=$(grep "^BRANCH_NAME:" | cut -d: -f2 | xargs)
   DEPENDS_ON=$(grep "^DEPENDS_ON:" | cut -d: -f2 | xargs)
   EPIC_ISSUE=$(grep "^EPIC_ISSUE:" | cut -d: -f2 | xargs)
   ```

3. **Verify Dependencies**
   If DEPENDS_ON != "none":
   - Check each dependency issue closed
   - If open: error and exit
   ```
   ❌ Cannot start - dependencies incomplete:
      - #123 still open

   Complete dependencies first, then run:
      /work {ISSUE_NUMBER}
   ```

4. **Check Branch State**
   ```bash
   if git rev-parse --verify "$BRANCH_NAME" 2>/dev/null; then
     # Branch exists - resume
     git checkout "$BRANCH_NAME"

     PR_NUMBER=$(gh pr list --head "$BRANCH_NAME" --json number -q '.[0].number')

     if [ -n "$PR_NUMBER" ]; then
       PR_STATE=$(gh pr view "$PR_NUMBER" --json state -q '.state')

       if [ "$PR_STATE" = "MERGED" ]; then
         echo "✅ Task complete (PR #$PR_NUMBER merged)"
         exit 0
       elif [ "$PR_STATE" = "OPEN" ]; then
         echo "⚠️  PR #$PR_NUMBER exists"
         echo "Resuming..."
       fi
     fi
   else
     # Create branch from main
     git checkout main
     git pull origin main
     git checkout -b "$BRANCH_NAME"
   fi
   ```

### Phase 1: Documentation

**Use retcon writing: document as if feature exists (present tense).**

1. **Parse Documentation Files from Issue**
   Extract paths from "Files to Change" → "Documentation".

2. **Update Each File**
   - Read current content
   - Update with new functionality
   - Use present tense (retcon style)
   - Verify DRY - no duplication

3. **Verify and Commit**
   ```bash
   just check-all
   git add <doc-files>
   git commit -m "docs: Update documentation for #${ISSUE_NUMBER}"
   git push origin "$BRANCH_NAME"
   ```

### Phase 2: Implementation with Chunk Testing

**Use `software-development` skill.**

For each chunk in "Implementation Guidance" → "Phase 2: Implementation Chunks":

#### A. Implement Chunk

- Read implementation guidance from issue
- Read code examples from issue
- Follow architecture context
- Implement changes
- Keep maximally simple

#### B. Write Tests for Chunk

- Add unit tests per issue guidance
- Test specific functionality in chunk
- Follow testing strategy from issue

#### C. Verify Chunk Quality

```bash
just check-all
```

**If failures:**
- Parse error messages
- Apply common fixes
- Retry up to 3 times
- If still failing → Use `software-debugging` skill

#### D. Commit Chunk

```bash
git add .
git commit -m "feat: Implement {CHUNK_NAME} for #${ISSUE_NUMBER}"
```

#### E. Push Incrementally

```bash
git push origin "$BRANCH_NAME"
```

*Incremental pushes make work recoverable.*

### Phase 3: Test Review

**Use `software-quality` skill.**

After all chunks:

1. **Run Quality Check with Coverage**
   ```bash
   just check-all
   ```

2. **Check Coverage Threshold**
   - Must be >= 96%
   - If below:
     - Use `software-quality` skill to identify gaps
     - Add tests for uncovered code
     - Re-run `just check-all`

3. **Enhance Test Suite**
   - Edge cases from issue testing strategy
   - Error handling scenarios
   - Integration tests if specified

4. **Commit Test Enhancements**
   ```bash
   git add .
   git commit -m "test: Enhance coverage for #${ISSUE_NUMBER}"
   git push origin "$BRANCH_NAME"
   ```

### Phase 4: Final Verification

1. **Run Full Quality Gate**
   ```bash
   just check-all
   ```

2. **Self-Healing (max 3 attempts)**

   If `just check-all` fails:

   **Attempt 1:**
   ```bash
   just check-all
   ```

   **Attempt 2:**
   Use `software-debugging` skill:
   - Parse error messages
   - Identify root cause
   - Apply fix
   - Re-run `just check-all`

   **Attempt 3:**
   - Review errors systematically
   - Fix remaining issues
   - Re-run `just check-all`

   **If still failing:**
   → Go to Phase 6 (Blocked Path)

3. **Run User Acceptance Tests**

   Extract and run commands from "User Verification" section.
   ```bash
   {COMMAND_FROM_ISSUE}  # Verify: {EXPECTED_OUTPUT}
   ```

### Phase 5: PR Creation (Success Path)

**When `just check-all` passes:**

1. **Generate Verification Report**
   ```markdown
   ## Implementation Summary

   Implements: #{ISSUE_NUMBER}
   Epic: #{EPIC_ISSUE}
   Branch: {BRANCH_NAME}

   ## Changes
   - {LIST_OF_CHANGES}

   ## Quality Verification

   ✅ `just check-all` passing
   ✅ Coverage: {PERCENTAGE}%
   ✅ All acceptance criteria met

   ## Commits
   - {COMMIT_1_HASH}: {MESSAGE}
   - {COMMIT_2_HASH}: {MESSAGE}

   ## User Acceptance
   {VERIFICATION_COMMANDS_RAN_SUCCESSFULLY}

   ## Next Steps
   - Review and merge
   - Close #{ISSUE_NUMBER}
   - Update epic #{EPIC_ISSUE} checklist
   ```

2. **Create Pull Request**
   ```bash
   gh pr create \
     --base main \
     --head "$BRANCH_NAME" \
     --title "$(gh issue view $ISSUE_NUMBER --json title -q '.title')" \
     --body "$(cat <<EOF
   Closes #${ISSUE_NUMBER}

   ${VERIFICATION_REPORT}
   EOF
   )"
   ```

3. **Comment on Epic**
   ```bash
   gh issue comment "$EPIC_ISSUE" \
     --body "✅ Task #${ISSUE_NUMBER} complete - PR #${PR_NUMBER}"
   ```

4. **Output Success**
   ```
   ✅ Task #${ISSUE_NUMBER} Complete!

   PR: {PR_URL}

   Commits: {COUNT}
   - {COMMIT_SUMMARY_1}
   - {COMMIT_SUMMARY_2}

   Quality: ✅ just check-all passing
   Coverage: {PERCENTAGE}%

   Epic Progress:
     Epic #{EPIC_ISSUE}: {X} of {Y} tasks complete

   Next: Review and merge PR #{PR_NUMBER}
   ```

### Phase 6: PR Creation (Blocked Path)

**When quality checks fail after 3 attempts:**

1. **Generate Diagnostic Report**
   ```markdown
   ## ⚠️ Task Blocked

   Task: #{ISSUE_NUMBER}
   Branch: {BRANCH_NAME}
   Status: Quality checks failing

   ## Failing Checks

   {ERROR_OUTPUT_FROM_JUST_CHECK_ALL}

   ## Attempts Made

   1. Auto-fix with `just format && just lint`
   2. Debugging analysis: {FINDINGS}
   3. Manual fixes attempted: {WHAT_WAS_TRIED}

   ## Current State

   - Implementation: Complete
   - Tests: {STATUS}
   - Coverage: {PERCENTAGE}%
   - Failures: {SPECIFIC_ERRORS}

   ## Suggestions

   {SPECIFIC_RECOMMENDATIONS_FOR_FIXING}

   ## Next Steps

   1. Review diagnostics
   2. Fix issues manually or update task spec
   3. Re-run (idempotent): `/work ${ISSUE_NUMBER}`
   ```

2. **Create Draft PR**
   ```bash
   gh pr create \
     --base main \
     --head "$BRANCH_NAME" \
     --draft \
     --title "[BLOCKED] $(gh issue view $ISSUE_NUMBER --json title -q '.title')" \
     --body "$(cat <<EOF
   ⚠️  Blocked on quality checks

   Related: #${ISSUE_NUMBER}

   ${DIAGNOSTIC_REPORT}
   EOF
   )"
   ```

3. **Comment on Task Issue**
   ```bash
   gh issue comment "$ISSUE_NUMBER" \
     --body "$(cat <<EOF
   ⚠️  Task blocked on quality checks

   Draft PR: #${PR_NUMBER}
   See diagnostics in PR.

   After fixing, re-run (idempotent):
   \`\`\`bash
   /work ${ISSUE_NUMBER}
   \`\`\`
   EOF
   )"
   ```

4. **Output Blocked Status**
   ```
   ⚠️  Task #${ISSUE_NUMBER} Blocked

   Draft PR: {PR_URL}

   Quality checks failing after 3 attempts.
   See diagnostics in PR.

   After fixing, re-run (idempotent):
     /work ${ISSUE_NUMBER}
   ```

---

## Idempotent Guarantees

**Re-running `/work <issue>` is safe:**

- Checks if branch exists → resumes if yes, creates if no
- Checks if PR exists → reports if merged, resumes if open
- Checks if work complete → exits cleanly
- Skips completed commits (checks git log)
- Resumes from current chunk

**Interrupt anytime and restart.**

---

## Skills Used

- **`software-development`** - Phase 2 implementation
- **`software-debugging`** - Self-healing
- **`software-quality`** - Phase 3 test coverage

---

## Quality Checks

Before PR:
- [ ] All documentation updated
- [ ] All chunks implemented
- [ ] All chunk tests passing
- [ ] Coverage >= 96%
- [ ] `just check-all` passing
- [ ] User acceptance tests verified
- [ ] All commits pushed
- [ ] Branch up to date with main

---

## Error Scenarios

**Dependency not closed:**
```
❌ Cannot start - dependencies incomplete:
   - #123: Setup infrastructure (still open)

Complete #123 first, then run:
   /work {ISSUE_NUMBER}
```

**Branch merged:**
```
✅ Task #124 complete
   PR #45 merged on 2025-01-15
```

**Quality checks failing:**
```
⚠️  Task #124 blocked on quality checks
   Draft PR: #46

   See diagnostics and fix, then re-run:
   /work 124
```

---

## Example Execution

```bash
$ /work 124

Loading task #124...
✓ Issue fetched
✓ Metadata parsed:
  - Epic: #123 (JWT Authentication)
  - Branch: epic/jwt-auth/task-1
  - Dependencies: none

Checking branch state...
✓ Branch created from main

Phase 1: Documentation
✓ Updated README.md
✓ Updated docs/authentication.md
✓ Committed and pushed

Phase 2: Implementation
  Chunk 1: Add JWT dependencies
  ✓ Updated pyproject.toml
  ✓ Tests added
  ✓ Quality checks passing
  ✓ Committed and pushed

  Chunk 2: Implement token generation
  ✓ Added token.py
  ✓ Tests added
  ✓ Quality checks passing
  ✓ Committed and pushed

Phase 3: Test Review
✓ Coverage: 98%
✓ Enhanced edge case tests
✓ Committed and pushed

Phase 4: Final Verification
✓ just check-all passing
✓ User acceptance tests passing

Phase 5: PR Creation
✓ PR created: #45
✓ Epic #123 updated

✅ Task #124 Complete!

PR: https://github.com/user/repo/pull/45

Commits: 4
- docs: Update documentation for #124
- feat: Add JWT dependencies for #124
- feat: Implement token generation for #124
- test: Enhance coverage for #124

Quality: ✅ just check-all passing
Coverage: 98%

Epic Progress:
  Epic #123: 1 of 5 tasks complete

Next: Review and merge PR #45
```
