---
name: configuring-github-actions
description: Use when setting up GitHub Actions CI/CD for pull request checks - provides workflow templates for Python, JavaScript, and polyglot projects that run quality gates on every PR
---

# Configuring GitHub Actions

## Overview

Standard PR checks workflow: `.github/workflows/pr-checks.yml`

Runs on every PR and push to main. Executes `just check-all` to enforce quality gates.

## Quick Reference

```yaml
# .github/workflows/pr-checks.yml (Python example)
name: PR Checks

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: extractions/setup-just@v2

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install uv
        run: pip install uv

      - name: Install dependencies
        run: |
          uv venv .venv
          source .venv/bin/activate
          uv pip install -e ".[dev]"

      - name: Run all checks
        run: |
          source .venv/bin/activate
          just check-all
```

## Python Project Workflow

**Complete template** (`.github/workflows/pr-checks.yml`):

```yaml
name: PR Checks

on:
  pull_request:
    branches: [main, master]
  push:
    branches: [main, master]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install just
        uses: extractions/setup-just@v2

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install uv
        run: pip install uv

      - name: Create venv and install dependencies
        run: |
          uv venv .venv
          source .venv/bin/activate
          uv pip install -e ".[dev]"

      - name: Run all checks
        run: |
          source .venv/bin/activate
          just check-all

      - name: Upload coverage
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: htmlcov/
```

## JavaScript/TypeScript Project Workflow

```yaml
name: PR Checks

on:
  pull_request:
    branches: [main, master]
  push:
    branches: [main, master]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install just
        uses: extractions/setup-just@v2

      - name: Setup pnpm
        uses: pnpm/action-setup@v3
        with:
          version: 8

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'

      - name: Install dependencies
        run: pnpm install

      - name: Run all checks
        run: just check-all

      - name: Upload coverage
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/
```

## Polyglot Project Workflow

```yaml
name: PR Checks

on:
  pull_request:
    branches: [main, master]
  push:
    branches: [main, master]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install just
        uses: extractions/setup-just@v2

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Setup pnpm
        uses: pnpm/action-setup@v3
        with:
          version: 8

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'

      - name: Install uv
        run: pip install uv

      - name: Install dependencies
        run: just dev

      - name: Run all checks
        run: just check-all

      - name: Upload Python coverage
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: python-coverage
          path: api/htmlcov/

      - name: Upload JS coverage
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: js-coverage
          path: web/coverage/
```

## Matrix Testing (Multiple Versions)

```yaml
name: PR Checks

on:
  pull_request:
    branches: [main]

jobs:
  check:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.11', '3.12']
        node-version: ['20', '21']
    steps:
      - uses: actions/checkout@v4
      - uses: extractions/setup-just@v2

      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}

      - name: Run checks
        run: just check-all
```

## Branch Protection Rules

**Configure in GitHub:** Repo Settings → Branches → Add rule

Required settings:
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Select `check` (job name from workflow)
- ✅ Require conversation resolution before merging
- ✅ Do not allow bypassing the above settings

## Creating Workflow

```bash
mkdir -p .github/workflows

# Copy appropriate template to .github/workflows/pr-checks.yml

git add .github/workflows/pr-checks.yml
git commit -m "chore: Add GitHub Actions PR checks"
git push
```

## Workflow Features

**Caching:**
- Python: Auto-caches based on `pyproject.toml`
- Node: Auto-caches with `cache: 'pnpm'`

**Artifacts:**
Upload coverage reports:
```yaml
- uses: actions/upload-artifact@v4
  with:
    name: coverage-report
    path: htmlcov/
```

**Conditional steps:**
```yaml
- name: Upload coverage
  if: always()  # Run even if previous steps failed
```

**Manual triggers:**
```yaml
on:
  pull_request:
  push:
  workflow_dispatch:  # Enables "Run workflow" button
```

## Optimization

**Skip checks for docs-only changes:**
```yaml
on:
  pull_request:
    paths-ignore:
      - '**.md'
      - 'docs/**'
```

**Run expensive checks only on main:**
```yaml
- name: Integration tests
  if: github.ref == 'refs/heads/main'
  run: just test-integration
```

## Troubleshooting

**Just not found:**
- Add `extractions/setup-just@v2` step

**Permission denied:**
- Add `chmod +x script.sh` before running

**Missing dependencies:**
- Ensure `just dev` or equivalent runs

**Cache issues:**
- Settings → Actions → Caches → Clear cache

## Debugging

**View logs:**
- Actions tab → Click workflow → Click job → View logs

**Add debug output:**
```yaml
- name: Debug info
  run: |
    echo "Python: $(python --version)"
    echo "Node: $(node --version)"
    echo "Just: $(just --version)"
    ls -la
```

**Re-run with debug:**
- "Re-run jobs" → "Enable debug logging"

## Security Best Practices

**Pin versions:**
```yaml
- uses: actions/checkout@v4  # ✅ Good
- uses: actions/checkout@main  # ❌ Bad
```

**Limit permissions:**
```yaml
permissions:
  contents: read
  pull-requests: write
```

**Use secrets:**
```yaml
- name: Deploy
  env:
    API_KEY: ${{ secrets.API_KEY }}
  run: ./deploy.sh
```

## Common Issues

| Issue | Solution |
|-------|----------|
| Just not found | Add setup-just action |
| Python cache miss | Check pyproject.toml exists |
| Node cache miss | Check pnpm-lock.yaml exists |
| Tests fail in CI | Run locally with same versions |
| Slow workflow | Add caching, optimize checks |
