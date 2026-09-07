-- =============================================================================
-- VyaparMap (व्यापार-मानचित्र) Master SQL Database Dump
-- Generated for SIH Problem Statement 26091 - MoSJE
-- Includes Schema DDL, Seed Records, and Production-Ready Test Data
-- =============================================================================

BEGIN TRANSACTION;

-- Table 1: Seed Users
INSERT INTO vyapar_r_users (id, name, phone, email, password_hash, otp_delivery, default_otp, created_at)
VALUES
  ('000001', 'Abhinav Choudhary', '9999999999', 'Abhinav@gmail.com', 'argon2@123', 'Email', '111111', '2026-01-15 10:00:00+05:30'),
  ('000002', 'Ramesh Chandra Verma', '9829012345', 'ramesh.verma@vyaparmap.in', 'argon2@123', 'SMS', '111111', '2026-02-01 11:30:00+05:30'),
  ('000003', 'Sunita Devi Meghwal', '9414056789', 'sunita.meghwal@gramin.org', 'argon2@123', 'SMS', '111111', '2026-02-18 14:15:00+05:30');

-- Table 2: Seed Business Registrations
INSERT INTO vyapar_business_registrations (id, user_id, business_name, business_type, location, city, owner_name, business_email, business_phone, land_area_sqft, avg_daily_footfall, monthly_revenue, monthly_rent, is_verified, registered_mode, is_franchise_offered, registered_at)
VALUES
  ('biz-001', '000001', 'Atrix Cafe', 'Cafe & Specialty Coffee', 'C-Scheme, Near Statue Circle', 'Jaipur', 'Abhinav Choudhary', 'business@atrixcafe.in', '9999999999', 650, 520, 485000, 62000, TRUE, 'existing', TRUE, '2026-01-16 12:00:00+05:30'),
  ('biz-002', '000002', 'Verma Agro Processing & Dal Mill', 'Agro-Processing', 'Bassi Industrial Cluster', 'Jaipur', 'Ramesh Chandra Verma', 'ramesh.verma@vyaparmap.in', '9829012345', 1200, 180, 240000, 22000, TRUE, 'new', FALSE, '2026-02-02 09:30:00+05:30');

-- Table 3: Seed MoSJE Concessional Loan Applications (SIH 26091)
INSERT INTO vyapar_loan_applications (id, applicant_name, phone, email, village_or_block, business_category, margin_amount, project_cost, loan_amount, scheme_tier, interest_rate, tenure_years, moratorium_months, quarterly_installment, funding_agency, status, submitted_at)
VALUES
  ('LOAN-26091-001', 'Sunita Devi Meghwal', '9414056789', 'sunita.meghwal@gramin.org', 'Chomu Block, Gram Panchayat Morija', 'Dairy & Cattle Farming', 14000.00, 140000.00, 125000.00, 'MICRO_FINANCE', 6.50, 3, 3, 11520.00, 'Rajasthan SC/ST Finance & Dev Corp (SCA/MoSJE)', 'PRE_QUALIFIED', '2026-02-20 16:20:00+05:30'),
  ('LOAN-26091-002', 'Ramesh Chandra Verma', '9829012345', 'ramesh.verma@vyaparmap.in', 'Bassi Block, Jaipur Rural', 'Agro-Processing & Dal Mill', 100000.00, 1000000.00, 900000.00, 'TERM_LOAN', 8.00, 7, 6, 42180.00, 'National Backward Classes Finance & Dev Corp (NBCFDC/MoSJE)', 'PRE_QUALIFIED', '2026-02-22 10:45:00+05:30'),
  ('LOAN-26091-003', 'Kailash Chand Raigar', '9829077777', 'kailash.cobbler@vyaparmap.in', 'Sanganer Tehsil, Amber Mojari Cluster', 'Traditional Handcrafted Mojari Workshop', 10000.00, 100000.00, 90000.00, 'MICRO_FINANCE', 6.50, 3, 3, 8294.00, 'Rajasthan SC/ST Dev Corp / PM Vishwakarma Co-Option', 'PRE_QUALIFIED', '2026-03-02 11:20:00+05:30');

