---
name: justfile-quality-patterns
description: Level 1 patterns - test-watch, integration-test, complexity, loc
---

# Quality Patterns (Level 1)

Add when CI matters. Fast feedback, test separation, complexity analysis.

## Commands

### test-watch

Continuous test execution on file changes.

```just
# Run tests in watch mode
test-watch:
    <continuous test execution on file changes>
```

**Python:**
```just
test-watch:
    uv run pytest-watch -v -m "not integration"
```

**JavaScript:**
```just
test-watch:
    pnpm vitest watch --project unit
```

### integration-test

Integration tests. No coverage threshold. Never blocks merge.

```just
# Run integration tests with coverage report (no threshold)
integration-test:
    <integration tests (marked/tagged), report only, never blocks>
```

**Python:**
```just
integration-test:
    uv run pytest -v -m "integration" --durations=10
```

**JavaScript:**
```just
integration-test:
    pnpm exec playwright test
```

**Java:**
```just
integration-test:
    mvn failsafe:integration-test
```

**Key:** Marked/tagged tests. Report coverage, no threshold. Never in check-all.

### complexity

Detailed complexity report. Informational, not blocking.

```just
# Detailed complexity report for refactoring decisions
complexity:
    <per-function/class complexity, informational, does not block>
```

**Python:**
```just
complexity:
    uv run radon cc . -a -nc
```

**JavaScript:**
```just
complexity:
    pnpm exec eslint . --ext .ts,.tsx --format complexity
```

**Java:**
```just
complexity:
    mvn pmd:pmd
    cat target/pmd.xml
```

### loc

Show N largest files by lines of code.

```just
# Show N largest files by lines of code
loc N="20":
    <show N largest files by LOC, sorted descending>
```

**Universal (works all stacks):**
```just
loc N="20":
    find . -name "*.py" -o -name "*.ts" -o -name "*.tsx" -o -name "*.java" | \
      xargs wc -l | sort -rn | head -n {{N}}
```

## Test Separation Philosophy

**Unit tests (unmarked):**
- Fast (< 5s total)
- No external dependencies
- 96% coverage threshold
- Block merge if fail
- Run in CI every commit
- Run in pre-commit hook

**Integration tests (marked/tagged):**
- Slower (> 10s, possibly minutes)
- Require external services
- Coverage reported, no threshold
- Never block merge
- Run in CI, don't fail build
- Optional in pre-commit

**Rationale:** Quality gates must be fast. Integration tests validate but shouldn't slow feedback loop.

## Markers/Tags

**Python (`pytest.ini`):**
```ini
[pytest]
markers =
    integration: Integration tests requiring external services
    unit: Fast unit tests (default, unmarked)
```

**JavaScript (file naming):**
```
src/lib/**/*.test.ts          # Unit tests
src/components/**/*.test.tsx  # Component tests
tests/integration/**/*.spec.ts # Integration tests (Playwright)
```

**Java (JUnit tags):**
```java
@Tag("integration")
@Test
void testDatabaseConnection() { }
```

## Coverage Thresholds

**Unit tests:** 96% (blocks merge)
**Integration tests:** Report only (no threshold)

**Why 96%?**
- 100% impractical (edge cases, defensive code)
- 90% too permissive
- 96% forces thinking, allows rare exceptions

## When to Add Level 1

Add when:
- Setting up CI/CD
- Multiple developers
- Need fast local feedback (test-watch)
- Integration tests exist (separate from unit)

Skip when:
- Solo project, no CI
- No integration tests yet
- Prefer simplicity over thoroughness
