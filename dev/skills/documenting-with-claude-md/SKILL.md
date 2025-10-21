---
name: documenting-with-claude-md
description: Use when creating or updating CLAUDE.md files for machine-readable context - establishes hierarchical documentation with root module index and per-module context files that load automatically
---

# Documenting with CLAUDE.md

## Overview

**Machine-first documentation:** CLAUDE.md files provide context that loads automatically when AI reads code. Not for human browsing - for instant AI understanding.

**Hierarchy:**
- Root `CLAUDE.md` - Project overview + module index
- Module `CLAUDE.md` - Per-module context in significant directories

## Quick Reference

**Root CLAUDE.md template:**
```markdown
# Project Name

## Purpose
What this project does and why it exists

## Architecture Overview
High-level system design

## Module Index
- `src/auth/` - Authentication (see src/auth/CLAUDE.md)
- `src/api/` - REST API (see src/api/CLAUDE.md)

## Tech Stack
- Language/framework
- Key dependencies
```

**Module CLAUDE.md template:**
```markdown
# Module: Authentication

## Purpose
Handles user authentication and sessions

## Responsibilities
- User login/logout
- Token generation
- Session management

## Key Files
- `auth_service.py` - Core logic
- `token_handler.py` - JWT operations

## Public Interface
- `authenticate(email, password) -> Token`
- `validate_token(token) -> User`

## Architecture Decisions
- Using JWT for stateless auth
- Tokens expire after 24 hours
```

## Root CLAUDE.md (Required)

**Every project must have root CLAUDE.md:**

```markdown
# Project Name

## Purpose
Clear statement of what project does and why

## Architecture Overview
High-level design, key patterns, major components

## Module Index
- `src/auth/` - Brief description (see src/auth/CLAUDE.md)
- `src/api/` - Brief description (see src/api/CLAUDE.md)
- `src/db/` - Brief description (see src/db/CLAUDE.md)
- `src/utils/` - Brief description (no CLAUDE.md, simple utils)

## Tech Stack
- Python 3.11 + FastAPI
- PostgreSQL database
- Redis for caching
- Deployed on AWS ECS

## Development
See ~/.claude/CLAUDE.md for standard workflow
```

**Key element:** Module index with links to sub-CLAUDEs

## Module CLAUDE.md (For Significant Modules)

**What is "significant"?**
- Contains 3+ files
- Represents distinct concern/domain
- Has subdirectories
- Takes >5 minutes to understand from code alone

**Template:**
```markdown
# Module: [Name]

## Purpose
One-paragraph explanation of module's role

## Responsibilities
- Responsibility 1
- Responsibility 2
- Responsibility 3

## Key Files
- `file1.py` - What it does
- `file2.py` - What it does
- `file3.py` - What it does

## Dependencies
- Uses: Other modules this depends on
- Used by: Modules that depend on this

## Public Interface
Key functions/classes others use:
- `function_name(args) -> return` - Description
- `ClassName` - Description

## Architecture Decisions
- Why we chose approach X over Y
- Performance considerations
- Security decisions

## Testing
- Tests located in tests/module_name/
- Key test scenarios covered
- Integration vs unit test split
```

## When to Create Module CLAUDE.md

**Create immediately when:**
- Creating new module with multiple files
- Refactoring code into new module
- Module responsibility changes significantly

**Update when:**
- Adding/removing major functionality
- Changing public interface
- Making architectural decisions
- Restructuring files

**Do NOT create for:**
- Single-file directories
- Test directories (tests self-document)
- Generated code directories
- Utility folders with <3 simple files

## Source Code Comments

**Module-level docstrings:**

```python
"""
Authentication service for user login and session management.

This module provides JWT-based authentication with bcrypt hashing.
Tokens expire after 24 hours. All operations are async.

Key functions:
    authenticate(email, password) -> Token
    validate_token(token) -> User

See: auth/CLAUDE.md for architecture details
"""

import bcrypt
from jwt import encode, decode
```

