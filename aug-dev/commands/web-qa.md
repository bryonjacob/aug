---
name: web-qa
description: Interactive exploratory QA session for web applications using Playwright
argument-hint: <scope-description>
---

# Web QA - Exploratory Testing Session

Start an interactive QA exploration session for a web application feature or flow.

**Purpose**: Perform exploratory testing using Playwright to find bugs, UX issues, and edge cases. Creates QA artifacts in `/tmp/webqa/{session-id}/` that feed directly into planning workflows.

**Next Commands**: After completing QA, run `/plan-chat` to design fixes or `/plan-breakdown` to create tasks directly from findings.

---

## Workflow

**Use the `web-qa-exploration` skill to guide this interactive session.**

### Phase 1: Session Setup

**Use TodoWrite to track progress through these steps:**

1. **Parse Scope**
   - Understand what the user wants to QA
   - Clarify target URL/environment if not obvious
   - Identify if specific flow or open exploration

2. **Create Session**
   - Generate session-id slug from scope (e.g., "checkout-flow-qa", "new-auth-feature")
   - Create directory: `/tmp/webqa/{session-id}/`
   - Write initial `session.md`:
     ```markdown
     # QA Session: {SCOPE}

     **Created**: {TIMESTAMP}
     **Target**: {BASE_URL}
     **Status**: in-progress

     ## Scope
     {WHAT_WE_RE_TESTING}

     ## Waypoints
     {PLANNED_OR_TBD}
     ```
   - Write initial `metadata.json`:
     ```json
     {
       "session_id": "{session-id}",
       "scope": "{SCOPE}",
       "status": "in-progress",
       "created": "{TIMESTAMP}",
       "target_url": "{BASE_URL}"
     }
     ```

3. **Launch Browser**
   - Start Playwright browser (headed mode for visibility)
   - Configure viewport (1280x720 default)
   - Enable video recording if available
   - Navigate to starting point

### Phase 2: Flow Discovery

**If user provides specific flow:**
- Parse waypoints from description
- Confirm understanding with user

**If open-ended exploration:**
1. Navigate to base URL
2. Identify key user journeys visible
3. Propose waypoints:
   ```
   Proposed QA Waypoints:

   1. {PAGE/STATE} - Focus: {WHAT_TO_CHECK}
   2. {PAGE/STATE} - Focus: {WHAT_TO_CHECK}
   3. {PAGE/STATE} - Focus: {WHAT_TO_CHECK}

   Approve this flow or suggest changes?
   ```
4. Get user approval before deep dive

### Phase 3: Waypoint Exploration

**For each waypoint, follow the `web-qa-exploration` skill analysis checklist:**

1. **Navigate** to waypoint
2. **Wait** for page fully loaded
3. **Capture** screenshot to `screenshots/waypoint-{n}.png`
4. **Analyze** using the checklist:
   - Visual & Layout
   - Navigation & State (back button, refresh, deep link)
   - Forms & Inputs (if present)
   - Interactions
   - Accessibility (basic)
   - Error handling

5. **Test edge cases**:
   - Try to break it
   - Unexpected inputs
   - Rapid interactions
   - Browser controls (back, refresh)

6. **Document issues** as found:
   - Screenshot evidence
   - Severity assessment
   - Steps to reproduce
   - Suggested Playwright test

7. **Report progress**:
   ```
   Waypoint 2/5: Checkout Form
   ✅ Visual check: OK
   ✅ Navigation: OK
   ⚠️ Form validation: Found issue (MEDIUM-001)
   ✅ Accessibility: OK

   Issues found: 1
   Proceeding to Waypoint 3...
   ```

### Phase 4: Report Generation

1. **Compile findings** into `report.md`:
   - Summary table (severity counts)
   - Each issue with full documentation
   - Waypoint summary table
   - Next steps recommendations

2. **Generate `report.json`** for automation:
   ```json
   {
     "meta": { ... },
     "summary": { "critical": 0, "high": 1, ... },
     "issues": [ ... ],
     "waypoints": [ ... ]
   }
   ```

3. **Update `metadata.json`** with final status

4. **Close browser** and save any video recordings

### Phase 5: Report Completion

Output:
```
✅ QA Session Complete

Scope: {SCOPE}
Session: /tmp/webqa/{session-id}/

Summary:
| Severity | Count |
|----------|-------|
| Critical | 0     |
| High     | 1     |
| Medium   | 3     |
| Low      | 2     |

Full Report: /tmp/webqa/{session-id}/report.md

Next Steps:
- Review report.md for detailed findings
- `/plan-chat "Fix {high-priority-issue}"` - Design solution for critical/high issues
- `/plan-breakdown` - Create tasks directly from QA findings (reads /tmp/webqa/)
```

---

## Skills to Use

- `web-qa-exploration` - **Required.** Invoke this skill for analysis methodology and report formats.

---

## Quality Checks

Before marking session complete:
- [ ] All waypoints visited or documented as blocked
- [ ] Each issue has severity, category, description
- [ ] Screenshots captured for visual issues
- [ ] Steps to reproduce provided
- [ ] Suggested Playwright tests included
- [ ] Summary statistics accurate
- [ ] Next steps recommendations provided
- [ ] All artifacts written to /tmp/webqa/{session-id}/

---

## Integration with Planning

**QA → Plan-Chat:**
```bash
/web-qa "Test new checkout flow"
# ... QA session finds critical auth bug ...
/plan-chat "Fix authentication redirect issue found in QA"
# Claude reads /tmp/webqa/ for context
```

**QA → Plan-Breakdown (direct to tasks):**
```bash
/web-qa "Test new checkout flow"
# ... QA session finds medium/low issues ...
/plan-breakdown
# Claude offers to create tasks from QA findings
```

The session artifacts (`session.md`, `report.md`, `report.json`) provide context for planning commands, enabling seamless flow from QA findings to implementation tasks.

---

## Example Usage

```bash
/web-qa "QA the new user registration flow"
```

This starts an interactive session where Claude will:
1. Clarify the target URL and scope
2. Propose waypoints (landing → form → validation → confirmation)
3. Navigate through each with Playwright
4. Test edge cases at each step
5. Document issues with screenshots and suggested tests
6. Generate a comprehensive report
7. Recommend next steps (/plan-chat or /plan-breakdown)

```bash
/web-qa "Test checkout - focus on payment validation"
```

More focused session targeting specific functionality.
