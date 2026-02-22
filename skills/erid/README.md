# ERID Skill (Executive Role Intelligence Dashboard)

This is a reusable OpenClaw skill for tracking executive-level cybersecurity leadership opportunities. It includes a SQLite DB schema, CLI commands (erid init, erid status, erid add-firm, erid add-app, erid complete, erid report, erid interview, erid query), templates, and integration notes.

## Quick Start
1. Install the skill via clawhub:
```
clawhub install erid
```
2. Initialize database:
```
erid init
```

## Database
- Schema located at /app/.openclaw/workspace/skills/erid/schema.sql
- Example view: v_active_pipeline

## CLI Overview
- erid init
- erid status
- erid add-firm
- erid add-app
- erid complete
- erid report
- erid interview
- erid query

## Templates
- Outreach email: templates/outreach-email.md
- Interview debrief: templates/interview-debrief.md
- Weekly report: templates/weekly-report.md

## IPIS Integration
ERID integrates with IPIS via interview sessions and shared applications context.

## Data Model Overview
- Core tables: exec_search_firms, applications, ciso_mobility_signals, action_items, advisory_opportunities, interview_sessions
- Related structures: application_firm_relationships, salary_benchmarks, interview_questions

## Contact
For issues, open an OpenClaw issue or contact Clinton Wanner.
