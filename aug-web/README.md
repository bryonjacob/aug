# Aug-Web Plugin

Web development patterns for Next.js, static sites, and modern design systems.

## Skills

- **building-with-nextjs** - Next.js 15+ App Router, React 19 Server Components
- **building-static-sites** - Next.js static export, YAML content, deployment
- **styling-with-tailwind-cva** - Tailwind v4 + CVA design systems
- **integrating-formspree-forms** - Form handling for static sites

## Installation

```bash
/plugin install aug-web@aug
```

## Opinionated Choices

This plugin is highly opinionated for a specific stack:

| Choice | Rationale | Alternatives |
|--------|-----------|--------------|
| **Next.js 15+** | App Router, React Server Components | Remix, Nuxt, SvelteKit |
| **React 19** | Server Components, use hooks | Vue, Svelte, Solid |
| **App Router** | Server-first, layouts, streaming | Pages Router |
| **Tailwind v4** | Utility-first, CSS variables | styled-components, CSS modules |
| **CVA** | Type-safe component variants | Manual className logic |
| **Formspree** | No backend for static sites | Custom API, Netlify Forms |
| **Vitest** | Fast, Vite-compatible | Jest |
| **Playwright** | Cross-browser E2E | Cypress |

### Adaptation Guide

**This plugin is the most opinionated** in the aug collection. The specific framework/library choices are tightly coupled.

**What transfers:**
- Component-based architecture pattern
- Server/client separation concept
- Design system structure (tokens, variants)
- E2E testing approach

**What doesn't transfer:**
- Next.js-specific patterns (App Router, Server Components)
- Tailwind utility class approach
- CVA variant definitions

**For other frameworks:**
Study the patterns, then implement framework-specific versions. The skill structure (separate concerns, test thoroughly) applies universally.

## Dependencies

Extends `aug-dev:configuring-javascript-stack` for base JavaScript/TypeScript tooling.
