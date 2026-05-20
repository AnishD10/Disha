-- DISHA Career Discovery integration migration.
-- Safe intent: create missing career-module tables and seed baseline career data
-- without dropping shared integration tables.
--
-- Manual review required before shared-database execution:
-- 1. Confirm whether `careers` and `aptitude_profiles` are shared by other modules.
-- 2. If those tables already exist with different columns, do not run this file
--    until the team chooses whether to extend the shared tables or refactor DAO code.

USE disha_career_portal;

CREATE TABLE IF NOT EXISTS careers (
    career_id INT AUTO_INCREMENT PRIMARY KEY,
    career_name VARCHAR(150) NOT NULL,
    overview TEXT NOT NULL,
    responsibilities TEXT NOT NULL,
    industry VARCHAR(120) NOT NULL,
    future_scope TEXT NOT NULL,
    salary_entry DECIMAL(12, 2) NOT NULL,
    salary_mid DECIMAL(12, 2) NOT NULL,
    salary_senior DECIMAL(12, 2) NOT NULL,
    demand_level ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL DEFAULT 'MEDIUM',
    automation_risk ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL DEFAULT 'MEDIUM',
    remote_opportunity ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL DEFAULT 'MEDIUM',
    growth_rate DECIMAL(5, 2) NOT NULL DEFAULT 0.00,
    description TEXT NOT NULL,
    suggested_certifications TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_career_name (career_name),
    INDEX idx_industry (industry),
    INDEX idx_demand_level (demand_level),
    INDEX idx_salary_mid (salary_mid),
    INDEX idx_growth_rate (growth_rate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS aptitude_profiles (
    aptitude_profile_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL UNIQUE,
    analytical_score INT NOT NULL DEFAULT 0,
    creativity_score INT NOT NULL DEFAULT 0,
    leadership_score INT NOT NULL DEFAULT 0,
    technical_score INT NOT NULL DEFAULT 0,
    communication_score INT NOT NULL DEFAULT 0,
    entrepreneurial_score INT NOT NULL DEFAULT 0,
    research_score INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_aptitude_profiles_student
        FOREIGN KEY (student_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_aptitude_analytical CHECK (analytical_score BETWEEN 0 AND 100),
    CONSTRAINT chk_aptitude_creativity CHECK (creativity_score BETWEEN 0 AND 100),
    CONSTRAINT chk_aptitude_leadership CHECK (leadership_score BETWEEN 0 AND 100),
    CONSTRAINT chk_aptitude_technical CHECK (technical_score BETWEEN 0 AND 100),
    CONSTRAINT chk_aptitude_communication CHECK (communication_score BETWEEN 0 AND 100),
    CONSTRAINT chk_aptitude_entrepreneurial CHECK (entrepreneurial_score BETWEEN 0 AND 100),
    CONSTRAINT chk_aptitude_research CHECK (research_score BETWEEN 0 AND 100),
    INDEX idx_technical_score (technical_score),
    INDEX idx_analytical_score (analytical_score),
    INDEX idx_creativity_score (creativity_score)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS career_match_rules (
    rule_id INT AUTO_INCREMENT PRIMARY KEY,
    career_id INT NOT NULL UNIQUE,
    required_analytical INT NOT NULL DEFAULT 0,
    required_creativity INT NOT NULL DEFAULT 0,
    required_leadership INT NOT NULL DEFAULT 0,
    required_technical INT NOT NULL DEFAULT 0,
    required_communication INT NOT NULL DEFAULT 0,
    required_entrepreneurial INT NOT NULL DEFAULT 0,
    required_research INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_match_rules_career
        FOREIGN KEY (career_id) REFERENCES careers(career_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_rule_career_id (career_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS career_skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    career_id INT NOT NULL,
    skill_name VARCHAR(150) NOT NULL,
    skill_type ENUM('TECHNICAL', 'SOFT', 'DOMAIN', 'TOOL') NOT NULL,
    skill_level ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED') NOT NULL DEFAULT 'BEGINNER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_career_skills_career
        FOREIGN KEY (career_id) REFERENCES careers(career_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_career_skill_name (career_id, skill_name),
    INDEX idx_skill_career_id (career_id),
    INDEX idx_skill_type (skill_type),
    INDEX idx_skill_name (skill_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS career_roadmaps (
    roadmap_id INT AUTO_INCREMENT PRIMARY KEY,
    career_id INT NOT NULL,
    stage_name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    estimated_duration VARCHAR(80) NOT NULL,
    stage_order INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_career_roadmaps_career
        FOREIGN KEY (career_id) REFERENCES careers(career_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_career_stage (career_id, stage_order),
    INDEX idx_roadmap_career_id (career_id),
    INDEX idx_roadmap_stage_order (stage_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS career_courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    career_id INT NOT NULL,
    course_name VARCHAR(180) NOT NULL,
    platform VARCHAR(100) NOT NULL,
    difficulty ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED') NOT NULL DEFAULT 'BEGINNER',
    duration VARCHAR(80) NOT NULL,
    free_paid ENUM('FREE', 'PAID', 'FREEMIUM') NOT NULL DEFAULT 'FREE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_career_courses_career
        FOREIGN KEY (career_id) REFERENCES careers(career_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_career_course (career_id, course_name, platform),
    INDEX idx_course_career_id (career_id),
    INDEX idx_course_difficulty (difficulty),
    INDEX idx_course_platform (platform)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS saved_careers (
    saved_career_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    career_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_saved_careers_student
        FOREIGN KEY (student_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_saved_careers_career
        FOREIGN KEY (career_id) REFERENCES careers(career_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_saved_career (student_id, career_id),
    INDEX idx_saved_student_id (student_id),
    INDEX idx_saved_career_id (career_id),
    INDEX idx_saved_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO careers
(career_id, career_name, overview, responsibilities, industry, future_scope, salary_entry, salary_mid, salary_senior,
 demand_level, automation_risk, remote_opportunity, growth_rate, description, suggested_certifications)
VALUES
(1, 'Software Engineer', 'Designs, builds, tests, and maintains web, mobile, and enterprise software systems.', 'Develop applications, review code, write tests, debug production issues, collaborate with product teams, and improve system performance.', 'Information Technology', 'Strong demand in Nepal for fintech, edtech, outsourcing, SaaS, and remote international engineering roles.', 420000, 900000, 1800000, 'HIGH', 'MEDIUM', 'HIGH', 18.50, 'A high-growth technology career for students with strong technical and analytical aptitude.', 'Oracle Java Certification, AWS Cloud Practitioner, Scrum Fundamentals'),
(2, 'UI/UX Designer', 'Researches user needs and creates accessible digital experiences for websites and apps.', 'Conduct user interviews, design wireframes, build prototypes, run usability tests, and collaborate with developers.', 'Digital Product Design', 'Growing opportunity as Nepali startups and service companies improve digital products for local and global users.', 300000, 720000, 1400000, 'HIGH', 'LOW', 'HIGH', 15.00, 'Ideal for creative students who communicate clearly and enjoy solving usability problems.', 'Google UX Design Certificate, Human-Computer Interaction, Figma Professional Training'),
(3, 'Data Analyst', 'Turns raw data into reports, dashboards, and insights for business and public-sector decisions.', 'Clean datasets, write SQL queries, build dashboards, analyze trends, and present insights to stakeholders.', 'Data and Business Intelligence', 'High growth as banks, NGOs, ecommerce companies, and government projects adopt data-driven planning.', 360000, 780000, 1500000, 'HIGH', 'MEDIUM', 'MEDIUM', 17.00, 'Best suited to analytical students who enjoy research, statistics, and practical business problem solving.', 'Google Data Analytics, Microsoft Power BI Data Analyst, Tableau Desktop Specialist'),
(4, 'Public Health Researcher', 'Studies health trends, evaluates programs, and supports evidence-based health policy in Nepal.', 'Design surveys, collect and analyze health data, write research reports, and coordinate with communities and institutions.', 'Public Health and Development', 'Stable demand through NGOs, INGOs, hospitals, universities, and public health agencies.', 320000, 760000, 1300000, 'MEDIUM', 'LOW', 'MEDIUM', 9.50, 'A research-oriented career for students interested in community impact and evidence-based policy.', 'Research Ethics, SPSS/STATA Training, Monitoring and Evaluation Certificate'),
(5, 'Digital Marketing Strategist', 'Plans campaigns across social media, search, content, and analytics to grow brands and products.', 'Create campaign strategy, manage ads, write content briefs, analyze conversion data, and coordinate creative teams.', 'Marketing and Media', 'Demand is increasing as Nepali businesses shift to ecommerce, tourism marketing, and online services.', 300000, 650000, 1200000, 'HIGH', 'MEDIUM', 'HIGH', 14.00, 'Good fit for students with creativity, communication, and entrepreneurial thinking.', 'Google Ads Certification, Meta Blueprint, HubSpot Content Marketing'),
(6, 'Civil Engineer', 'Plans, designs, and supervises infrastructure projects such as roads, buildings, bridges, and water systems.', 'Prepare designs, inspect construction work, manage site teams, estimate costs, and ensure safety compliance.', 'Engineering and Infrastructure', 'Long-term demand continues through urban development, hydropower, roads, reconstruction, and municipal planning.', 360000, 840000, 1600000, 'MEDIUM', 'LOW', 'LOW', 8.00, 'Suited to analytical and leadership-focused students who want tangible infrastructure impact.', 'Nepal Engineering Council License, AutoCAD Civil 3D, Project Management Fundamentals')
ON DUPLICATE KEY UPDATE
    career_name = VALUES(career_name),
    overview = VALUES(overview),
    responsibilities = VALUES(responsibilities),
    industry = VALUES(industry),
    future_scope = VALUES(future_scope),
    salary_entry = VALUES(salary_entry),
    salary_mid = VALUES(salary_mid),
    salary_senior = VALUES(salary_senior),
    demand_level = VALUES(demand_level),
    automation_risk = VALUES(automation_risk),
    remote_opportunity = VALUES(remote_opportunity),
    growth_rate = VALUES(growth_rate),
    description = VALUES(description),
    suggested_certifications = VALUES(suggested_certifications);

INSERT INTO career_match_rules
(career_id, required_analytical, required_creativity, required_leadership, required_technical,
 required_communication, required_entrepreneurial, required_research)
VALUES
(1, 78, 55, 50, 85, 60, 45, 65),
(2, 55, 88, 50, 58, 75, 55, 60),
(3, 85, 45, 45, 72, 62, 45, 80),
(4, 75, 50, 58, 55, 72, 45, 85),
(5, 58, 78, 65, 55, 82, 78, 58),
(6, 78, 48, 70, 76, 62, 45, 68)
ON DUPLICATE KEY UPDATE
    required_analytical = VALUES(required_analytical),
    required_creativity = VALUES(required_creativity),
    required_leadership = VALUES(required_leadership),
    required_technical = VALUES(required_technical),
    required_communication = VALUES(required_communication),
    required_entrepreneurial = VALUES(required_entrepreneurial),
    required_research = VALUES(required_research);

INSERT IGNORE INTO career_skills (career_id, skill_name, skill_type, skill_level) VALUES
(1, 'Java Servlet and JSP', 'TECHNICAL', 'INTERMEDIATE'),
(1, 'SQL and database design', 'TECHNICAL', 'INTERMEDIATE'),
(1, 'Problem solving', 'SOFT', 'ADVANCED'),
(1, 'Git and code review', 'TOOL', 'INTERMEDIATE'),
(2, 'User research', 'DOMAIN', 'INTERMEDIATE'),
(2, 'Wireframing and prototyping', 'TECHNICAL', 'INTERMEDIATE'),
(2, 'Figma', 'TOOL', 'INTERMEDIATE'),
(2, 'Visual communication', 'SOFT', 'ADVANCED'),
(3, 'SQL analytics', 'TECHNICAL', 'ADVANCED'),
(3, 'Excel or Google Sheets', 'TOOL', 'INTERMEDIATE'),
(3, 'Dashboard design', 'TECHNICAL', 'INTERMEDIATE'),
(3, 'Statistical reasoning', 'DOMAIN', 'INTERMEDIATE'),
(4, 'Survey design', 'DOMAIN', 'INTERMEDIATE'),
(4, 'Research writing', 'SOFT', 'ADVANCED'),
(4, 'SPSS or STATA', 'TOOL', 'INTERMEDIATE'),
(4, 'Community coordination', 'SOFT', 'INTERMEDIATE'),
(5, 'SEO and SEM', 'TECHNICAL', 'INTERMEDIATE'),
(5, 'Content strategy', 'DOMAIN', 'INTERMEDIATE'),
(5, 'Campaign analytics', 'TECHNICAL', 'INTERMEDIATE'),
(5, 'Client communication', 'SOFT', 'ADVANCED'),
(6, 'Structural fundamentals', 'DOMAIN', 'INTERMEDIATE'),
(6, 'AutoCAD', 'TOOL', 'INTERMEDIATE'),
(6, 'Site supervision', 'DOMAIN', 'INTERMEDIATE'),
(6, 'Team leadership', 'SOFT', 'INTERMEDIATE');

INSERT IGNORE INTO career_roadmaps (career_id, stage_name, description, estimated_duration, stage_order) VALUES
(1, 'Programming Foundation', 'Learn Java, OOP, data structures, SQL, HTML, CSS, and JavaScript basics.', '3-6 months', 1),
(1, 'Web Application Development', 'Build Servlet/JSP MVC apps with JDBC, authentication, validation, and deployment.', '4-6 months', 2),
(1, 'Portfolio and Internship', 'Publish projects on GitHub, practice interviews, and apply for internships or junior roles.', '2-4 months', 3),
(2, 'Design Foundation', 'Study layout, color, typography, accessibility, and user psychology.', '2-3 months', 1),
(2, 'UX Practice', 'Run user research, create personas, wireframes, prototypes, and usability tests.', '3-5 months', 2),
(2, 'Portfolio Case Studies', 'Create 3 detailed case studies for local products or nonprofit problems.', '2-4 months', 3),
(3, 'Data Fundamentals', 'Learn spreadsheets, SQL, descriptive statistics, and data cleaning.', '3-4 months', 1),
(3, 'BI Tools', 'Build dashboards in Power BI or Tableau using real datasets.', '2-4 months', 2),
(3, 'Applied Analytics', 'Complete business, NGO, or public-data analysis projects.', '2-3 months', 3),
(4, 'Research Foundation', 'Study public health basics, epidemiology, survey methods, and ethics.', '4-6 months', 1),
(4, 'Field and Data Skills', 'Practice data collection, SPSS/STATA, interviews, and report writing.', '3-5 months', 2),
(4, 'Project Experience', 'Assist in NGO, hospital, university, or community research projects.', '3-6 months', 3),
(5, 'Marketing Foundation', 'Learn consumer behavior, branding, copywriting, SEO, and social media channels.', '2-3 months', 1),
(5, 'Campaign Execution', 'Run small campaigns, track analytics, and optimize conversion.', '3-4 months', 2),
(5, 'Strategy Portfolio', 'Prepare campaign reports and case studies for local businesses.', '2-3 months', 3),
(6, 'Engineering Foundation', 'Build strength in mathematics, mechanics, materials, surveying, and drawing.', '6-12 months', 1),
(6, 'Design and Site Tools', 'Learn AutoCAD, estimation, safety practices, and project documentation.', '4-6 months', 2),
(6, 'Professional Licensing', 'Complete internships, site exposure, and Nepal Engineering Council registration.', '6-12 months', 3);

INSERT IGNORE INTO career_courses (career_id, course_name, platform, difficulty, duration, free_paid) VALUES
(1, 'Java Programming and Software Engineering Fundamentals', 'Coursera', 'BEGINNER', '4 months', 'FREEMIUM'),
(1, 'SQL for Data Science', 'Coursera', 'BEGINNER', '4 weeks', 'FREEMIUM'),
(1, 'CS50 Web Programming', 'edX', 'INTERMEDIATE', '12 weeks', 'FREE'),
(2, 'Google UX Design Professional Certificate', 'Coursera', 'BEGINNER', '6 months', 'FREEMIUM'),
(2, 'Figma UI UX Design Essentials', 'Udemy', 'BEGINNER', '11 hours', 'PAID'),
(2, 'Human-Computer Interaction', 'Interaction Design Foundation', 'INTERMEDIATE', '6 weeks', 'PAID'),
(3, 'Google Data Analytics Professional Certificate', 'Coursera', 'BEGINNER', '6 months', 'FREEMIUM'),
(3, 'Power BI Data Analyst Associate', 'Microsoft Learn', 'INTERMEDIATE', '6 weeks', 'FREE'),
(3, 'Statistics with Python', 'Coursera', 'INTERMEDIATE', '8 weeks', 'FREEMIUM'),
(4, 'Epidemiology: The Basic Science of Public Health', 'Coursera', 'BEGINNER', '6 weeks', 'FREEMIUM'),
(4, 'Monitoring and Evaluation Fundamentals', 'Global Health eLearning Center', 'BEGINNER', '8 hours', 'FREE'),
(4, 'Research Methodology', 'NPTEL', 'INTERMEDIATE', '12 weeks', 'FREE'),
(5, 'Fundamentals of Digital Marketing', 'Google Digital Garage', 'BEGINNER', '40 hours', 'FREE'),
(5, 'Meta Social Media Marketing', 'Coursera', 'BEGINNER', '5 months', 'FREEMIUM'),
(5, 'SEO Training', 'HubSpot Academy', 'BEGINNER', '4 hours', 'FREE'),
(6, 'AutoCAD Civil 3D Training', 'Autodesk Learning', 'INTERMEDIATE', '6 weeks', 'FREEMIUM'),
(6, 'Construction Project Management', 'Coursera', 'INTERMEDIATE', '5 weeks', 'FREEMIUM'),
(6, 'Structural Engineering Basics', 'NPTEL', 'INTERMEDIATE', '12 weeks', 'FREE');
