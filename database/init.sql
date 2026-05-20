-- Initial data setup for Disha application
-- This file is executed after schema.sql

USE disha_db;

-- Insert initial admin user (password: admin123 -> SHA-256 hash)
INSERT INTO users (username, email, password_hash, role, first_name, last_name, phone, is_active) 
VALUES ('admin', 'admin@disha.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'ADMIN', 'Admin', 'User', '9800000000', TRUE);

-- Insert sample students
INSERT INTO users (username, email, password_hash, role, first_name, last_name, phone, is_active) VALUES 
('ram_sharma', 'ram@student.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'STUDENT', 'Ram', 'Sharma', '9801000001', TRUE),
('sita_kc', 'sita@student.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'STUDENT', 'Sita', 'KC', '9801000002', TRUE),
('hari_thapa', 'hari@student.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'STUDENT', 'Hari', 'Thapa', '9801000003', TRUE),
('gita_poudel', 'gita@student.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'STUDENT', 'Gita', 'Poudel', '9801000004', TRUE),
('bikash_rai', 'bikash@student.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'STUDENT', 'Bikash', 'Rai', '9801000005', TRUE);

-- Insert sample parents
INSERT INTO users (username, email, password_hash, role, first_name, last_name, phone, is_active) VALUES 
('parent_sharma', 'parent.sharma@disha.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'PARENT', 'Krishna', 'Sharma', '9802000001', TRUE),
('parent_kc', 'parent.kc@disha.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'PARENT', 'Durga', 'KC', '9802000002', TRUE);

-- Insert sample counselors
INSERT INTO users (username, email, password_hash, role, first_name, last_name, phone, is_active) VALUES 
('counselor1', 'counselor1@disha.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'COUNSELOR', 'Rajesh', 'Hamal', '9803000001', TRUE),
('counselor2', 'counselor2@disha.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'COUNSELOR', 'Anita', 'Gurung', '9803000002', TRUE);

-- Insert sample careers
INSERT INTO careers (career_name, career_description, required_aptitude_cluster, average_salary, market_demand, risk_index, job_market_growth_rate) VALUES 
('Software Engineer', 'Design, develop, and maintain software applications', 'Analytical', 120000.00, 'HIGH', 2, 15.50),
('Data Analyst', 'Analyze data to help organizations make informed decisions', 'Analytical', 80000.00, 'HIGH', 3, 12.00),
('Civil Engineer', 'Plan, design, and oversee construction projects', 'Technical', 70000.00, 'MEDIUM', 4, 8.00),
('Doctor (MBBS)', 'Diagnose and treat patients in healthcare settings', 'Scientific', 150000.00, 'HIGH', 2, 10.00),
('Teacher', 'Educate students in schools and colleges', 'Interpersonal', 45000.00, 'MEDIUM', 5, 5.00),
('Graphic Designer', 'Create visual content for digital and print media', 'Creative', 55000.00, 'MEDIUM', 4, 9.00),
('Accountant', 'Manage financial records and prepare reports', 'Numerical', 60000.00, 'MEDIUM', 3, 6.00),
('Nurse', 'Provide patient care in healthcare facilities', 'Scientific', 50000.00, 'HIGH', 3, 11.00);

-- Insert sample colleges
INSERT INTO colleges (college_name, college_location, college_city, college_description, website_url, contact_email, contact_phone, is_public, is_verified) VALUES 
('Tribhuvan University', 'Kirtipur', 'Kathmandu', 'Oldest and largest university in Nepal', 'https://tu.edu.np', 'info@tu.edu.np', '01-4331964', TRUE, TRUE),
('Kathmandu University', 'Dhulikhel', 'Kavre', 'Autonomous public university established in 1991', 'https://ku.edu.np', 'info@ku.edu.np', '011-661399', FALSE, TRUE),
('Pokhara University', 'Dhungepatan', 'Kaski', 'University focused on science, technology and management', 'https://pu.edu.np', 'info@pu.edu.np', '061-504072', TRUE, TRUE),
('Purbanchal University', 'Biratnagar', 'Morang', 'University in eastern Nepal', 'https://puranchaluniversity.edu.np', 'info@puranchaluniversity.edu.np', '021-525242', TRUE, TRUE),
('Nepal Engineering College', 'Changunarayan', 'Bhaktapur', 'Premier engineering college affiliated to Pokhara University', 'https://nec.edu.np', 'info@nec.edu.np', '01-6614149', FALSE, TRUE);

-- Insert sample assessments
INSERT INTO assessments (assessment_name, description, total_questions, duration_minutes, passing_score, created_by, is_active) VALUES 
('Career Aptitude Test', 'Comprehensive aptitude assessment for career guidance', 50, 60, 70, 1, TRUE),
('Interest Inventory', 'Identify your professional interests', 40, 45, 60, 1, TRUE),
('Skill Assessment', 'Evaluate your current skill levels', 30, 30, 75, 1, TRUE),
('Personality Test', 'Understand your personality traits for career matching', 25, 20, 50, 1, TRUE),
('Logical Reasoning', 'Test your logical and analytical thinking abilities', 35, 40, 65, 1, TRUE);

-- Insert sample questions
INSERT INTO questions (assessment_id, question_text, question_type, question_order) VALUES 
(1, 'Which type of work environment do you prefer?', 'MULTIPLE_CHOICE', 1),
(1, 'How would you rate your analytical skills?', 'RATING_SCALE', 2),
(1, 'What motivates you most in a career?', 'OPEN_ENDED', 3);

-- Insert sample question options
INSERT INTO question_options (question_id, option_text, option_value, option_order) VALUES 
(1, 'Structured and organized', 1, 1),
(1, 'Creative and flexible', 2, 2),
(1, 'Team-based and collaborative', 3, 3),
(1, 'Independent and autonomous', 4, 4);
