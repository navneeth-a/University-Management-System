--  30 SQL Scenarios & Queries

-- 1.Retrieve all students from the Computer Science department ordered by CGPA.

SELECT s.student_id,s.name,s.year,s.cgpa,s.email,d.name
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
WHERE d.name = 'Computer Science'
ORDER BY s.cgpa DESC;

-- 2.Insert a new student record into the students table.

INSERT INTO students (name, dept_id, year, email, phone, dob, gender, cgpa, admitted_year, address)
VALUES ('Priya Lakshmi', 1, 1, 'priya.lakshmi@uni.edu', '9500009901', '2006-03-15', 'F', 0.00, 2025, 'Chennai');

-- 3.Update the CGPA of a student to 9.20 where student_id= 1 after results are published.

UPDATE students SET cgpa = 9.20
WHERE student_id = 1;

-- 4.Delete a student who has withdrawn from admission.

DELETE FROM students
WHERE email = 'priya.lakshmi@uni.edu';

-- 5.Filter students with CGPA above 9.0 and whose email ends with @uni.edu.

SELECT s.name AS stundent_name,s.cgpa,s.email,d.name AS department
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
WHERE s.cgpa >= 9.00
  AND s.email LIKE '%@uni.edu'
ORDER BY s.cgpa DESC
LIMIT 10;

-- 6.Find the average, highest, and lowest CGPA for each department where the average CGPA is above 8.0.

SELECT d.name                      AS department,
    COUNT(s.student_id)            AS total_students,
    ROUND(AVG(s.cgpa),2)           AS avg_cgpa,
    MAX(s.cgpa)                    AS highest_cgpa,
    MIN(s.cgpa)                    AS lowest_cgpa
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
GROUP BY d.dept_id, d.name
HAVING AVG(s.cgpa) > 8.0
ORDER BY avg_cgpa DESC;

-- 7.Find all students who have not paid their tuition fees.

SELECT s.student_id,s.name,s.email,d.name AS department
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
WHERE s.student_id NOT IN (
    SELECT DISTINCT student_id
    FROM fees
    WHERE status = 'Paid'
      AND fee_type = 'Tuition'
);

-- 8.Get the top 3 students with the highest placement package.

SELECT s.name, p.company_name, p.role, p.package_lpa
FROM placements p
JOIN students s ON p.student_id = s.student_id
ORDER BY p.package_lpa DESC
LIMIT 3;

-- 9.List students whose attendance is below 75% in any course.

SELECT
    s.name,
    c.title                                             AS course,
    COUNT(a.att_id)                                     AS total_classes,
    SUM(a.status = 'P')                                 AS present,
    ROUND(SUM(a.status = 'P') * 100.0 / COUNT(*), 1)    AS attendance_pct
FROM attendance a
JOIN enrollments e  ON a.enroll_id  = e.enroll_id
JOIN students s     ON e.student_id = s.student_id
JOIN courses c      ON e.course_id  = c.course_id
GROUP BY s.student_id, s.name, c.course_id, c.title
HAVING attendance_pct < 75
ORDER BY attendance_pct ASC;

-- 10.Show all students who have not yet returned the library book.

SELECT s.name AS student, l.book_title, l.issue_date, l.return_date
FROM library l
JOIN students s ON l.student_id = s.student_id
WHERE l.returned_on IS NULL
ORDER BY l.issue_date;

-- 11.Display all students along with their enrolled courses and faculty name.

SELECT
    s.name          AS student,
    c.title         AS course,
    c.code          AS course_code,
    e.semester,
    f.name          AS faculty
FROM enrollments e
INNER JOIN students s   ON e.student_id  = s.student_id
INNER JOIN courses  c   ON e.course_id   = c.course_id
INNER JOIN faculty  f   ON c.faculty_id  = f.faculty_id
ORDER BY s.name, c.title;

-- 12.Show all students with their hostel block and room details, including day scholars.

SELECT s.name AS student,
       s.year,
       d.name AS department,
       IFNULL(h.block, 'Day Scholar') AS block,
       IFNULL(h.room_no, '-') AS room_no,
       IFNULL(h.bed_no, '-') AS bed_no
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
LEFT JOIN hostels h ON s.student_id = h.student_id
ORDER BY h.block, h.room_no;

-- 13.List all courses with the count of students enrolled in each course.

SELECT
    c.title                         AS course,
    c.code,
    COUNT(e.enroll_id)              AS enrolled_students
FROM enrollments e
RIGHT JOIN courses c ON e.course_id  = c.course_id
GROUP BY c.course_id, c.title, c.code
ORDER BY enrolled_students DESC;

-- 14.Find pairs of students who are in the same department and same year.

SELECT
    s1.name     AS student_1,
    s2.name     AS student_2,
    d.name      AS department,
    s1.year
FROM students s1
JOIN students s2    ON s1.dept_id = s2.dept_id
                    AND s1.year    = s2.year
                    AND s1.student_id < s2.student_id
JOIN departments d  ON s1.dept_id  = d.dept_id
ORDER BY d.name, s1.year, s1.name
LIMIT 20;

