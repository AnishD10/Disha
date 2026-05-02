USE disha_career_portal;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('STUDENT', 'PARENT', 'COUNSELOR', 'ADMIN') NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_role (role),
    INDEX idx_email (email),
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_profiles (
    student_profile_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    date_of_birth DATE,
    academic_score DECIMAL(5, 2),
    school_name VARCHAR(150),
    gender ENUM('MALE', 'FEMALE', 'OTHER'),
    location VARCHAR(100),
    budget_range ENUM('LOW', 'MEDIUM', 'HIGH'),
    preferred_study_mode ENUM('ONLINE', 'OFFLINE', 'HYBRID'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_student_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_academic_score (academic_score),
    INDEX idx_location (location),
    INDEX idx_budget_range (budget_range)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE parent_student_links (
    link_id INT PRIMARY KEY AUTO_INCREMENT,
    parent_user_id INT NOT NULL,
    student_user_id INT NOT NULL,
    relationship VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_parent_user FOREIGN KEY (parent_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_student_user_link FOREIGN KEY (student_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_parent_student (parent_user_id, student_user_id),
    INDEX idx_parent_id (parent_user_id),
    INDEX idx_student_id (student_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE assessments (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    assessment_name VARCHAR(150) NOT NULL,
    description TEXT,
    total_questions INT,
    duration_minutes INT,
    passing_score INT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_assessment_creator FOREIGN KEY (created_by) REFERENCES users(user_id),
    INDEX idx_created_by (created_by)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    assessment_id INT NOT NULL,
    question_text TEXT NOT NULL,
    question_type ENUM('MULTIPLE_CHOICE', 'RATING_SCALE', 'OPEN_ENDED'),
    question_order INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_question_assessment FOREIGN KEY (assessment_id) REFERENCES assessments(assessment_id) ON DELETE CASCADE,
    INDEX idx_assessment_id (assessment_id),
    INDEX idx_question_order (question_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE question_options (
    option_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT NOT NULL,
    option_text VARCHAR(255),
    option_value INT,
    option_order INT,
    CONSTRAINT fk_option_question FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE,
    INDEX idx_question_id (question_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_assessments (
    student_assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_user_id INT NOT NULL,
    assessment_id INT NOT NULL,
    score INT,
    status ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED', 'FLAGGED'),
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_student_assessment_user FOREIGN KEY (student_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_student_assessment_assessment FOREIGN KEY (assessment_id) REFERENCES assessments(assessment_id),
    INDEX idx_student_user_id (student_user_id),
    INDEX idx_assessment_id (assessment_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_answers (
    answer_id INT PRIMARY KEY AUTO_INCREMENT,
    student_assessment_id INT NOT NULL,
    question_id INT NOT NULL,
    answer_text TEXT,
    answer_value INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_answer_student_assessment FOREIGN KEY (student_assessment_id) REFERENCES student_assessments(student_assessment_id) ON DELETE CASCADE,
    CONSTRAINT fk_answer_question FOREIGN KEY (question_id) REFERENCES questions(question_id),
    INDEX idx_student_assessment_id (student_assessment_id),
    INDEX idx_question_id (question_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE aptitude_profiles (
    aptitude_profile_id INT PRIMARY KEY AUTO_INCREMENT,
    student_user_id INT NOT NULL,
    student_assessment_id INT NOT NULL,
    skill_cluster VARCHAR(100),
    score INT,
    strength_level ENUM('LOW', 'MEDIUM', 'HIGH'),
    weakness_level ENUM('LOW', 'MEDIUM', 'HIGH'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_aptitude_student FOREIGN KEY (student_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_aptitude_assessment FOREIGN KEY (student_assessment_id) REFERENCES student_assessments(student_assessment_id),
    INDEX idx_student_user_id (student_user_id),
    INDEX idx_skill_cluster (skill_cluster)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE careers (
    career_id INT PRIMARY KEY AUTO_INCREMENT,
    career_name VARCHAR(150) NOT NULL,
    career_description TEXT,
    required_aptitude_cluster VARCHAR(100),
    average_salary DECIMAL(10, 2),
    salary_currency VARCHAR(10) DEFAULT 'NPR',
    market_demand ENUM('LOW', 'MEDIUM', 'HIGH'),
    risk_index INT,
    job_market_growth_rate DECIMAL(5, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_market_demand (market_demand),
    INDEX idx_aptitude_cluster (required_aptitude_cluster),
    INDEX idx_career_name (career_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE career_aptitude_mapping (
    mapping_id INT PRIMARY KEY AUTO_INCREMENT,
    career_id INT NOT NULL,
    skill_cluster VARCHAR(100),
    required_score_min INT,
    required_score_max INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mapping_career FOREIGN KEY (career_id) REFERENCES careers(career_id) ON DELETE CASCADE,
    UNIQUE KEY unique_career_skill (career_id, skill_cluster),
    INDEX idx_career_id (career_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE career_matches (
    career_match_id INT PRIMARY KEY AUTO_INCREMENT,
    student_user_id INT NOT NULL,
    career_id INT NOT NULL,
    aptitude_profile_id INT,
    match_score DECIMAL(5, 2),
    match_status ENUM('STRONG', 'MODERATE', 'WEAK'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_match_student FOREIGN KEY (student_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_match_career FOREIGN KEY (career_id) REFERENCES careers(career_id),
    CONSTRAINT fk_match_aptitude FOREIGN KEY (aptitude_profile_id) REFERENCES aptitude_profiles(aptitude_profile_id),
    INDEX idx_student_user_id (student_user_id),
    INDEX idx_career_id (career_id),
    INDEX idx_match_status (match_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE colleges (
    college_id INT PRIMARY KEY AUTO_INCREMENT,
    college_name VARCHAR(150) NOT NULL,
    college_location VARCHAR(100),
    college_city VARCHAR(50),
    college_description TEXT,
    website_url VARCHAR(255),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    is_public BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_verified BOOLEAN DEFAULT FALSE,
    INDEX idx_college_name (college_name),
    INDEX idx_college_location (college_location)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE degrees (
    degree_id INT PRIMARY KEY AUTO_INCREMENT,
    college_id INT NOT NULL,
    degree_name VARCHAR(150) NOT NULL,
    degree_level ENUM('DIPLOMA', 'BACHELORS', 'MASTERS', 'PHD'),
    field_of_study VARCHAR(100),
    duration_years INT,
    tuition_cost DECIMAL(10, 2),
    cost_currency VARCHAR(10) DEFAULT 'NPR',
    minimum_academic_score DECIMAL(5, 2),
    study_mode ENUM('ONLINE', 'OFFLINE', 'HYBRID'),
    linked_career_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_degree_college FOREIGN KEY (college_id) REFERENCES colleges(college_id) ON DELETE CASCADE,
    CONSTRAINT fk_degree_career FOREIGN KEY (linked_career_id) REFERENCES careers(career_id),
    INDEX idx_college_id (college_id),
    INDEX idx_degree_level (degree_level),
    INDEX idx_field_of_study (field_of_study)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_constraints (
    constraint_id INT PRIMARY KEY AUTO_INCREMENT,
    student_user_id INT NOT NULL,
    budget_max DECIMAL(10, 2),
    preferred_locations VARCHAR(500),
    academic_score_threshold DECIMAL(5, 2),
    preferred_degree_level ENUM('DIPLOMA', 'BACHELORS', 'MASTERS', 'PHD'),
    preferred_study_mode ENUM('ONLINE', 'OFFLINE', 'HYBRID'),
    preferred_career_paths VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_constraint_student FOREIGN KEY (student_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_student_constraint (student_user_id),
    INDEX idx_student_user_id (student_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE decision_plans (
    decision_plan_id INT PRIMARY KEY AUTO_INCREMENT,
    student_user_id INT NOT NULL,
    plan_name VARCHAR(150),
    degree_id INT NOT NULL,
    career_id INT,
    recommended_score DECIMAL(5, 2),
    match_percentage INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_plan_student FOREIGN KEY (student_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_plan_degree FOREIGN KEY (degree_id) REFERENCES degrees(degree_id),
    CONSTRAINT fk_plan_career FOREIGN KEY (career_id) REFERENCES careers(career_id),
    INDEX idx_student_user_id (student_user_id),
    INDEX idx_degree_id (degree_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE counselor_assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    counselor_user_id INT NOT NULL,
    student_user_id INT NOT NULL,
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    status ENUM('ACTIVE', 'INACTIVE', 'FLAGGED'),
    is_at_risk BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_assignment_counselor FOREIGN KEY (counselor_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_assignment_student FOREIGN KEY (student_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_counselor_student (counselor_user_id, student_user_id),
    INDEX idx_counselor_user_id (counselor_user_id),
    INDEX idx_student_user_id (student_user_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE counselor_reports (
    report_id INT PRIMARY KEY AUTO_INCREMENT,
    counselor_user_id INT NOT NULL,
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_students_managed INT,
    total_assessments_completed INT,
    at_risk_count INT,
    average_student_score DECIMAL(5, 2),
    report_content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_report_counselor FOREIGN KEY (counselor_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_counselor_user_id (counselor_user_id),
    INDEX idx_report_date (report_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE labour_market_data (
    market_data_id INT PRIMARY KEY AUTO_INCREMENT,
    career_id INT NOT NULL,
    data_year INT,
    job_openings INT,
    average_salary DECIMAL(10, 2),
    salary_currency VARCHAR(10) DEFAULT 'NPR',
    market_demand ENUM('LOW', 'MEDIUM', 'HIGH'),
    risk_index INT,
    growth_rate DECIMAL(5, 2),
    updated_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_market_data_career FOREIGN KEY (career_id) REFERENCES careers(career_id) ON DELETE CASCADE,
    CONSTRAINT fk_market_data_updater FOREIGN KEY (updated_by) REFERENCES users(user_id),
    INDEX idx_career_id (career_id),
    INDEX idx_data_year (data_year),
    INDEX idx_market_demand (market_demand)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE admin_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_user_id INT NOT NULL,
    action_type VARCHAR(100),
    entity_type VARCHAR(50),
    entity_id INT,
    old_value TEXT,
    new_value TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_admin_log_user FOREIGN KEY (admin_user_id) REFERENCES users(user_id),
    INDEX idx_admin_user_id (admin_user_id),
    INDEX idx_action_type (action_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE system_feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    feedback_type VARCHAR(50),
    rating INT,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    session_token VARCHAR(255) NOT NULL UNIQUE,
    ip_address VARCHAR(50),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_session_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_session_token (session_token),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
