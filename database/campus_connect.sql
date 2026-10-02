-- ====================================================================
-- Campus Connect - College Complaint & Issue Management Portal
-- Database Initialization Script for MySQL / MySQL Workbench
-- Project: B.Sc.IT Undergraduate Mini Project
-- ====================================================================

-- 1. Create Database if not exists
CREATE DATABASE IF NOT EXISTS campus_connect
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE campus_connect;

-- Disable foreign key checks during schema creation
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Drop existing tables if re-running script
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS lost_found;
DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS students;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ====================================================================
-- 3. Table: students
-- Primary Key: roll_number (e.g. 243-02-A-0007)
-- ====================================================================
CREATE TABLE students (
    roll_number VARCHAR(50) NOT NULL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    course VARCHAR(50) NOT NULL,
    year VARCHAR(20) NOT NULL,
    division VARCHAR(10) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ====================================================================
-- 4. Table: admins
-- Unique administrator accounts
-- ====================================================================
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- ====================================================================
-- 5. Table: locations
-- Campus blocks, rooms, labs and facilities (extensible)
-- ====================================================================
CREATE TABLE locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    block VARCHAR(50) NOT NULL,
    location_name VARCHAR(100) NOT NULL,
    location_type VARCHAR(50) NOT NULL,
    active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- ====================================================================
-- 6. Table: staff
-- Responsible campus staff & maintenance departments
-- ====================================================================
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    contact VARCHAR(50) NOT NULL,
    active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- ====================================================================
-- 7. Table: complaints
-- Central issue tracker with lifecycle management
-- ====================================================================
CREATE TABLE complaints (
    complaint_id VARCHAR(50) NOT NULL PRIMARY KEY,
    roll_number VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    location_id INT NOT NULL,
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) NOT NULL DEFAULT 'Medium',
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    assigned_staff_id INT NULL,
    admin_remarks TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    CONSTRAINT fk_complaint_student FOREIGN KEY (roll_number) REFERENCES students(roll_number) ON DELETE CASCADE,
    CONSTRAINT fk_complaint_location FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE RESTRICT,
    CONSTRAINT fk_complaint_staff FOREIGN KEY (assigned_staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ====================================================================
-- 8. Table: lost_found
-- Student lost and found items
-- ====================================================================
CREATE TABLE lost_found (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_number VARCHAR(50) NOT NULL,
    type VARCHAR(10) NOT NULL, -- 'LOST' or 'FOUND'
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(100) NOT NULL,
    report_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN', -- 'LOST', 'FOUND', 'CLAIMED', 'CLOSED'
    contact VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_lostfound_student FOREIGN KEY (roll_number) REFERENCES students(roll_number) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ====================================================================
-- 9. Table: feedback
-- Post-resolution ratings and reviews
-- ====================================================================
CREATE TABLE feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id VARCHAR(50) NOT NULL,
    roll_number VARCHAR(50) NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_complaint FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE CASCADE,
    CONSTRAINT fk_feedback_student FOREIGN KEY (roll_number) REFERENCES students(roll_number) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ====================================================================
-- 10. Sample Seed Data
-- ====================================================================

-- Admins: demo credentials -> username: admin, password: admin123
-- SHA-256 of "admin123" is: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
INSERT INTO admins (username, password, full_name) VALUES
('admin', 'admin123', 'Campus Administrator'),
('principal', 'admin123', 'Office of Principal');

-- Students: demo student -> roll_number: 243-02-A-0007, password: student123
-- SHA-256 of "student123" is: cd6357efdd966de8a075f47123b4934414514f722822f66a9291fa74345cd7f
INSERT INTO students (roll_number, full_name, email, phone, course, year, division, password) VALUES
('243-02-A-0007', 'Anushka Ranjan', 'anushka.ranjan@college.edu', '9876543210', 'B.Sc.IT', 'SY', 'A', 'student123'),
('243-02-A-0012', 'Rahul Sharma', 'rahul.sharma@college.edu', '9812345678', 'B.Sc.IT', 'TY', 'A', 'student123'),
('243-02-B-0045', 'Priya Patel', 'priya.patel@college.edu', '9823456789', 'B.Sc.CS', 'FY', 'B', 'student123');

-- Campus Locations (Predefined Blocks and Rooms)
INSERT INTO locations (block, location_name, location_type, active) VALUES
('A Block', 'A-01 Lecture Hall', 'Classroom', TRUE),
('A Block', 'A-02 Smart Classroom', 'Classroom', TRUE),
('A Block', 'Staff Room (Ground Floor)', 'Faculty', TRUE),
('X Block', 'Computer Lab 1 (First Floor)', 'Laboratory', TRUE),
('X Block', 'Computer Lab 2 (Software Lab)', 'Laboratory', TRUE),
('X Block', 'Lopez Lab (Electronics)', 'Laboratory', TRUE),
('X Block', 'Radio Lab (Telecommunications)', 'Laboratory', TRUE),
('Y Block', 'Y-20 Classroom', 'Classroom', TRUE),
('Y Block', 'Y-50 Multi-Purpose Hall', 'Classroom', TRUE),
('Central Block', 'Reading Room (Library)', 'Library', TRUE),
('Central Block', 'Main Seminar Hall', 'Auditorium', TRUE),
('Central Block', 'Boys Washroom (1st Floor)', 'Washroom', TRUE),
('Central Block', 'Girls Washroom (1st Floor)', 'Washroom', TRUE),
('Campus Grounds', 'College Canteen', 'Amenities', TRUE),
('Campus Grounds', 'Main Gate / Parking Lot', 'Security', TRUE);

-- Staff / Department Directory
INSERT INTO staff (staff_name, department, contact, active) VALUES
('Rajesh Verma', 'Electrical Department', '+91 98201 11223', TRUE),
('Sanjay Kulkarni', 'Air Conditioning & Cooling', '+91 98202 22334', TRUE),
('Amit Deshmukh', 'IT Support & Systems', '+91 98203 33445', TRUE),
('Sunita Shinde', 'Housekeeping & Cleanliness', '+91 98204 44556', TRUE),
('Manoj Yadav', 'Carpentry & Furniture', '+91 98205 55667', TRUE),
('Suraj Singh', 'Campus Security', '+91 98206 66778', TRUE),
('Dr. V. N. Kulkarni', 'Academic & Faculty Support', '+91 98207 77889', TRUE);

-- Sample Initial Complaints
INSERT INTO complaints (complaint_id, roll_number, category, location_id, subject, description, priority, status, assigned_staff_id, admin_remarks, created_at, resolved_at) VALUES
('CC-2026-00001', '243-02-A-0007', 'AC / Cooling', 11, 'AC unit leaking water in Seminar Hall', 'The central split AC unit in the Seminar Hall is continuously dripping water onto row 3 seats during lectures.', 'High', 'IN PROGRESS', 2, 'Technician Sanjay Kulkarni has been dispatched with replacement drain pipes.', DATE_SUB(NOW(), INTERVAL 2 DAY), NULL),

('CC-2026-00002', '243-02-A-0007', 'Projector / Display Panel', 2, 'Projector HDMI display flickering', 'The ceiling mounted projector in room A-02 repeatedly loses signal when connected to laptop.', 'Medium', 'RESOLVED', 3, 'Replaced faulty HDMI cable with a new 5-meter shielded cable. Tested and verified.', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY)),

('CC-2026-00003', '243-02-A-0012', 'Cleanliness', 12, 'Water cooler area floor slippery', 'Spilled water outside the 1st floor boys washroom is causing slipping hazard.', 'Urgent', 'RESOLVED', 4, 'Cleaning staff mopped the area and placed a safety floor mat.', DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),

('CC-2026-00004', '243-02-B-0045', 'Computer / Technology', 4, 'PC 14 monitor not turning on', 'In Computer Lab 1, workstation number 14 monitor power indicator remains off.', 'Low', 'PENDING', NULL, NULL, DATE_SUB(NOW(), INTERVAL 1 HOUR), NULL);

-- Sample Feedback for Resolved Complaint
INSERT INTO feedback (complaint_id, roll_number, rating, message, created_at) VALUES
('CC-2026-00002', '243-02-A-0007', 5, 'Complaint was resolved very quickly before our next practical lecture. Excellent work by IT support!', DATE_SUB(NOW(), INTERVAL 4 DAY));

-- Sample Lost & Found Data
INSERT INTO lost_found (roll_number, type, item_name, category, description, location, report_date, status, contact) VALUES
('243-02-A-0007', 'LOST', 'Blue Casio Scientific Calculator (fx-991ES Plus)', 'Electronics', 'Has a small white sticker on the back cover with initials AR.', 'Lopez Lab (Electronics)', CURDATE() - INTERVAL 1 DAY, 'LOST', 'anushka.ranjan@college.edu | 9876543210'),
('243-02-A-0012', 'FOUND', 'Black Vega Half Helmet', 'Vehicle Gear', 'Found left on the parking lot bench near the bike shed.', 'Main Gate / Parking Lot', CURDATE() - INTERVAL 2 DAY, 'FOUND', 'rahul.sharma@college.edu (or collect at Security Cabin)'),
('243-02-B-0045', 'FOUND', 'College Student ID Card (SY B.Sc.IT)', 'ID Card', 'Found in Reading Room near newspaper section. Name: Rohit Roy.', 'Reading Room (Library)', CURDATE(), 'CLAIMED', 'Security / Library desk');
