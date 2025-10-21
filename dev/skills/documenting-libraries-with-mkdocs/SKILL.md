---
name: documenting-libraries-with-mkdocs
description: Use when creating documentation for library projects using MkDocs Material - provides consistent structure for Python, TypeScript, Rust, and Go libraries with GitHub Pages deployment
---

# Documenting Libraries with MkDocs

## Overview

Comprehensive documentation using **MkDocs Material** with consistent structure across all library projects, regardless of language.

## Directory Structure

```
docs/
├── index.md                    # Landing page
├── getting-started/
│   ├── installation.md
│   ├── quickstart.md
│   └── hello-world.md
├── guides/
│   ├── architecture.md
│   └── core-concepts.md
├── components/                 # Or "widgets", "modules"
│   ├── overview.md
│   └── component-name.md
├── examples/
│   └── example-1.md
├── advanced/
│   ├── performance.md
│   ├── testing.md
│   └── troubleshooting.md
└── api/                        # Auto-generated
    └── module-1.md
```

## mkdocs.yml Configuration

```yaml
site_name: Library Name
site_description: Brief description
site_url: https://username.github.io/repo/
repo_url: https://github.com/username/repo

theme:
  name: material
  palette:
    - media: "(prefers-color-scheme: light)"
      scheme: default
      primary: indigo
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    - media: "(prefers-color-scheme: dark)"
      scheme: slate
      primary: indigo
      toggle:
        icon: material/brightness-4
        name: Switch to light mode
  features:
    - navigation.sections
    - navigation.expand
    - content.code.copy
    - search.suggest

plugins:
  - search
  # Language-specific API doc plugin

markdown_extensions:
  - pymdownx.highlight
  - pymdownx.superfences
  - admonition
  - tables

nav:
  - Home: index.md
  - Getting Started:
      - Installation: getting-started/installation.md
      - Quick Start: getting-started/quickstart.md
  - API Reference:
      - Module 1: api/module-1.md
```

## Language-Specific API Docs

**Python (mkdocstrings):**
```yaml
plugins:
  - mkdocstrings:
      handlers:
        python:
          options:
            show_source: true
            docstring_style: google
```

**Dependencies:**
```toml
[project.optional-dependencies]
dev = [
    "mkdocs-material>=9.5",
    "mkdocstrings[python]>=0.24",
]
```

**TypeScript (typedoc):**
```bash
npx typedoc --plugin typedoc-plugin-markdown --out docs/api
```

**Rust/Go:**
Link to docs.rs or pkg.go.dev for API reference.

## justfile Commands

**Python:**
```just
docs-serve:
    uv run mkdocs serve --dev-addr 0.0.0.0:8000

docs-build:
    uv run mkdocs build

docs-deploy:
    uv run mkdocs gh-deploy --force
```

**TypeScript:**
```just
docs-serve:
    npm run docs:serve

docs-build:
    npm run docs:build

docs-deploy:
    npm run docs:deploy
```

## GitHub Pages Deployment

**GitHub Actions (.github/workflows/docs.yml):**
```yaml
name: Deploy Documentation

on:
  push:
    branches: [main]
    paths:
      - 'docs/**'
      - 'mkdocs.yml'

permissions:
  contents: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - name: Install dependencies
        run: pip install mkdocs-material mkdocstrings[python]
      - name: Deploy docs
        run: mkdocs gh-deploy --force
```

## Content Guidelines

**index.md (Landing Page):**
```markdown
# Library Name

**Brief tagline**

One-paragraph description.

## Key Features

- **Feature 1** - Description
- **Feature 2** - Description

## Quick Example

\`\`\`python
# Complete, runnable example (< 20 lines)
\`\`\`

## Installation

\`\`\`bash
pip install library-name
\`\`\`

## Getting Started

- [Installation](getting-started/installation.md)
- [Quick Start](getting-started/quickstart.md)
```

**Guide pages:**
- Start with "Why" (motivation)
- Include architecture diagrams
- Complete code examples
- Link to related API docs

**Component reference:**
- Component purpose
- Parameters table
- Method examples
- Complete working code
- Common patterns

## Quality Checklist

- [ ] `docs-build` succeeds without warnings
- [ ] All internal links work
- [ ] All code examples tested and correct
- [ ] Dark/light mode both look good
- [ ] Search functionality works
