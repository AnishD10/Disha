-- Adds the assessment-module tables expected by the integrated aptitude,
-- counselor, and parent dashboard code. This migration is additive only.

CREATE TABLE IF NOT EXISTS aptitude_questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    question_text TEXT NOT NULL,
    section ENUM('APTITUDE', 'PERSONALITY', 'INTEREST') NOT NULL,
    question_type ENUM('MCQ', 'LIKERT') NOT NULL,
    question_order INT NOT NULL,
    UNIQUE KEY unique_question_order (question_order),
    INDEX idx_section (section),
    INDEX idx_question_order (question_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS aptitude_options (
    option_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT NOT NULL,
    option_text VARCHAR(255) NOT NULL,
    score_value INT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_aptitude_option_question
        FOREIGN KEY (question_id) REFERENCES aptitude_questions(question_id)
        ON DELETE CASCADE,
    UNIQUE KEY unique_question_option (question_id, option_text),
    INDEX idx_question_id (question_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS assessment_attempts (
    attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    attempt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_completed BOOLEAN DEFAULT FALSE,
    aptitude_score INT DEFAULT 0,
    personality_score INT DEFAULT 0,
    interest_score INT DEFAULT 0,
    personality_cluster VARCHAR(50),
    CONSTRAINT fk_assessment_attempt_student
        FOREIGN KEY (student_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_attempt_date (attempt_date),
    INDEX idx_completed (is_completed)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS attempt_answers (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    attempt_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option_id INT NOT NULL,
    CONSTRAINT fk_attempt_answer_attempt
        FOREIGN KEY (attempt_id) REFERENCES assessment_attempts(attempt_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_attempt_answer_question
        FOREIGN KEY (question_id) REFERENCES aptitude_questions(question_id),
    CONSTRAINT fk_attempt_answer_option
        FOREIGN KEY (selected_option_id) REFERENCES aptitude_options(option_id),
    UNIQUE KEY unique_attempt_question (attempt_id, question_id),
    INDEX idx_attempt_id (attempt_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS attempt_skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    attempt_id INT NOT NULL,
    skill_name VARCHAR(100) NOT NULL,
    skill_score INT NOT NULL,
    skill_level ENUM('STRONG', 'AVERAGE', 'WEAK') NOT NULL,
    CONSTRAINT fk_attempt_skill_attempt
        FOREIGN KEY (attempt_id) REFERENCES assessment_attempts(attempt_id)
        ON DELETE CASCADE,
    UNIQUE KEY unique_attempt_skill (attempt_id, skill_name),
    INDEX idx_attempt_id (attempt_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS nepal_careers (
    career_id INT PRIMARY KEY AUTO_INCREMENT,
    career_name VARCHAR(100) NOT NULL,
    career_description TEXT,
    suitable_clusters VARCHAR(200),
    min_aptitude_score INT DEFAULT 0,
    nepal_relevance_note TEXT,
    UNIQUE KEY unique_nepal_career (career_name),
    INDEX idx_min_aptitude_score (min_aptitude_score)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS attempt_career_recs (
    rec_id INT PRIMARY KEY AUTO_INCREMENT,
    attempt_id INT NOT NULL,
    career_id INT NOT NULL,
    career_rank INT NOT NULL,
    CONSTRAINT fk_attempt_rec_attempt
        FOREIGN KEY (attempt_id) REFERENCES assessment_attempts(attempt_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_attempt_rec_career
        FOREIGN KEY (career_id) REFERENCES nepal_careers(career_id),
    UNIQUE KEY unique_attempt_rank (attempt_id, career_rank),
    INDEX idx_attempt_id (attempt_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO aptitude_questions
    (question_text, section, question_type, question_order)
VALUES
    ('Ramesh has 24 apples. He gives one-third to classmates. How many apples are left?', 'APTITUDE', 'MCQ', 1),
    ('A bus travels 200 km at 50 km/h. How long does the journey take?', 'APTITUDE', 'MCQ', 2),
    ('Which word does not belong: River, Mountain, Calculator, Valley?', 'APTITUDE', 'MCQ', 3),
    ('What comes next in the series: 3, 6, 12, 24, __?', 'APTITUDE', 'MCQ', 4),
    ('All birds can fly. An eagle is a bird. What can we conclude?', 'APTITUDE', 'MCQ', 5),
    ('If 1 USD equals 133 NPR, how many rupees are 3 USD?', 'APTITUDE', 'MCQ', 6),
    ('A shopkeeper buys for Rs. 400 and sells for Rs. 500. What is profit percent?', 'APTITUDE', 'MCQ', 7),
    ('Which shape has the most sides?', 'APTITUDE', 'MCQ', 8),
    ('If today is Wednesday, what day is it after 9 days?', 'APTITUDE', 'MCQ', 9),
    ('A train covers 60 km in 2 hours. What is the average speed?', 'APTITUDE', 'MCQ', 10),
    ('I enjoy solving mathematical puzzles and logical problems.', 'PERSONALITY', 'LIKERT', 11),
    ('I analyze information carefully before making decisions.', 'PERSONALITY', 'LIKERT', 12),
    ('I like breaking complex problems into small steps.', 'PERSONALITY', 'LIKERT', 13),
    ('I feel energized when working in a team.', 'PERSONALITY', 'LIKERT', 14),
    ('I enjoy listening to others and helping solve problems.', 'PERSONALITY', 'LIKERT', 15),
    ('I am comfortable speaking in front of a group.', 'PERSONALITY', 'LIKERT', 16),
    ('I enjoy creative activities such as writing, drawing, or music.', 'PERSONALITY', 'LIKERT', 17),
    ('I often think of original ideas for everyday challenges.', 'PERSONALITY', 'LIKERT', 18),
    ('I prefer trying new approaches over repeating old methods.', 'PERSONALITY', 'LIKERT', 19),
    ('I prefer hands-on practical work over theory.', 'PERSONALITY', 'LIKERT', 20),
    ('I would enjoy working in government or civil service.', 'INTEREST', 'LIKERT', 21),
    ('I am interested in computers and technology.', 'INTEREST', 'LIKERT', 22),
    ('I want work that directly serves the community.', 'INTEREST', 'LIKERT', 23),
    ('I prefer an office environment over outdoor field work.', 'INTEREST', 'LIKERT', 24),
    ('I dream of starting and running my own business.', 'INTEREST', 'LIKERT', 25),
    ('I am interested in Nepal history, culture, and tourism.', 'INTEREST', 'LIKERT', 26),
    ('I would enjoy frequent travel across Nepal.', 'INTEREST', 'LIKERT', 27),
    ('I am interested in health, medicine, and caring for people.', 'INTEREST', 'LIKERT', 28),
    ('I prefer job security and stability.', 'INTEREST', 'LIKERT', 29),
    ('I enjoy working with numbers, finance, and accounting data.', 'INTEREST', 'LIKERT', 30);

INSERT IGNORE INTO aptitude_options
    (question_id, option_text, score_value, is_correct)
SELECT q.question_id, o.option_text, o.score_value, o.is_correct
FROM aptitude_questions q
JOIN (
    SELECT 1 ord, '6' option_text, 0 score_value, FALSE is_correct UNION ALL
    SELECT 1, '8', 0, FALSE UNION ALL
    SELECT 1, '16', 1, TRUE UNION ALL
    SELECT 1, '18', 0, FALSE UNION ALL
    SELECT 2, '2 hours', 0, FALSE UNION ALL
    SELECT 2, '3 hours', 0, FALSE UNION ALL
    SELECT 2, '4 hours', 1, TRUE UNION ALL
    SELECT 2, '5 hours', 0, FALSE UNION ALL
    SELECT 3, 'River', 0, FALSE UNION ALL
    SELECT 3, 'Mountain', 0, FALSE UNION ALL
    SELECT 3, 'Calculator', 1, TRUE UNION ALL
    SELECT 3, 'Valley', 0, FALSE UNION ALL
    SELECT 4, '36', 0, FALSE UNION ALL
    SELECT 4, '48', 1, TRUE UNION ALL
    SELECT 4, '30', 0, FALSE UNION ALL
    SELECT 4, '42', 0, FALSE UNION ALL
    SELECT 5, 'Eagles cannot fly', 0, FALSE UNION ALL
    SELECT 5, 'Eagles can fly', 1, TRUE UNION ALL
    SELECT 5, 'Some birds cannot fly', 0, FALSE UNION ALL
    SELECT 5, 'Eagles are not birds', 0, FALSE UNION ALL
    SELECT 6, '266 NPR', 0, FALSE UNION ALL
    SELECT 6, '333 NPR', 0, FALSE UNION ALL
    SELECT 6, '399 NPR', 1, TRUE UNION ALL
    SELECT 6, '430 NPR', 0, FALSE UNION ALL
    SELECT 7, '15%', 0, FALSE UNION ALL
    SELECT 7, '20%', 0, FALSE UNION ALL
    SELECT 7, '25%', 1, TRUE UNION ALL
    SELECT 7, '30%', 0, FALSE UNION ALL
    SELECT 8, 'Triangle', 0, FALSE UNION ALL
    SELECT 8, 'Square', 0, FALSE UNION ALL
    SELECT 8, 'Pentagon', 0, FALSE UNION ALL
    SELECT 8, 'Hexagon', 1, TRUE UNION ALL
    SELECT 9, 'Thursday', 0, FALSE UNION ALL
    SELECT 9, 'Friday', 1, TRUE UNION ALL
    SELECT 9, 'Saturday', 0, FALSE UNION ALL
    SELECT 9, 'Sunday', 0, FALSE UNION ALL
    SELECT 10, '20 km/h', 0, FALSE UNION ALL
    SELECT 10, '25 km/h', 0, FALSE UNION ALL
    SELECT 10, '30 km/h', 1, TRUE UNION ALL
    SELECT 10, '35 km/h', 0, FALSE
) o ON q.question_order = o.ord;

INSERT IGNORE INTO aptitude_options
    (question_id, option_text, score_value, is_correct)
SELECT q.question_id, o.option_text, o.score_value, FALSE
FROM aptitude_questions q
JOIN (
    SELECT 'Strongly Disagree' option_text, 1 score_value UNION ALL
    SELECT 'Disagree', 2 UNION ALL
    SELECT 'Neutral', 3 UNION ALL
    SELECT 'Agree', 4 UNION ALL
    SELECT 'Strongly Agree', 5
) o
WHERE q.question_order BETWEEN 11 AND 30;

INSERT IGNORE INTO nepal_careers
    (career_name, career_description, suitable_clusters, min_aptitude_score, nepal_relevance_note)
VALUES
    ('Software Engineer', 'Designs and builds software applications and systems.', 'Analytical,Creative', 6, 'High demand in Nepal IT companies and remote software teams.'),
    ('Civil Engineer', 'Plans and oversees construction of roads, bridges, and buildings.', 'Analytical,Practical', 7, 'Important for infrastructure development and reconstruction work.'),
    ('Medical Doctor', 'Diagnoses and treats illnesses and injuries.', 'Analytical,Social', 8, 'Strong demand across urban and rural health systems.'),
    ('Teacher / Educator', 'Teaches and mentors students.', 'Social,Creative', 5, 'Useful in schools, colleges, tutoring, and edtech.'),
    ('Civil Servant', 'Works in public administration and government services.', 'Analytical,Practical', 6, 'Loksewa-oriented path with stable public service work.'),
    ('Entrepreneur', 'Starts and runs a business or enterprise.', 'Creative,Practical', 4, 'Relevant for local business, startups, tourism, and trade.'),
    ('Tourism Manager', 'Manages hospitality, trekking, and travel services.', 'Social,Creative', 4, 'Fits Nepal tourism, hotel, and travel industries.'),
    ('Accountant', 'Manages financial records, budgets, and reports.', 'Analytical,Practical', 6, 'Needed by businesses, NGOs, banks, and government offices.');
