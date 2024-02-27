-- i. ############################################################################

SELECT 
    department, COUNT(student_id)
FROM
    registration
        JOIN
    program ON registration.program_id = program.id
GROUP BY department;

-- ii. ###########################################################################

SELECT 
    year, COUNT(student_id)
FROM
    exam_taken
        JOIN
    time ON exam_taken.time_id = time.id
GROUP BY year;

-- iii. ###########################################################################

SELECT 
    course_code,
    SUM(count) / COUNT(DISTINCT student_id) AS NumExamTries
FROM
    exam_taken
GROUP BY course_code;

-- iv. ###########################################################################

SELECT 
    course.name, AVG(overall)
FROM
    evaluation
        JOIN
    course ON course.code = evaluation.course_code
GROUP BY course_code;

-- v. ###########################################################################

SELECT 
    lecturer.name AS Lecturer, AVG(score)
FROM
    exam_taken
        JOIN
    lecturers_group ON exam_taken.lecturers_group_id = lecturers_group.id
        JOIN
    lecturer ON lecturer.id = lecturers_group.lecturer_id
GROUP BY lecturer.id;