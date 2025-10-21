---
name: self-reviewing-code
description: Use when PR is complete and ready for review - provides fresh-eyes review checklist to catch problems before marking ready, including when to invoke code-review subagent
---

# Self-Reviewing Code

## Overview

Before marking PR ready, review with beginner-mind. Fresh perspective catches assumptions, missing edge cases, and unclear code that made sense in the moment.

**Core insight:** You're too close to the code. Step back and review as if seeing it for the first time.

## Self-Review Checklist

**Before marking PR ready:**

- [ ] Re-read original issue - are ALL criteria met?
- [ ] Review the diff - is code clear and maintainable?
- [ ] Check test coverage - are edge cases covered?
- [ ] Verify documentation updated
- [ ] Run `just check-all` one final time
- [ ] Check CI status: `gh pr checks`

## When to Invoke Code Review Subagent

**Consider using fresh subagent when:**
- Change is complex (>200 lines, multiple files)
- Touches critical paths (auth, payments, data integrity)
- Refactoring without clear tests
- You're unsure about approach
- Making architectural changes
- Want extra confidence before review

**How fresh review helps:**

A subagent with no prior context catches:
- Assumptions that aren't obvious
- Missing edge cases you didn't consider
- Code that made sense to you but is unclear
- Documentation gaps
- Subtle bugs from too much familiarity

**Invoke pattern:**
```bash
# Create review request describing:
# - What the code does
# - What to look for
# - Specific concerns

# Subagent sees only:
# - Issue description
# - The diff
# - Test files
```

## Review Questions

**Clarity:**
- Would this make sense to someone unfamiliar with the code?
- Are variable/function names descriptive?
- Is complex logic commented with "why"?

**Correctness:**
- Do tests cover edge cases?
- Are error conditions handled?
- Could this fail in production scenarios?

**Maintainability:**
- Is code DRY (Don't Repeat Yourself)?
- Are functions focused on single responsibility?
- Would future changes be easy?

**Performance:**
- Any obvious performance issues?
- Database queries efficient?
- Unnecessary loops or allocations?

**Security:**
- Are inputs validated?
- Sensitive data handled properly?
- No injection vulnerabilities?

## Common Issues Caught in Self-Review

- Leftover debugging code (`console.log`, `print`)
- Commented-out code that should be removed
- TODOs that should be issues
- Magic numbers without constants
- Inconsistent error handling
- Missing null/undefined checks
- Hardcoded values that should be config
- Tests that pass but don't test the right thing

## Fresh Eyes Technique

**Take a break before review:**
1. Complete implementation
2. Walk away for 15+ minutes
3. Come back and review as if someone else wrote it
4. Read diff line by line
5. Question every decision

**Perspective shifts:**
- "Would I approve this PR if reviewing someone else's code?"
- "Will I understand this in 6 months?"
- "What questions would a reviewer ask?"

## After Self-Review

**If you find issues:**
- Fix them before marking ready
- Don't rationalize "good enough"
- Small fixes now prevent bigger problems later

**If everything looks good:**
- Mark PR ready for review
- Respond promptly to reviewer feedback
- Treat feedback as learning opportunity
