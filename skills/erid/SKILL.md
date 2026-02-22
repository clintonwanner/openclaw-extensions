# ERID - Executive Role Intelligence Dashboard

## Skill Metadata
- **Name:** erid
- **Version:** 1.0.0
- **Author:** Clinton Wanner
- **Description:** Executive Role Intelligence Dashboard — track CISO/VP security roles, executive search firms, applications, and career signals
- **Category:** career/exec-job-search

## When to Use
- Active executive job searches at Director+ level
- Tracking CISO, VP Security, Director Security roles
- Managing relationships with executive search firms
- Monitoring executive mobility signals in the market
- Coordinating advisory opportunities alongside full-time roles

## When NOT to Use
- Entry-level or individual contributor job searches
- Non-executive roles (manager, senior IC)
- General networking without specific role targets
- Internship or new graduate recruiting

## Installation
```bash
clawhub install erid
```

## Dependencies
- sqlite3 (bundled with OpenClaw)
- OpenClaw CLI framework

## Data Location
- Database: `~/.openclaw/data/erid/erid.db`
- Config: `~/.openclaw/data/erid/config.json`
- Templates: `~/.openclaw/skills/erid/templates/`

## CLI Commands

### erid init
Initialize the ERID database and configuration.
```bash
erid init
```
Creates SQLite database with all executive tracking tables.

### erid status
Show executive pipeline summary dashboard.
```bash
erid status
```
Displays:
- Active applications by stage
- Pending action items
- Recent CISO mobility signals
- Advisory opportunities status
- Weekly activity metrics

### erid add-firm
Add executive search firm to tracking.
```bash
erid add-firm --name "Heidrick & Struggles" --sector "Cybersecurity" --contact "Jane Doe" --email "jane.doe@heidrick.com"
```
Flags:
- `--name`: Firm name (required)
- `--sector`: Practice area/sector focus
- `--contact`: Primary contact name
- `--email`: Contact email
- `--phone`: Contact phone
- `--linkedin`: Contact LinkedIn URL
- `--relationship`: warm|cold|referral (default: cold)
- `--notes`: Additional notes

### erid add-app
Add job application to pipeline.
```bash
erid add-app --company "Acme Corp" --role "VP Security" --source "Heidrick & Struggles" --salary-range "400-500k"
```
Flags:
- `--company`: Company name (required)
- `--role`: Role title (required)
- `--source`: How discovered (search firm, referral, direct)
- `--salary-range`: Expected compensation range
- `--location`: Role location/remote
- `--stage`: prospect|applied|screen|interview|final|offer|accepted|closed (default: prospect)
- `--priority`: high|medium|low (default: medium)
- `--notes`: Opportunity notes

### erid add-signal
Add CISO mobility signal.
```bash
erid add-signal --ciso "John Smith" --company "Target Corp" --signal "announced departure" --date "2026-02-20"
```
Flags:
- `--ciso`: CISO name (required)
- `--company`: Current/former company (required)
- `--signal`: Type of signal (required)
- `--date`: Signal date (default: today)
- `--new-role`: New position if known
- `--new-company`: New company if known
- `--source`: News source or LinkedIn
- `--notes`: Additional context

### erid complete
Mark action item as complete.
```bash
erid complete <action-id>
```

### erid add-action
Create new action item.
```bash
erid add-action --title "Follow up with Heidrick" --due "2026-02-25" --priority high
```
Flags:
- `--title`: Action description (required)
- `--due`: Due date (YYYY-MM-DD)
- `--priority`: high|medium|low (default: medium)
- `--related-app`: Related application ID
- `--related-firm`: Related search firm ID

### erid add-advisory
Track advisory opportunity.
```bash
erid add-advisory --company "StartupXYZ" --role "Security Advisor" --comp "equity-only"
```
Flags:
- `--company`: Company name (required)
- `--role`: Advisory title (required)
- `--comp`: Compensation structure
- `--stage`: discussion|agreed|active|ended (default: discussion)
- `--time-commitment`: Hours per month
- `--notes`: Additional details

### erid report
Generate weekly summary report.
```bash
erid report [--output markdown|json] [--days 7]
```
Saves report to `~/.openclaw/data/erid/reports/YYYY-MM-DD_weekly_report.md`

### erid interview
Add interview session record (from IPIS skill).
```bash
erid interview --app-id <id> --round "1st Round" --date "2026-02-20" --interviewer "CTO Jane"
```
Flags:
- `--app-id`: Related application ID (required)
- `--round`: Interview round/stage (required)
- `--date`: Interview date (default: today)
- `--interviewer`: Interviewer name/role
- `--format`: technical|behavioral|case|culture (default: behavioral)
- `--notes`: Interview notes
- `--next-steps`: Follow-up actions

### erid query
Run custom SQL queries against the database.
```bash
erid query "SELECT * FROM applications WHERE stage = 'interview'"
```

## Database Schema
See `schema.sql` for complete table definitions.

Key Tables:
- **applications**: Job application pipeline
- **exec_search_firms**: Executive search firm relationships
- **ciso_mobility_signals**: Market intelligence on executive moves
- **action_items**: Task and follow-up tracking
- **advisory_opportunities**: Advisory/board role tracking
- **interview_sessions**: Interview debriefs and notes
- **salary_benchmarks**: Compensation reference data

## Templates
Templates are available in `~/.openclaw/skills/erid/templates/`:
- `outreach-email.md`: Cold/warm outreach to search firms
- `interview-debrief.md`: Post-interview analysis template
- `weekly-report.md`: Weekly status report format

## Integration with IPIS
ERID integrates with the IPIS (Interview Performance Intelligence System) skill:
- Interview sessions synced between systems
- Shared application context
- Unified reporting across skills

## Workflows

### Weekly Review Workflow
1. Run `erid status` to see current pipeline
2. Run `erid report` to generate weekly summary
3. Review and complete action items
4. Update application stages based on week's activity
5. Add any new mobility signals detected

### Outreach Workflow
1. Identify target firm via `erid status` or research
2. Copy template: `cp ~/.openclaw/skills/erid/templates/outreach-email.md ~/draft.md`
3. Customize and send
4. Add firm: `erid add-firm --name "..." --relationship warm`
5. Create follow-up action: `erid add-action --title "Follow up with..."`

### Interview Debrief Workflow
1. Immediately post-interview: `erid interview --app-id <id> --round "..."`
2. Use template to structure notes
3. Identify action items and add via `erid add-action`
4. Update application stage if advancing: `erid update-app --id <id> --stage <new>`

## Tips & Best Practices

1. **Update Weekly**: Set a weekly calendar reminder to update ERID
2. **Signal Tracking**: Add mobility signals within 24 hours of detection
3. **Action Items**: Never end a search session with unrecorded action items
4. **Nurture Relationships**: Track all firm interactions, not just active roles
5. **Salary Data**: Record benchmarks even from informal conversations
6. **Advisory Balance**: Keep advisory opportunities visible alongside full-time search

## Export/Backup
```bash
# Backup database
cp ~/.openclaw/data/erid/erid.db ~/backups/erid-$(date +%Y%m%d).db

# Export applications to CSV
erid query "SELECT * FROM applications" --format csv > apps.csv
```

## Support
Skill issues: Open issue in OpenClaw/clawhub
Personal questions: Contact Clinton Wanner
