---
name: code-patterns
description: Learn project conventions, detect patterns, suggest consistency improvements
---

# Code Patterns Skill

Statistical analysis to derive project conventions from code.

## Core Principle

"What's the convention here?" - Derive from code, not impose external standards.

## Pattern Types

### 1. Error Handling
- try/except vs if/else vs result types
- Error classes, logging patterns, error propagation

### 2. Testing Conventions
- Test file/function naming
- Fixture usage, mock patterns, assertion style

### 3. Code Organization
- Import style (absolute vs relative), grouping
- Module structure, file/directory naming

### 4. Naming Conventions
- Functions, classes, constants, private members, booleans

### 5. Architecture Patterns
- Dependency injection style
- Layer separation, return types, config access

### 6. Code Style
- Line length, quote style, trailing commas, whitespace

## Analysis Method

### Statistical Pattern Detection

1. **Scan:** Find all instances of pattern type, categorize by approach, count
2. **Calculate:** `adoption_rate = count(pattern) / count(all_instances)`
3. **Determine convention:**
   - >=80% = strong convention
   - 60-79% = weak convention
   - <60% = no clear convention

### Detection Techniques

**AST Parsing (preferred):** Use language-specific parsers for accurate structure analysis.

**Regex Matching (fallback):** For simple patterns when AST unavailable.

### Diff Analysis

Compare file to detected conventions:
1. Analyze file using same methods
2. Compare to project conventions
3. Identify deviations (using minority pattern, mixing patterns, inconsistent with nearby code)

## Convention Thresholds

- **Strong (>=80%):** Follow in new code, refactor non-conforming
- **Weak (60-79%):** Standardize, document in CONVENTIONS.md
- **None (<60%):** Team decision needed

## Output Format

```
[Pattern Type] Patterns
=======================

Analyzed: <N> instances

Pattern Distribution:
  [Pattern A]: <count> (<percent>%) <- Convention
  [Pattern B]: <count> (<percent>%)

Convention: [Pattern A] (<percent>% adoption)
Status: Strong|Weak|None

Example:
  [code showing convention]

Module Adoption:
  [module]: [percent]% ([count]/[total])

Non-conforming files:
  [file]: [reason]
```

## Limitations

- **Statistical, not semantic:** Can't understand intent, only usage
- **Language-specific:** AST parsing requires language-specific parsers
- **Project-scoped:** No cross-repo learning, pure project-specific detection

## Philosophy

- **Descriptive, not prescriptive** - Learn from code, don't impose external rules
- **Statistical, not dogmatic** - 80% = convention, but context matters
- **Consistency over perfection** - Clear convention beats "best" approach
- **Team-specific** - Each project defines conventions through usage
