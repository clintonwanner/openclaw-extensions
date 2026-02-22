-- IPIS Database Schema
-- Interview Performance Intelligence System

-- Core interview sessions table
CREATE TABLE IF NOT EXISTS interview_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    application_id INTEGER,
    company_name TEXT NOT NULL,
    role_title TEXT NOT NULL,
    interview_date DATE NOT NULL,
    interview_type TEXT CHECK(interview_type IN ('phone', 'video', 'onsite', 'final', 'board')),
    interviewer_name TEXT,
    interviewer_title TEXT,
    interviewer_background TEXT,
    questions_asked TEXT,
    stumbling_points TEXT,
    strong_moments TEXT,
    follow_up_action TEXT,
    follow_up_deadline DATE,
    thank_you_sent BOOLEAN DEFAULT 0,
    thank_you_date DATE,
    lessons_learned TEXT,
    pattern_tags TEXT,
    notes TEXT,
    created_date DATE DEFAULT CURRENT_DATE,
    gaps_identified TEXT,
    offer_received BOOLEAN DEFAULT 0,
    offer_accepted BOOLEAN DEFAULT 0
);

-- Pattern analytics table
CREATE TABLE IF NOT EXISTS interview_patterns (
    tag TEXT PRIMARY KEY,
    frequency INTEGER DEFAULT 1,
    average_performance TEXT CHECK(average_performance IN ('weak', 'average', 'strong')),
    last_occurrence DATE,
    trend TEXT CHECK(trend IN ('improving', 'declining', 'stable'))
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_interview_date ON interview_sessions(interview_date);
CREATE INDEX IF NOT EXISTS idx_company ON interview_sessions(company_name);
CREATE INDEX IF NOT EXISTS idx_pattern_tags ON interview_sessions(pattern_tags);
CREATE INDEX IF NOT EXISTS idx_offer_status ON interview_sessions(offer_received, offer_accepted);
CREATE INDEX IF NOT EXISTS idx_follow_up ON interview_sessions(follow_up_deadline) WHERE follow_up_deadline IS NOT NULL;

-- Auto-update trigger for pattern analytics
CREATE TRIGGER IF NOT EXISTS auto_update_interview_patterns
AFTER INSERT ON interview_sessions
BEGIN
    -- Parse pattern_tags (comma-separated) and update interview_patterns
    INSERT OR REPLACE INTO interview_patterns (tag, frequency, last_occurrence, trend)
    WITH split_tags AS (
        SELECT trim(value) as tag
        FROM json_each('["' || replace(NEW.pattern_tags, ',', '","') || '"]')
        WHERE value != ''
    )
    SELECT 
        tag,
        COALESCE((SELECT frequency FROM interview_patterns ip WHERE ip.tag = split_tags.tag), 0) + 1,
        NEW.interview_date,
        CASE 
            WHEN (SELECT frequency FROM interview_patterns ip2 WHERE ip2.tag = split_tags.tag) IS NULL THEN 'improving'
            WHEN (SELECT frequency FROM interview_patterns ip3 WHERE ip3.tag = split_tags.tag) < 
                 (SELECT AVG(frequency) FROM interview_patterns) THEN 'improving'
            ELSE 'stable'
        END
    FROM split_tags;
END;

-- Update trigger for existing records
CREATE TRIGGER IF NOT EXISTS update_interview_patterns_on_update
AFTER UPDATE OF pattern_tags ON interview_sessions
WHEN NEW.pattern_tags != OLD.pattern_tags
BEGIN
    -- Remove old tags
    DELETE FROM interview_patterns 
    WHERE tag IN (
        SELECT trim(value) as tag
        FROM json_each('["' || replace(OLD.pattern_tags, ',', '","') || '"]')
        WHERE value != ''
    );
    
    -- Add new tags
    INSERT OR REPLACE INTO interview_patterns (tag, frequency, last_occurrence, trend)
    WITH split_tags AS (
        SELECT trim(value) as tag
        FROM json_each('["' || replace(NEW.pattern_tags, ',', '","') || '"]')
        WHERE value != ''
    )
    SELECT 
        tag,
        COALESCE((SELECT frequency FROM interview_patterns ip WHERE ip.tag = split_tags.tag), 0) + 1,
        NEW.interview_date,
        CASE 
            WHEN (SELECT frequency FROM interview_patterns ip2 WHERE ip2.tag = split_tags.tag) IS NULL THEN 'improving'
            WHEN (SELECT frequency FROM interview_patterns ip3 WHERE ip3.tag = split_tags.tag) < 
                 (SELECT AVG(frequency) FROM interview_patterns) THEN 'improving'
            ELSE 'stable'
        END
    FROM split_tags;
END;