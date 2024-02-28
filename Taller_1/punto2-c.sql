-- i. ###########################################################################

SELECT 
    time.weekday, AVG(score)
FROM
    exam_taken
        JOIN
    time ON time.id = exam_taken.time_id
GROUP BY time.weekday;

-- ii. ###########################################################################

SELECT 
    lecturer.name, AVG(overall)
FROM
    evaluation
        JOIN
    lecturers_group ON lecturers_group.id = evaluation.lecturers_group_id
        JOIN
    lecturer ON lecturer.id = lecturers_group.lecturer_id
GROUP BY lecturer.id;

-- iii. ###########################################################################

SELECT 
    a.course_code,
    AvgScore,
    AvgOverall,
    (AvgScore / 20) - AvgOverall AS Diff
FROM
    (SELECT 
        course_code, AVG(score) AS AvgScore
    FROM
        exam_taken
    GROUP BY course_code) AS a
        JOIN
    (SELECT 
        course_code, AVG(overall) AS AvgOverall
    FROM
        evaluation
    GROUP BY course_code) AS b ON a.course_code = b.course_code;

-- iv. ###########################################################################

SELECT 
    gender, AVG(score)
FROM
    exam_taken
        JOIN
    student ON student.id = exam_taken.student_id
GROUP BY gender;

-- v. ###########################################################################

SELECT 
    course.name,
    lecturing_hours + exercise_hours AS TotalHours,
    AVG(evaluation.content) AS AvgContent
FROM
    evaluation
        JOIN
    course ON course.code = evaluation.course_code
GROUP BY course_code
ORDER BY TotalHours DESC;