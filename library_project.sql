-- Digital Library Audit System

DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db;
USE library_db;

-- Create Tables
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE IssuedBooks (
    issue_id INT PRIMARY KEY,
    student_id INT,
    book_id INT,
    issue_date DATE,
    return_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Insert Sample Data
INSERT INTO Books VALUES
(1, 'Java Basics', 'Programming'),
(2, 'Python Guide', 'Programming'),
(3, 'World History', 'History'),
(4, 'Data Science 101', 'Science'),
(5, 'English Grammar', 'Education');

INSERT INTO Students VALUES
(101, 'Arati'),
(102, 'Rahul'),
(103, 'Sneha'),
(104, 'Kiran');

INSERT INTO IssuedBooks VALUES
(1, 101, 1, '2026-03-01', NULL),
(2, 102, 2, '2026-03-20', '2026-03-25'),
(3, 103, 3, '2026-02-10', NULL),
(4, 101, 4, '2026-03-28', NULL),
(5, 104, 5, '2023-01-01', '2023-01-10');

-- View Data
SELECT * FROM Books;
SELECT * FROM Students;
SELECT * FROM IssuedBooks;

-- Overdue Books Report
SELECT s.name, b.title, i.issue_date
FROM IssuedBooks i
JOIN Students s ON i.student_id = s.student_id
JOIN Books b ON i.book_id = b.book_id
WHERE i.return_date IS NULL
AND i.issue_date < CURDATE() - INTERVAL 14 DAY;

-- Popular Category Report
SELECT b.category, COUNT(*) AS total_borrows
FROM IssuedBooks i
JOIN Books b ON i.book_id = b.book_id
GROUP BY b.category
ORDER BY total_borrows DESC;

-- Add Status Column
ALTER TABLE Students ADD status VARCHAR(20);

-- Mark Inactive Students (No borrow in last 3 years)
UPDATE Students
SET status = 'Inactive'
WHERE student_id NOT IN (
    SELECT student_id
    FROM IssuedBooks
    WHERE issue_date >= CURDATE() - INTERVAL 3 YEAR
);

-- Final Output
SELECT * FROM Students;