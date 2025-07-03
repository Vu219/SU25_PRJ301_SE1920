-- 1. Create Database
CREATE DATABASE OnlineExaminationDB;
GO

-- 2. Use the database
USE OnlineExaminationDB;
GO

-- 3. Create Table: tblUsers
CREATE TABLE tblUsers (
    username VARCHAR(50) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Instructor', 'Student'))
);

-- Insert sample users
INSERT INTO tblUsers (username, Name, password, Role) VALUES
('Instructor', 'Instructor', '12345', 'Instructor'),
('NguyenTranTu', 'Nguyen Tran Tu', '12345', 'Student'),
('TranAnhVu', 'Tran Anh Vu', '12345', 'Student');

-- 4. Create Table: tblExamCategories
CREATE TABLE tblExamCategories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Insert sample exam categories
INSERT INTO tblExamCategories (category_id, category_name, description) VALUES
(1, 'Quiz', 'Short quizzes for quick assessments'),
(2, 'Midterm', 'Midterm examination'),
(3, 'Final', 'Final semester examination');

-- 5. Create Table: tblExams
CREATE TABLE tblExams (
    exam_id INT PRIMARY KEY,
    exam_title VARCHAR(100) NOT NULL,
    Subject VARCHAR(50) NOT NULL,
    category_id INT NOT NULL FOREIGN KEY REFERENCES tblExamCategories(category_id),
    total_marks INT NOT NULL,
    Duration INT NOT NULL
);

-- Insert sample exams
INSERT INTO tblExams (exam_id, exam_title, Subject, category_id, total_marks, Duration) VALUES
(101, 'OOP Midterm Exam', 'Object-Oriented Programming', 2, 100, 90),
(102, 'DB Quiz 1', 'Database Systems', 1, 20, 40);
(103, 'Final Exam - Web Development', 'Web Development', 3, 100, 90);

-- 6. Create Table: tblQuestions
CREATE TABLE tblQuestions (
    question_id INT PRIMARY KEY,
    exam_id INT NOT NULL FOREIGN KEY REFERENCES tblExams(exam_id),
    question_text TEXT NOT NULL,
    option_a VARCHAR(100) NOT NULL,
    option_b VARCHAR(100) NOT NULL,
    option_c VARCHAR(100) NOT NULL,
    option_d VARCHAR(100) NOT NULL,
    correct_option CHAR(1) NOT NULL CHECK (correct_option IN ('A', 'B', 'C', 'D'))
);

-- Insert sample questions
INSERT INTO tblQuestions (question_id, exam_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES
(1, 101, 'Which of the following is a valid OOP concept?', 'Encapsulation', 'Iteration', 'Recursion', 'Compilation', 'A'),
(2, 101, 'Which keyword is used to inherit a class in Java?', 'this', 'super', 'extends', 'implements', 'C'),
(3, 102, 'Which SQL statement is used to retrieve data?', 'INSERT', 'DELETE', 'SELECT', 'UPDATE', 'C'),
(4, 101, 'What is the access modifier to allow access within the same package?', 'private', 'protected', 'public', 'default', 'D'),
(5, 102, 'Which command is used to delete all rows in a table without logging each row deletion?', 'TRUNCATE', 'DELETE', 'DROP', 'REMOVE', 'A'),
(6, 102, 'What does SQL stand for?', 'Structured Question Language', 'Simple Query Language', 'Structured Query Language', 'Standard Question Language', 'C'),
(7, 103, 'What does HTML stand for?', 'Hyper Trainer Marking Language', 'Hyper Text Markup Language', 'Hyper Text Marketing Language', 'Hyper Tool Markup Language', 'B'),
(8, 103, 'Which tag is used to create a hyperlink in HTML?', '<link>', '<a>', '<href>', '<hyperlink>', 'B'),
(9, 103, 'What is the purpose of CSS?', 'Structure content', 'Style content', 'Manage databases', 'Write scripts', 'B'),
(10, 103, 'Which of the following is a JavaScript data type?', 'float', 'number', 'character', 'decimal', 'B'),
(11, 103, 'Which tag is used for inserting an image in HTML?', '<picture>', '<image>', '<img>', '<src>', 'C');