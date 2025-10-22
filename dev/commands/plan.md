# plan

## Task
$ARGUMENTS

## Purpose
Break down work into concrete, actionable GitHub issues with proper hierarchy and tracking.

## Issue Storage

**Preferred: GitHub Issues**
If git remote origin is configured and points to GitHub, create issues via gh CLI.

**Fallback: Local Issues**
If no GitHub remote configured, create local issues in `ISSUES.LOCAL/` directory:
- Format: `LOCAL001-MeaningfulNameInCamelCase.md`
- Numbers are zero-padded (001, 002, etc.) for proper sorting
- Still follow same issue template structure
- Track status in issue file frontmatter

Check for GitHub remote:
```bash
git remote get-url origin 2>/dev/null | grep -q github.com && echo "use GitHub" || echo "use local"
```

## Issue Content Guidelines

### Issue Title Format
Follow conventional commit style prefixes:
- `feat:` - New feature implementation
- `fix:` - Bug fix
- `docs:` - Documentation only changes
- `test:` - Testing additions or changes
- `refactor:` - Code refactoring without functionality change
- `chore:` - Maintenance tasks, dependency updates
- `perf:` - Performance improvements
- `style:` - Code style/formatting changes

### Issue Body Template
Each issue should include:
1. **Summary** - Clear, concise description of what needs to be done
2. **Acceptance Criteria** - Checklist of requirements that must be met
3. **Technical Notes** - Any implementation guidance or constraints
4. **Dependencies** - Links to related issues or requirements

Example:
```markdown
## Summary
Set up Docker environment for local development with all required services.

## Acceptance Criteria
- [ ] Docker Compose file with PostgreSQL, Redis, and application services
- [ ] Makefile with common commands (start, stop, logs, shell)
- [ ] Health checks for all services
- [ ] README updated with setup instructions
- [ ] .env.example file with all required variables

## Technical Notes
- Use PostgreSQL 15 and Redis 7
- Include database initialization scripts
- Ensure volumes persist data between restarts

## Dependencies
Part of #1 (Initial project setup)
```

## Detailed Instructions

### 1. Get Repository ID
```bash
REPO_ID=$(gh repo view --json id -q .id)
echo "Repository ID: $REPO_ID"
```

### 2. Create Parent Issue (if hierarchical issues requested)
**IMPORTANT: If creating parent-child issues, create the parent FIRST and save its ID**

Parent issues should represent complete features or epics, with child issues as implementation steps.

```bash
PARENT_ISSUE=$(gh api graphql --jq '.data.createIssue.issue' -f query="$(cat <<EOF
mutation {
  createIssue(input: {
    repositoryId: "$REPO_ID"
    title: "[PARENT_ISSUE_TITLE]"
    body: "[PARENT_ISSUE_DESCRIPTION]"
  }) {
    issue {
      id
      number
      url
    }
  }
}
EOF
)")

PARENT_ID=$(echo "$PARENT_ISSUE" | jq -r '.id')
PARENT_NUMBER=$(echo "$PARENT_ISSUE" | jq -r '.number')
echo "Created parent issue #$PARENT_NUMBER with ID: $PARENT_ID"
```

### 3. Create Child Issues with Parent Link (MOST EFFICIENT METHOD)
**CRITICAL: Use the `parentIssueId` field in the mutation to establish parent-child relationship immediately**

This is the recommended approach - creates the child issue with parent relationship in a single mutation:

```bash
# For EACH child issue, use the parent ID obtained above
CHILD_ISSUE=$(gh api graphql --jq '.data.createIssue.issue' -f query="$(cat <<EOF
mutation {
  createIssue(input: {
    repositoryId: "$REPO_ID"
    title: "[CHILD_TITLE]"
    body: "[CHILD_DESCRIPTION]"
    parentIssueId: "$PARENT_ID"
  }) {
    issue {
      id
      number
      url
    }
  }
}
EOF
)")

CHILD_ID=$(echo "$CHILD_ISSUE" | jq -r '.id')
CHILD_NUMBER=$(echo "$CHILD_ISSUE" | jq -r '.number')
echo "Created child issue #$CHILD_NUMBER with parent link to #$PARENT_NUMBER"
```

