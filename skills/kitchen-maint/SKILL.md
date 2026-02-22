# SKILL.md - kitchen-maint

Maintenance commands for kitchen-app React/TypeScript project.

## Commands

- `kitchen test` — Run tests with clean output
- `kitchen lint` — Run linter, show errors with file:line
- `kitchen build` — Production build with bundle size
- `kitchen check` — Full sweep: lint → test → build
- `kitchen outdated` — Check for outdated dependencies

## Setup

Run `kitchen install` to set up Git pre-commit hook.

## Usage

```bash
cd /app/.openclaw/workspace/kitchen-app
kitchen check    # Before committing
```
