-- ============================================================
-- DISHA Nepal Career Intelligence Portal
-- Database Schema — Tables owned/used by Joyal Karki
-- Auth + Decision Planning
--
-- Designed to be run AFTER Anish's DBUtil and base schema.
-- All foreign keys reference the `users` table created by Anish.
-- ============================================================

-- ── Users Table (Auth Foundation) ──────────────────────────────
-- Created and owned by Anish Dangal (DBUtil owner).
-- Reproduced here for reference — DO NOT run twice.
/*
CREATE TABLE IF NOT EXISTS users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(120)  NOT NULL,
    email         VARCHAR(200)  NOT NULL UNIQUE,
    password_hash VARCHAR(300)  NOT NULL,  -- stores "base64salt:base64hash"
    role          ENUM('STUDENT','PARENT','COUNSELOR','ADMIN') NOT NULL,
    phone         VARCHAR(20),
    address       VARCHAR(200),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active     TINYINT(1) DEFAULT 1,

    INDEX idx_users_email  (email),
    INDEX idx_users_role   (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
*/

-- ── College Programmes Table (Decision Planning) ───────────────
CREATE TABLE IF NOT EXISTS college_programmes (
                                                  plan_id                INT AUTO_INCREMENT PRIMARY KEY,
                                                  college_name           VARCHAR(200)   NOT NULL,
                                                  degree_name            VARCHAR(200)   NOT NULL,
                                                  faculty                VARCHAR(100)   NOT NULL,   -- Science, Management, Humanities, IT, etc.
                                                  location               VARCHAR(100)   NOT NULL,   -- District or Province
                                                  annual_fee_npr         DECIMAL(12, 2) NOT NULL,
                                                  minimum_percentage     DECIMAL(5, 2)  NOT NULL DEFAULT 0.00,
                                                  career_path            TEXT,                      -- Comma-separated career tags
                                                  affiliation            VARCHAR(100),              -- TU, PU, KU, Pokhara Uni, etc.
                                                  duration_years         TINYINT        NOT NULL DEFAULT 4,
                                                  scholarship_available  TINYINT(1)     NOT NULL DEFAULT 0,
                                                  contact_info           VARCHAR(300),
                                                  is_active              TINYINT(1)     NOT NULL DEFAULT 1,
                                                  created_at             TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,

                                                  INDEX idx_prog_location   (location),
                                                  INDEX idx_prog_faculty    (faculty),
                                                  INDEX idx_prog_fee        (annual_fee_npr),
                                                  INDEX idx_prog_percentage (minimum_percentage),
                                                  INDEX idx_prog_active     (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ── Student Decision Search History (Audit + Counselor Visibility) ──
CREATE TABLE IF NOT EXISTS student_decision_searches (
                                                         search_id          INT AUTO_INCREMENT PRIMARY KEY,
                                                         user_id            INT            NOT NULL,
                                                         max_budget         DECIMAL(12, 2) DEFAULT 0,
                                                         location_filter    VARCHAR(100),
                                                         min_percentage     DECIMAL(5, 2)  DEFAULT 0,
                                                         career_path_filter VARCHAR(200),
                                                         result_count       INT            DEFAULT 0,
                                                         searched_at        TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,

                                                         FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
                                                         INDEX idx_search_user      (user_id),
                                                         INDEX idx_search_timestamp (searched_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ================================================================
-- Sample Data — College Programmes (for report screenshots)
-- 15 realistic Nepal colleges across locations, faculties, fees
-- ================================================================

INSERT INTO college_programmes
(college_name, degree_name, faculty, location, annual_fee_npr,
 minimum_percentage, career_path, affiliation, duration_years,
 scholarship_available, contact_info)
VALUES
    ('Tribhuvan University Central Campus',
     'B.Sc. CSIT', 'Science & Technology', 'Kathmandu',
     75000.00, 50.00,
     'Software Engineer,Data Analyst,Web Developer',
     'TU', 4, 0,
     '01-4330561 | info@tucentral.edu.np'),

    ('Kathmandu University',
     'B.E. Computer Engineering', 'Engineering', 'Dhulikhel',
     290000.00, 65.00,
     'Software Engineer,Network Engineer,AI Researcher',
     'KU', 4, 1,
     '011-661399 | admission@ku.edu.np'),

    ('Pokhara University',
     'BCA', 'Management & IT', 'Pokhara',
     60000.00, 45.00,
     'Web Developer,Database Admin,IT Support',
     'PU', 3, 0,
     '061-504021 | info@pu.edu.np'),

    ('Patan Multiple Campus',
     'BBS (Bachelor of Business Studies)', 'Management', 'Lalitpur',
     35000.00, 40.00,
     'Accountant,Bank Officer,Business Analyst',
     'TU', 4, 0,
     '01-5522462'),

    ('Nepal Commerce Campus',
     'B.Com. (Hons)', 'Management', 'Kathmandu',
     45000.00, 45.00,
     'Finance Officer,Auditor,Business Analyst',
     'TU', 4, 0,
     '01-4214593'),

    ('Kathmandu Medical College',
     'MBBS', 'Medical', 'Kathmandu',
     1400000.00, 75.00,
     'General Physician,Surgeon,Specialist Doctor',
     'KU', 5, 1,
     '01-4911008 | kmc@kmc.edu.np'),

    ('Chitwan Medical College',
     'MBBS', 'Medical', 'Bharatpur',
     1200000.00, 72.00,
     'General Physician,Surgeon,Hospital Administrator',
     'TU', 5, 0,
     '056-524410'),

    ('Pulchowk Campus (IOE)',
     'B.E. Civil Engineering', 'Engineering', 'Lalitpur',
     120000.00, 70.00,
     'Civil Engineer,Structural Engineer,Project Manager',
     'TU', 4, 0,
     '01-5521465 | info@ioe.edu.np'),

    ('Birendra Multiple Campus',
     'B.Sc. Agriculture', 'Agriculture', 'Bharatpur',
     40000.00, 45.00,
     'Agricultural Officer,Agronomist,Farm Manager',
     'TU', 4, 1,
     '056-522112'),

    ('Mid-Western University',
     'BBA', 'Management', 'Surkhet',
     30000.00, 40.00,
     'Business Analyst,Entrepreneur,Bank Officer',
     'MU', 4, 1,
     '083-520800'),

    ('Butwal Multiple Campus',
     'B.Sc. CSIT', 'Science & Technology', 'Butwal',
     55000.00, 48.00,
     'Software Engineer,IT Support,Web Developer',
     'TU', 4, 0,
     '071-547623'),

    ('Dharan Campus',
     'B.E. Electronics Engineering', 'Engineering', 'Dharan',
     90000.00, 65.00,
     'Electronics Engineer,Telecom Engineer,Embedded Systems',
     'TU', 4, 0,
     '025-520133'),

    ('Hetauda Campus',
     'B.Sc. Forestry', 'Environment & Natural Resources', 'Hetauda',
     35000.00, 45.00,
     'Forest Officer,Environmental Consultant,Wildlife Researcher',
     'TU', 4, 1,
     '057-523211'),

    ('Padma Kanya Multiple Campus',
     'B.A. Sociology', 'Humanities & Social Sciences', 'Kathmandu',
     20000.00, 35.00,
     'Social Worker,NGO Officer,Researcher',
     'TU', 4, 0,
     '01-4411435'),

    ('Nobel College',
     'BBA (Aviation Management)', 'Management', 'Kathmandu',
     180000.00, 50.00,
     'Airline Operations,Airport Manager,Tourism Manager',
     'PU', 4, 0,
     '01-4499914 | info@nobel.edu.np');


-- ================================================================
-- Sample Data — Users (for testing all 4 roles)
-- Passwords are placeholder SHA-256 hashes.
-- Replace with real PasswordUtil.hash() output in integration tests.
-- ================================================================

INSERT INTO users (full_name, email, password_hash, role, phone, address) VALUES
                                                                              ('Test Student',   'student@disha.test',
                                                                               'dGVzdHNhbHQ=:dGVzdGhhc2g=',   -- placeholder
                                                                               'STUDENT',   '9800000001', 'Kathmandu'),

                                                                              ('Test Parent',    'parent@disha.test',
                                                                               'dGVzdHNhbHQ=:dGVzdGhhc2g=',
                                                                               'PARENT',    '9800000002', 'Lalitpur'),

                                                                              ('Test Counselor', 'counselor@disha.test',
                                                                               'dGVzdHNhbHQ=:dGVzdGhhc2g=',
                                                                               'COUNSELOR', '9800000003', 'Bhaktapur'),

                                                                              ('Admin Disha',    'admin@disha.test',
                                                                               'dGVzdHNhbHQ=:dGVzdGhhc2g=',
                                                                               'ADMIN',     '9800000004', 'Kathmandu');
