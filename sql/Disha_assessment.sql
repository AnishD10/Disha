-- Disha Nepal Career Intelligence Portal
-- Assessment Feature: Database Schema and Seed Data
-- Run this entire file in MySQL before starting the application

-- Create the database if it does not exist, then switch to it
CREATE DATABASE IF NOT EXISTS Disha_db;
USE Disha_db;

-- -------------------------------------------------------
-- users table (required by assessment_attempts foreign key)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS users
(
    user_id        INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(100)                                     NOT NULL,
    email          VARCHAR(100)                                     NOT NULL UNIQUE,
    password       VARCHAR(255)                                     NOT NULL,
    role           ENUM ('STUDENT', 'COUNSELOR', 'ADMIN', 'PARENT') NOT NULL DEFAULT 'STUDENT',
    is_flagged     TINYINT(1)                                                DEFAULT 0,
    counselor_note TEXT                                                      DEFAULT NULL
);

-- Drop tables in reverse dependency order so we can re-run safely
DROP TABLE IF EXISTS attempt_skills;
DROP TABLE IF EXISTS attempt_career_recs;
DROP TABLE IF EXISTS attempt_answers;
DROP TABLE IF EXISTS assessment_attempts;
DROP TABLE IF EXISTS options;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS nepal_careers;

-- -------------------------------------------------------
-- Table 1: questions
-- Holds all 30 fixed questions for the assessment
-- -------------------------------------------------------
CREATE TABLE questions
(
    question_id    INT AUTO_INCREMENT PRIMARY KEY,
    question_text  TEXT                                         NOT NULL,
    section        ENUM ('APTITUDE', 'PERSONALITY', 'INTEREST') NOT NULL,
    question_type  ENUM ('MCQ', 'LIKERT')                       NOT NULL,
    question_order INT                                          NOT NULL
);

-- -------------------------------------------------------
-- Table 2: options
-- Holds answer choices for every question
-- MCQ: 4 options, score_value=1 for correct and 0 for wrong
-- Likert: 5 options, score_value 1 (Strongly Disagree) to 5 (Strongly Agree)
-- -------------------------------------------------------
CREATE TABLE options
(
    option_id   INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT          NOT NULL,
    option_text VARCHAR(255) NOT NULL,
    score_value INT          NOT NULL,
    is_correct  TINYINT(1) DEFAULT 0,
    FOREIGN KEY (question_id) REFERENCES questions (question_id)
);

-- -------------------------------------------------------
-- Table 3: assessment_attempts
-- One row per student per attempt (multiple retakes are allowed)
-- Scores are calculated and saved here after the student submits
-- -------------------------------------------------------
CREATE TABLE assessment_attempts
(
    attempt_id          INT AUTO_INCREMENT PRIMARY KEY,
    student_id          INT NOT NULL,
    attempt_date        DATETIME   DEFAULT NOW(),
    is_completed        TINYINT(1) DEFAULT 0,
    aptitude_score      INT        DEFAULT 0,
    personality_score   INT        DEFAULT 0,
    interest_score      INT        DEFAULT 0,
    personality_cluster VARCHAR(50),
    FOREIGN KEY (student_id) REFERENCES users (user_id)
);

-- -------------------------------------------------------
-- Table 4: attempt_answers
-- Saves every answer the student chose during one attempt
-- -------------------------------------------------------
CREATE TABLE attempt_answers
(
    answer_id          INT AUTO_INCREMENT PRIMARY KEY,
    attempt_id         INT NOT NULL,
    question_id        INT NOT NULL,
    selected_option_id INT NOT NULL,
    FOREIGN KEY (attempt_id) REFERENCES assessment_attempts (attempt_id),
    FOREIGN KEY (question_id) REFERENCES questions (question_id),
    FOREIGN KEY (selected_option_id) REFERENCES options (option_id)
);

---------------------------------------------------------
-- Table 5: nepal_careers
-- Careers relevant to Nepal that students can be matched to
-- suitable_clusters: comma-separated cluster names
-- -------------------------------------------------------
CREATE TABLE nepal_careers
(
    career_id            INT AUTO_INCREMENT PRIMARY KEY,
    career_name          VARCHAR(100) NOT NULL,
    career_description   TEXT,
    suitable_clusters    VARCHAR(200),
    min_aptitude_score   INT DEFAULT 0,
    nepal_relevance_note TEXT
);

