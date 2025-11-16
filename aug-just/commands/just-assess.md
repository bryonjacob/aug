---
name: just-assess
description: Assess current justfile - level, gaps, recommendations
---

Analyze justfile. Show level, missing commands, non-standard comments, next steps.

## Usage

```bash
/just-assess
```

## Instructions

1. **Load skills**
   ```
   Use Skill tool: justfile-interface
   Use Skill tool: justfile-maturity-model
   ```

2. **Check justfile exists**
   ```bash
   if [ ! -f justfile ]; then
     echo "No justfile found"
     echo "Run: /just-init <stack>"
     exit 0
   fi
   ```

3. **Analyze baseline (level 0)**

   Check all 9 commands present:
   ```bash
   for cmd in default dev-install format lint typecheck test coverage check-all clean; do
     grep -q "^$cmd:" justfile || echo "Missing: $cmd"
   done
   ```

   Check comment strings match exactly:
   ```bash
   grep -q "# Show all available commands" justfile
   grep -q "# Install dependencies and setup development environment" justfile
   # ... etc for all commands
   ```

   Check check-all dependencies:
   ```bash
   grep -q "^check-all: format lint typecheck coverage$" justfile
   ```

4. **Analyze level 1 (quality)**

   Check for: `test-watch`, `integration-test`, `complexity`, `loc`

5. **Analyze level 2 (security)**

   Check for: `vulns`, `lic`, `sbom`, `doctor`

6. **Analyze level 3 (advanced)**

   Check for: `test-smart`, `deploy`, `migrate`, `logs`, `status`

7. **Analyze level 4 (polyglot)**

   Check for:
   - Multiple justfiles (root + subprojects)
   - `_run-all` helper in root

8. **Determine level**

   - Level 0: All baseline present
   - Level 1: Level 0 + all quality commands
   - Level 2: Level 1 + all security commands
   - Level 3: Level 2 + any advanced commands
   - Level 4: Polyglot structure

9. **Report**

   ```
   ═══════════════════════════════════════
   Justfile Assessment
   ═══════════════════════════════════════

   Current Level: 1 (Quality Gates)

   ✅ Level 0 (Baseline): Complete
      All 9 commands present
      All comments correct
      check-all dependencies correct

   ✅ Level 1 (Quality): Complete
      test-watch: ✅
      integration-test: ✅
      complexity: ✅
      loc: ✅

   ○ Level 2 (Security): Not started
      vulns: ❌
      lic: ❌
      sbom: ❌
      doctor: ❌

   ═══════════════════════════════════════
   Recommendations:
   ═══════════════════════════════════════

   Next level: Security (Level 2)

   Add security commands:
   /just-upgrade 2

   Or add specific patterns:
   /just-upgrade vulns       # Vulnerability scanning
   /just-upgrade lic         # License compliance
   /just-upgrade sbom        # SBOM generation
   /just-upgrade doctor      # Environment health

   ═══════════════════════════════════════
   ```

## Output Format

Show:
- Current level (0-4)
- Completion status per level (✅ complete, ○ not started, ⚠️ partial)
- Missing commands
- Non-standard comments
- Recommendations (next level or specific patterns)

## Notes

- Read-only analysis
- No modifications
- Use before `/just-refactor` or `/just-upgrade`
- YAGNI-appropriate next steps
