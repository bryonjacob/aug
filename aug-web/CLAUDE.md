# Module: Aug-Web Plugin

## Purpose

Web development patterns and tooling for Next.js, static sites, Tailwind CSS design systems, and form handling. Extends aug-dev's JavaScript stack with web-specific workflows.

## Responsibilities

- Next.js 15+ App Router and Server Components patterns
- Static site generation and deployment
- Tailwind CSS v4 + CVA design systems
- Form handling for static sites (Formspree)

## Key Files

### Skills (`skills/`)
- `building-with-nextjs/` - Next.js 15+ App Router, React 19 Server Components, Vitest, Playwright
- `building-static-sites/` - Next.js static export, YAML content, GitHub Pages/Netlify deployment
- `styling-with-tailwind-cva/` - Tailwind v4 + CVA design systems with CSS variables
- `integrating-formspree-forms/` - Formspree form handling without backend

## Public Interface

All skills available for reference using `@skill-name` syntax.

## Dependencies

- **Uses:** aug-dev's `configuring-javascript-stack` for base tooling
- **Used by:** Web developers building Next.js applications and static sites

## Architecture Decisions

**Next.js Focus:**
- App Router (not Pages Router)
- Server Components by default
- TypeScript strict mode
- Vitest for unit tests, Playwright for E2E

**Static Sites:**
- YAML-based content management
- GitHub Pages/Netlify deployment
- Form handling via Formspree (no backend needed)

**Design Systems:**
- Tailwind v4 utility-first approach
- CVA for type-safe component variants
- CSS variables for design tokens

## Plugin Metadata

Defined in `.claude-plugin/plugin.json`:
- Name: `aug-web`
- Version: `1.2.0`
- Category: `development`
- Keywords: nextjs, react, tailwind, static-sites, web