-- -------------------------------------------------------
-- Table 6: attempt_career_recs
-- Stores the top 3 career recommendations for each attempt
-- career_rank is 1, 2, or 3
-- -------------------------------------------------------
CREATE TABLE attempt_career_recs
(
    rec_id      INT AUTO_INCREMENT PRIMARY KEY,
    attempt_id  INT NOT NULL,
    career_id   INT NOT NULL,
    career_rank INT NOT NULL,
    FOREIGN KEY (attempt_id) REFERENCES assessment_attempts (attempt_id),
    FOREIGN KEY (career_id) REFERENCES nepal_careers (career_id)
);

-- -------------------------------------------------------
-- Table 7: attempt_skills
-- Stores the skill cluster analysis result for each attempt
-- skill_level: STRONG, AVERAGE, or WEAK
-- -------------------------------------------------------
CREATE TABLE attempt_skills
(
    skill_id    INT AUTO_INCREMENT PRIMARY KEY,
    attempt_id  INT                                NOT NULL,
    skill_name  VARCHAR(100)                       NOT NULL,
    skill_score INT                                NOT NULL,
    skill_level ENUM ('STRONG', 'AVERAGE', 'WEAK') NOT NULL,
    FOREIGN KEY (attempt_id) REFERENCES assessment_attempts (attempt_id)
);


-- =======================================================
-- SEED: 30 Questions
-- Section A  = APTITUDE   MCQ     (Q1  - Q10)
-- Section B  = PERSONALITY LIKERT  (Q11 - Q20)
-- Section C  = INTEREST    LIKERT  (Q21 - Q30)
-- =======================================================

INSERT INTO questions (question_text, section, question_type, question_order)
VALUES ('Ramesh has 24 apples. He gives one-third to his classmates. How many apples does he have left?', 'APTITUDE',
        'MCQ', 1),
       ('A bus travels from Pokhara to Kathmandu, a distance of 200 km, at a speed of 50 km/h. How long does the journey take?',
        'APTITUDE', 'MCQ', 2),
       ('Which word does NOT belong with the others: River, Mountain, Calculator, Valley?', 'APTITUDE', 'MCQ', 3),
       ('What comes next in the series: 3, 6, 12, 24, ___?', 'APTITUDE', 'MCQ', 4),
       ('All birds can fly. An eagle is a bird. What can we conclude?', 'APTITUDE', 'MCQ', 5),
       ('If 1 US Dollar equals 133 Nepali Rupees, how many Rupees will you get for 3 US Dollars?', 'APTITUDE', 'MCQ',
        6),
       ('A shopkeeper in Thamel buys a souvenir for Rs. 400 and sells it for Rs. 500. What is the profit percentage?',
        'APTITUDE', 'MCQ', 7),
       ('Which of the following shapes has the most number of sides?', 'APTITUDE', 'MCQ', 8),
       ('If today is Wednesday, what day will it be after 9 days?', 'APTITUDE', 'MCQ', 9),
       ('A train covers 60 km in 2 hours. What is its average speed?', 'APTITUDE', 'MCQ', 10),
       ('I enjoy solving mathematical puzzles and logical problems.', 'PERSONALITY', 'LIKERT', 11),
       ('I prefer to analyze all available information carefully before making a decision.', 'PERSONALITY', 'LIKERT',
        12),
       ('I like breaking down complex problems into smaller, manageable steps.', 'PERSONALITY', 'LIKERT', 13),
       ('I feel energized and motivated when working as part of a group or team.', 'PERSONALITY', 'LIKERT', 14),
       ('I enjoy listening to others and helping them find solutions to their problems.', 'PERSONALITY', 'LIKERT', 15),
       ('I am comfortable speaking or presenting in front of a large audience.', 'PERSONALITY', 'LIKERT', 16),
       ('I enjoy creative activities such as drawing, writing stories, or making music.', 'PERSONALITY', 'LIKERT', 17),
       ('I often think of new and original ideas to solve everyday challenges.', 'PERSONALITY', 'LIKERT', 18),
       ('I prefer trying new approaches over repeating the same method every time.', 'PERSONALITY', 'LIKERT', 19),
       ('I prefer hands-on practical work over reading books and studying theory.', 'PERSONALITY', 'LIKERT', 20),
       ('I would enjoy working in Nepal''s government or civil service sector.', 'INTEREST', 'LIKERT', 21),
       ('I am interested in a career that involves computers and technology.', 'INTEREST', 'LIKERT', 22),
       ('I would like to work in a field that directly serves and helps the local community.', 'INTEREST', 'LIKERT',
        23),
       ('I prefer working in an office environment rather than working outdoors in the field.', 'INTEREST', 'LIKERT',
        24),
       ('I dream of starting and running my own business or enterprise in Nepal.', 'INTEREST', 'LIKERT', 25),
       ('I am interested in Nepal''s history, culture, and the tourism industry.', 'INTEREST', 'LIKERT', 26),
       ('I would enjoy a job that involves frequent travel across different regions of Nepal.', 'INTEREST', 'LIKERT',
        27),
       ('I am interested in health, medicine, and caring for sick and injured people.', 'INTEREST', 'LIKERT', 28),
       ('I prefer the job security and stability of a government position over the private sector.', 'INTEREST',
        'LIKERT', 29),
       ('I enjoy working with numbers, financial records, and accounting data.', 'INTEREST', 'LIKERT', 30);


