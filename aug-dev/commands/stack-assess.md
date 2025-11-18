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

Check dimensions and justfile recipes at each level using stack-architect criteria.

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

## Assessment Algorithm

```python
def assess_level_0():
    """Check foundation dimensions and justfile."""
    dimensions = {
        'package_manager': check_package_manifest(),
        'format': check_formatter_config(),
        'lint': check_linter_config(),
        'typecheck': check_typecheck_config(),
        'test': check_test_framework(),
        'coverage': check_coverage_config(),
        'build': check_build_capability(),
        'clean': check_clean_capability(),
    }

    justfile_recipes = {
        'dev-install': check_recipe('dev-install'),
        'format': check_recipe('format'),
        'lint': check_recipe('lint'),
        'typecheck': check_recipe('typecheck'),
        'test': check_recipe('test'),
        'coverage': check_recipe('coverage'),
        'build': check_recipe('build'),
        'clean': check_recipe('clean'),
        'check-all': check_recipe('check-all'),
        'default': check_recipe('default'),
    }

    functionality = {
        'dev_install_works': run_command('just dev-install'),
        'check_all_works': run_command('just check-all'),
    }

    return {
        'dimensions': dimensions,
        'justfile': justfile_recipes,
        'functionality': functionality,
        'complete': all(dimensions.values()) and all(justfile_recipes.values())
    }

def assess_level_1():
    """Check quality gate additions."""
    if not assess_level_0()['complete']:
        return {'skipped': True, 'reason': 'Level 0 incomplete'}

    # Check threshold configurations
    coverage_threshold = check_coverage_threshold_96()
    complexity_threshold = check_complexity_10()
    integration_markers = check_integration_test_markers()

    # Check justfile additions
    recipes = {
        'test-watch': check_recipe('test-watch'),
        'integration-test': check_recipe('integration-test'),
        'complexity': check_recipe('complexity'),
        'loc': check_recipe('loc'),
    }

    # Check enforcement
    functionality = {
        'coverage_enforces': test_coverage_threshold_enforcement(),
        'complexity_enforces': test_complexity_threshold_enforcement(),
    }

    return {
        'thresholds': {
            'coverage': coverage_threshold,
            'complexity': complexity_threshold,
            'integration_markers': integration_markers,
        },
        'recipes': recipes,
        'functionality': functionality,
        'complete': all([...])
    }

# Similar for levels 2, 3, 4...
```

## Examples

### Python Project - Level 0 Incomplete

```bash
$ /stack-assess

Stack Assessment: Python
Standard: configuring-python-stack (Level 2)

Level 0: Foundation [7/9] ✗
  ✓ Package manager (uv)
  ✓ Format (ruff)
  ✓ Lint (ruff)
  ✗ Missing: typecheck (mypy)
  ✓ Test (pytest)
  △ Coverage measured but no threshold configured
  ✓ Build (python -m build)
  ✓ Clean (present)

  Justfile: 8/10 recipes
  ✓ dev-install, format, lint, test, build, clean, default
  ✗ Missing: typecheck, coverage, check-all

  Functionality:
  ✓ just dev-install succeeds
  ✗ just check-all missing

Current Level: 0 (incomplete)

---

Next Steps:

To complete Level 0:
1. Add mypy to pyproject.toml: mypy>=1.8
2. Add [tool.mypy] section with strict = true
3. Add typecheck recipe: uv run mypy src
4. Add coverage recipe: uv run pytest --cov=src
5. Add check-all recipe: format lint typecheck coverage
6. Verify: just dev-install && just check-all

See: aug-dev/skills/configuring-python-stack for complete example
```

### JavaScript Project - Level 1 Complete

```bash
$ /stack-assess

Stack Assessment: JavaScript/TypeScript
Standard: configuring-javascript-stack (Level 2)

Level 0: Foundation [8/8] ✓
Level 1: Quality Gates [4/4] ✓
  ✓ Coverage threshold 96% (vitest.config.ts)
  ✓ Complexity ≤10 (eslint.config.js)
  ✓ Integration tests (tests/integration/)
  ✓ Watch mode (vitest)

  Justfile: 14/14 recipes ✓

Level 2: Security [0/4] ✗
  ✗ Missing: deps, vulns, lic, sbom

Current Level: 1 (complete)

---

Next Steps:

Level 1 complete! ✓

Consider Level 2 (Security & Compliance):
When: Deploying to production, security requirements
Adds: Vulnerability scanning, license analysis, SBOM

To add Level 2:
1. Add `deps` recipe: pnpm outdated
2. Add `vulns` recipe: pnpm audit
3. Add `lic` recipe: pnpm dlx license-checker --summary
4. Add `sbom` recipe: pnpm dlx @cyclonedx/cyclonedx-npm --output-file sbom.json

Or: Stop at Level 1 if not deploying (YAGNI applies)
```

## Notes

- Auto-detect language from project structure
- Load appropriate stack standard
- Assess systematically (dimensions → justfile → functionality)
- Provide actionable next steps
- Include YAGNI guidance (when to stop)
- Reference stack skill for complete examples
