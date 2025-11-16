---
name: just-refactor
description: Make existing justfile conform to standard (preserve implementations)
---

Fix existing justfile. Add missing baseline commands, fix comment strings, preserve implementations.

## Usage

```bash
/just-refactor
```

## Instructions

1. **Load skill**
   ```
   Use Skill tool: justfile-interface
   ```

2. **Check justfile exists**
   ```bash
   if [ ! -f justfile ]; then
     echo "No justfile - use /just-init instead"
     exit 1
   fi
   ```

3. **Run assessment**

   Use `/just-assess` logic to identify:
   - Missing baseline commands
   - Incorrect comment strings
   - Wrong check-all dependencies

4. **Preserve implementations**

   For each command:
   - Keep implementation if correct
   - Fix comment only if wrong
   - Don't modify working code

5. **Add missing commands**

   For missing baseline commands:
   - Detect stack (look for uv/pnpm/mvn)
   - Add stub: `@echo "⚠️ <command> not implemented"`
   - Use exact comment string

6. **Fix comments**

   For wrong comments:
   - Replace with exact string
   - Preserve implementation
   - Example:
     ```just
     # Old: "Lint the code"
     # New: "# Lint code (auto-fix, complexity threshold=10)"
     lint:
         uv run ruff check .  # Preserve existing
     ```

7. **Fix check-all**

   If dependencies wrong:
   - Update to: `check-all: format lint typecheck coverage`
   - Preserve any additional logic

8. **Validate**

   ```bash
   just --list
   ```

9. **Report**

   ```
   ═══════════════════════════════════════
   Refactoring Complete
   ═══════════════════════════════════════

   Changes made:
   ✓ Added missing commands: 2
     - integration-test (stub)
     - complexity (stub)

   ✓ Fixed comments: 3
     - lint (was: "Lint the code")
     - test (was: "Run tests")
     - coverage (was: "Code coverage")

   ✓ Fixed check-all dependencies
     (was: check-all: lint test)
     (now: check-all: format lint typecheck coverage)

   ═══════════════════════════════════════

   Next steps:
   1. Run: just check-all
   2. Implement stubs as needed
   3. Assess: /just-assess
   4. Upgrade: /just-upgrade 1 (when ready)
   ```

## Refactoring Strategy

### Minimal Changes

- Add missing commands (stub)
- Fix comment strings exactly
- Fix check-all dependencies
- Don't rewrite working implementations

### Stack Detection

- `uv` → Python
- `pnpm` → JavaScript
- `mvn` → Java
- Mixed → Polyglot

### Preserving Logic

```just
# Before:
# Lint the code
lint:
    uv run ruff check .
    uv run mypy .

# After:
# Lint code (auto-fix, complexity threshold=10)
lint:
    uv run ruff check .  # Keep existing
    uv run mypy .        # Keep existing
```

Don't change implementations unless clearly wrong.

## Special Cases

### check-all Has Extra Steps

```just
# Before:
check-all: lint test build

# After:
check-all: format lint typecheck coverage build
```

Add required four, keep extras.

### Commands in Wrong Order

Don't reorder. Preserve organization. Only add/fix needed.

### Custom Commands

Preserve custom commands. Only modify standard ones.

## Notes

- Minimal invasive changes
- Preserve working code
- Add stubs for missing
- Fix comments exactly
- Validate with `just --list`
