-- ERID Database Schema
-- Executive Role Intelligence Dashboard
-- Version: 1.0.0

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- Executive Search Firms
CREATE TABLE IF NOT EXISTS exec_search_firms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    sector TEXT, -- Cybersecurity, Technology, Healthcare, etc.
    contact_name TEXT,
    contact_email TEXT,
    contact_phone TEXT,
    contact_linkedin TEXT,
    relationship TEXT CHECK(relationship IN ('cold', 'warm', 'referral', 'active', 'dormant')) DEFAULT 'cold',
    last_contact_date DATE,
    next_follow_up DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Job Applications Pipeline
CREATE TABLE IF NOT EXISTS applications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    company TEXT NOT NULL,
    role TEXT NOT NULL,
    source TEXT CHECK(source IN ('search_firm', 'direct', 'referral', 'linkedin', 'job_board', 'network')) DEFAULT 'search_firm',
    source_firm_id INTEGER REFERENCES exec_search_firms(id) ON DELETE SET NULL,
    stage TEXT CHECK(stage IN ('prospect', 'applied', 'screen', 'interview', 'final', 'offer', 'accepted', 'closed', 'rejected')) DEFAULT 'prospect',
    priority TEXT CHECK(priority IN ('high', 'medium', 'low')) DEFAULT 'medium',
    salary_range TEXT, -- e.g., "400-500k", "350k+equity"
    location TEXT,
    remote_policy TEXT, -- remote, hybrid, onsite
    application_date DATE,
    last_updated DATE,
    next_step TEXT,
    next_step_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CISO Mobility Signals (Market Intelligence)
CREATE TABLE IF NOT EXISTS ciso_mobility_signals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ciso_name TEXT NOT NULL,
    company TEXT NOT NULL,
    signal_type TEXT CHECK(signal_type IN ('announced departure', 'rumored departure', 'new hire', 'promotion', 'role change', 'board appointment', 'other')) DEFAULT 'announced departure',
    signal_date DATE NOT NULL,
    new_role TEXT,
    new_company TEXT,
    source TEXT, -- LinkedIn, news, direct, rumor
    confidence TEXT CHECK(confidence IN ('high', 'medium', 'low')) DEFAULT 'medium',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Action Items (Task Management)
CREATE TABLE IF NOT EXISTS action_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT CHECK(status IN ('pending', 'in_progress', 'completed', 'deferred', 'cancelled')) DEFAULT 'pending',
    priority TEXT CHECK(priority IN ('high', 'medium', 'low')) DEFAULT 'medium',
    due_date DATE,
    completed_date DATE,
    related_app_id INTEGER REFERENCES applications(id) ON DELETE CASCADE,
    related_firm_id INTEGER REFERENCES exec_search_firms(id) ON DELETE CASCADE,
    related_signal_id INTEGER REFERENCES ciso_mobility_signals(id) ON DELETE CASCADE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Advisory Opportunities
CREATE TABLE IF NOT EXISTS advisory_opportunities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    company TEXT NOT NULL,
    role TEXT NOT NULL,
    stage TEXT CHECK(stage IN ('discussion', 'agreed', 'active', 'ended', 'declined')) DEFAULT 'discussion',
    compensation TEXT, -- equity-only, cash+equity, retainer, etc.
    time_commitment TEXT, -- e.g., "5-10 hours/month"
    start_date DATE,
    end_date DATE,
    contact_name TEXT,
    contact_email TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- INTERVIEW TABLES (Integration with IPIS)
-- ============================================================================

-- Interview Sessions
CREATE TABLE IF NOT EXISTS interview_sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    application_id INTEGER NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    round_number INTEGER DEFAULT 1,
    round_name TEXT, -- e.g., "1st Round", "Final Round", "Case Study"
    interview_date DATE NOT NULL,
    interview_time TIME,
    format TEXT CHECK(format IN ('technical', 'behavioral', 'case', 'culture', 'panel', 'executive')) DEFAULT 'behavioral',
    interviewer_name TEXT,
    interviewer_role TEXT,
    interviewer_linkedin TEXT,
    duration_minutes INTEGER,
    notes TEXT,
    strengths TEXT,
    weaknesses TEXT,
    next_steps TEXT,
    follow_up_required BOOLEAN DEFAULT FALSE,
    follow_up_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Interview Questions & Answers
