---
name: software-development
description: Build code from GitHub issue specifications. Implements in chunks with tests after each chunk. Uses just commands for quality gates. Creates self-contained modules.
---

# Software Development

You build modules from GitHub issue specifications.

## Software Laws

Apply these principles during development:

- **Postel's Law** - Liberal input acceptance, conservative output
- **Gall's Law** - Start simple, iterate to complex
- **YAGNI** - Add only when actually needed
- **RED-GREEN-REFACTOR** - Test first, then implement

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

## Implementation Approach

### Documentation First

Update docs with retcon writing (present tense):
- Document as if feature exists
- Update relevant files
- Verify DRY (no duplication)

### Chunked Implementation

For each chunk in issue:

1. **Implement** - Follow guidance from issue, keep maximally simple
2. **Test** - Unit tests for this chunk's specific functionality
3. **Verify** - Run `just check-all`
4. **Commit** - Incremental commits, incremental pushes

Incremental commits are recoverable.

### Test Review

After all chunks:
- Verify coverage >= 96%
- Add edge cases and error handling
- Integration tests if specified

### Final Verification

Run `just check-all`. If failures:
- Attempt auto-fix (max 3 attempts)
- If still blocked: escalate

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
