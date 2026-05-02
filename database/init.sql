-- Initial data setup for Disha application
-- This file is executed after schema.sql

-- Insert initial admin user (password: admin123)
INSERT INTO users (username, email, password_hash, role, first_name, last_name, is_active) 
VALUES ('admin', 'admin@disha.com', '$2a$10$...', 'ADMIN', 'Admin', 'User', TRUE);

-- Insert sample assessments
INSERT INTO assessments (assessment_name, description, total_questions, duration_minutes, passing_score, created_by, is_active) 
VALUES 
('Career Aptitude Test', 'Comprehensive aptitude assessment for career guidance', 50, 60, 70, 1, TRUE),
('Interest Inventory', 'Identify your professional interests', 40, 45, 60, 1, TRUE),
('Skill Assessment', 'Evaluate your current skill levels', 30, 30, 75, 1, TRUE);

-- Insert sample questions (for Career Aptitude Test - Assessment ID 1)
INSERT INTO questions (assessment_id, question_text, question_type, question_order) 
VALUES 
(1, 'Which type of work environment do you prefer?', 'MULTIPLE_CHOICE', 1),
(1, 'How would you rate your analytical skills?', 'RATING_SCALE', 2),
(1, 'What motivates you most in a career?', 'OPEN_ENDED', 3);

-- Insert sample question options
INSERT INTO question_options (question_id, option_text, option_value, option_order) 
VALUES 
(1, 'Structured and organized', 1, 1),
(1, 'Creative and flexible', 2, 2),
(1, 'Team-based and collaborative', 3, 3),
(1, 'Independent and autonomous', 4, 4);