-- =======================================================
-- SEED: Options for Section A (MCQ, Q1-Q10)
-- Each question has 4 options. Correct option has score_value=1 and is_correct=1.
-- =======================================================

-- Q1: answer is 16 (24 - 24/3 = 16)
INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (1, '6', 0, 0),
       (1, '8', 0, 0),
       (1, '16', 1, 1),
       (1, '18', 0, 0);

-- Q2: answer is 4 hours (200 / 50 = 4)
INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (2, '2 hours', 0, 0),
       (2, '3 hours', 0, 0),
       (2, '4 hours', 1, 1),
       (2, '5 hours', 0, 0);

-- Q3: answer is Calculator (all others are natural geographic features)
INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (3, 'River', 0, 0),
       (3, 'Mountain', 0, 0),
       (3, 'Calculator', 1, 1),
       (3, 'Valley', 0, 0);

-- Q4: answer is 48 (series doubles each time: 3,6,12,24,48)
INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (4, '36', 0, 0),
       (4, '48', 1, 1),
       (4, '30', 0, 0),
       (4, '42', 0, 0);

-- Q5: answer is Eagles can fly (valid deductive conclusion)
INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (5, 'Eagles cannot fly', 0, 0),
       (5, 'Eagles can fly', 1, 1),
       (5, 'Some birds cannot fly', 0, 0),
       (5, 'Eagles are not birds', 0, 0);

-- Q6: answer is 399 NPR (3 x 133 = 399)
INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (6, '266 NPR', 0, 0),
       (6, '333 NPR', 0, 0),
       (6, '399 NPR', 1, 1),
       (6, '430 NPR', 0, 0);

-- Q7: answer is 25% ((500-400)/400 x 100 = 25)
INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (7, '15%', 0, 0),
       (7, '20%', 0, 0),
       (7, '25%', 1, 1),
       (7, '30%', 0, 0);

-- Q8: answer is Hexagon (6 sides, most of the four choices)
INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (8, 'Triangle', 0, 0),
       (8, 'Square', 0, 0),
       (8, 'Pentagon', 0, 0),
       (8, 'Hexagon', 1, 1);

-- Q9: answer is Friday (Wednesday + 9 days = Wednesday + 7 + 2 = Friday)
INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (9, 'Thursday', 0, 0),
       (9, 'Friday', 1, 1),
       (9, 'Saturday', 0, 0),
       (9, 'Sunday', 0, 0);

-- Q10: answer is 30 km/h (60 / 2 = 30)
INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (10, '20 km/h', 0, 0),
       (10, '25 km/h', 0, 0),
       (10, '30 km/h', 1, 1),
       (10, '35 km/h', 0, 0);


-- =======================================================
-- SEED: Options for Sections B and C (Likert, Q11-Q30)
-- Every Likert question has the same 5 choices with scores 1 to 5.
-- is_correct is always 0 because there is no right or wrong answer here.
-- =======================================================

