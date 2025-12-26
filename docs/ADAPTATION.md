# Adapting Aug to Your Stack

Aug makes specific tool choices. This guide shows how to adapt while keeping the workflow patterns.

## Quick Reference

| Aug Choice | Alternatives | Pattern That Transfers |
|------------|--------------|----------------------|
| uv (Python) | poetry, pip-tools, conda | Lockfile, isolated env, reproducible builds |
| pnpm (JS) | npm, yarn, bun | Lockfile, workspace support |
| justfile | Makefile, npm scripts, task | Standard interface, check-all gate |
| vitest | jest, mocha | Fast unit tests, coverage reporting |
| ruff | black + flake8, pylint | Format + lint in one pass |
| 96% coverage | 80%, 90%, 100% | High threshold with documented exceptions |

## Python: uv → poetry

### Aug's Python justfile (uv)
```just
install:
    uv sync

test:
    uv run pytest

coverage:
    uv run pytest --cov --cov-report=term --cov-fail-under=96

format:
    uv run ruff format .

lint:
    uv run ruff check . --fix
```

### Adapted for poetry
```just
install:
    poetry install

test:
    poetry run pytest

coverage:
    poetry run pytest --cov --cov-report=term --cov-fail-under=96

format:
    poetry run black .

lint:
    poetry run flake8 .
```

### What transfers
- `check-all` pattern (format-check → lint → typecheck → coverage)
- High coverage threshold
- Isolated virtual environment
- Lockfile for reproducibility

### What changes
- Package manager commands
- Formatter (ruff format → black)
- Linter (ruff check → flake8)

## JavaScript: pnpm → npm

### Aug's JavaScript justfile (pnpm)
```just
install:
    pnpm install

test:
    pnpm test

coverage:
    pnpm test -- --coverage --coverage.thresholds.lines=96

format:
    pnpm prettier --write .

lint:
    pnpm eslint . --fix
```

### Adapted for npm
```just
install:
    npm ci

test:
    npm test

coverage:
    npm test -- --coverage --coverageThreshold='{"global":{"lines":96}}'

format:
    npx prettier --write .

lint:
    npx eslint . --fix
```

### What transfers
- Same check-all structure
- Same coverage threshold
- Same format/lint/test separation

### What changes
- `pnpm` → `npm`/`npx`
- `pnpm install` → `npm ci` (cleaner for CI)

## Build Tool: justfile → Makefile

### Aug's justfile
```just
# Development
install:
    uv sync

dev:
    uv run python -m myapp

# Quality
format:
    uv run ruff format .

lint:
    uv run ruff check . --fix

typecheck:
    uv run mypy .

coverage:
    uv run pytest --cov --cov-fail-under=96

check-all: format-check lint typecheck coverage
```

### Adapted to Makefile
```makefile
.PHONY: install dev format lint typecheck coverage check-all

# Development
install:
	uv sync

dev:
	uv run python -m myapp

# Quality
format:
	uv run ruff format .

lint:
	uv run ruff check . --fix

typecheck:
	uv run mypy .

coverage:
	uv run pytest --cov --cov-fail-under=96

check-all: format-check lint typecheck coverage
```

### What transfers
- Standard command names
- check-all as single entry point
- Same dependency chain

### What changes
- Syntax (`:=` vs `=`, tabs required)
- `.PHONY` declarations needed
- No built-in argument passing

## Coverage: 96% → Your Threshold

Aug uses 96%. Adjust based on your context:

### Legacy codebase (80%)
```just
coverage:
    uv run pytest --cov --cov-fail-under=80
```
Rationale: Existing untested code. Improving gradually.

### Standard project (90%)
```just
coverage:
    uv run pytest --cov --cov-fail-under=90
```
Rationale: Good coverage without excessive mocking.

### Critical system (100%)
```just
coverage:
    uv run pytest --cov --cov-fail-under=100
```
Rationale: Every path matters. Worth the investment.

### Pattern that transfers
- Threshold enforced in CI
- Failures visible immediately
- Documented exceptions (if any)

## Git Workflow: Flat → Gitflow

Aug uses flat branches. If you need gitflow:

### Aug's pattern
```
main
├── epic/auth/login-page
├── epic/auth/logout-api
└── epic/payments/checkout
```

### Gitflow adaptation
```
main
└── develop
    ├── feature/auth/login-page
    ├── feature/auth/logout-api
    └── feature/payments/checkout
```

### What transfers
- Branch naming convention (prefix/scope/task)
- One task per branch
- PR-based workflow

### What changes
- Target branch (main → develop)
- Release branches (gitflow adds these)
- Hotfix process

### Workflow command adaptation
Update `/work` command to target develop:
```bash
# Aug default
git checkout main && git pull && git checkout -b epic/...

# Gitflow
git checkout develop && git pull && git checkout -b feature/...
```

## Web: Next.js → Other Frameworks

Aug's aug-web targets Next.js 15+. For other frameworks:

### Pattern transfers
- Component-based architecture
- Server/client separation
- Type-safe props
- E2E testing with Playwright

### Framework-specific
- Next.js: App Router, Server Components
- Remix: Loaders, Actions
- SvelteKit: +page.svelte, +server.ts
- Nuxt: pages/, server/

### Styling adaptation
Aug uses Tailwind + CVA. Alternatives:
- styled-components (CSS-in-JS)
- CSS Modules (scoped CSS)
- Vanilla Extract (type-safe CSS)

Pattern that transfers: Design tokens, component variants, consistent spacing.

## Creating Your Own Stack

For languages Aug doesn't cover (Go, Rust, etc.):

### 1. Define baseline justfile
```just
# Standard interface (all stacks)
install:
    # language-specific install

dev:
    # run development server/watcher

test:
    # run tests

format:
    # format code

lint:
    # lint code

typecheck:
    # type checking (if applicable)

coverage:
    # test with coverage threshold

check-all: format-check lint typecheck coverage
```

### 2. Follow maturity model
- Level 0: Basic commands above
- Level 1: Add `test-watch`, `complexity`
- Level 2: Add `security-check`, `sbom`
- Level 3: Add `deploy`, `migrate`

### 3. Document choices
```markdown
## Opinionated Choices

- **Formatter:** gofmt (standard, no config)
- **Linter:** golangci-lint (comprehensive)
- **Test:** go test with race detector
- **Coverage:** 90% (Go idiom: test public API thoroughly)
```

### 4. Add adaptation guide
Explain what's Go-specific vs. what transfers to Rust, etc.

## Summary

Adaptation strategy:
1. Keep workflow patterns (plan → breakdown → create → work)
2. Keep quality gates (check-all with threshold)
3. Keep documentation structure (README + CLAUDE.md)
4. Swap tools to match your preferences
5. Adjust thresholds to match your context
6. Document your choices and rationale
