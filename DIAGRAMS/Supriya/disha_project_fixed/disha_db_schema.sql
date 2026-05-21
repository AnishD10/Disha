-- ============================================================
-- DISHA Database Schema + Sample Data
-- Run this in MySQL/XAMPP before starting the application.
-- ============================================================

CREATE DATABASE IF NOT EXISTS disha_db;
USE disha_db;

-- ── Tables ──────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS users (
    id               INT           AUTO_INCREMENT PRIMARY KEY,
    username         VARCHAR(50)   NOT NULL UNIQUE,
    password         VARCHAR(255)  NOT NULL,           -- store hashed password in production
    full_name        VARCHAR(100)  NOT NULL,
    email            VARCHAR(100)  NOT NULL UNIQUE,
    phone            VARCHAR(20),
    education_level  VARCHAR(100),
    preferred_career VARCHAR(100),
    role             ENUM('student','parent','counselor','admin') DEFAULT 'student',
    created_at       DATETIME      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS assessments (
    id               INT           AUTO_INCREMENT PRIMARY KEY,
    assessment_name  VARCHAR(150)  NOT NULL,
    description      TEXT,
    created_at       DATETIME      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS test_history (
    id               INT  AUTO_INCREMENT PRIMARY KEY,
    user_id          INT  NOT NULL,
    assessment_id    INT  NOT NULL,
    score            INT  NOT NULL,
    date_taken       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)      REFERENCES users(id)       ON DELETE CASCADE,
    FOREIGN KEY (assessment_id) REFERENCES assessments(id) ON DELETE CASCADE
);

-- ── Sample Data ──────────────────────────────────────────────

-- Test user: username = supriya, password = test123  (plain text for dev only)
INSERT INTO users (username, password, full_name, email, phone, education_level, preferred_career, created_at)
VALUES ('supriya', 'test123', 'Supriya Kc', 'supriya@email.com', '9800000001', 'Bachelor', 'Software Engineer', '2025-03-10 09:00:00');

-- Assessments
INSERT INTO assessments (assessment_name, description) VALUES
    ('Aptitude Assessment',   'Tests logical reasoning and numerical aptitude.'),
    ('Personality Assessment','Evaluates personality traits aligned to careers.'),
    ('Skill Competency Test', 'Measures technical and soft skill competencies.');

-- Test history for supriya (user_id = 1)
INSERT INTO test_history (user_id, assessment_id, score, date_taken) VALUES
    (1, 1, 72, '2025-03-10 10:00:00'),
    (1, 2, 58, '2025-03-15 11:30:00'),
    (1, 3, 85, '2025-04-01 09:00:00'),
    (1, 1, 80, '2025-04-20 14:00:00');

-- ── Verify ───────────────────────────────────────────────────
SELECT 'Users:'       AS '', COUNT(*) FROM users;
SELECT 'Assessments:' AS '', COUNT(*) FROM assessments;
SELECT 'TestHistory:' AS '', COUNT(*) FROM test_history;
