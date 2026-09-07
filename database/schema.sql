-- =============================================================================
-- VyaparMap (व्यापार-मानचित्र) Relational Database Schema
-- Smart India Hackathon (SIH) 2024 / MoSJE Problem Statement 26091
-- Ministry of Social Justice and Empowerment (MoSJE)
-- Target RDBMS: PostgreSQL 14+ / MySQL 8.0+ / SQLite 3
-- =============================================================================

-- Table 1: Registered Users & Micro-Entrepreneurs (r_users)
CREATE TABLE IF NOT EXISTS vyapar_r_users (
    id VARCHAR(10) PRIMARY KEY,                   -- 6-digit formatted ID, e.g., '000001'
    name VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(160) NOT NULL UNIQUE,
    password_hash VARCHAR(255),
    otp_delivery VARCHAR(10) DEFAULT 'SMS',       -- 'SMS' or 'Email'
    default_otp VARCHAR(10) DEFAULT '111111',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: Business Profiles / Verified Units (Owner Dashboard)
CREATE TABLE IF NOT EXISTS vyapar_business_registrations (
    id VARCHAR(40) PRIMARY KEY,
    user_id VARCHAR(10) REFERENCES vyapar_r_users(id) ON DELETE SET NULL,
    business_name VARCHAR(160) NOT NULL,
    business_type VARCHAR(80) NOT NULL,
    location VARCHAR(200) NOT NULL,
    city VARCHAR(80) NOT NULL,
    owner_name VARCHAR(120) NOT NULL,
    business_email VARCHAR(160),
    business_phone VARCHAR(20),
    land_area_sqft NUMERIC(10, 2) DEFAULT 0,
    avg_daily_footfall INTEGER DEFAULT 0,
    monthly_revenue NUMERIC(12, 2) DEFAULT 0,
    monthly_rent NUMERIC(12, 2) DEFAULT 0,
    is_verified BOOLEAN DEFAULT TRUE,
    registered_mode VARCHAR(20) DEFAULT 'existing', -- 'existing' (5a) or 'new' (5b)
    is_franchise_offered BOOLEAN DEFAULT FALSE,     -- Offered for franchise expansion
    registered_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table 3: Master Commercial Opportunities Catalog (m_business)
CREATE TABLE IF NOT EXISTS vyapar_m_business (
    id VARCHAR(40) PRIMARY KEY,
    name VARCHAR(160) NOT NULL,
    category VARCHAR(60) NOT NULL,
    startup_cost NUMERIC(12, 2) NOT NULL,
    monthly_revenue NUMERIC(12, 2) NOT NULL,
    roi_months INTEGER NOT NULL,
    competition_level VARCHAR(20) NOT NULL,         -- 'Low', 'Medium', 'High'
    competition_score NUMERIC(3, 1) NOT NULL,
    best_suited_for VARCHAR(255),
    description TEXT,
    emoji VARCHAR(10),
    match_score INTEGER DEFAULT 85,
    is_actual_data BOOLEAN DEFAULT TRUE,
    source_badge VARCHAR(80),
    apply_url VARCHAR(500)
);

-- Table 4: Franchise Expansion Applications / Inquiries
CREATE TABLE IF NOT EXISTS vyapar_franchise_inquiries (
    id VARCHAR(40) PRIMARY KEY,
    franchise_id VARCHAR(40) NOT NULL,
    brand_name VARCHAR(160) NOT NULL,
    applicant_name VARCHAR(120) NOT NULL,
    preferred_location VARCHAR(200) NOT NULL,
    investment_amount NUMERIC(14, 2) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(160) NOT NULL,
    status VARCHAR(30) DEFAULT 'UNDER_REVIEW',      -- 'UNDER_REVIEW', 'OFFER_DISPATCHED', 'APPROVED'
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table 5: Commercial Property Site Visits & Tour Bookings
CREATE TABLE IF NOT EXISTS vyapar_property_inquiries (
    id VARCHAR(40) PRIMARY KEY,
    property_id VARCHAR(40) NOT NULL,
    property_title VARCHAR(200) NOT NULL,
    applicant_name VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    preferred_date VARCHAR(40) NOT NULL,
    notes TEXT,
    status VARCHAR(30) DEFAULT 'SCHEDULED',         -- 'SCHEDULED', 'VISITED', 'NEGOTIATION'
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table 6: Business Inquiries & Internal Onboarding (Find Business Internal Portal)
CREATE TABLE IF NOT EXISTS vyapar_business_inquiries (
    id VARCHAR(40) PRIMARY KEY,
    business_name VARCHAR(160) NOT NULL,
    category VARCHAR(60) NOT NULL,
    applicant_name VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(160) NOT NULL,
    target_location VARCHAR(200) NOT NULL,
    available_margin NUMERIC(12, 2) NOT NULL,
    estimated_project_cost NUMERIC(12, 2) NOT NULL,
    scheme_preference VARCHAR(80),
    notes TEXT,
    status VARCHAR(30) DEFAULT 'APPLICATION_LOGGED',-- 'APPLICATION_LOGGED', 'DOCS_PENDING', 'PROCESSED'
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table 7: MoSJE Concessional Credit & Loan Applications (Problem Statement 26091)
CREATE TABLE IF NOT EXISTS vyapar_loan_applications (
    id VARCHAR(40) PRIMARY KEY,
    applicant_name VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(160) NOT NULL,
    village_or_block VARCHAR(200) NOT NULL,
    business_category VARCHAR(80) NOT NULL,
    margin_amount NUMERIC(12, 2) NOT NULL,          -- 10% Beneficiary Contribution
    project_cost NUMERIC(12, 2) NOT NULL,           -- Margin / 10%
    loan_amount NUMERIC(12, 2) NOT NULL,            -- 90% Concessional Credit (capped)
    scheme_tier VARCHAR(60) NOT NULL,               -- 'MICRO_FINANCE' (<=1.4L) or 'TERM_LOAN' (>1.4L to 50L)
    interest_rate NUMERIC(4, 2) NOT NULL,           -- 6.50% or 8.00%
    tenure_years INTEGER NOT NULL,                  -- 3 or 7 years
    moratorium_months INTEGER NOT NULL,             -- 3 or 6 months
    quarterly_installment NUMERIC(12, 2) NOT NULL,
    funding_agency VARCHAR(100) DEFAULT 'MoSJE State Channelizing Agency (SCA)',
    status VARCHAR(30) DEFAULT 'PRE_QUALIFIED',     -- 'PRE_QUALIFIED', 'FORWARDED_TO_SCA', 'DISBURSED'
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table 8: Real-Time SQL Transaction & Execution Audit Trail
CREATE TABLE IF NOT EXISTS vyapar_sql_transaction_logs (
    id VARCHAR(40) PRIMARY KEY,
    table_name VARCHAR(60) NOT NULL,
    operation VARCHAR(20) NOT NULL,                 -- 'INSERT', 'UPDATE', 'DELETE'
    sql_statement TEXT NOT NULL,
    executed_by VARCHAR(60) DEFAULT 'guest_or_user',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices for rapid indexing & search queries
CREATE INDEX IF NOT EXISTS idx_users_phone ON vyapar_r_users(phone);
CREATE INDEX IF NOT EXISTS idx_users_email ON vyapar_r_users(email);
CREATE INDEX IF NOT EXISTS idx_biz_reg_user ON vyapar_business_registrations(user_id);
CREATE INDEX IF NOT EXISTS idx_loans_applicant ON vyapar_loan_applications(phone);
CREATE INDEX IF NOT EXISTS idx_loans_tier ON vyapar_loan_applications(scheme_tier);
CREATE INDEX IF NOT EXISTS idx_inquiries_phone ON vyapar_business_inquiries(phone);