-- Table 3B: Seed Master Micro-Business Catalog (m_business)
INSERT INTO vyapar_m_business (id, name, category, startup_cost, monthly_revenue, roi_months, competition_level, competition_score, best_suited_for, description, emoji, match_score, is_actual_data, source_badge, apply_url)
VALUES
  ('mb-leather-01', 'Traditional Handcrafted Mojari & Jutti Workshop', 'leather_footwear', 80000.00, 65000.00, 5, 'High', 9.4, 'Artisan cobblers leveraging PM Vishwakarma + MoSJE Micro Finance', 'Artisanal handcrafted leather Mojaris in Sanganer/Amber cluster with 28% raw material savings.', '👞', 96, TRUE, 'PM Vishwakarma + MoSJE 6.5%', 'https://pmvishwakarma.gov.in/'),
  ('mb-repair-01', 'Laptop, PC & Hardware Component Repair Center', 'repair_services', 180000.00, 110000.00, 5, 'Medium', 7.8, 'ITI/hardware technicians servicing urban/tehsil colleges', 'Motherboard chip-level repair and hardware diagnostics.', '💻', 92, TRUE, 'MoSJE Micro Finance', 'https://www.jansamarth.in/'),
  ('mb-agro-01', 'Mini Flour Mill (Chakki) & Spices Grinding Unit', 'agro_food', 120000.00, 70000.00, 5, 'Low', 8.5, 'Village entrepreneurs with reliable single-phase power', 'Daily household milling of wheat, millet, and stone-ground spices.', '🌾', 94, TRUE, 'PMFME 35% Subsidy + MoSJE', 'https://www.jansamarth.in/');

-- Table 4: Seed Franchise Inquiries
INSERT INTO vyapar_franchise_inquiries (id, franchise_id, brand_name, applicant_name, preferred_location, investment_amount, phone, email, status, submitted_at)
VALUES
  ('INQ-FRAN-001', 'franchise-1', 'Chai Point Express', 'Vikas Sharma', 'Jaipur, Malviya Nagar', 1200000.00, '9829000001', 'vikas.sharma@gmail.com', 'UNDER_REVIEW', '2026-02-25 15:30:00+05:30');

-- Table 5: Seed Property Tour Bookings
INSERT INTO vyapar_property_inquiries (id, property_id, property_title, applicant_name, phone, preferred_date, notes, status, submitted_at)
VALUES
  ('TOUR-PROP-001', 'prop-1', 'Corner Retail Showroom - C-Scheme', 'Pooja Agarwal', '9829000002', '2026-03-10', 'Interested for organic farm-to-table outlet', 'SCHEDULED', '2026-02-28 11:00:00+05:30');

-- Table 6: Seed Find Business Inquiries
INSERT INTO vyapar_business_inquiries (id, business_name, category, applicant_name, phone, email, target_location, available_margin, estimated_project_cost, scheme_preference, notes, status, submitted_at)
VALUES
  ('BIZ-INQ-001', 'Cold-Pressed Mustard Oil & Spices', 'food', 'Anil Meena', '9414012345', 'anil.meena@yahoo.com', 'Dausa Rural Block, Rajasthan', 35000.00, 350000.00, 'PMEGP 35% Capital Subsidy + MoSJE Concessional Credit', 'Have ancestral land along state highway', 'APPLICATION_LOGGED', '2026-03-01 14:00:00+05:30');

-- Table 7: Seed SQL Transaction Audit Trail
INSERT INTO vyapar_sql_transaction_logs (id, table_name, operation, sql_statement, executed_by, created_at)
VALUES
  ('TXN-001', 'vyapar_r_users', 'INSERT', 'INSERT INTO vyapar_r_users (id, name, phone, email) VALUES ('000001', 'Abhinav Choudhary', '9999999999', 'Abhinav@gmail.com');', 'system_init', '2026-01-15 10:00:00+05:30'),
  ('TXN-002', 'vyapar_loan_applications', 'INSERT', 'INSERT INTO vyapar_loan_applications (id, applicant_name, scheme_tier, loan_amount) VALUES ('LOAN-26091-001', 'Sunita Devi Meghwal', 'MICRO_FINANCE', 125000.00);', 'beneficiary_portal', '2026-02-20 16:20:00+05:30'),
  ('TXN-003', 'vyapar_loan_applications', 'INSERT', 'INSERT INTO vyapar_loan_applications (id, applicant_name, scheme_tier, loan_amount) VALUES ('LOAN-26091-002', 'Ramesh Chandra Verma', 'TERM_LOAN', 900000.00);', 'beneficiary_portal', '2026-02-22 10:45:00+05:30');

COMMIT;