### 4. Alternative: Link Existing Issues (Only if needed)
If you have existing issues that need to be linked:

```bash
# Get the node IDs for both issues
PARENT_ID=$(gh issue view 24 --json id -q .id)
CHILD_ID=$(gh issue view 26 --json id -q .id)

# Create the sub-issue relationship
gh api graphql --jq '.data' -f query="$(cat <<EOF
mutation {
  addSubIssue(input: { 
    issueId: "$PARENT_ID"
    subIssueId: "$CHILD_ID"
  }) {
    issue {
      title
      number
    }
    subIssue {
      title
      number
    }
  }
}
EOF
)"
```

### 5. Add All Issues to Project (if project specified)
**Note:** The `projectIds` field in `createIssue` does NOT work with ProjectV2. You must add issues as a separate step.

```bash
# If working with a project created earlier, use the PROJECT_ID directly
# Otherwise, get project ID by name:
PROJECT_ID=$(gh project list --owner @me --format json | jq -r '.projects[] | select(.title == "[PROJECT_NAME]") | .id')

# Add ALL issues (parent and children) to project in one mutation
gh api graphql --jq '.data' -f query="$(cat <<EOF
mutation {
  parent: addProjectV2ItemById(input: {
    projectId: "$PROJECT_ID"
    contentId: "$PARENT_ID"
  }) {
    item { id }
  }
  child1: addProjectV2ItemById(input: {
    projectId: "$PROJECT_ID"
    contentId: "$CHILD1_ID"
  }) {
    item { id }
  }
  child2: addProjectV2ItemById(input: {
    projectId: "$PROJECT_ID"
    contentId: "$CHILD2_ID"
  }) {
    item { id }
  }
}
EOF
)"
```

### 6. Managing Sub-Issues

**View sub-issues of a parent:**
```bash
gh api repos/[owner]/[repo]/issues/[parent_number]/sub_issues
```

**Remove a sub-issue relationship:**
```bash
gh api --method DELETE repos/[owner]/[repo]/issues/[parent_number]/sub_issues/[child_number]
```

## Local Issue Template

If using local issues, create in `ISSUES.LOCAL/LOCAL###-Title.md`:

```markdown
---
number: LOCAL001
status: open
created: 2025-09-30
---

# feat: Title of the issue

## Summary
Description of what needs to be done

## Acceptance Criteria
- [ ] Requirement 1
- [ ] Requirement 2

## Technical Notes
Implementation guidance

## Dependencies
Links to related issues (e.g., "Part of LOCAL002")
```

Find next number:
```bash
mkdir -p ISSUES.LOCAL
NEXT=$(ls ISSUES.LOCAL/LOCAL*.md 2>/dev/null | sed 's/.*LOCAL0*\([0-9]*\)-.*/\1/' | sort -n | tail -1)
NEXT=$((NEXT + 1))
printf "LOCAL%03d" $NEXT
```

## Execution Strategy

After creating all issues, provide the recommended execution order.

Issues should be executed **sequentially** in dependency order.

### Output Format

After creating all issues, output:

```
## Recommended Execution Order

Issues to execute in order:

1. Issue #99 - [Title]
2. Issue #100 - [Title]
3. Issue #101 - [Title]

To execute this plan:
/work 99 100 101

Or execute them one at a time:
/work 99
/work 100
/work 101
```

### Example Output

```
## Recommended Execution Order

Based on dependencies:

1. Issue #99 - Database schema setup (foundation)
2. Issue #100 - User API endpoint (requires database)
3. Issue #101 - Auth API endpoint (requires database)
4. Issue #102 - Integration tests (requires all endpoints)

To execute:
/work 99 100 101 102

Each issue will be completed fully before moving to the next.
```

## Execution Notes
- Check for GitHub remote first - prefer GitHub issues when available
- For GitHub: create parent first, then children with `parentIssueId`
- For local: use `ISSUES.LOCAL/LOCAL###-Title.md` format
- Follow same issue template structure regardless of storage
- Use conventional commit prefixes in titles for better organization
- Same SDLC rigor whether using GitHub or local issues
- **Always output recommended execution order** after creating issues

## Example Flow
1. Create parent issue → Save its ID
2. Create each child issue WITH `parentIssueId: "parent_id_here"`
3. Add all issues to project if needed

