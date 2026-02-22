# Interview Performance Intelligence System (IPIS)

## Overview

The Interview Performance Intelligence System (IPIS) is a structured system for tracking, analyzing, and improving interview performance during executive job searches. It provides a systematic approach to post-interview debriefs, pattern analysis, and performance improvement.

## Quick Start

### 1. Initialize the Database
```bash
ipis init
```
This creates an `ipis.db` SQLite database with the necessary tables and triggers.

### 2. Start a Post-Interview Debrief
```bash
ipis debrief
```
Follow the interactive prompts to capture interview details while memory is fresh.

### 3. Review Patterns
```bash
ipis pattern
```
See common interview patterns, stumbling points, and performance trends.

### 4. Track Follow-ups
```bash
ipis thankyou
```
Mark thank-you notes as sent and track follow-up actions.

### 5. View Statistics
```bash
ipis stats
```
Get interview performance metrics and conversion rates.

## Database Schema

### interview_sessions Table
Stores all interview debrief data including:
- Company and role details
- Interviewer information
- Questions asked and responses
- Stumbling points and strong moments
- Follow-up actions and deadlines
- Pattern tags for analytics
- Outcome tracking (offer received/accepted)

### interview_patterns Table
Auto-updated analytics table that tracks:
- Pattern frequency across interviews
- Last occurrence date
- Performance trends (improving/stable/declining)

## Usage Examples

### Insert a Debrief Manually
```sql
INSERT INTO interview_sessions (
    company_name, role_title, interview_date, interview_type,
    interviewer_name, interviewer_title, interviewer_background,
    questions_asked, stumbling_points, strong_moments,
    follow_up_action, follow_up_deadline, thank_you_sent,
    lessons_learned, pattern_tags, notes,
    gaps_identified, offer_received, offer_accepted
) VALUES (
    'CyberGuard Solutions', 'VP of Security Architecture', '2026-02-20', 'video',
    'Sarah Johnson', 'CISO', '15 years financial services security',
    '["zero-trust architecture", "DevOps security", "APT incident response"]',
    'IPO alignment question, metrics for board ROI',
    'Strong zero-trust explanation, AP incident story',
    'Send whitepaper', '2026-02-23', 1,
    'Research company milestones, quantify everything',
    'strategy,technical_depth,executive_presence,gaps_identified',
    'Good chemistry with Sarah, board member engaged',
    'IPO security requirements, board-level metrics, financial services frameworks',
    0, 0
);
```

### Analytics Queries

#### Recent Interviews
```sql
SELECT company_name, interview_type, lessons_learned 
FROM interview_sessions 
WHERE interview_date > DATE('now', '-30 days')
ORDER BY interview_date DESC;
```

#### Common Patterns
```sql
SELECT tag, frequency, trend
FROM interview_patterns 
ORDER BY frequency DESC
LIMIT 10;
```

#### Interview-to-Offer Conversion
```sql
SELECT 
    COUNT(*) as total_interviews,
    SUM(CASE WHEN offer_received = 1 THEN 1 ELSE 0 END) as offers_received,
    SUM(CASE WHEN offer_accepted = 1 THEN 1 ELSE 0 END) as offers_accepted,
    ROUND(100.0 * SUM(CASE WHEN offer_received = 1 THEN 1 ELSE 0 END) / COUNT(*), 1) as offer_rate_percent,
    ROUND(100.0 * SUM(CASE WHEN offer_accepted = 1 THEN 1 ELSE 0 END) / COUNT(*), 1) as acceptance_rate_percent
FROM interview_sessions;
```

#### Knowledge Gaps Analysis
```sql
SELECT gaps_identified, COUNT(*) as frequency
FROM interview_sessions
WHERE gaps_identified IS NOT NULL AND gaps_identified != ''
GROUP BY gaps_identified
ORDER BY frequency DESC;
```

#### Follow-up Tracking
```sql
SELECT company_name, follow_up_action, follow_up_deadline,
       julianday(follow_up_deadline) - julianday('now') as days_remaining
FROM interview_sessions
WHERE follow_up_action != ''
  AND follow_up_deadline >= DATE('now')
ORDER BY days_remaining;
```

