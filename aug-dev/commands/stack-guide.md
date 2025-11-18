---
name: stack-guide
description: Create new stack definitions, validate existing ones, or create customized variants
---

# Stack Definition Guide

Work with development stack definitions: create new, validate existing, customize variants.

## Usage

```bash
/stack-guide rust                  # Create new stack for Rust
/stack-guide python                # Validate existing Python stack
/stack-guide --variant acme-python # Create customized variant
```

## Three Modes

### Mode 1: Create New Stack

When stack skill doesn't exist for language.

**Example:** `/stack-guide rust`

### Mode 2: Validate Existing Stack

When stack skill exists, validate against development-stack-standards standards.

**Example:** `/stack-guide python` (validates configuring-python-stack)

### Mode 3: Create Variant

Create customized stack based on existing one.

**Example:** `/stack-guide --variant acme-python`

---

## Mode 1: Create New Stack

### Instructions

#### 1. Check if Stack Exists

```bash
# Look for existing stack skill
ls aug-dev/skills/configuring-[language]-stack/
```

If exists, suggest Mode 2 (validate) instead.

#### 2. Load development-stack-standards Standards

Use `development-stack-standards` skill to understand requirements.

#### 3. Interactive Wizard

Ask questions to build stack definition:

**Language basics:**
- Language name?
- Version/LTS to target?
- Official package registry?

**Level 0 dimensions:**

For each dimension, ask:

**Package Manager:**
- What's the standard package manager? (pip, npm, cargo, go mod, etc.)
- Does it handle: dependency install, lockfile, isolation?
- Config file names?

**Formatter:**
- Standard formatter in ecosystem? (black, prettier, rustfmt, gofmt, etc.)
- Auto-fix capability?
- Config file?
- Recommended settings?

**Linter:**
- Standard linter? (ruff, eslint, clippy, golangci-lint, etc.)
- Auto-fix capability?
- Can check complexity?
- Config file?

**Type Checker:**
- Built into language or separate tool?
- Static type checking available?
- Strict mode?
- Config file?

**Test Framework:**
- Standard test framework? (pytest, jest, cargo test, go test, etc.)
- Fast execution?
- Can mark integration tests?
- Config file?

**Coverage:**
- Coverage tool? (pytest-cov, jest, tarpaulin, go test -cover, etc.)
- Threshold support?
- HTML reports?
- Config file?

**Build:**
- Build command? (python -m build, tsc, cargo build, go build, etc.)
- Output artifacts?

**Clean:**
- What to clean? (build artifacts, caches, dependencies)

**Level 1 additions:**

**Coverage Threshold:**
- Can enforce 96% threshold?
- How to configure?

**Complexity:**
- Complexity checker? (radon, eslint, clippy, gocyclo, etc.)
- Can enforce ≤10?
- Detailed reporting?

**Test Separation:**
- How to mark integration tests?
- How to exclude from unit test runs?

**Watch Mode:**
- Test watch tool? (pytest-watcher, vitest, cargo-watch, etc.)
- How to run?

**Level 2 additions:**

**Dependencies:**
- How to list outdated?

**Vulnerabilities:**
- Security scanner? (pip-audit, npm audit, cargo-audit, etc.)

**Licenses:**
- License checker?

**SBOM:**
- SBOM generator? (CycloneDX, etc.)

#### 4. Generate Stack Skill

Create `aug-dev/skills/configuring-[language]-stack/SKILL.md`

**Use template from development-stack-standards:**

```markdown
---
name: configuring-[language]-stack
description: [Language] stack - [tools] ([coverage]%)
---

# [Language] Stack

## Standards Compliance

| Standard | Level | Status |
|----------|-------|--------|
| justfile-standard-interface | Baseline | ✓ Full |
| development-stack-standards | Level [N] | ✓ Complete |

**Dimensions:** [X]/[Y] (Foundation + Quality Gates + Security)

## Toolchain

[Table of tools]

## Quick Reference

[Bash commands]

## Docker Compatibility

[Binding example]

## Standard Justfile Interface

[Complete justfile]

## Configuration Files

[All config files]

## Notes

[Stack-specific guidance]
```

#### 5. Validate Generated Skill

Run through development-stack-standards checklist:
- All Level 0 dimensions covered?
- Justfile implements justfile-standard-interface?
- Config examples complete?
- Docker compatibility addressed?

