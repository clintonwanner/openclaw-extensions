# IPIS Skill

## Metadata
- **Name**: ipis
- **Version**: 1.0.0
- **Author**: Clinton Wanner
- **Description**: Interview Performance Intelligence System — track debriefs, identify patterns, improve performance
- **Category**: productivity, job-search, analytics

## Overview
IPIS is a structured system for tracking, analyzing, and improving interview performance during executive job searches. It provides a systematic approach to post-interview debriefs, pattern analysis, and performance improvement.

## When to Use
- Active executive interviews (Director+ level roles)
- Post-interview debriefs while memory is fresh
- Identifying recurring patterns in interview questions and stumbling points
- Tracking follow-up actions and thank-you notes
- Analyzing interview-to-offer conversion rates

## Installation
```bash
clawhub install ipis
```

## CLI Commands
- `ipis init` — Initialize database
- `ipis debrief` — Start post-interview capture
- `ipis pattern` — Show common patterns/trends
- `ipis thankyou` — Mark thank-you as sent
- `ipis stats` — Interview performance summary

## Dependencies
- SQLite3
- OpenClaw CLI

## Database Schema
The skill creates and manages two tables:
1. `interview_sessions` - Core debrief data
2. `interview_patterns` - Auto-updated pattern analytics

## Files
- `schema.sql` - Database schema and triggers
- `README.md` - Complete usage guide
- `templates/debrief-template.md` - Post-interview template

## License
MIT