CREATE TABLE IF NOT EXISTS interview_questions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    interview_id INTEGER NOT NULL REFERENCES interview_sessions(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT,
    category TEXT CHECK(category IN ('technical', 'behavioral', 'leadership', 'strategy', 'culture', 'compensation')) DEFAULT 'behavioral',
    difficulty TEXT CHECK(difficulty IN ('easy', 'medium', 'hard')) DEFAULT 'medium',
    performance TEXT CHECK(performance IN ('excellent', 'good', 'average', 'poor')) DEFAULT 'average',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- REFERENCE TABLES
-- ============================================================================

-- Salary Benchmarks
CREATE TABLE IF NOT EXISTS salary_benchmarks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_title TEXT NOT NULL,
    company_size TEXT CHECK(company_size IN ('startup', 'growth', 'enterprise', 'public')) DEFAULT 'enterprise',
    location TEXT,
    base_salary_min INTEGER,
    base_salary_max INTEGER,
    total_comp_min INTEGER,
    total_comp_max INTEGER,
    equity_percent TEXT,
    source TEXT,
    source_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Company Intelligence
CREATE TABLE IF NOT EXISTS company_intelligence (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_name TEXT NOT NULL,
    industry TEXT,
    size TEXT,
    headquarters TEXT,
    known_for TEXT,
    recent_news TEXT,
    funding_round TEXT,
    valuation TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- RELATIONSHIP TABLES
-- ============================================================================

-- Application ↔ Search Firm Relationship (many-to-many)
CREATE TABLE IF NOT EXISTS application_firm_relationships (
    application_id INTEGER NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    firm_id INTEGER NOT NULL REFERENCES exec_search_firms(id) ON DELETE CASCADE,
    role TEXT, -- e.g., "primary", "secondary", "introduced"
    PRIMARY KEY (application_id, firm_id)
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Applications indexes
CREATE INDEX IF NOT EXISTS idx_applications_stage ON applications(stage);
CREATE INDEX IF NOT EXISTS idx_applications_priority ON applications(priority);
CREATE INDEX IF NOT EXISTS idx_applications_company ON applications(company);
CREATE INDEX IF NOT EXISTS idx_applications_created_at ON applications(created_at);

-- Search Firms indexes
CREATE INDEX IF NOT EXISTS idx_firms_name ON exec_search_firms(name);
CREATE INDEX IF NOT EXISTS idx_firms_relationship ON exec_search_firms(relationship);

-- CISO Signals indexes
CREATE INDEX IF NOT EXISTS idx_signals_date ON ciso_mobility_signals(signal_date);
CREATE INDEX IF NOT EXISTS idx_signals_company ON ciso_mobility_signals(company);

-- Action Items indexes
CREATE INDEX IF NOT EXISTS idx_actions_status ON action_items(status);
CREATE INDEX IF NOT EXISTS idx_actions_due_date ON action_items(due_date);
CREATE INDEX IF NOT EXISTS idx_actions_priority ON action_items(priority);

-- Interview indexes
CREATE INDEX IF NOT EXISTS idx_interviews_app_id ON interview_sessions(application_id);
CREATE INDEX IF NOT EXISTS idx_interviews_date ON interview_sessions(interview_date);

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Update timestamp trigger
CREATE TRIGGER IF NOT EXISTS update_applications_timestamp 
AFTER UPDATE ON applications
BEGIN
    UPDATE applications SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_firms_timestamp 
AFTER UPDATE ON exec_search_firms
BEGIN
    UPDATE exec_search_firms SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_signals_timestamp 
AFTER UPDATE ON ciso_mobility_signals
BEGIN
    UPDATE ciso_mobility_signals SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_actions_timestamp 
AFTER UPDATE ON action_items
BEGIN
    UPDATE action_items SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_advisory_timestamp 
AFTER UPDATE ON advisory_opportunities
BEGIN
    UPDATE advisory_opportunities SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_interviews_timestamp 
AFTER UPDATE ON interview_sessions
BEGIN
    UPDATE interview_sessions SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- ============================================================================
-- VIEWS
-- ============================================================================

-- Active Pipeline View
CREATE VIEW IF NOT EXISTS v_active_pipeline AS
SELECT 
    a.id,
    a.company,
    a.role,
    a.stage,
    a.priority,
    a.salary_range,
    a.last_updated,
    a.next_step,
    a.next_step_date,
    COUNT(DISTINCT i.id) as interview_count,
    GROUP_CONCAT(DISTINCT f.name) as search_firms
FROM applications a
LEFT JOIN interview_sessions i ON a.id = i.application_id
LEFT JOIN application_firm_relationships afr ON a.id = afr.application_id
LEFT JOIN exec_search_firms f ON afr.firm_id = f.id
WHERE a.stage NOT IN ('closed', 'rejected', 'accepted')
GROUP BY a.id
ORDER BY 
    CASE a.priority 
        WHEN 'high' THEN 1
        WHEN 'medium' THEN 2
        WHEN 'low' THEN 3
    END,
    a.next_step_date ASC;

-- Weekly Action Items View
CREATE VIEW IF NOT EXISTS v_weekly_actions AS
SELECT 
    id,
    title,
    priority,
    due_date,
    CASE 
        WHEN due_date < DATE('now') THEN 'overdue'
        WHEN due_date <= DATE('now', '+7 days') THEN 'due_this_week'
        ELSE 'future'
    END as urgency,
    CASE 
        WHEN related_app_id IS NOT NULL THEN 'application'
        WHEN related_firm_id IS NOT NULL THEN 'search_firm'
        WHEN related_signal_id IS NOT NULL THEN 'signal'
        ELSE 'general'
    END as category
FROM action_items
WHERE status = 'pending'
ORDER BY 
    CASE urgency
        WHEN 'overdue' THEN 1
        WHEN 'due_this_week' THEN 2
        ELSE 3
    END,
    CASE priority
        WHEN 'high' THEN 1
        WHEN 'medium' THEN 2
        WHEN 'low' THEN 3
    END;

-- Recent CISO Mobility View
CREATE VIEW IF NOT EXISTS v_recent_ciso_signals AS
SELECT 
    id,
    ciso_name,
    company,
    signal_type,
    signal_date,
    new_role,
    new_company,
    source,
    confidence,
    notes
FROM ciso_mobility_signals
WHERE signal_date >= DATE('now', '-30 days')
ORDER BY signal_date DESC;

-- Search Firm Relationship Dashboard
CREATE VIEW IF NOT EXISTS v_firm_relationships AS
SELECT 
    f.id,
    f.name,
    f.relationship,
    f.last_contact_date,
    f.next_follow_up,
    COUNT(DISTINCT a.id) as active_applications,
    COUNT(DISTINCT CASE WHEN a.stage IN ('interview', 'final', 'offer') THEN a.id END) as advanced_applications
FROM exec_search_firms f
LEFT JOIN application_firm_relationships afr ON f.id = afr.firm_id
LEFT JOIN applications a ON afr.application_id = a.id AND a.stage NOT IN ('closed', 'rejected', 'accepted')
GROUP BY f.id
ORDER BY 
    CASE f.relationship
        WHEN 'active' THEN 1
        WHEN 'warm' THEN 2
        WHEN 'referral' THEN 3
        WHEN 'cold' THEN 4
        ELSE 5
    END,
    f.next_follow_up ASC;

-- ============================================================================
-- INITIAL DATA (Optional)
-- ============================================================================

-- Insert common executive search firms
INSERT OR IGNORE INTO exec_search_firms (name, sector, relationship) VALUES
    ('Heidrick & Struggles', 'Cybersecurity', 'cold'),
    ('Korn Ferry', 'Technology', 'cold'),
    ('Spencer Stuart', 'Cybersecurity', 'cold'),
    ('Russell Reynolds', 'Technology', 'cold'),
    ('Egon Zehnder', 'Cybersecurity', 'cold'),
    ('Boyden', 'Technology', 'cold'),
    ('Odgers Berndtson', 'Cybersecurity', 'cold'),
    ('Caldwell', 'Technology', 'cold');

-- Insert common role titles for salary benchmarks
INSERT OR IGNORE INTO salary_benchmarks (role_title, company_size, location, base_salary_min, base_salary_max, total_comp_min, total_comp_max, source) VALUES
    ('CISO', 'enterprise', 'US', 350000, 550000, 450000, 800000, 'industry_avg'),
    ('VP Security', 'enterprise', 'US', 300000, 450000, 400000, 650000, 'industry_avg'),
    ('Director Security', 'enterprise', 'US', 200000, 350000, 250000, 450000, 'industry_avg'),
    ('CISO', 'growth', 'US', 250000, 400000, 350000, 600000, 'industry_avg'),
    ('VP Security', 'growth', 'US', 200000, 350000, 300000, 500000, 'industry_avg'),
    ('CISO', 'startup', 'US', 180000, 300000, 250000, 500000, 'industry_avg');

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================