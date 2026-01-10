---
name: stack-assess
description: Assess project stack against language standards, show current level and gaps
---

# Stack Assessment

Grade current project's development stack against language-specific standards.

## Usage

```bash
/stack-assess                    # Auto-detect language, assess project
/stack-assess python             # Explicit language override
```

## Instructions

### 1. Detect Language

Auto-detect from project files:
- Python: `pyproject.toml`, `requirements.txt`, `setup.py`
- JavaScript/TypeScript: `package.json`, `tsconfig.json`
- Java: `pom.xml`, `build.gradle`

If ambiguous, ask user which language to assess against.

### 2. Load Stack Standards

Load appropriate stack skill:
- Python → `configuring-python-stack`
- JavaScript → `configuring-javascript-stack`
- Java → `configuring-java-stack`

If no stack skill exists for language:
```
No stack standard for [language] yet.
Run `/stack-guide [language]` to create one.
```

### 3. Assess Each Level

Check dimensions and justfile recipes at each level using development-stack-standards criteria.

**Level 0: Foundation**

Check config files:
- Package manifest exists?
- Formatter configured?
- Linter configured?
- Type checker configured?
- Test framework configured?

Check justfile:
- All 10 baseline recipes present?
- `check-all` dependencies correct?
- Comments match standard?

Test functionality:
- Does `just dev-install` work?
- Does `just check-all` run?

**Level 1: Quality Gates**

Check configurations:
- Coverage threshold 96% in config?
- Complexity ≤10 in lint config?
- Integration test markers defined?

Check justfile:
- `test-watch` recipe present?
- `integration-test` recipe present?
- `complexity` recipe present?
- `loc` recipe present?

Test functionality:
- Does `just coverage` enforce threshold?
- Does `just lint` check complexity?

**Level 2: Security**

Check justfile:
- `deps` recipe present?
- `vulns` recipe present?
- `lic` recipe present?
- `sbom` recipe present?

Test functionality:
- Does each command work?

**Level 3: Metrics**

Check if complexity/loc commands provide detailed output suitable for refactoring decisions.

**Level 4: Polyglot**

Check structure:
- Root justfile exists?
- Subproject justfiles exist?
- Root uses `_run-all` pattern?

### 4. Generate Report

**Format:**

```
Stack Assessment: [Language]
Standard: [stack-skill-name] (Level [N])

Level 0: Foundation [X/Y] [✓ or ✗]
  ✓ Package manager ([tool-name])
  ✓ Format ([tool-name])
  ✗ Missing: typecheck configuration
  △ Present but not configured: coverage (no threshold)
  ...

  Justfile: [X]/10 recipes
  ✓ dev-install, format, lint, test, build, clean, check-all, default
  ✗ Missing: typecheck, coverage

  Functionality:
  ✓ just dev-install succeeds
  ✗ just check-all fails (missing typecheck)

Level 1: Quality Gates [X/Y] [✓ or ✗]
  [Similar breakdown]

Current Level: 0 (incomplete)
Completion: 7/9 dimensions, 8/10 recipes

---

Next Steps:

To complete Level 0:
1. Add mypy to pyproject.toml dev dependencies
2. Add [tool.mypy] config with strict = true
3. Add `typecheck` recipe to justfile
4. Add `coverage` recipe to justfile
5. Update `check-all` dependencies to include typecheck and coverage
6. Run `just dev-install && just check-all` to verify

After Level 0:
- Consider Level 1 if setting up CI/CD (coverage threshold, complexity check)
- Consider Level 2 if deploying to production (security scanning)
```

**Symbols:**
- ✓ Present and correct
- ✗ Missing entirely
- △ Present but incomplete/misconfigured

**Levels marked:**
- ✓ Complete
- ✗ Incomplete or not started
- [X/Y] Count of dimensions/recipes present

### 5. Provide Context

**When current level incomplete:**
- List specific gaps
- Provide exact steps to complete
- Link to stack skill for examples

**When current level complete:**
- Recommend next level if appropriate
- Provide "when" guidance for advancement
- Suggest stopping if YAGNI applies

**Example recommendations:**

```
Level 0 complete! ✓

Next: Consider Level 1 (Quality Gates)
When: Setting up CI/CD, multiple developers
Adds: Coverage threshold 96%, complexity ≤10, test watch mode

Or: Stop here if solo project without CI/CD (YAGNI)
```

## Example

```bash
$ /stack-assess

Stack Assessment: Python
Standard: configuring-python-stack (Level 2)

Level 0: Foundation [7/9] ✗
  ✓ Package manager (uv), Format (ruff), Lint (ruff), Test (pytest)
  ✗ Missing: typecheck (mypy)
  △ Coverage measured but no threshold

  Justfile: 8/10 recipes (missing: typecheck, coverage)

Current Level: 0 (incomplete)

Next Steps:
1. Add mypy to pyproject.toml
2. Add typecheck recipe to justfile
3. Add coverage recipe with threshold
4. Verify: just dev-install && just check-all
```

## Notes

- Auto-detect language from project structure
- Load appropriate stack standard
- Assess systematically (dimensions → justfile → functionality)
- Provide actionable next steps
- Include YAGNI guidance (when to stop)
- Reference stack skill for complete examples