## Best Practices for Issues
1. **Keep issues atomic** - One clear deliverable per issue
2. **Write clear acceptance criteria** - Checkboxes that define "done"
3. **Reference related issues** - Use "Part of #X" or "Refs #Y"
4. **Include technical context** - Framework versions, constraints, etc.
5. **Prioritize readability** - Future you will thank present you
6. **Follow YAGNI principle** - Don't add requirements not requested
7. **Test commands in issues** - If suggesting commands, verify they work

## Common Mistakes to Avoid
❌ DO NOT create child issues without the `parentIssueId` field and expect to link them later
✅ DO include `parentIssueId` in the initial creation mutation for each child issue

❌ DO NOT create vague issues like "Fix bugs" or "Improve performance"
✅ DO create specific, actionable issues with clear acceptance criteria

❌ DO NOT forget to include dependencies and technical notes
✅ DO provide context that helps implementers understand the full picture

## Working Example with Real Values

Here's a complete example that creates a parent issue with two child issues:

```bash
# 1. Get repository ID
REPO_ID=$(gh repo view --json id -q .id)

# 2. Create parent issue
PARENT_ISSUE=$(gh api graphql --jq '.data.createIssue.issue' -f query="$(cat <<EOF
mutation {
  createIssue(input: {
    repositoryId: "$REPO_ID"
    title: "feat: Add user authentication system"
    body: "## Summary\nImplement complete user authentication with login, registration, and password reset.\n\n## Acceptance Criteria\n- [ ] User registration with email validation\n- [ ] Login with JWT tokens\n- [ ] Password reset functionality\n- [ ] All endpoints tested"
  }) {
    issue {
      id
      number
      url
    }
  }
}
EOF
)")

PARENT_ID=$(echo "$PARENT_ISSUE" | jq -r '.id')
PARENT_NUMBER=$(echo "$PARENT_ISSUE" | jq -r '.number')

# 3. Create first child issue
CHILD1=$(gh api graphql --jq '.data.createIssue.issue' -f query="$(cat <<EOF
mutation {
  createIssue(input: {
    repositoryId: "$REPO_ID"
    title: "feat: Implement user registration endpoint"
    body: "## Summary\nCreate POST /api/auth/register endpoint\n\n## Acceptance Criteria\n- [ ] Email validation\n- [ ] Password hashing\n- [ ] Return JWT token\n- [ ] Tests pass"
    parentIssueId: "$PARENT_ID"
  }) {
    issue {
      id
      number
      url
    }
  }
}
EOF
)")

CHILD1_ID=$(echo "$CHILD1" | jq -r '.id')

# 4. Create second child issue
CHILD2=$(gh api graphql --jq '.data.createIssue.issue' -f query="$(cat <<EOF
mutation {
  createIssue(input: {
    repositoryId: "$REPO_ID"
    title: "feat: Implement login endpoint"
    body: "## Summary\nCreate POST /api/auth/login endpoint\n\n## Acceptance Criteria\n- [ ] Validate credentials\n- [ ] Return JWT token\n- [ ] Handle errors properly\n- [ ] Tests pass"
    parentIssueId: "$PARENT_ID"
  }) {
    issue {
      id
      number
      url
    }
  }
}
EOF
)")

CHILD2_ID=$(echo "$CHILD2" | jq -r '.id')

# 5. Add to project (if needed)
PROJECT_ID=$(gh project list --owner @me --format json | jq -r '.projects[] | select(.title == "My Project") | .id')

gh api graphql --jq '.data' -f query="$(cat <<EOF
mutation {
  parent: addProjectV2ItemById(input: {
    projectId: "$PROJECT_ID"
    contentId: "$PARENT_ID"
  }) {
    item { id }
  }
  child1: addProjectV2ItemById(input: {
    projectId: "$PROJECT_ID"
    contentId: "$CHILD1_ID"
  }) {
    item { id }
  }
  child2: addProjectV2ItemById(input: {
    projectId: "$PROJECT_ID"
    contentId: "$CHILD2_ID"
  }) {
    item { id }
  }
}
EOF
)"

echo "✅ Created parent issue #$PARENT_NUMBER with child issues"
```