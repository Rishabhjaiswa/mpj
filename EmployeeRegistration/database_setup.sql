-- ================================================================
-- Employee Registration System – MySQL Database Setup Script
-- ================================================================
-- Run this script in MySQL Workbench or via the CLI:
--   mysql -u root -p < database_setup.sql
-- ================================================================

-- 1. Create & select the database
CREATE DATABASE IF NOT EXISTS empdb
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE empdb;

-- 2. Create the employees table
CREATE TABLE IF NOT EXISTS employees (
    id           INT          AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    department   VARCHAR(50)  DEFAULT 'General',
    salary       DOUBLE       DEFAULT 0.00,
    phone        VARCHAR(15)  DEFAULT NULL,
    joined_date  DATE         DEFAULT NULL,
    created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. Insert sample data
INSERT INTO employees (name, email, department, salary, phone, joined_date) VALUES
  ('Aarav Sharma',   'aarav.sharma@company.com',   'Engineering',     75000.00, '9876543210', '2022-06-01'),
  ('Priya Verma',    'priya.verma@company.com',    'Human Resources', 55000.00, '9123456789', '2021-03-15'),
  ('Rohit Mehta',    'rohit.mehta@company.com',    'Finance',         82000.00, '9988776655', '2020-11-20'),
  ('Sneha Patel',    'sneha.patel@company.com',    'Marketing',       60000.00, '9871234560', '2023-01-10'),
  ('Vikram Singh',   'vikram.singh@company.com',   'Sales',           65000.00, '9765432109', '2019-08-05'),
  ('Ananya Iyer',    'ananya.iyer@company.com',    'Product',         90000.00, '9654321098', '2022-09-12'),
  ('Kiran Joshi',    'kiran.joshi@company.com',    'Design',          70000.00, '9543210987', '2021-07-22'),
  ('Meera Nair',     'meera.nair@company.com',     'Operations',      58000.00, '9432109876', '2020-04-18');

-- 4. Verify insert
SELECT id, name, email, department, salary FROM employees ORDER BY name;
