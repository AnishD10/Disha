CREATE DATABASE IF NOT EXISTS disha_db;
USE disha_db;

CREATE TABLE IF NOT EXISTS users (
    user_id           INT AUTO_INCREMENT PRIMARY KEY,
    full_name         VARCHAR(100)  NOT NULL,
    email             VARCHAR(150)  NOT NULL UNIQUE,
    password_hash     VARCHAR(255)  NOT NULL,
    role              ENUM('STUDENT','PARENT','COUNSELOR','ADMIN') NOT NULL,
    linked_student_id INT           NULL,
    created_at        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (linked_student_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS aptitude_results (
    result_id         INT AUTO_INCREMENT PRIMARY KEY,
    student_id        INT           NOT NULL,
    summary           VARCHAR(300)  NOT NULL,
    strength_clusters VARCHAR(200)  NOT NULL,
    weakness_clusters VARCHAR(200)  NOT NULL,
    total_score       INT           NOT NULL,
    taken_date        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS careers (
    career_id         INT AUTO_INCREMENT PRIMARY KEY,
    career_name       VARCHAR(150)  NOT NULL,
    plain_description TEXT          NOT NULL,
    category          VARCHAR(100)  NOT NULL
);

CREATE TABLE IF NOT EXISTS labour_market (
    market_id         INT AUTO_INCREMENT PRIMARY KEY,
    career_id         INT           NOT NULL,
    salary_min        INT           NOT NULL,
    salary_max        INT           NOT NULL,
    demand_level      ENUM('High','Medium','Low') NOT NULL,
    risk_index        VARCHAR(50)   NOT NULL,
    last_updated      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (career_id) REFERENCES careers(career_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS career_matches (
    match_id          INT AUTO_INCREMENT PRIMARY KEY,
    student_id        INT           NOT NULL,
    career_id         INT           NOT NULL,
    match_score       INT           NOT NULL,
    matched_on        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (career_id)  REFERENCES careers(career_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS colleges (
    college_id        INT AUTO_INCREMENT PRIMARY KEY,
    college_name      VARCHAR(200)  NOT NULL,
    location          VARCHAR(100)  NOT NULL
);

CREATE TABLE IF NOT EXISTS degrees (
    degree_id         INT AUTO_INCREMENT PRIMARY KEY,
    degree_name       VARCHAR(200)  NOT NULL,
    college_id        INT           NOT NULL,
    annual_fee_npr    INT           NOT NULL,
    duration_years    INT           NOT NULL,
    FOREIGN KEY (college_id) REFERENCES colleges(college_id) ON DELETE CASCADE
);

-- Sample Data
INSERT INTO users (full_name, email, password_hash, role) VALUES
('Admin User',      'admin@disha.np',    'hashed_pw_1', 'ADMIN'),
('Sita Thapa',      'sita@student.np',  'hashed_pw_2', 'STUDENT'),
('Ram Thapa',       'ram@parent.np',    'hashed_pw_3', 'PARENT'),
('Dr. Asha Khadka', 'asha@counselor.np','hashed_pw_4', 'COUNSELOR');

UPDATE users SET linked_student_id = 2 WHERE user_id = 3;

INSERT INTO aptitude_results (student_id, summary, strength_clusters, weakness_clusters, total_score) VALUES
(2, 'Strong analytical and technical aptitude', 'Mathematics, Problem Solving, Logic', 'Creative Arts, Languages', 82);

INSERT INTO careers (career_name, plain_description, category) VALUES
('Software Engineer',        'Your child would write computer programs. Good salary, many jobs in Nepal and abroad.', 'Technology'),
('Data Analyst',             'Your child would analyse data to help companies make better decisions.', 'Technology'),
('Civil Engineer',           'Your child would design and build roads, bridges, and buildings.', 'Engineering'),
('Accountant',               'Your child would manage money and financial records for businesses.', 'Finance'),
('Healthcare IT Specialist', 'Your child would manage computer systems in hospitals and clinics.', 'Healthcare');

INSERT INTO labour_market (career_id, salary_min, salary_max, demand_level, risk_index) VALUES
(1, 50000, 150000, 'High',   'Low Risk'),
(2, 45000, 120000, 'High',   'Low Risk'),
(3, 40000, 100000, 'Medium', 'Low Risk'),
(4, 35000,  80000, 'Medium', 'Low Risk'),
(5, 45000, 110000, 'Medium', 'Low Risk');

INSERT INTO career_matches (student_id, career_id, match_score) VALUES
(2, 1, 91), (2, 2, 85), (2, 5, 74), (2, 3, 60), (2, 4, 55);

INSERT INTO colleges (college_name, location) VALUES
('Tribhuvan University',   'Kathmandu'),
('Kathmandu University',   'Dhulikhel'),
('Pokhara University',     'Pokhara'),
('Purbanchal University',  'Biratnagar'),
('Mid-Western University', 'Surkhet');

INSERT INTO degrees (degree_name, college_id, annual_fee_npr, duration_years) VALUES
('BSc Computer Science',      1,  80000, 4),
('BIT (Bachelor of IT)',      2, 120000, 4),
('BSc Data Science',          2, 130000, 4),
('BE Civil Engineering',      1,  90000, 4),
('BBA (Accounting)',          3,  70000, 4),
('BSc Health Informatics',    2, 110000, 4),
('BEng Software Engineering', 4,  75000, 4),
('BSc Mathematics',           1,  60000, 4);