-- 15.Combine all student and faculty emails into a single list without duplicates.

SELECT name, email, 'Student' AS role FROM students  WHERE email IS NOT NULL
UNION
SELECT name, email, 'Faculty' AS role FROM faculty   WHERE email IS NOT NULL
ORDER BY name

-- 16:Combine students and alumni email list with duplicates

SELECT name, email, 'Student' AS type FROM students
WHERE cgpa >= 8.0
UNION ALL
SELECT job_title, email, 'Alumni' AS type FROM alumni
WHERE email IS NOT NULL
ORDER BY type, name;

-- 17.Rank students by CGPA within each department.

SELECT
    s.name,
    d.name AS department,
    s.cgpa,
    RANK()       OVER (PARTITION BY s.dept_id ORDER BY s.cgpa DESC) AS dept_rank,
    DENSE_RANK() OVER (PARTITION BY s.dept_id ORDER BY s.cgpa DESC) AS deptdense_rank,
    ROW_NUMBER() OVER (PARTITION BY s.dept_id ORDER BY s.cgpa DESC) AS row_num
FROM students s
JOIN departments d ON s.dept_id = d.dept_id;

-- 18.Find the total fees collected from each student.

SELECT s.name AS student,
       d.name AS department,
       SUM(f.amount) AS total_paid
FROM fees f
JOIN students s ON f.student_id = s.student_id
JOIN departments d ON s.dept_id = d.dept_id
WHERE f.status = 'Paid'
GROUP BY f.student_id, s.name, d.name
ORDER BY total_paid DESC;

-- 19.Compare each student's CGPA with their department average and show the difference.

SELECT s.name, d.name AS department, s.cgpa,
		ROUND(AVG(s.cgpa) OVER (PARTITION BY s.dept_id), 2) 				AS dept_Avg_cgpa,
        ROUND(s.cgpa - AVG(s.cgpa) OVER (PARTITION BY s.dept_id), 2)		AS diff_from_avg,
        LAG(s.cgpa) OVER (PARTITION BY s.dept_id ORDER BY s.cgpa DESC)		AS prev_cgpa,
        LEAD(s.cgpa) OVER (PARTITION BY s.dept_id ORDER BY s.cgpa DESC)		AS next_cgpa
FROM students s
INNER JOIN departments d ON s.dept_id = d.dept_id

-- 20.Top 1 placed student per department using RANK.

SELECT student, department, company_name, package_lpa FROM
(SELECT s.name AS student, d.name AS department, p.company_name, p.package_lpa,
		RANK() OVER (PARTITION BY s.dept_id ORDER BY p.package_lpa DESC) AS rnk
FROM placements p
INNER JOIN students s ON p.student_id = s.student_id
INNER JOIN departments d ON s.dept_id = d.dept_id) AS ranked_placements
where rnk = 1
ORDER BY package_lpa DESC

-- 21.Find the total number of students in each department

SELECT
    d.name              AS department,
    COUNT(s.student_id) AS total_students
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
GROUP BY d.dept_id, d.name
ORDER BY total_students DESC;

-- 22.Create a stored procedure to display full student details including courses, fees, and placement by student ID.

DELIMITER $$
CREATE PROCEDURE GetStudentReport(IN p_student_id INT)
BEGIN
    -- Basic Info
    SELECT
        s.student_id, s.name, s.email, s.phone, s.cgpa,
        s.year, s.admitted_year, d.name AS department
    FROM students s
    JOIN departments d ON s.dept_id = d.dept_id
    WHERE s.student_id = p_student_id;

    -- Enrolled Courses
    SELECT c.title, c.code, e.semester, e.status
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
    WHERE e.student_id = p_student_id;

    -- Fee Status
    SELECT fee_type, amount, status, due_date, paid_on
    FROM fees
    WHERE student_id = p_student_id;

    -- Placement Info
    SELECT company_name, role, package_lpa, status
    FROM placements
    WHERE student_id = p_student_id;
END$$
DELIMITER ;

CALL GetStudentReport(6);

-- 23.Get department wise student count using Stored Procedure.

DELIMITER $$
CREATE PROCEDURE GetDeptStudentCount(
    IN  p_dept_id      INT,
    OUT p_total_count  INT )
BEGIN
    SELECT COUNT(student_id) INTO p_total_count
    FROM students
    WHERE dept_id = p_dept_id;
END$$
DELIMITER ;

-- Call the procedure
CALL GetDeptStudentCount(7, @total);
SELECT @total AS total_students;

-- 24.Get faculty details by department using Stored Procedure

DELIMITER $$
CREATE PROCEDURE GetFacultyByDept(IN p_dept_id INT)
BEGIN
    SELECT f.name       AS faculty_name,     f.email         AS email,
        f.designation   AS designation,      d.name          AS department
    FROM faculty f
    JOIN departments d ON f.dept_id = d.dept_id
    WHERE f.dept_id = p_dept_id
    ORDER BY f.designation;
