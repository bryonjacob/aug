---
name: test-project-bootstrap
description: Clone project fresh and test setup from scratch to catch "works on my machine" issues
---

# Test Project Bootstrap

Clone the current project to a fresh location and attempt to set up a development environment from scratch, following only the documented instructions.

**Purpose**: Catch "works on my machine" issues by forcing a fresh build.

**Output**: Bootstrap test report in `/tmp/bootstrap-test/{project}-{timestamp}/`

---

## Workflow

### Phase 1: Prepare Fresh Clone

**Use TodoWrite to track progress through these steps:**

1. **Identify Project**
   ```bash
   PROJECT_NAME=$(basename $(git rev-parse --show-toplevel))
   CLONE_SOURCE=$(git remote get-url origin 2>/dev/null || git rev-parse --show-toplevel)
   CURRENT_REF=$(git rev-parse HEAD)
   ```

2. **Create Fresh Location**
   ```bash
   TIMESTAMP=$(date +%Y%m%d-%H%M%S)
   BOOTSTRAP_DIR="/tmp/bootstrap-test/${PROJECT_NAME}-${TIMESTAMP}"
   mkdir -p "$BOOTSTRAP_DIR"
   ```

3. **Clone Fresh Copy**
   ```bash
   git clone "$CLONE_SOURCE" "$BOOTSTRAP_DIR/repo"
   cd "$BOOTSTRAP_DIR/repo"
   git checkout "$CURRENT_REF"
   ```

4. **Initialize Test Report**
   Write `$BOOTSTRAP_DIR/report.md` with project info and status.

### Phase 2: Launch Bootstrap Agent

Use the **Task tool** to launch a subagent:

```
You are testing whether this project can be set up from scratch.

**Working directory**: {BOOTSTRAP_DIR}/repo

**Mission**:
1. Read README.md (or CLAUDE.md if no README) for setup instructions
2. Follow documented steps EXACTLY as written
3. Document every command and its output
4. Note errors, missing instructions, or assumptions
5. Attempt to run tests or verify setup works

**Rules**:
- Do NOT use your knowledge to fill gaps - only follow documentation
- If a step fails, document the error and try to continue
- Do NOT fix issues - only document them

**Output format** (append to ../report.md):

### Step N: {DESCRIPTION}
**Command**: `{command}`
**Result**: Success | Warning | Failed
**Output**: {actual output}
**Notes**: {observations}

When complete, add summary with issues found and suggestions.
```

### Phase 3: Collect Results

1. Wait for subagent completion
2. Read the report
3. Update report metadata with completion status

### Phase 4: Report to User

```
Bootstrap Test Complete

Project: {PROJECT_NAME}
Location: {BOOTSTRAP_DIR}/repo
Report: {BOOTSTRAP_DIR}/report.md

Summary:
| Category | Count |
|----------|-------|
| Passed Steps | {N} |
| Warnings | {N} |
| Failed Steps | {N} |

{IF ISSUES}
Issues Found:
1. {ISSUE_TITLE} - {IMPACT}

Recommendations:
- {ACTION_ITEMS}
{/IF}

Next Steps:
- Review full report
- Fix documentation gaps
- Re-run /test-project-bootstrap to verify
```

---

## Usage

```bash
/test-project-bootstrap
```

This will:
1. Clone your project to `/tmp/bootstrap-test/{name}-{timestamp}/`
2. Launch a subagent to follow your README
3. Document every step and error
4. Report what works and what doesn't

---

## Notes

- Fresh clone ensures no local state affects test
- Subagent follows docs literally to catch assumptions
- Report provides actionable improvements
- Run periodically to catch documentation drift
- Especially useful before sharing project or onboarding