#### 6. Test Generated Skill

**Suggest test project:**
```
Created configuring-[language]-stack skill!

Test it:
1. Create test project: mkdir test-[language]-project
2. Copy justfile and configs from skill
3. Run: just dev-install && just check-all
4. Verify all recipes work

Once validated, the skill is ready for use.
```

---

## Mode 2: Validate Existing Stack

### Instructions

#### 1. Load Existing Stack Skill

```bash
# Read the skill
cat aug-dev/skills/configuring-[language]-stack/SKILL.md
```

#### 2. Assess Against development-stack-standards

Check each requirement:

**Structure:**
- ✓/✗ Frontmatter (name, description)
- ✓/✗ Standards Compliance table
- ✓/✗ Toolchain table
- ✓/✗ Quick Reference
- ✓/✗ Docker Compatibility
- ✓/✗ Standard Justfile Interface
- ✓/✗ Configuration Files
- ✓/✗ Notes

**Level 0 Dimensions:**
- ✓/✗ Package manager
- ✓/✗ Format
- ✓/✗ Lint
- ✓/✗ Typecheck
- ✓/✗ Test
- ✓/✗ Coverage
- ✓/✗ Build
- ✓/✗ Clean

**Justfile:**
- ✓/✗ All 10 baseline recipes
- ✓/✗ Correct check-all dependencies
- ✓/✗ Implements justfile-standard-interface

**Level 1 (if claimed):**
- ✓/✗ Coverage threshold 96%
- ✓/✗ Complexity ≤10
- ✓/✗ Test separation
- ✓/✗ Watch mode
- ✓/✗ 4 additional recipes

**Level 2 (if claimed):**
- ✓/✗ deps, vulns, lic, sbom recipes

**Consistency:**
- ✓/✗ Tool choices appropriate for ecosystem
- ✓/✗ Examples complete and correct
- ✓/✗ Config files match justfile recipes

#### 3. Generate Validation Report

```
Stack Validation: configuring-[language]-stack
Standard: development-stack-standards

Structure: [X]/8 ✓
  ✓ Frontmatter
  ✓ Standards Compliance table
  ✓ Toolchain table
  ...

Level 0: [X]/8 ✓
  ✓ All dimensions present
  ✓ Justfile complete
  ✓ Examples functional

Level 1: [X]/4 ✓
  ✓ Coverage threshold 96%
  ✗ Missing: Complexity threshold in ruff config
  ✓ Test separation documented
  ✓ Watch mode present

Overall: Level 1 (mostly complete)

---

Improvements:

1. Add complexity threshold to ruff config:
   [tool.ruff.mccabe]
   max-complexity = 10

2. Update lint recipe to check complexity:
   uv run ruff check --fix . --select C90 --complexity-max 10

After fixes, stack will be Level 1 complete.
```

#### 4. Suggest Improvements

**If gaps found:**
- List specific missing items
- Provide exact additions needed
- Reference development-stack-standards for requirements

**If complete:**
```
Stack validation: PASS ✓

configuring-[language]-stack fully implements development-stack-standards Level [N].
All dimensions present, justfile correct, examples complete.

No improvements needed.
```

---

## Mode 3: Create Variant

### Instructions

#### 1. Identify Base Stack

Ask user:
```
Which stack to base on?
- configuring-python-stack
- configuring-javascript-stack
- configuring-java-stack
- Other (specify)
```

#### 2. Load Base Stack

Read the base stack skill.

#### 3. Ask What to Customize

**Common customizations:**

**Coverage threshold:**
- Base: 96%
- Variant: Lower (80%?) or higher (98%?)
- Reason: Team preference, gradual adoption, stricter standards

**Complexity threshold:**
- Base: ≤10
- Variant: Lower (≤8?) or higher (≤15?)
- Reason: Team preference, codebase style

**Formatter:**
- Base: [tool]
- Variant: Different tool or settings?
- Reason: Team preference, company standard

**Additional tools:**
- Add: Performance profiling, additional linters, custom validators
- Reason: Team-specific needs

**Naming conventions:**
- Base: Standard
- Variant: Company-specific (acme-python, companyname-javascript)

**Additional recipes:**
- Add custom justfile recipes for team workflows

