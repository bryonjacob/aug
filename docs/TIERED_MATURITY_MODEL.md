# Tiered Maturity Model

Philosophy for progressive capability addition across aug plugins.

## Principles

**Level 0 non-negotiable** - Baseline required for all projects

**Add levels as needed** - YAGNI enforcement. Don't add capabilities you don't use.

**Assessment-driven progression** - Know current level before advancing

**Non-linear allowed** - Can add specific patterns without completing full level

**"When" criteria define appropriateness** - Each level states when you need it

## Level Structure

### Level 0: Foundation

**Required:** All projects, no exceptions

**Contains:** Core capabilities every project needs (build, test, quality basics)

**Assessment:** Must be complete before considering other levels

### Level 1: Quality Gates

**When:** CI/CD pipeline, multiple developers, quality enforcement

**Contains:** Thresholds, metrics, separation of concerns

**Assessment:** Adds rigor to foundation

### Level 2: Security & Compliance

**When:** Production deployment, security requirements, compliance needs

**Contains:** Vulnerability scanning, license analysis, SBOM, dependency tracking

**Assessment:** Deployment readiness

### Level 3: Advanced Capabilities

**When:** Specific needs (deployment automation, performance analysis, etc.)

**Contains:** Domain-specific advanced features

**Assessment:** Tailored to project type

### Level 4: Special Architectures

**When:** Polyglot projects, distributed systems, monorepos

**Contains:** Cross-project orchestration, multi-language coordination

**Assessment:** Architectural complexity management

## Assessment Pattern

All maturity assessments follow this pattern:

**Current state:**
- Show current level
- List dimensions/commands present at that level
- Mark complete/incomplete

**Gaps:**
- What's missing from current level
- What's needed to complete it

**Next steps:**
- Recommend next level OR specific patterns
- Provide "when" guidance for advancement
- Suggest stopping point (YAGNI)

**Example output:**
```
Current Level: 1 (incomplete)

Level 0: Foundation [9/9] ✓
Level 1: Quality Gates [3/4]
  ✓ Coverage threshold (96%)
  ✓ Complexity check (≤10)
  ✓ Test separation
  ✗ Missing: test-watch

Next: Add test-watch to complete Level 1
Then: Consider Level 2 if deploying to production
Stop: Level 1 sufficient for libraries without deployment
```

## Progression Strategy

**Complete before advancing** - Finish current level before starting next

**Skip levels intentionally** - Can skip levels you don't need (document why)

**Pattern-specific addition** - Can add individual patterns without full level

**Typical paths:**

Web application: 0 → 1 → 2 → 3

Library: 0 → 1 → 2 (stop, no deployment)

Solo project: 0 → 2 (skip quality overhead, add security)

Monorepo: 0 → 1 → 4 → 2 → 3 (polyglot early, then security/deployment)

## Anti-Patterns

**Don't:**
- Skip level 0 (baseline non-negotiable)
- Add all levels (YAGNI violation)
- Advance without completing current level
- Add capabilities you don't use
- Ignore "when" criteria

**Do:**
- Complete level 0 first
- Add levels only when "when" criteria met
- Validate after each addition
- Document intentional skips
- Stop at appropriate level

## Domain Applications

This model applies across aug plugins:

**aug-just:** Justfile maturity (commands, patterns)

**aug-dev (stack-architect):** Development stack maturity (tools, dimensions)

**Future plugins:** Can adopt same structure for domain-specific maturity

Each domain defines:
- What dimensions/capabilities belong at each level
- Assessment criteria for that domain
- Domain-specific "when" criteria
- Typical progression paths for that domain
