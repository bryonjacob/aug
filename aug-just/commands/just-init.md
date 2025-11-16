---
name: just-init
description: Install baseline justfile for stack (python, javascript, java, polyglot)
argument-hint: <stack>
---

Generate level 0 justfile. All baseline commands, stack-appropriate implementations.

## Usage

```bash
/just-init python
/just-init javascript
/just-init java
/just-init polyglot
```

## Instructions

1. **Load skill**
   ```
   Use Skill tool: justfile-interface
   ```

2. **Verify no existing justfile**
   ```bash
   if [ -f justfile ]; then
     echo "justfile exists - use /just-refactor instead"
     exit 1
   fi
   ```

3. **Generate justfile**

   Create justfile with:
   - All baseline commands (level 0)
   - Exact comment strings from skill
   - Stack-appropriate implementations
   - Stubs for non-applicable commands (`@echo "⚠️ not implemented"`)

4. **Write justfile**

   Use Write tool to create `justfile` in current directory.

5. **Validate**
   ```bash
   just --list
   ```

6. **Report**
   ```
   ✅ Baseline justfile created (level 0)

   Commands implemented: 9/9
   - dev-install
   - format
   - lint
   - typecheck
   - test
   - coverage
   - check-all
   - clean
   - default

   Next steps:
   1. Run: just dev-install
   2. Run: just check-all
   3. Assess: /just-assess
   4. Upgrade: /just-upgrade 1 (when ready)
   ```

## Stack Templates

**Python:** uv, ruff, mypy, pytest
**JavaScript:** pnpm, prettier, eslint, vitest
**Java:** maven, spotless, pmd, junit5
**Polyglot:** root orchestration with `_run-all` helper

Follow justfile-interface skill for exact implementations.

## Polyglot Special Case

For polyglot:
1. Generate root justfile (orchestration subset)
2. Prompt for subproject directories
3. Generate full justfile in each subproject
4. Test `_run-all` helper

## Notes

- Creates NEW justfile only
- Existing justfile? Use `/just-refactor`
- Level 0 only (baseline)
- Advanced patterns: use `/just-upgrade`
