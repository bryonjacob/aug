---
name: yagni-dry-edit
description: Interactively audit prompt file for redundancy and unnecessary content
---

Audit prompt file (command/skill/agent) for YAGNI and DRY violations. Interactive section-by-section review.

## Instructions

### 1. Load File

Get file path from user. Read file.

### 2. Create Outline

Parse file structure:
- Frontmatter (name, description)
- H2 sections (## Title)
- H3 subsections (### Title)
- Content blocks (lists, prose, code)

Present outline:
```
File: {path}
Lines: {count}

Structure:
1. Frontmatter
2. {Section title} (lines X-Y)
   - {Subsection} (lines A-B)
   - {Subsection} (lines C-D)
3. {Section title} (lines M-N)
...
```

### 3. Analyze Each Section

For each section, create logical breakdown:

**Content type classification:**
- Rule: "MUST do X" / "NEVER do Y"
- Instruction: "Do X, then Y"
- Example: Demonstration of concept
- Explanation: Why/how something works
- Format: Template or structure definition

**Extract claims:**

Break content into atomic statements. Identify:
- What does this say? (claim)
- Does another section say the same thing? (redundancy)
- Is this used? Can we prove it's needed? (YAGNI)
- Is it implied by other claims? (derivable)

Present per section:
```
## Section: {title}

Claims:
1. [Line X] "Must do Y before Z"
   - Type: Rule
   - Used by: Step 2.3, Example 2
   - Redundancy: None

2. [Line Y] "This ensures correctness"
   - Type: Explanation
   - Adds value: No (derivable from Rule 1)
   - VERDICT: REMOVE

3. [Line Z] "You can also do A or B"
   - Type: Instruction
   - Used: No examples use A or B
   - VERDICT: YAGNI - remove unless proven needed
```

### 4. Discuss with User

For each REMOVE or YAGNI verdict:
- Show the claim
- Explain redundancy/YAGNI reasoning
- Ask: "Remove this? (y/n/revise)"

User can:
- `y` - Remove it
- `n` - Keep it (user proves it's needed)
- `revise: {text}` - Replace with tighter version

### 5. Apply Edits

After reviewing all sections:
- Collect all approved deletions
- Collect all revisions
- Apply edits to file
- Show before/after line count
- Show removed content summary

## Output Format

**Per section review:**
```
━━━ Section: {title} (lines X-Y) ━━━

Claims:
{numbered list with verdicts}

Recommendations:
- Remove: {count} explanations, {count} redundant rules
- Keep: {count} unique instructions
- Revise: {count} for concision

Continue to next section? (y/n)
```

**Final summary:**
```
━━━ Audit Complete ━━━

Original: {lines} lines, {words} words
After edits: {lines} lines, {words} words
Reduction: {percent}%

Removed:
- {count} redundant explanations
- {count} unused examples
- {count} derivable rules

Kept:
- {count} unique rules
- {count} essential instructions
- {count} clarifying examples

File updated: {path}
```

## Philosophy

**YAGNI (You Aren't Gonna Need It):**
- Remove examples never referenced
- Remove rules for edge cases not in scope
- Remove "you can also..." unless proven used

**DRY (Don't Repeat Yourself):**
- One canonical statement per concept
- Remove restatements, even in different words
- Remove explanations derivable from rules

**Lawyer reading:**
- Every sentence is a claim
- Identify exact logical content
- Find overlapping claim sets
- Merge or eliminate

**Prompts are code:**
- Redundancy creates inconsistency risk
- Unused features are bugs
- Clear beats comprehensive

## Notes

- Interactive: user approves each deletion
- Conservative: on ambiguity, ask user
- Measure: line/word counts before and after
- Preserve meaning: no semantic changes without user approval
