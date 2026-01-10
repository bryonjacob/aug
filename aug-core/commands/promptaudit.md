---
name: promptaudit
description: Audit prompt artifacts (skills, commands, agents) for anti-patterns and quality issues
---

# Prompt Audit

Analyze Claude Code prompt artifacts (skills, commands, agents) for anti-patterns, tracking changes to avoid re-scanning unchanged files.

## Usage

```bash
/promptaudit                    # Audit changed files only
/promptaudit --init             # Bootstrap .promptaudit.yaml only
/promptaudit --all              # Audit all files regardless of changes
/promptaudit path/to/file.md    # Audit specific file
/promptaudit --dry-run          # Report only, no state updates
```

## Anti-Patterns Checked

**YAGNI Violations:**
- Unused parameters or options defined
- Features described but not actionable
- Over-engineered structures

**Token Waste:**
- Redundant explanations
- Verbose phrasing where concise works
- Repeated information across sections
- Examples that don't add value

**Boundary Violations:**
- Skills acting like commands (procedural steps)
- Commands embedding skill-level knowledge
- Agents with hardcoded behaviors vs context-driven

**Structural Issues:**
- Missing required frontmatter fields
- Inconsistent heading hierarchy
- Dead references to other skills/commands

## Instructions

### 1. Check for .promptaudit.yaml

**If missing and not --init:**
- Report: "No .promptaudit.yaml found. Run `/promptaudit --init` to bootstrap."
- Exit

**If --init:**
- Create `.promptaudit.yaml` with:
  - Empty `audits:` section
  - `version: 1`
- Scan for existing prompt files
- Initialize each with current HEAD commit
- Report: "Initialized audit tracking for N files"
- Exit

**If exists:**
- Load current state
- Proceed with audit

### 2. Identify Files to Audit

**Default (no --all):**
```bash
# Find all prompt artifact files
find . -path "*/skills/*.md" -o -path "*/commands/*.md" -o -path "*/agents/*.md" | \
  grep -v CLAUDE.md | grep -v README.md
```

For each file, check if audit needed:
```bash
# Get last audited commit from .promptaudit.yaml
last_commit=$(yq ".audits[\"$file\"].commit" .promptaudit.yaml)

# Check if file changed since then
if git diff --quiet "$last_commit"..HEAD -- "$file" 2>/dev/null; then
  # No changes, skip
else
  # Changed or new, needs audit
fi
```

**With --all:**
- Audit every file regardless of change status

**With specific path:**
- Audit only that file

### 3. Audit Each File

For each file needing audit:

**Read the file content.**

**Analyze for anti-patterns:**

1. **YAGNI Check:**
   - Are all described features actually used/usable?
   - Are there parameters that serve no purpose?
   - Is there speculative functionality?

2. **Token Waste Check:**
   - Could explanations be shorter without losing meaning?
   - Are there redundant sections?
   - Do examples add value or just bulk?

3. **Boundary Check (based on file type):**

   *Skills (`*/skills/*.md`):*
   - Should be knowledge/principles, not procedures
   - Red flags: numbered step lists, "do this then that"
   - OK: concepts, patterns, decision frameworks

   *Commands (`*/commands/*.md`):*
   - Should be procedures referencing skills
   - Red flags: embedding domain knowledge inline
   - OK: step sequences, tool invocations, orchestration

   *Agents (`*/agents/*.md`):*
   - Should be context-driven decision makers
   - Red flags: hardcoded choices, no context gathering
   - OK: context analysis, evidence-based decisions

4. **Structural Check:**
   - Frontmatter has `name:` and `description:`
   - Heading hierarchy makes sense
   - References to other files exist (use `just refs` logic)

**Record findings:**
- List of issues found (if any)
- Severity: error (must fix) vs warning (consider fixing)

### 4. Generate Report

```
Prompt Artifact Audit Report
============================

Scanned: N files (M skipped - unchanged)

Issues Found:

  path/to/skill.md:
    ⚠ Token waste: Lines 45-60 repeat information from lines 10-25
    ⚠ YAGNI: Parameter `--verbose` described but never referenced

  path/to/command.md:
    ❌ Boundary violation: Embeds domain knowledge (lines 30-80)
       → Extract to skill, reference from command
    ⚠ Structural: Missing `description:` in frontmatter

  path/to/agent.md:
    ⚠ Boundary: Hardcoded decision at line 45
       → Should gather context and decide dynamically

Clean Files: K files passed all checks
  ✓ path/to/good-skill.md
  ✓ path/to/good-command.md
  ... (list all)

Summary:
  Errors: E (must fix)
  Warnings: W (consider fixing)
  Clean: K
```

### 5. Update .promptaudit.yaml

**If not --dry-run:**

Update audit records for scanned files:
```yaml
version: 1

audits:
  path/to/skill.md:
    commit: abc123
    date: 2025-01-06
    status: warning  # or: clean, error
    issues: 2
  path/to/command.md:
    commit: abc123
    date: 2025-01-06
    status: error
    issues: 1
  # ... all audited files
```

**If --dry-run:**
- Don't update file
- Report: "Dry run - state not updated"

### 6. Exit

**Exit code 0:** No errors found (warnings OK)
**Exit code 1:** Errors found that must be fixed

## Examples

### First Run (Bootstrap)

```bash
$ /promptaudit --init

Creating .promptaudit.yaml...

Found 45 prompt artifact files:
  Skills: 28
  Commands: 15
  Agents: 2

Initialized audit tracking at commit abc123

Next: Run '/promptaudit' to audit changed files
```

### Incremental Audit

```bash
$ /promptaudit

Prompt Artifact Audit Report
============================

Scanned: 3 files (42 skipped - unchanged)

Issues Found:

  aug-core/commands/new-command.md:
    ⚠ Token waste: Description section could be 50% shorter
    ⚠ Structural: Example code block not syntax-highlighted

Clean Files: 2 files passed all checks
  ✓ aug-dev/skills/updated-skill/SKILL.md
  ✓ aug-core/agents/user-standin.md

Summary:
  Errors: 0
  Warnings: 2
  Clean: 2

Updated .promptaudit.yaml
```

### Full Audit

```bash
$ /promptaudit --all

Prompt Artifact Audit Report
============================

Scanned: 45 files

Issues Found:
  ... (detailed list)

Summary:
  Errors: 1
  Warnings: 8
  Clean: 36

Exit code: 1 (errors found)
```

## Notes

- First run requires `--init` to bootstrap tracking
- Incremental by default - only audits changed files
- Uses git diff to detect changes since last audit
- Errors (boundary violations) should be fixed
- Warnings (token waste, YAGNI) are advisory
- Add `.promptaudit.yaml` to git for team consistency
