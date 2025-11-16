# Justfile Adoption Workflow

End-to-end workflow from assessment through implementation. New or existing projects.

## When to Use

- Adding justfile to project
- Standardizing existing justfile
- Upgrading justfile capabilities
- Converting to polyglot structure

## Phases

### 1. Assess (both new and existing)
- **Command:** /just-assess
- **Purpose:** Understand current state
- **Output:** Current level, gaps, recommendations
- **Notes:** Shows "no justfile" for new projects, analysis for existing

### 2. Init or Refactor (choose one)
- **Command:** /just-init [stack] OR /just-refactor
- **Purpose:** Establish baseline (level 0)
- **Requires:** Assessment complete
- **Output:** Standard justfile with all baseline commands
- **Notes:** Init for new, refactor for existing

### 3. Verify Baseline
- **Command:** Manual verification
- **Purpose:** Ensure baseline works
- **Output:** `just check-all` passes or fails meaningfully
- **Notes:** Fix any issues before upgrading

### 4. Assess Progress
- **Command:** /just-assess
- **Purpose:** Confirm level 0 complete
- **Output:** Level 0 status, upgrade recommendations
- **Notes:** Should show level 0 complete

### 5. Upgrade (repeatable)
- **Command:** /just-upgrade [level|pattern]
- **Purpose:** Add capabilities as needed
- **Repeatable:** Yes, add levels incrementally
- **Output:** New commands, supporting files
- **Notes:** YAGNI - only add what you need

## Execution

### Manual (new project)

```bash
# Phase 1: Assess
/just-assess
# Output: No justfile found. Run /just-init <stack>

# Phase 2: Init
/just-init python
# Output: Baseline justfile created

# Phase 3: Verify
just dev-install
just check-all
# Output: ✅ All checks passed

# Phase 4: Assess
/just-assess
# Output: Level 0 complete. Ready for level 1.

# Phase 5: Upgrade (when needed)
/just-upgrade 1
# Adds quality patterns

/just-upgrade 2
# Adds security patterns
```

### Manual (existing project)

```bash
# Phase 1: Assess
/just-assess
# Output: Level 0 (7/9 commands, missing: integration-test, complexity)

# Phase 2: Refactor
/just-refactor
# Output: Added missing commands, fixed comments

# Phase 3: Verify
just check-all
# Output: ✅ All checks passed

# Phase 4: Assess
/just-assess
# Output: Level 0 complete. Ready for level 1.

# Phase 5: Upgrade
/just-upgrade 1
# Adds quality patterns
```

### Automated (full workflow)

```bash
/workflow-run justfile-adoption
```

Uses `/automate` for each phase, user-standin agent handles decisions.

## Decision Points

### During Init (/just-init)
- Which stack? (python/javascript/java/polyglot)

**Automation:** User-standin reads package files (pyproject.toml, package.json, pom.xml)

### During Refactor (/just-refactor)
- Keep existing implementations?
- Which commands to stub?

**Automation:** Always preserve implementations, stub missing

### During Upgrade (/just-upgrade)
- Which level to add?
- Full level or specific pattern?

**Automation:** User-standin checks:
- Deploying? Add level 2 (security)
- CI exists? Add level 1 (quality)
- Cloud provider configured? Add level 3 (advanced)

## Success Criteria

### After Phase 2 (Init/Refactor)
- All 9 baseline commands present
- Exact comment strings
- check-all runs format → lint → typecheck → coverage
- `just check-all` succeeds

### After Phase 3 (Verify)
- `just dev-install` succeeds
- `just check-all` passes
- No errors, meaningful failures only

### After Phase 5 (Upgrade)
- New commands work
- Supporting files created
- Can run new commands successfully
- Assessment shows new level

## Common Paths

**Web application:**
0 (baseline) → 1 (quality) → 2 (security) → 3 (deployment)

**Library:**
0 (baseline) → 1 (quality) → 2 (security)
Skip level 3 (no deployment)

**Monorepo:**
0 (baseline) → 4 (polyglot) → 1 (quality) → 2 (security) → 3 (deployment)

**Solo project:**
0 (baseline) → 2 (security)
Skip level 1 (quality overhead not needed)

## Notes

- Assess before and after each phase
- Verify baseline before upgrading
- YAGNI - don't add unnecessary levels
- Can add patterns non-linearly
- Automation uses user-standin for decisions
