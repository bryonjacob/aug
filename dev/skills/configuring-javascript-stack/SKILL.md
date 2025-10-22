---
name: configuring-javascript-stack
description: Use when setting up JavaScript/TypeScript projects with modern tooling - provides pnpm, TypeScript, prettier, eslint, and vitest configuration with 0.0.0.0 binding for Docker compatibility
---

# Configuring JavaScript/TypeScript Stack

## Overview

Modern JavaScript/TypeScript toolchain: **pnpm** (fast package manager) + **TypeScript** (type safety) + **prettier** (formatting) + **eslint** (linting) + **vitest** (testing).

## Toolchain

| Tool | Purpose | Replaces |
|------|---------|----------|
| **pnpm** | Package manager | npm, yarn |
| **TypeScript** | Type-safe JavaScript | - |
| **prettier** | Code formatter | - |
| **eslint** | Linter (basic complexity check) | - |
| **vitest** | Testing framework (with slow test reporting) | jest |
| **tsx** | TypeScript execution | ts-node |
| **ts-complex** | Detailed complexity analysis | - |
| **cloc** | Lines of code counter | - |

## Quick Reference

```bash
# Setup
pnpm init
pnpm add -D typescript prettier eslint vitest tsx ts-complex

# System install (one-time)
brew install cloc  # macOS
# or: sudo apt install cloc  # Linux

# Quality checks
pnpm prettier --write .
pnpm eslint .
pnpm tsc --noEmit
pnpm vitest run --reporter=verbose  # Shows slow tests
pnpm vitest run --coverage
pnpm ts-complex src/**/*.ts  # Detailed complexity analysis
cloc src/ --by-file --include-lang=TypeScript --quiet | sort -rn | head -20  # LOC
```

## Web Service Configuration

**Critical: Always bind to 0.0.0.0 (not 127.0.0.1) for Docker compatibility.**

**Express:**
```typescript
const host = process.env.HOST || '0.0.0.0'
const port = parseInt(process.env.PORT || '3000', 10)

app.listen(port, host, () => {
  console.log(`Server running at http://${host}:${port}`)
})
```

**Vite dev server:**
```typescript
// vite.config.ts
export default defineConfig({
  server: {
    host: '0.0.0.0',
    port: 5173,
  },
})
```

## tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "sourceMap": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "tests"]
}
```

## .prettierrc

```json
{
  "semi": false,
  "singleQuote": true,
  "trailingComma": "es5",
  "printWidth": 100,
  "tabWidth": 2
}
```

## eslint.config.js

ESLint v9+ uses flat config format:

```javascript
import tseslint from '@typescript-eslint/eslint-plugin'
import tsparser from '@typescript-eslint/parser'

export default [
  {
    ignores: ['node_modules/**', 'dist/**', 'coverage/**', '.vitest/**'],
  },
  {
    files: ['**/*.ts', '**/*.tsx'],
    languageOptions: {
      parser: tsparser,
      parserOptions: {
        ecmaVersion: 2022,
        sourceType: 'module',
      },
    },
    plugins: {
      '@typescript-eslint': tseslint,
    },
    rules: {
      'no-console': 'warn',
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/no-explicit-any': 'error',
      'complexity': ['warn', 10],
    },
  },
]
```

## vitest.config.ts

```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html'],
      exclude: [
        'node_modules/',
        'tests/',
        'dist/',
        'coverage/',
        '**/*.config.{js,ts}',
        '**/.*rc.{js,ts,json}',
      ],
      thresholds: {
        lines: 80,
        functions: 80,
        branches: 80,
        statements: 80,
      },
    },
  },
})
```

## package.json Scripts

```json
{
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "format": "prettier --write .",
    "lint": "eslint .",
    "typecheck": "tsc --noEmit",
    "test": "vitest run",
    "test:watch": "vitest",
    "coverage": "vitest run --coverage"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@typescript-eslint/eslint-plugin": "^7.0.0",
    "@typescript-eslint/parser": "^7.0.0",
    "@vitest/coverage-v8": "^1.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "ts-complex": "^1.0.0",
    "tsx": "^4.0.0",
    "typescript": "^5.3.0",
    "vitest": "^1.0.0"
  }
}
```

## justfile Integration

```just
dev:
    pnpm install

format:
    pnpm prettier --write .

lint:
    pnpm eslint .

typecheck:
    pnpm tsc --noEmit

test:
    pnpm vitest run --reporter=verbose  # Shows slow tests

test-watch:
    pnpm vitest

coverage:
    pnpm vitest run --coverage

complexity:
    pnpm ts-complex src/**/*.ts

loc N="20":
    @echo "📊 Lines of code by file (largest first, showing {{N}}):"
    @pnpm cloc src/ --by-file --include-lang=TypeScript --quiet | sort -rn | head -{{N}}

check-all: format lint typecheck coverage
    @echo "✅ All checks passed"

clean:
    rm -rf node_modules dist coverage .vitest
```

## Quality Thresholds

- **Coverage:** 80% minimum
- **Type coverage:** 100% (no `any` types)
- **Linting:** Zero eslint violations
- **Type checking:** Zero tsc errors
- **Complexity:** Max 10 (cyclomatic)

## Common Patterns

**Type definitions:**
```typescript
interface User {
  id: string
  email: string
  active: boolean
}

type Result<T> = { ok: true; value: T } | { ok: false; error: string }
```

**Async/await:**
```typescript
async function fetchUser(id: string): Promise<User> {
  const response = await fetch(`/api/users/${id}`)
  if (!response.ok) {
    throw new Error(`Failed: ${response.statusText}`)
  }
  return response.json()
}
```

**Testing:**
```typescript
import { describe, it, expect } from 'vitest'

describe('processUser', () => {
  it('returns email for active user', () => {
    const user = { id: '1', email: 'test@example.com', active: true }
    const result = processUser(user)
    expect(result).toEqual({ ok: true, value: 'test@example.com' })
  })
})
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Using npm/yarn | Use **pnpm** for speed |
| Binding to 127.0.0.1 | Bind to **0.0.0.0** for Docker |
| Using `any` type | Enable `no-explicit-any` rule |
| Missing coverage config | Set 80% threshold in vitest.config.ts |
| No type checking in CI | Include `tsc --noEmit` in check-all |
| Missing cloc | Install system-wide: `brew install cloc` or `sudo apt install cloc` |

## Installation Requirements

**System-wide (one-time setup):**
```bash
# Node.js 20+ and pnpm
brew install node pnpm  # macOS
# or: sudo apt install nodejs && npm install -g pnpm  # Linux

# cloc for LOC measurement
brew install cloc  # macOS
# or: sudo apt install cloc  # Linux

# just for justfile commands
brew install just  # macOS
# or: cargo install just  # Linux

# Verify
node -v   # Should show 20.x+
pnpm -v   # Should show 8.x+
cloc --version
just --version
```
