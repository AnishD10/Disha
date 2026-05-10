-- Migration: Add tables required for Joyal's authentication and decision planning integration
-- These tables support the external UserDAO and DecisionDAO

-- ============================================================================
-- IMPORTANT: The users table needs to be updated to support the new code
-- ============================================================================
-- The current schema has first_name and last_name, but the external DAO
-- expects a single full_name column. 

-- Option 1: Add full_name column and populate from existing names
ALTER TABLE users ADD COLUMN full_name VARCHAR(200);
UPDATE users SET full_name = CONCAT(COALESCE(first_name, ''), ' ', COALESCE(last_name, ''));
UPDATE users SET full_name = TRIM(full_name);

-- Option 2: If you prefer to use the legacy name columns, you'll need to modify UserDAO's mapRow() method
-- to concatenate first_name and last_name when reading.

-- ============================================================================
-- Create college_programmes table (used by DecisionDAO)
-- ============================================================================
-- This table stores all available college degree programmes with their filters
CREATE TABLE IF NOT EXISTS college_programmes (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    college_name VARCHAR(150) NOT NULL,
    degree_name VARCHAR(150) NOT NULL,
    faculty VARCHAR(100),                    -- Science, Management, Humanities, etc.
    location VARCHAR(100),                   -- District / Province
    annual_fee_npr DECIMAL(10, 2),          -- Annual fee in NPR
    minimum_percentage DECIMAL(5, 2),       -- Minimum academic score required
    career_path VARCHAR(500),                -- Comma-separated career tags
    affiliation VARCHAR(50),                 -- TU, PU, KU, etc.
    duration_years INT,                     -- Duration of the degree
    scholarship_available BOOLEAN DEFAULT FALSE,
    contact_info VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_faculty (faculty),
    INDEX idx_location (location),
    INDEX idx_annual_fee (annual_fee_npr),
    INDEX idx_minimum_percentage (minimum_percentage),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- Create student_decision_searches table (for audit trail)
-- ============================================================================
-- This table logs all search queries run by students for counselor visibility
CREATE TABLE IF NOT EXISTS student_decision_searches (
    search_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    max_budget DECIMAL(10, 2),
    location_filter VARCHAR(100),
    min_percentage DECIMAL(5, 2),
    career_path_filter VARCHAR(500),
    result_count INT,
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_search_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_searched_at (searched_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- Sample data for college_programmes (for testing)
-- ============================================================================
INSERT IGNORE INTO college_programmes (college_name, degree_name, faculty, location, annual_fee_npr, minimum_percentage, career_path, affiliation, duration_years, scholarship_available, contact_info, is_active) VALUES
('Tribhuvan University', 'Bachelor of Science in Computer Science', 'Science', 'Kathmandu', 150000, 60, 'Software Engineer,Data Scientist,Web Developer', 'TU', 4, TRUE, 'admission@tribhuvan.edu.np', TRUE),
('Purbanchal University', 'Bachelor of Engineering', 'Science', 'Biratnagar', 200000, 65, 'Engineer,Project Manager', 'PU', 4, FALSE, 'admin@purbanchal.edu.np', TRUE),
('Kathmandu University', 'Bachelor of Business Studies', 'Management', 'Kathmandu', 300000, 50, 'Accountant,Banker,Manager', 'KU', 3, TRUE, 'admission@ku.edu.np', TRUE),
('Nepal Engineering College', 'Diploma in Civil Engineering', 'Science', 'Kathmandu', 100000, 45, 'Civil Engineer,Contractor', 'TU', 3, FALSE, 'info@nec.edu.np', TRUE),
('Ambition College', 'Bachelor of Hotel Management', 'Management', 'Kathmandu', 250000, 40, 'Hotel Manager,Chef,Tourism Expert', 'PU', 3, TRUE, 'admin@ambition.edu.np', TRUE);
