-- DISHA Auth, Authorization, Session, and Decision Planning module SQL
-- Integration-safe: creates only this module's required database objects when
-- they are missing and does not drop or replace shared development tables.

CREATE DATABASE IF NOT EXISTS disha_career_portal
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE disha_career_portal;

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('STUDENT', 'PARENT', 'COUNSELOR', 'ADMIN') NOT NULL,
    full_name VARCHAR(120),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,

    INDEX idx_users_role (role),
    INDEX idx_users_email (email),
    INDEX idx_users_username (username),
    INDEX idx_users_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS college_programmes (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    college_name VARCHAR(200) NOT NULL,
    degree_name VARCHAR(200) NOT NULL,
    faculty VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    annual_fee_npr DECIMAL(12, 2) NOT NULL,
    minimum_percentage DECIMAL(5, 2) NOT NULL DEFAULT 0.00,
    career_path TEXT,
    affiliation VARCHAR(100),
    duration_years TINYINT NOT NULL DEFAULT 4,
    scholarship_available TINYINT(1) NOT NULL DEFAULT 0,
    contact_info VARCHAR(300),
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_programmes_location (location),
    INDEX idx_programmes_faculty (faculty),
    INDEX idx_programmes_fee (annual_fee_npr),
    INDEX idx_programmes_percentage (minimum_percentage),
    INDEX idx_programmes_active (is_active),
    UNIQUE KEY uq_programme_identity (college_name, degree_name, location)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS student_decision_searches (
    search_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    max_budget DECIMAL(12, 2) DEFAULT 0,
    location_filter VARCHAR(100),
    min_percentage DECIMAL(5, 2) DEFAULT 0,
    career_path_filter VARCHAR(200),
    result_count INT DEFAULT 0,
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_decision_search_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    INDEX idx_decision_search_user (user_id),
    INDEX idx_decision_search_time (searched_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO college_programmes
(college_name, degree_name, faculty, location, annual_fee_npr, minimum_percentage,
 career_path, affiliation, duration_years, scholarship_available, contact_info)
SELECT 'Tribhuvan University Central Campus', 'B.Sc. CSIT', 'Science & Technology', 'Kathmandu',
       75000.00, 50.00, 'Software Engineer,Data Analyst,Web Developer', 'TU', 4, 0,
       '01-4330561 | info@tucentral.edu.np'
WHERE NOT EXISTS (
    SELECT 1 FROM college_programmes
    WHERE college_name = 'Tribhuvan University Central Campus'
      AND degree_name = 'B.Sc. CSIT'
      AND location = 'Kathmandu'
);

INSERT INTO college_programmes
(college_name, degree_name, faculty, location, annual_fee_npr, minimum_percentage,
 career_path, affiliation, duration_years, scholarship_available, contact_info)
SELECT 'Kathmandu University', 'B.E. Computer Engineering', 'Engineering', 'Dhulikhel',
       290000.00, 65.00, 'Software Engineer,Network Engineer,AI Researcher', 'KU', 4, 1,
       '011-661399 | admission@ku.edu.np'
WHERE NOT EXISTS (
    SELECT 1 FROM college_programmes
    WHERE college_name = 'Kathmandu University'
      AND degree_name = 'B.E. Computer Engineering'
      AND location = 'Dhulikhel'
);

INSERT INTO college_programmes
(college_name, degree_name, faculty, location, annual_fee_npr, minimum_percentage,
 career_path, affiliation, duration_years, scholarship_available, contact_info)
SELECT 'Pokhara University', 'BCA', 'Management & IT', 'Pokhara',
       60000.00, 45.00, 'Web Developer,Database Admin,IT Support', 'PU', 3, 0,
       '061-504021 | info@pu.edu.np'
WHERE NOT EXISTS (
    SELECT 1 FROM college_programmes
    WHERE college_name = 'Pokhara University'
      AND degree_name = 'BCA'
      AND location = 'Pokhara'
);

INSERT INTO college_programmes
(college_name, degree_name, faculty, location, annual_fee_npr, minimum_percentage,
 career_path, affiliation, duration_years, scholarship_available, contact_info)
SELECT 'Patan Multiple Campus', 'BBS', 'Management', 'Lalitpur',
       35000.00, 40.00, 'Accountant,Bank Officer,Business Analyst', 'TU', 4, 0,
       '01-5522462'
WHERE NOT EXISTS (
    SELECT 1 FROM college_programmes
    WHERE college_name = 'Patan Multiple Campus'
      AND degree_name = 'BBS'
      AND location = 'Lalitpur'
);

INSERT INTO college_programmes
(college_name, degree_name, faculty, location, annual_fee_npr, minimum_percentage,
 career_path, affiliation, duration_years, scholarship_available, contact_info)
SELECT 'Pulchowk Campus', 'B.E. Civil Engineering', 'Engineering', 'Lalitpur',
       120000.00, 70.00, 'Civil Engineer,Structural Engineer,Project Manager', 'TU', 4, 0,
       '01-5521465 | info@ioe.edu.np'
WHERE NOT EXISTS (
    SELECT 1 FROM college_programmes
    WHERE college_name = 'Pulchowk Campus'
      AND degree_name = 'B.E. Civil Engineering'
      AND location = 'Lalitpur'
);