#### 4. Generate Variant Skill

Create `aug-dev/skills/configuring-[variant-name]-stack/SKILL.md`

**Modifications from base:**

```markdown
---
name: configuring-[variant-name]-stack
description: [Variant] stack - based on [base-stack] with [customizations]
---

# [Variant] Stack

**Based on:** configuring-[base]-stack

**Customizations:**
- Coverage threshold: 80% (gradual adoption)
- Additional linter: [tool-name] for [purpose]
- Custom recipe: `deploy-staging` for team workflow

## Standards Compliance

| Standard | Level | Status |
|----------|-------|--------|
| justfile-standard-interface | Baseline | ✓ Full |
| development-stack-standards | Level [N] | ✓ Complete (customized) |
| configuring-[base]-stack | Base | ✓ Inherits |

[Rest follows base stack template with modifications noted]
```

**Document customizations:**
- What differs from base?
- Why these choices?
- How to migrate from base to variant?

#### 5. Validate Variant

Check:
- Still implements justfile-standard-interface?
- Still meets development-stack-standards Level requirements (if customizations don't violate them)?
- Customizations documented?
- Migration path from base clear?

#### 6. Provide Usage Guidance

```
Created [variant-name]-stack!

Usage:
- New projects: Follow this variant instead of base stack
- Existing projects using base: Migration steps in "Notes" section
- Team onboarding: Reference this skill for team standards

Relationship to base:
- Inherits all base capabilities
- Adds: [customizations]
- Differs: [differences]

This variant is team-specific. Consider:
- Documenting in team wiki
- Not upstreaming to aug-dev (unless broadly useful)
- Reviewing annually (does team still need these customizations?)
```

---

## Examples

### Example 1: Create Rust Stack

```bash
$ /stack-guide rust

No stack skill found for Rust. Creating new stack definition.

Loading development-stack-standards standards...

--- Interactive Wizard ---

Language: Rust
Version: 1.75+ (current stable)

Level 0 Dimensions:

Package Manager: cargo (built-in)
  - Install: cargo build
  - Lockfile: Cargo.lock
  - Isolation: target/ directory

Formatter: rustfmt (built-in)
  - Auto-fix: Yes (cargo fmt)
  - Config: rustfmt.toml

Linter: clippy (built-in)
  - Auto-fix: Some (cargo clippy --fix)
  - Complexity: Yes (cognitive-complexity)
  - Config: clippy.toml

[... continue for all dimensions ...]

--- Generating Skill ---

Created: aug-dev/skills/configuring-rust-stack/SKILL.md

Validation: Level 0 complete ✓

Test it:
1. mkdir test-rust && cd test-rust
2. Copy justfile from skill
3. cargo init
4. just dev-install && just check-all

Ready for use!
```

### Example 2: Validate Python Stack

```bash
$ /stack-guide python

Found existing stack: configuring-python-stack

Validating against development-stack-standards standards...

Structure: 8/8 ✓
Level 0: 8/8 ✓
Level 1: 4/4 ✓
Level 2: 4/4 ✓

Stack validation: PASS ✓

configuring-python-stack fully implements development-stack-standards Level 2.
No improvements needed.
```

### Example 3: Create ACME Variant

```bash
$ /stack-guide --variant acme-python

Create customized stack variant.

Base stack: configuring-python-stack (Level 2)

Customizations:

Coverage threshold?
  Base: 96%
  Variant: 85% (gradual adoption for legacy codebase)

Complexity threshold?
  Base: ≤10
  Variant: ≤10 (keep same)

Additional tools?
  Add: bandit (security linter)
  Add: `deploy-staging` recipe

--- Generating Variant ---

Created: aug-dev/skills/configuring-acme-python-stack/SKILL.md

Customizations:
- Coverage: 85% (vs 96% base)
- Added: bandit for security scanning
- Added: deploy-staging recipe
- Inherits: All other base capabilities

Usage: Reference this skill for ACME Python projects.

Note: This is team-specific. Not for upstream contribution.
```

## Notes

- Mode 1: Interactive wizard, comprehensive questions
- Mode 2: Automated validation, actionable improvements
- Mode 3: Inheritance model, document customizations
- All modes: Reference development-stack-standards for standards
- All modes: Validate output before completion