## Pattern Tags System

### Technical Tags
- **`technical_depth`**: Questions about specific security technologies, architectures
- **`incident_response`**: Incident handling, breach response scenarios
- **`vendor_management`**: Third-party security, tool selection, procurement
- **`compliance_governance`**: Regulatory requirements, audit, policy

### Leadership Tags
- **`team_leadership`**: Team building, management, scaling organizations
- **`budget_planning`**: Financial management, ROI, resource allocation
- **`executive_presence`**: Board communication, executive demeanor
- **`board_communications`**: Specifically board-level interactions

### Strategic Tags
- **`strategy`**: Long-term planning, business alignment, vision
- **`culture_fit`**: Company values, team dynamics, behavioral alignment

### Gap Tags
- **`gaps_identified`**: Knowledge or skill gaps identified during interview

## Auto-Update Trigger

The `auto_update_interview_patterns` trigger automatically maintains pattern analytics:
- **Trigger**: `auto_update_interview_patterns`
- **Event**: `AFTER INSERT ON interview_sessions`
- **Action**: Parses `pattern_tags`, updates `interview_patterns` frequency, last_occurrence, and trend
- **Benefit**: Eliminates manual SQL updates, ensures real-time pattern tracking

## Success Metrics

- **Debrief completion rate**: % of interviews with completed debriefs
- **Pattern recognition**: Number of identified improvement areas
- **Follow-up completion**: % of follow-ups completed on time
- **Interview-to-offer ratio**: Track improvement over time
- **Knowledge gaps identified**: Number of specific learning opportunities captured
- **Offer conversion rate**: Interviews → Offers → Acceptances

## Continuous Improvement Cycle

1. **Interview** → **Debrief** → **Save** → **Analyze** → **Learn** → **Improve**
2. **Weekly review** of patterns and lessons learned
3. **Monthly analysis** of performance trends
4. **Before each interview**: Review relevant patterns and past lessons

## CLI Command Reference

### `ipis init`
Initializes the IPIS database. Creates `ipis.db` with all necessary tables and triggers.

### `ipis debrief`
Interactive command that guides you through post-interview debrief capture. Asks questions about:
- Company and role details
- Interviewer information
- Questions asked and your responses
- Stumbling points and strong moments
- Follow-up actions
- Pattern tags

### `ipis pattern`
Shows common interview patterns and trends:
- Most frequent pattern tags
- Performance trends (improving/stable/declining)
- Recent occurrences

### `ipis thankyou`
Manages follow-up tracking:
- Lists interviews needing thank-you notes
- Allows marking thank-you as sent
- Tracks follow-up deadlines

### `ipis stats`
Provides performance statistics:
- Total interviews
- Offer conversion rates
- Common stumbling points
- Knowledge gaps identified
- Follow-up completion rates

## Template Files

The skill includes a comprehensive debrief template in `templates/debrief-template.md` that covers:
- Session information
- Interviewer details
- Questions asked
- Stumbling points and strong moments
- Lessons learned
- Knowledge gaps identified
- Follow-up actions
- Pattern tagging

## Troubleshooting

### Database Issues
If the database becomes corrupted:
```bash
rm ~/.openclaw/skills/ipis/ipis.db
ipis init
```

### Missing Triggers
If pattern analytics aren't updating:
```bash
sqlite3 ~/.openclaw/skills/ipis/ipis.db ".schema"
```
Check that the `auto_update_interview_patterns` trigger exists.

### Data Migration
To migrate from an existing applications.db:
```bash
sqlite3 /path/to/applications.db ".dump interview_sessions" | sqlite3 ~/.openclaw/skills/ipis/ipis.db
sqlite3 /path/to/applications.db ".dump interview_patterns" | sqlite3 ~/.openclaw/skills/ipis/ipis.db
```

## License
MIT License

---

*IPIS v1.0 - Created for Executive Job Search Performance Improvement*
*Last Updated: 2026-02-21*