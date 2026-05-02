-- MySQL Setup Script for Disha Career Intelligence Portal
-- Execute this file as root user to set up the database and user

-- Create the database
CREATE DATABASE IF NOT EXISTS disha_career_portal;

-- Use the database
USE disha_career_portal;

-- Create user 'disha' with password 'disha123'
-- First, drop the user if it exists (to avoid errors on re-run)
DROP USER IF EXISTS 'disha'@'localhost';

-- Create the new user
CREATE USER 'disha'@'localhost' IDENTIFIED BY 'disha123';

-- Grant all privileges on disha_career_portal database to disha user
GRANT ALL PRIVILEGES ON disha_career_portal.* TO 'disha'@'localhost';

-- Flush privileges to reload grant tables
FLUSH PRIVILEGES;

-- Verify the setup
SELECT 'User disha created successfully' as status;
SHOW DATABASES LIKE 'disha%';
SELECT User, Host FROM mysql.user WHERE User = 'disha';
