#!/bin/bash
# IPIS CLI - Interview Performance Intelligence System

DB_PATH="$HOME/.openclaw/skills/ipis/ipis.db"
SCHEMA_PATH="$HOME/.openclaw/skills/ipis/schema.sql"

init_db() {
    if [ -f "$DB_PATH" ]; then
        echo "Database already exists at $DB_PATH"
        echo "Use 'ipis reset' to recreate it (warning: deletes all data)"
        return 1
    fi
    
    echo "Initializing IPIS database..."
    sqlite3 "$DB_PATH" < "$SCHEMA_PATH"
    
    if [ $? -eq 0 ]; then
        echo "✅ Database created successfully at $DB_PATH"
        echo "Tables created:"
        sqlite3 "$DB_PATH" ".tables"
    else
        echo "❌ Failed to create database"
        return 1
    fi
}

debrief() {
    if [ ! -f "$DB_PATH" ]; then
        echo "Database not found. Run 'ipis init' first."
        return 1
    fi
    
    echo "📝 Starting post-interview debrief..."
    echo "Please answer the following questions:"
    echo ""
    
    read -p "Company name: " company
    read -p "Role title: " role
    read -p "Interview date (YYYY-MM-DD): " date
    read -p "Interview type (phone/video/onsite/final/board): " type
    
    echo ""
    echo "Interviewer details:"
    read -p "Interviewer name: " interviewer_name
    read -p "Interviewer title: " interviewer_title
    
    echo ""
    echo "Key questions asked (one per line, empty line to finish):"
    questions=""
    while true; do
        read -p "> " question
        [ -z "$question" ] && break
        questions="${questions}${question}; "
    done
    
    echo ""
    echo "Stumbling points (one per line, empty line to finish):"
    stumbles=""
    while true; do
        read -p "> " stumble
        [ -z "$stumble" ] && break
        stumbles="${stumbles}${stumble}; "
    done
    
    echo ""
    echo "Strong moments (one per line, empty line to finish):"
    strong=""
    while true; do
        read -p "> " moment
        [ -z "$moment" ] && break
        strong="${strong}${moment}; "
    done
    
    echo ""
    echo "Pattern tags (comma-separated, e.g., technical_depth,strategy):"
    read -p "Tags: " tags
    
    echo ""
    echo "Saving debrief to database..."
    
    sqlite3 "$DB_PATH" <<EOF
INSERT INTO interview_sessions (
    company_name, role_title, interview_date, interview_type,
    interviewer_name, interviewer_title,
    questions_asked, stumbling_points, strong_moments, pattern_tags
) VALUES (
    '$company', '$role', '$date', '$type',
    '$interviewer_name', '$interviewer_title',
    '$questions', '$stumbles', '$strong', '$tags'
);
EOF
    
    if [ $? -eq 0 ]; then
        echo "✅ Debrief saved successfully!"
        echo "Pattern analytics updated automatically via trigger."
    else
        echo "❌ Failed to save debrief"
    fi
}

pattern() {
    if [ ! -f "$DB_PATH" ]; then
        echo "Database not found. Run 'ipis init' first."
        return 1
    fi
    
    echo "📊 Interview Pattern Analysis"
    echo "============================="
    echo ""
    
    echo "Most Common Patterns:"
    sqlite3 -column -header "$DB_PATH" <<EOF
SELECT tag as Pattern, frequency as Count, trend as Trend
FROM interview_patterns 
ORDER BY frequency DESC 
LIMIT 10;
EOF
    
    echo ""
    echo "Recent Pattern Occurrences:"
    sqlite3 -column -header "$DB_PATH" <<EOF
SELECT tag as Pattern, last_occurrence as Last_Seen
FROM interview_patterns 
ORDER BY last_occurrence DESC 
LIMIT 10;
EOF
}