INSERT INTO options (question_id, option_text, score_value, is_correct)
VALUES (11, 'Strongly Disagree', 1, 0),
       (11, 'Disagree', 2, 0),
       (11, 'Neutral', 3, 0),
       (11, 'Agree', 4, 0),
       (11, 'Strongly Agree', 5, 0),
       (12, 'Strongly Disagree', 1, 0),
       (12, 'Disagree', 2, 0),
       (12, 'Neutral', 3, 0),
       (12, 'Agree', 4, 0),
       (12, 'Strongly Agree', 5, 0),
       (13, 'Strongly Disagree', 1, 0),
       (13, 'Disagree', 2, 0),
       (13, 'Neutral', 3, 0),
       (13, 'Agree', 4, 0),
       (13, 'Strongly Agree', 5, 0),
       (14, 'Strongly Disagree', 1, 0),
       (14, 'Disagree', 2, 0),
       (14, 'Neutral', 3, 0),
       (14, 'Agree', 4, 0),
       (14, 'Strongly Agree', 5, 0),
       (15, 'Strongly Disagree', 1, 0),
       (15, 'Disagree', 2, 0),
       (15, 'Neutral', 3, 0),
       (15, 'Agree', 4, 0),
       (15, 'Strongly Agree', 5, 0),
       (16, 'Strongly Disagree', 1, 0),
       (16, 'Disagree', 2, 0),
       (16, 'Neutral', 3, 0),
       (16, 'Agree', 4, 0),
       (16, 'Strongly Agree', 5, 0),
       (17, 'Strongly Disagree', 1, 0),
       (17, 'Disagree', 2, 0),
       (17, 'Neutral', 3, 0),
       (17, 'Agree', 4, 0),
       (17, 'Strongly Agree', 5, 0),
       (18, 'Strongly Disagree', 1, 0),
       (18, 'Disagree', 2, 0),
       (18, 'Neutral', 3, 0),
       (18, 'Agree', 4, 0),
       (18, 'Strongly Agree', 5, 0),
       (19, 'Strongly Disagree', 1, 0),
       (19, 'Disagree', 2, 0),
       (19, 'Neutral', 3, 0),
       (19, 'Agree', 4, 0),
       (19, 'Strongly Agree', 5, 0),
       (20, 'Strongly Disagree', 1, 0),
       (20, 'Disagree', 2, 0),
       (20, 'Neutral', 3, 0),
       (20, 'Agree', 4, 0),
       (20, 'Strongly Agree', 5, 0),
       (21, 'Strongly Disagree', 1, 0),
       (21, 'Disagree', 2, 0),
       (21, 'Neutral', 3, 0),
       (21, 'Agree', 4, 0),
       (21, 'Strongly Agree', 5, 0),
       (22, 'Strongly Disagree', 1, 0),
       (22, 'Disagree', 2, 0),
       (22, 'Neutral', 3, 0),
       (22, 'Agree', 4, 0),
       (22, 'Strongly Agree', 5, 0),
       (23, 'Strongly Disagree', 1, 0),
       (23, 'Disagree', 2, 0),
       (23, 'Neutral', 3, 0),
       (23, 'Agree', 4, 0),
       (23, 'Strongly Agree', 5, 0),
       (24, 'Strongly Disagree', 1, 0),
       (24, 'Disagree', 2, 0),
       (24, 'Neutral', 3, 0),
       (24, 'Agree', 4, 0),
       (24, 'Strongly Agree', 5, 0),
       (25, 'Strongly Disagree', 1, 0),
       (25, 'Disagree', 2, 0),
       (25, 'Neutral', 3, 0),
       (25, 'Agree', 4, 0),
       (25, 'Strongly Agree', 5, 0),
       (26, 'Strongly Disagree', 1, 0),
       (26, 'Disagree', 2, 0),
       (26, 'Neutral', 3, 0),
       (26, 'Agree', 4, 0),
       (26, 'Strongly Agree', 5, 0),
       (27, 'Strongly Disagree', 1, 0),
       (27, 'Disagree', 2, 0),
       (27, 'Neutral', 3, 0),
       (27, 'Agree', 4, 0),
       (27, 'Strongly Agree', 5, 0),
       (28, 'Strongly Disagree', 1, 0),
       (28, 'Disagree', 2, 0),
       (28, 'Neutral', 3, 0),
       (28, 'Agree', 4, 0),
       (28, 'Strongly Agree', 5, 0),
       (29, 'Strongly Disagree', 1, 0),
       (29, 'Disagree', 2, 0),
       (29, 'Neutral', 3, 0),
       (29, 'Agree', 4, 0),
       (29, 'Strongly Agree', 5, 0),
       (30, 'Strongly Disagree', 1, 0),
       (30, 'Disagree', 2, 0),
       (30, 'Neutral', 3, 0),
       (30, 'Agree', 4, 0),
       (30, 'Strongly Agree', 5, 0);


