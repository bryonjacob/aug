---
name: software-development
description: Build code from GitHub issue specifications. Implements in chunks with tests after each chunk. Uses just commands for quality gates. Creates self-contained modules.
---

# Software Development

You build modules from GitHub issue specifications.

## Input Source

GitHub issue with structured metadata:
- Implementation guidance
- Code examples
- Chunk-by-chunk approach
- Acceptance criteria
- Testing strategy

Parse from issue body, not labels.

## Working Context

```
Branch: epic/{epic-id}/{task-slug}
Base: main
Target: main (via PR)
```

All branches from main. Flat structure only.

## Implementation Process

### 1. Read Issue Spec

Extract:
- Architecture context
- Files to change
- Implementation chunks
- Code examples
- Test requirements
- Acceptance criteria

### 2. Documentation First

Update docs with retcon writing (present tense):
- Document as if feature exists
- Update relevant files
- Verify DRY (no duplication)

```bash
just format
git commit -m "docs: Update for #{ISSUE}"
git push
```

### 3. Implement Chunks

For each chunk in issue:

**A. Implement**
- Follow guidance from issue
- Use code examples as reference
- Keep maximally simple

**B. Test**
- Unit tests for this chunk
- Test specific functionality

**C. Verify**
```bash
just format      # Auto-fix
just lint        # Auto-fix
just typecheck   # Check types
just test        # Run tests
```

**D. Commit**
```bash
git commit -m "feat: Implement {CHUNK} for #{ISSUE}"
git push
```

Incremental commits. Incremental pushes. Recoverable.

### 4. Test Review

After all chunks:
```bash
just coverage    # Verify >= 96%
```

If below threshold:
- Identify uncovered code
- Add missing tests
- Re-run coverage

Add edge cases, error handling, integration tests.

```bash
git commit -m "test: Enhance coverage for #{ISSUE}"
git push
```

### 5. Final Verification

```bash
just check-all
```

Run user acceptance tests from issue.

If failures:
- Attempt auto-fix (max 3 attempts)
- `just format` → `just lint` → fix types → fix tests
- Re-run `just check-all`

If still failing after 3 attempts: escalate (not your job to force it).

### 6. Done

Quality gate passed. Ready for PR creation.

## Module Structure

```
module_name/
├── __init__.py      # Public interface ONLY
├── README.md        # Contract (MANDATORY)
├── core.py          # Implementation
├── models.py        # Data structures
└── tests/           # Unit tests
```

## Containment Rules

- Everything inside module directory
- No reaching into others' internals
- Tests run without external setup
- Clear public/private boundary

## Public Interface

```python
# __init__.py
from .core import process
from .models import Input, Output

__all__ = ['process', 'Input', 'Output']
```

No private exports. No internal leaks.

## Quality Checklist

Before claiming done:
- [ ] Matches issue spec exactly
- [ ] Works in isolation
- [ ] Public interface minimal
- [ ] All tests pass
- [ ] Coverage >= 96%
- [ ] `just check-all` passing
- [ ] Can regenerate from README

## Anti-Patterns

Don't:
- Export private functions
- Import from other modules' internals
- Mix multiple responsibilities
- Skip tests after chunks
- Push without verifying
- Assume library availability

## Just Commands

Standard interface across all projects:

```bash
just format      # Auto-fix formatting
just lint        # Auto-fix linting
just typecheck   # Static type checking
just test        # Run test suite
just coverage    # Coverage analysis (96% threshold)
just check-all   # Full quality gate
```

Use these. Don't invent custom verification.

## Philosophy References

Follow:
- `@ai_context/IMPLEMENTATION_PHILOSOPHY.md`
- `@ai_context/MODULAR_DESIGN_PHILOSOPHY.md`

Check: `@DISCOVERIES.md` for known patterns

## Self-Healing

When quality checks fail:
1. Parse error messages
2. Apply common fixes
3. Re-run verification
4. Retry up to 3 times
5. If still blocked: escalate

Auto-fix what's fixable. Escalate what's not.

## Success Criteria

Task complete when:
- Implementation matches spec
- Tests comprehensive
- Quality gates passing
- Incremental commits pushed
- User acceptance tests verified

No draft PRs. No "almost done". Either passing or escalated.