thankyou() {
    if [ ! -f "$DB_PATH" ]; then
        echo "Database not found. Run 'ipis init' first."
        return 1
    fi
    
    echo "📧 Thank-You Note Tracking"
    echo "=========================="
    echo ""
    
    echo "Interviews needing thank-you notes:"
    sqlite3 -column -header "$DB_PATH" <<EOF
SELECT id, company_name, interview_date, interviewer_name
FROM interview_sessions 
WHERE thank_you_sent = 0
ORDER BY interview_date DESC;
EOF
    
    echo ""
    read -p "Enter interview ID to mark thank-you as sent (or press Enter to skip): " id
    
    if [ -n "$id" ]; then
        sqlite3 "$DB_PATH" "UPDATE interview_sessions SET thank_you_sent = 1, thank_you_date = DATE('now') WHERE id = $id;"
        if [ $? -eq 0 ]; then
            echo "✅ Thank-you marked as sent for interview #$id"
        else
            echo "❌ Failed to update thank-you status"
        fi
    fi
}

stats() {
    if [ ! -f "$DB_PATH" ]; then
        echo "Database not found. Run 'ipis init' first."
        return 1
    fi
    
    echo "📈 Interview Performance Statistics"
    echo "=================================="
    echo ""
    
    echo "Overall Metrics:"
    sqlite3 -column -header "$DB_PATH" <<EOF
SELECT 
    COUNT(*) as 'Total Interviews',
    SUM(CASE WHEN offer_received = 1 THEN 1 ELSE 0 END) as 'Offers Received',
    SUM(CASE WHEN offer_accepted = 1 THEN 1 ELSE 0 END) as 'Offers Accepted',
    ROUND(100.0 * SUM(CASE WHEN offer_received = 1 THEN 1 ELSE 0 END) / COUNT(*), 1) as 'Offer Rate %',
    ROUND(100.0 * SUM(CASE WHEN offer_accepted = 1 THEN 1 ELSE 0 END) / COUNT(*), 1) as 'Acceptance Rate %'
FROM interview_sessions;
EOF
    
    echo ""
    echo "Interview Types:"
    sqlite3 -column -header "$DB_PATH" <<EOF
SELECT 
    interview_type as Type,
    COUNT(*) as Count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM interview_sessions), 1) as 'Percentage %'
FROM interview_sessions
GROUP BY interview_type
ORDER BY Count DESC;
EOF
    
    echo ""
    echo "Follow-up Status:"
    sqlite3 -column -header "$DB_PATH" <<EOF
SELECT 
    COUNT(*) as 'Total Follow-ups',
    SUM(CASE WHEN thank_you_sent = 1 THEN 1 ELSE 0 END) as 'Thank-You Sent',
    ROUND(100.0 * SUM(CASE WHEN thank_you_sent = 1 THEN 1 ELSE 0 END) / COUNT(*), 1) as 'Completion %'
FROM interview_sessions
WHERE follow_up_action != '';
EOF
}

reset() {
    read -p "⚠️  This will delete ALL IPIS data. Are you sure? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Reset cancelled."
        return 0
    fi
    
    if [ -f "$DB_PATH" ]; then
        rm "$DB_PATH"
        echo "Database deleted."
    fi
    
    init_db
}

help() {
    echo "IPIS CLI - Interview Performance Intelligence System"
    echo "Usage: ipis <command>"
    echo ""
    echo "Commands:"
    echo "  init     - Initialize database"
    echo "  debrief  - Start post-interview capture"
    echo "  pattern  - Show common patterns/trends"
    echo "  thankyou - Mark thank-you as sent"
    echo "  stats    - Interview performance summary"
    echo "  reset    - Reset database (deletes all data)"
    echo "  help     - Show this help"
    echo ""
    echo "Database: $DB_PATH"
}

# Main command handler
case "$1" in
    init)
        init_db
        ;;
    debrief)
        debrief
        ;;
    pattern)
        pattern
        ;;
    thankyou)
        thankyou
        ;;
    stats)
        stats
        ;;
    reset)
        reset
        ;;
    help|"")
        help
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use 'ipis help' for available commands."
        exit 1
        ;;
esac