**Function-level: Comment the "why" not the "what":**

```python
# ❌ Bad: Comments what code does (obvious)
def calculate_discount(total: float, user_type: str) -> float:
    # Check if user is premium
    if user_type == "premium":
        # Return 20% discount
        return total * 0.2
    return total * 0.1

# ✅ Good: Comments why decisions were made
def calculate_discount(total: float, user_type: str) -> float:
    """Calculate order discount based on user type.

    Premium users get 20% to incentivize membership.
    Standard 10% maintains competitive pricing.
    """
    if user_type == "premium":
        return total * 0.2
    return total * 0.1
```

**Always comment:**
- Non-obvious algorithms
- Performance optimizations
- Bug workarounds
- Business logic rationale
- Security considerations
- Data validation rules

## Module Index Maintenance

**Root CLAUDE.md module index must stay current.**

**Adding module:**
```markdown
- `src/notifications/` - Email and SMS (see src/notifications/CLAUDE.md)
```

**Removing module:**
```bash
# Archive the CLAUDE.md
git mv src/old-module/CLAUDE.md docs/archive/old-module.md
# Remove from index
```

**Renaming module:**
```bash
git mv src/old-name/CLAUDE.md src/new-name/CLAUDE.md
# Update root CLAUDE.md index entry
```

## Directory Structure Example

```
project/
├── CLAUDE.md                    # Root with module index
├── src/
│   ├── auth/
│   │   ├── CLAUDE.md            # Auth module context
│   │   ├── auth_service.py
│   │   ├── token_handler.py
│   │   └── middleware.py
│   ├── api/
│   │   ├── CLAUDE.md            # API module context
│   │   ├── routes/
│   │   │   ├── CLAUDE.md        # Routes submodule
│   │   │   ├── user_routes.py
│   │   │   └── order_routes.py
│   │   └── middleware/
│   ├── db/
│   │   ├── CLAUDE.md            # Database module
│   │   ├── models.py
│   │   └── migrations/
│   └── utils/
│       └── helpers.py           # Small utils, no CLAUDE.md
└── tests/
    └── test_auth.py             # Tests self-document
```

## Implementation Workflow

**Creating new module:**
1. Create module directory
2. Create module CLAUDE.md with template
3. Add to root CLAUDE.md module index
4. Write code with docstrings
5. Update module CLAUDE.md as evolves

**Refactoring existing code:**
1. Create CLAUDE.md for modules lacking them
2. Update root CLAUDE.md with module index
3. Add docstrings to functions
4. Add explanatory comments to complex logic
5. Document architectural decisions

## Documentation Review

**In PR reviews, check:**
- New modules have CLAUDE.md?
- Module index updated in root?
- Docstrings updated for changed functions?
- Complex sections have comments?

## Anti-Patterns

**Don't do:**
- ❌ Empty or placeholder CLAUDE.md
- ❌ Outdated docs (worse than no docs)
- ❌ Comments restating code
- ❌ Docs hard to find/navigate
- ❌ Human-browsing focused (links, wikis)

**Do:**
- ✅ CLAUDE.md loads automatically with code
- ✅ Docs updated with code changes
- ✅ Comments explain why, not what
- ✅ Clear module hierarchy
- ✅ Every significant module has CLAUDE.md

## Keeping Documentation Current

**When code changes, update docs:**

Add to PR template:
```markdown
## Documentation Checklist
- [ ] Updated module CLAUDE.md if responsibilities changed
- [ ] Updated root module index if new modules added
- [ ] Updated function docstrings for changed signatures
- [ ] Added comments explaining complex new logic
```

## Success Criteria

**Good documentation means:**
- AI understands project structure from root CLAUDE.md
- Loading module file brings its CLAUDE.md context
- Comments explain why, not what
- Every significant module has current CLAUDE.md
- Docs stay in sync with code
- New developers (AI or human) understand quickly
