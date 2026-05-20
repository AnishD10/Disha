USE disha_career_portal;

INSERT INTO users
(username, email, password_hash, role, first_name, last_name, is_active)
VALUES
('career_test_student', 'career_test_student@disha.local', 'local-test-password-placeholder',
 'STUDENT', 'Career', 'Test Student', TRUE)
ON DUPLICATE KEY UPDATE
    user_id = LAST_INSERT_ID(user_id),
    role = 'STUDENT',
    first_name = 'Career',
    last_name = 'Test Student',
    is_active = TRUE;

SET @student_user_id = LAST_INSERT_ID();

INSERT INTO aptitude_profiles
(student_id, analytical_score, creativity_score, leadership_score, technical_score,
 communication_score, entrepreneurial_score, research_score)
VALUES
(@student_user_id, 84, 62, 58, 88, 66, 52, 74)
ON DUPLICATE KEY UPDATE
    analytical_score = VALUES(analytical_score),
    creativity_score = VALUES(creativity_score),
    leadership_score = VALUES(leadership_score),
    technical_score = VALUES(technical_score),
    communication_score = VALUES(communication_score),
    entrepreneurial_score = VALUES(entrepreneurial_score),
    research_score = VALUES(research_score);

SELECT @student_user_id AS local_student_id;