-- =======================================================
-- SEED: Nepal Careers (15 careers)
-- suitable_clusters: comma-separated cluster names that match this career
-- min_aptitude_score: minimum Section A score required to be recommended
-- =======================================================

INSERT INTO nepal_careers (career_name, career_description, suitable_clusters, min_aptitude_score, nepal_relevance_note)
VALUES ('Software Engineer',
        'Designs and builds software applications and systems.',
        'Analytical,Creative',
        6,
        'High demand in Kathmandu IT sector. Companies like F1Soft, Leapfrog, and Deerwalk actively recruit.'),

       ('Civil Engineer',
        'Plans and oversees construction of roads, bridges, and buildings.',
        'Analytical,Practical',
        7,
        'Critical for Nepal infrastructure development. Government and private sector both have strong demand.'),

       ('Medical Doctor',
        'Diagnoses and treats illnesses and injuries.',
        'Analytical,Social',
        8,
        'High demand in Nepal with shortage of doctors in rural areas. MBBS offered at Tribhuvan and Kathmandu University.'),

       ('Teacher / Educator',
        'Teaches and mentors students at school or college level.',
        'Social,Creative',
        5,
        'Teaching Service Commission recruits thousands yearly. Growing demand in community schools across Nepal.'),

       ('Civil Servant / Government Officer',
        'Works in public administration to deliver government services.',
        'Analytical,Practical',
        6,
        'Loksewa Aayog exam is competitive. Permanent government jobs are highly valued in Nepal.'),

       ('Entrepreneur / Business Owner',
        'Starts and runs an independent business or enterprise.',
        'Creative,Practical',
        4,
        'Nepal government encourages youth entrepreneurship through programs like Business Incubation Centre.'),

       ('Journalist / Media Professional',
        'Reports news, writes articles, and produces media content.',
        'Creative,Social',
        5,
        'Growing media industry in Nepal with newspapers, FM radio, and online portals seeking skilled journalists.'),

       ('Architect',
        'Designs buildings and structures with both function and aesthetics in mind.',
        'Creative,Analytical',
        6,
        'Post-earthquake Nepal has high demand for qualified architects for reconstruction and urban planning.'),

       ('Lawyer',
        'Provides legal advice and represents clients in courts.',
        'Analytical,Social',
        7,
        'Demand growing as Nepal strengthens its legal system. Bar Council of Nepal regulates the profession.'),

       ('Agricultural Officer',
        'Advises farmers and manages agricultural development programs.',
        'Practical,Social',
        5,
        'Over 60% of Nepalis work in agriculture. Government agricultural extension officers are in high demand.'),

       ('Tourism / Hospitality Manager',
        'Manages hotels, trekking companies, and tourist services.',
        'Social,Creative',
        4,
        'Tourism is Nepal largest industry. Trekking, mountaineering, and cultural tourism drive major employment.'),

       ('Social Worker / NGO Professional',
        'Works with communities and organizations to address social issues.',
        'Social',
        3,
        'Nepal has thousands of active NGOs and INGOs. Strong demand for professionals in development work.'),

       ('Accountant / Finance Officer',
        'Manages financial records, budgets, and reports for organizations.',
        'Analytical,Practical',
        6,
        'Every business and government office needs accountants. ICAN certification is highly valued in Nepal.'),

       ('Nurse / Healthcare Worker',
        'Provides patient care and supports doctors in medical settings.',
        'Social,Practical',
        5,
        'Nepal has a shortage of nurses especially in rural hospitals and health posts.'),

       ('Graphic Designer',
        'Creates visual content for print, digital media, and advertising.',
        'Creative',
        4,
        'Growing demand from Nepali businesses for branding, social media, and advertising design work.');

-- =======================================================
-- SEED: Users (Sample accounts for testing)
-- Password for all is 'password123'
-- =======================================================

INSERT INTO users (full_name, email, password, role)
VALUES ('Sita Thapa', 'student@example.com', 'password123', 'STUDENT'),
       ('Arjun Sharma', 'devvv0264@gmail.com', 'password123', 'COUNSELOR'),
       ('Admin User', 'admin@example.com', 'password123', 'ADMIN');
