---
name: just-upgrade
description: Add next maturity level or specific pattern to justfile
argument-hint: <level|pattern>
---

Add capabilities to justfile. Upgrade by level (1, 2, 3, 4) or specific pattern.

## Usage

```bash
# Upgrade by level
/just-upgrade 1              # Add level 1 (quality)
/just-upgrade 2              # Add level 2 (security)
/just-upgrade 3              # Add level 3 (advanced)
/just-upgrade 4              # Add level 4 (polyglot)

# Upgrade by pattern
/just-upgrade test-smart     # Add git-aware testing
/just-upgrade deploy         # Add deployment commands
/just-upgrade vulns          # Add vulnerability scanning
```

## Instructions

1. **Load skills**
   ```
   Use Skill tool: justfile-maturity-model
   Use Skill tool for requested level:
     - Level 1: justfile-quality-patterns
     - Level 2: justfile-security-patterns
     - Level 3: justfile-advanced-patterns
     - Level 4: justfile-polyglot-patterns
   ```

2. **Assess first**

   Run `/just-assess` to verify:
   - Baseline (level 0) complete
   - Not already at requested level
   - Prerequisites met

3. **Determine what to add**

   **If level upgrade (1, 2, 3, 4):**
   - Load corresponding skill
   - Add ALL commands for level

   **If pattern upgrade (test-smart, deploy, etc):**
   - Load skill containing pattern
   - Add ONLY that pattern

4. **Detect stack**

   From existing justfile:
   - Python (uv, ruff, mypy, pytest)
   - JavaScript (pnpm, prettier, eslint, vitest)
   - Java (mvn, spotless, pmd, junit5)
   - Polyglot (root + subprojects)

5. **Add commands**

   For each new command:
   - Insert with exact comment string
   - Use stack-appropriate implementation
   - Add in logical location

6. **Add supporting files**

   **test-smart:** Create `scripts/test-smart.sh`
   **deploy:** Create `scripts/deploy/check-auth.sh`, deployment scripts
   **migrate:** Setup migration framework if not present
   **doctor:** Basic version (enhance later)

7. **Validate**

   ```bash
   just --list
   # New commands appear

   just <new-command>
   # Works or gives meaningful error
   ```

8. **Report**

   ```
   ═══════════════════════════════════════
   Upgrade Complete: Level 2 (Security)
   ═══════════════════════════════════════

   Added commands: 4
   ✓ vulns           # Vulnerability scanning
   ✓ lic             # License compliance
   ✓ sbom            # SBOM generation
   ✓ doctor          # Environment health

   Files created: 1
   ✓ .grype.yaml     # Grype configuration

   ═══════════════════════════════════════

   Next steps:
   1. Run: just doctor
   2. Run: just vulns
   3. Configure: .grype.yaml (add ignores if needed)
   4. Assess: /just-assess
   5. Upgrade: /just-upgrade 3 (when ready)
   ```

## Level Upgrade Details

### Level 1: Quality Patterns

Adds: `test-watch`, `integration-test`, `complexity`, `loc`

**Prerequisites:** Level 0 complete

**Requires:**
- Test framework configured
- Unit/integration test separation

### Level 2: Security Patterns

Adds: `vulns`, `lic`, `sbom`, `doctor`

**Prerequisites:** Level 0 complete (level 1 optional)

**Requires:**
- Grype and Syft (optional, stubs if not)
- License checking tools (pip-licenses, licensee)

### Level 3: Advanced Patterns

Adds: `test-smart`, `deploy`, `migrate`, `logs`, `status`

**Prerequisites:** Level 0 complete

**Requires:**
- Cloud provider account (deploy, logs, status)
- Migration framework (migrate)
- Git repository (test-smart)

### Level 4: Polyglot Patterns

Converts to polyglot structure.

**Prerequisites:** Level 0 in root and all subprojects

**Requires:**
- Multiple subprojects with different stacks
- Decision on subproject directories

**Warning:** Major refactoring. Creates root orchestration, moves existing to subproject.

## Pattern-Specific Upgrade

Add individual patterns without full level:

```bash
# At level 0, add test-smart only
/just-upgrade test-smart
# Adds test-smart from level 3, not deploy/migrate/logs/status

# At level 1, add deployment only
/just-upgrade deploy
# Adds deploy from level 3
```

## YAGNI Enforcement

Before adding level:
- Will you use these commands?
- Do you need them now?
- Can you add later when needed?

Don't add "just in case". Add when needed.

## Notes

- Assess before upgrade
- Complete current level before next (recommended)
- Can add patterns non-linearly
- Creates supporting files as needed
- Stack-appropriate implementations
- Validate after
