import re, os
from datetime import date, timedelta, datetime
import mysql.connector as mysqlc

scx = mysqlc.connect(
    host="localhost",
    user="root",
    password="abc123xd",
    database="bda"
)


scur = scx.cursor()

def exec_sql_file(cursor, sql_file):
    sql_file = os.path.join(os.path.dirname(__file__), sql_file)
    print ("\n[INFO] Executing SQL script file: %s",sql_file)
    statement = ""

    for line in open(sql_file):
        if re.match(r'--', line):  # ignore sql comment lines
            continue
        if not re.search(r';$', line):  # keep appending lines that don't end in ';'
            statement = statement + line
        else:  # when you get a line ending in ';' then exec statement and reset for next statement
            statement = statement + line
            #print "\n\n[DEBUG] Executing SQL statement:\n%s" % (statement)
            try:
                cursor.execute(statement)
            except (OperationalError, ProgrammingError) as e:
                print("\n[WARN] MySQLError during execute statement \n\tArgs: '%s'", (str(e.args)))

            statement = ""

exec_sql_file(scur, "punto2-ini.sql")


dcx = mysqlc.connect(
    host="localhost",
    user="root",
    password="abc123xd",
    database="bda_ws1"
)

dcur = dcx.cursor()

# Course

scur.close()
scx.reconnect()
scur = scx.cursor()

# Tablas la base de datos:

# course
# course_has_lecturer
# department
# evaluation
# exam
# faculty
# lecturer
# program
# student
# student_has_course
# student_has_exam

# Tablas del warehouse:

# - course
# course_evaluated
# - evaluation
# - exam
# - exam_taken
# - lecturer
# - lecturers_group
# - program
# - registration
# - semester
# - student
# - time

# Se inserta la tabla course

scur.execute("select code, course.name, lecturing_hours, exercise_hours, program.name from course join program on program_id = program.id;")
course =  scur.fetchall()

for row in course:
  dcur.execute("INSERT INTO course (code, name, lecturing_hours, exercise_hours, program) VALUES (%s, %s, %s, %s, %s)", row)


# Se inserta lecturer

scur.execute("select lecturer.id, lecturer.name, department.name from lecturer join department on department.id = lecturer.department_id;")
lecturer = scur.fetchall()

for row in lecturer:
  dcur.execute("INSERT INTO lecturer (id, name, department) VALUES (%s, %s, %s);", row)

# Se inserta lecturers_group
  
scur.execute("select * from course_has_lecturer;")
lecturers_group = scur.fetchall()

for row in lecturers_group:
    dcur.execute("INSERT INTO lecturers_group (id, lecturer_id) VALUES (%s, %s);", row)

# Se inserta program

scur.execute("SELECT program.id, faculty.name, department.name, program.name FROM program JOIN department ON department.id = program.department_id JOIN faculty ON faculty.id = department.faculty_id;")
program = scur.fetchall()

for row in program:
    dcur.execute("INSERT INTO program (id, faculty, department, name) VALUES (%s, %s, %s, %s);", row)
    # print(row)

# Se inserta student
  
scur.execute("select id, name, gender, birthdate from student;")
student = scur.fetchall()

for row in student:
   dcur.execute("INSERT INTO student (id, name, gender, birthdate) VALUES (%s, %s, %s, %s); ", row)

# Se inserta registration
   
scur.execute("select id, program_id from student;")
registration = scur.fetchall()

for row in registration:
    dcur.execute("INSERT INTO registration (student_id, program_id) VALUES (%s, %s);", row)

# Se llena time desde start_date a end_date
    
start_year = 2023
end_year = 2024
    
start_date = date(start_year,1,1)
end_date = date(end_year,7,1)

delta = end_date - start_date

for i in range(delta.days + 1):
    day = start_date + timedelta(days=i)
    dcur.execute("INSERT INTO time (id, year, semester, month, day) VALUES (%s, %s, %s, %s, %s);", [day.strftime("%Y%m%d") , day.year, 1 if day.month < 6 else 2, day.month, day.day])

# Se llena semester
    
for i in range((end_year - start_year)*2):
    dcur.execute("INSERT INTO semester (year, semester) VALUES (%s, %s);", [start_year + i//2, (i%2) + 1])

# Se llena exam
    
scur.execute("select id from exam")
exam = scur.fetchall()

for row in exam:
  dcur.execute("INSERT INTO exam (id) VALUES (%s);", row)

# Ahora se llenan los hechos
  
# Se insert exam_taken
  
scur.execute("select year, semester, student_id, course_code, exam_id, score from student_has_exam join exam on student_has_exam.exam_id = exam.id;")
exam_taken = scur.fetchall()

for row in exam_taken:
    year = row[0]
    sem = row[1]
    time_id = str(year) + ("0"+str((sem-1)*6+2))[:2] + "01" # como de momento la BD no tiene fecha en examen, se elige una del semestre y año adecuados
    

    # Además, de momento el lecturers_group_id es el mismo course_code
    dcur.execute("INSERT INTO exam_taken (time_id, student_id, lecturers_group_id, course_code, exam_id, score, count) VALUES (%s, %s, %s, %s, %s, %s, %s);", 
                 [time_id, row[2], row[3], row[3], row[4], row[5], 1])

# Se inserta evaluation
    
scur.execute("select * from evaluation;")
evaluation = scur.fetchall()

for row in evaluation:
    dcur.execute("INSERT INTO evaluation (course_code, lecturers_group_id, time_id, delivery, content, overall) VALUES (%s, %s, %s, %s, %s, %s);", 
                 [row[0], row[0], row[-1].strftime("%Y%m%d"), row[1], row[2], row[3]])
    
# Se inserta course_evaluated, de momento la BD no tiene un tiempo de cuaando se hizo, asi que se le asigna uno aleatorio
    
scur.execute("select * from student_has_course;")
course_evaluated = scur.fetchall()

for row in course_evaluated:
    dcur.execute("INSERT INTO course_evaluated (course_code, student_id, semester_id) VALUES (%s, %s, %s);", [
        row[1], row[0], 1
    ])

    
dcx.commit()
dcx.close()
scx.close()

# INSERT INTO course (code, name, lecturing_hours, exercise_hours) VALUES (%s, %s, %s, %s)
