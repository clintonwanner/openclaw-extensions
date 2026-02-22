#!/bin/bash
# Test script for IPIS skill

echo "Testing IPIS skill installation..."
echo ""

# Test 1: Check required files exist
echo "1. Checking required files..."
REQUIRED_FILES=(
    "SKILL.md"
    "schema.sql"
    "README.md"
    "templates/debrief-template.md"
    "ipis.sh"
    "install.sh"
)

all_files_exist=true
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$HOME/.openclaw/skills/ipis/$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
        all_files_exist=false
    fi
done

if [ "$all_files_exist" = false ]; then
    echo "Some required files are missing!"
    exit 1
fi

echo ""
echo "2. Testing schema.sql syntax..."
if sqlite3 :memory: < "$HOME/.openclaw/skills/ipis/schema.sql" 2>/dev/null; then
    echo "  ✅ schema.sql is valid SQL"
else
    echo "  ❌ schema.sql has syntax errors"
    exit 1
fi

echo ""
echo "3. Testing CLI script..."
if bash -n "$HOME/.openclaw/skills/ipis/ipis.sh" 2>/dev/null; then
    echo "  ✅ ipis.sh has valid bash syntax"
else
    echo "  ❌ ipis.sh has syntax errors"
    exit 1
fi

echo ""
echo "4. Testing installation script..."
if bash -n "$HOME/.openclaw/skills/ipis/install.sh" 2>/dev/null; then
    echo "  ✅ install.sh has valid bash syntax"
else
    echo "  ❌ install.sh has syntax errors"
    exit 1
fi

echo ""
echo "5. Checking database schema matches source..."
# Extract table structure from schema.sql
TEMP_DB="/tmp/ipis_test.db"
rm -f "$TEMP_DB"
sqlite3 "$TEMP_DB" < "$HOME/.openclaw/skills/ipis/schema.sql"

SOURCE_DB="/app/.openclaw/workspace/job-search/applications.db"

# Compare interview_sessions table structure
echo "  Comparing interview_sessions table..."
sqlite3 "$TEMP_DB" "PRAGMA table_info(interview_sessions);" > /tmp/ipis_new.txt
sqlite3 "$SOURCE_DB" "PRAGMA table_info(interview_sessions);" > /tmp/ipis_source.txt

if diff -q /tmp/ipis_new.txt /tmp/ipis_source.txt >/dev/null; then
    echo "  ✅ interview_sessions schema matches source"
else
    echo "  ❌ interview_sessions schema differs from source"
    echo "  Differences:"
    diff /tmp/ipis_new.txt /tmp/ipis_source.txt
    exit 1
fi

# Compare interview_patterns table structure
echo "  Comparing interview_patterns table..."
sqlite3 "$TEMP_DB" "PRAGMA table_info(interview_patterns);" > /tmp/patterns_new.txt
sqlite3 "$SOURCE_DB" "PRAGMA table_info(interview_patterns);" > /tmp/patterns_source.txt

if diff -q /tmp/patterns_new.txt /tmp/patterns_source.txt >/dev/null; then
    echo "  ✅ interview_patterns schema matches source"
else
    echo "  ❌ interview_patterns schema differs from source"
    echo "  Differences:"
    diff /tmp/patterns_new.txt /tmp/patterns_source.txt
    exit 1
fi

echo ""
echo "✅ All tests passed!"
echo ""
echo "IPIS skill is ready for use."
echo "To install:"
echo "  1. Run: ~/.openclaw/skills/ipis/install.sh"
echo "  2. Then use: ipis init"
echo "  3. Start capturing debriefs: ipis debrief"