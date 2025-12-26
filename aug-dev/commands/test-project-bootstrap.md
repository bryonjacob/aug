---
name: test-project-bootstrap
description: Clone project fresh and test setup from scratch to catch "works on my machine" issues
---

# Test Project Bootstrap

Clone the current project to a fresh location and attempt to set up a development environment from scratch, following only the documented instructions.

**Purpose**: Catch "works on my machine" issues by forcing a fresh build. Identifies missing documentation, undocumented dependencies, and environmental assumptions.

**Output**: Bootstrap test report in `/tmp/bootstrap-test/{project}-{timestamp}/`

---

## Workflow

### Phase 1: Prepare Fresh Clone

**Use TodoWrite to track progress through these steps:**

1. **Identify Project**
   ```bash
   # Get project name
   PROJECT_NAME=$(basename $(git rev-parse --show-toplevel))

   # Get remote URL (prefer origin, fallback to upstream, then local)
   CLONE_SOURCE=$(git remote get-url origin 2>/dev/null || \
                  git remote get-url upstream 2>/dev/null || \
                  git rev-parse --show-toplevel)

   # Get current branch/ref
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
   # If remote URL
   git clone "$CLONE_SOURCE" "$BOOTSTRAP_DIR/repo"

   # If local fallback, use git clone with --local
   git clone --local "$(git rev-parse --show-toplevel)" "$BOOTSTRAP_DIR/repo"

   # Checkout same ref we're testing
   cd "$BOOTSTRAP_DIR/repo"
   git checkout "$CURRENT_REF"
   ```

4. **Initialize Test Report**
   Write `$BOOTSTRAP_DIR/report.md`:
   ```markdown
   # Bootstrap Test Report

   **Project**: {PROJECT_NAME}
   **Source**: {CLONE_SOURCE}
   **Ref**: {CURRENT_REF}
   **Started**: {TIMESTAMP}
   **Status**: in-progress

   ## Environment
   - OS: {uname -a}
   - Shell: {$SHELL}
   - Working Dir: {BOOTSTRAP_DIR}/repo

   ## Setup Attempt Log

   <!-- Subagent will append here -->
   ```

### Phase 2: Launch Bootstrap Agent

Use the **Task tool** to launch a subagent with these instructions:

```
You are testing whether this project can be set up from scratch by a new developer.

**Working directory**: {BOOTSTRAP_DIR}/repo

**Your mission**:
1. Read README.md (or CLAUDE.md if no README) to find setup instructions
2. Follow the documented setup steps EXACTLY as written
3. Document every command you run and its output
4. Note any errors, missing instructions, or assumptions
5. Attempt to run the test suite or verify the setup works

**Rules**:
- Do NOT use your knowledge to fill gaps - only follow what's documented
- If a step fails, document the error and try to continue
- If instructions are ambiguous, note the ambiguity
- Do NOT fix issues - only document them

**Output format** (append to ../report.md):

### Step N: {DESCRIPTION}

**Command**: `{command}`

**Result**: ✅ Success | ⚠️ Warning | ❌ Failed

**Output**:
```
{actual output}
```

**Notes**: {any observations}

---

When complete, add a summary section:

## Summary

**Setup Result**: ✅ Success | ⚠️ Partial | ❌ Failed

**Issues Found**: {count}

### Issues

1. **{ISSUE_TITLE}**
   - Step: {which step}
   - Error: {what happened}
   - Impact: {blocking | degraded | cosmetic}
   - Suggestion: {what docs might need}

### Missing Documentation

- {list any undocumented steps you had to figure out}

### Assumptions Detected

- {list any environmental assumptions the docs make}
```

### Phase 3: Collect Results

1. **Wait for subagent completion**

2. **Read the report**
   ```bash
   Read "$BOOTSTRAP_DIR/report.md"
   ```

3. **Update report metadata**
   - Set status to complete
   - Add completion timestamp
   - Add final summary

### Phase 4: Report to User

Output summary:
```
✅ Bootstrap Test Complete

Project: {PROJECT_NAME}
Location: {BOOTSTRAP_DIR}/repo
Report: {BOOTSTRAP_DIR}/report.md

Summary:
| Category | Count |
|----------|-------|
| ✅ Passed Steps | {N} |
| ⚠️ Warnings | {N} |
| ❌ Failed Steps | {N} |

{IF ISSUES}
Issues Found:
1. {ISSUE_TITLE} - {IMPACT}
2. {ISSUE_TITLE} - {IMPACT}

Recommendations:
- {ACTION_ITEMS}
{/IF}

Next Steps:
- Review full report: {BOOTSTRAP_DIR}/report.md
- Fix documentation gaps
- Re-run /test-project-bootstrap to verify
```

---

## What This Tests

### Documentation Completeness
- Are all setup steps documented?
- Are prerequisites listed?
- Are commands copy-pasteable?

### Environmental Assumptions
- Does setup assume certain tools are installed?
- Does it assume specific OS or shell?
- Are there undocumented environment variables?

### Dependency Management
- Do lockfiles work correctly?
- Are all dependencies declared?
- Do install commands succeed?

### Build/Test Pipeline
- Does `just check-all` (or equivalent) pass?
- Are there flaky tests?
- Do tests require external services?

---

## Example Usage

```bash
/test-project-bootstrap
```

This will:
1. Clone your project to `/tmp/bootstrap-test/{name}-{timestamp}/`
2. Launch a subagent to follow your README
3. Document every step and error
4. Report what works and what doesn't

---

## Common Issues Detected

**Missing Prerequisites**
```
❌ Step 3: Install dependencies
Command: uv sync
Error: command not found: uv
Impact: blocking
Suggestion: Add "Prerequisites: Install uv" to README
```

**Undocumented Steps**
```
⚠️ Warning: README says "run tests" but doesn't specify command
Assumption: User knows to run `just test`
Suggestion: Add explicit command to README
```

**Environment Assumptions**
```
⚠️ Warning: Setup assumes Node 20+
Detected: Node 18.x installed
Impact: Tests fail with syntax error
Suggestion: Document minimum Node version
```

---

## Notes

- Fresh clone ensures no local state affects test
- Subagent follows docs literally to catch assumptions
- Report provides actionable improvements
- Run periodically to catch documentation drift
- Especially useful before sharing project or onboarding