END$$
DELIMITER ;

-- Call the procedure
CALL GetFacultyByDept(5);

-- 25.Classify students by CGPA using CASE

SELECT
    s.name   AS student, d.name   AS department, s.cgpa,
    CASE
        WHEN s.cgpa >= 9.0 THEN 'Distinction'
        WHEN s.cgpa >= 7.5 THEN 'First Class'
        WHEN s.cgpa >= 6.0 THEN 'Second Class'
        WHEN s.cgpa >= 5.0 THEN 'Pass'
        ELSE 'Fail'
    END         AS cgpa_category
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
ORDER BY s.cgpa DESC;

-- 26.Classify faculty by designation level, if designation = Professor eligible for HOD using CASE and IF

SELECT f.name  AS faculty_name,    d.name  AS department,
    f.designation,
    CASE f.designation
        WHEN 'Professor'        THEN 'Senior Level'
        WHEN 'Asst. Professor'  THEN 'Mid Level'
        WHEN 'Lecturer'         THEN 'Junior Level'
        ELSE                         'Other'
    END                                 AS level,
    IF(f.designation = 'Professor', 'Eligible for HOD', 'Not Eligible')
	AS hod_eligibility
FROM faculty f
JOIN departments d ON f.dept_id = d.dept_id
ORDER BY hod_eligibility, f.designation

-- 27.Create a trigger to automatically assign the grade letter when a new marks record is inserted.
-- BEFORE INSERT TRIGGER

DELIMITER $$
CREATE TRIGGER trg_auto_grade
BEFORE INSERT ON grades
FOR EACH ROW
BEGIN
    SET NEW.grade = CASE
        WHEN NEW.marks >= 90 THEN 'O'
        WHEN NEW.marks >= 80 THEN 'A+'
        WHEN NEW.marks >= 70 THEN 'A'
        WHEN NEW.marks >= 60 THEN 'B+'
        WHEN NEW.marks >= 50 THEN 'B'
        WHEN NEW.marks >= 40 THEN 'C'
        ELSE 'F'
    END;
END$$
DELIMITER ;

-- Test the trigger
INSERT INTO grades (enroll_id, exam_id, marks, graded_on)
VALUES (1, 3, 85, CURDATE());

-- 28.Create a trigger to automatically update the fee status to Overdue when the due date has passed.
-- BEFORE UPDATE TRIGGER

DELIMITER $$
CREATE TRIGGER trg_fee_overdue
BEFORE UPDATE ON fees
FOR EACH ROW
BEGIN
    IF NEW.due_date < CURDATE() 
    AND NEW.status = 'Pending' THEN
        SET NEW.status = 'Overdue';
    END IF;
END$$
DELIMITER ;

-- Test the trigger
UPDATE fees SET due_date = '2024-01-01' WHERE fee_id = 3;
SELECT * FROM fees WHERE fee_id = 3;

-- 29.Track deleted faculty record - AFTER DELETE Trigger

CREATE TABLE IF NOT EXISTS faculty_delete_log(
    log_id     INT AUTO_INCREMENT PRIMARY KEY,
    faculty_id INT,
    name       VARCHAR(100),
    deleted_at DATETIME
);

DELIMITER $$
CREATE TRIGGER trg_faculty_delete
AFTER DELETE ON faculty
FOR EACH ROW
BEGIN
    INSERT INTO faculty_delete_log(faculty_id, name, deleted_at)
    VALUES (OLD.faculty_id, OLD.name, NOW());
END$$
DELIMITER ;

-- Test the trigger
DELETE FROM faculty WHERE name = 'Dummy Faculty';

-- 30.Scheduled Event — Auto-mark overdue fees every day at midnight
-- Concepts: CREATE EVENT, EVERY interval, DO block
-- Create a scheduled event that runs every day at midnight to automatically mark pending fees as overdue.
 
-- Enable event scheduler
SET GLOBAL event_scheduler = ON;
 
DELIMITER $$
 
CREATE EVENT IF NOT EXISTS event_mark_overdue_fees
ON SCHEDULE EVERY 1 DAY
STARTS '2026-11-01 00:00:00'
DO
BEGIN
    UPDATE fees
    SET status = 'Overdue'
    WHERE status  = 'Pending'
      AND due_date < CURDATE();
END$$
 
DELIMITER ;
 
-- Check the event
SHOW EVENTS;

-- 31: Scheduled Event — Monthly library fine auto-calculation
-- Concepts: CREATE EVENT, EVERY 1 MONTH, UPDATE with DATEDIFF

DELIMITER $$
CREATE EVENT IF NOT EXISTS event_monthly_library_auto_fine
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-09-01 01:00:00'
DO
BEGIN
    UPDATE library
    SET fine = DATEDIFF(COALESCE(returned_on, CURDATE()), return_date) * 10
    WHERE DATEDIFF(COALESCE(returned_on, CURDATE()), return_date) > 0;
END$$
DELIMITER ;
 
-- Verify
SELECT * FROM library WHERE fine > 0 ORDER BY fine DESC;
