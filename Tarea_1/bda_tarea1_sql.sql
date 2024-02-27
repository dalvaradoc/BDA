-- -----------------------------------------------------
-- Table `faculty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `faculty` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `department` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `faculty_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_departments_faculties1_idx` (`faculty_id` ASC) VISIBLE,
  CONSTRAINT `fk_departments_faculties1`
    FOREIGN KEY (`faculty_id`)
    REFERENCES `faculty` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `program`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `program` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `department_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_programs_departments1_idx` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_programs_departments1`
    FOREIGN KEY (`department_id`)
    REFERENCES `department` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `student` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `gender` VARCHAR(45) NULL,
  `birthdate` DATE NULL,
  `program_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_students_programs1_idx` (`program_id` ASC) VISIBLE,
  CONSTRAINT `fk_students_programs1`
    FOREIGN KEY (`program_id`)
    REFERENCES `program` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `course` (
  `code` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `lecturing_hours` INT NULL,
  `exercise_hours` INT NULL,
  PRIMARY KEY (`code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lecturer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lecturer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `department_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_lecturers_departments1_idx` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_lecturers_departments1`
    FOREIGN KEY (`department_id`)
    REFERENCES `department` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `course_has_lecturer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `course_has_lecturer` (
  `course_code` INT NOT NULL,
  `lecturer_id` INT NOT NULL,
  PRIMARY KEY (`course_code`, `lecturer_id`),
  INDEX `fk_courses_has_lecturers_lecturers1_idx` (`lecturer_id` ASC) VISIBLE,
  INDEX `fk_courses_has_lecturers_courses1_idx` (`course_code` ASC) VISIBLE,
  CONSTRAINT `fk_courses_has_lecturers_courses1`
    FOREIGN KEY (`course_code`)
    REFERENCES `course` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_courses_has_lecturers_lecturers1`
    FOREIGN KEY (`lecturer_id`)
    REFERENCES `lecturer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `evaluation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `evaluation` (
  `course_code` INT NOT NULL,
  `delivery` DOUBLE NOT NULL,
  `content` DOUBLE NOT NULL,
  `overall` DOUBLE NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`course_code`),
  CONSTRAINT `fk_evaluation_course1`
    FOREIGN KEY (`course_code`)
    REFERENCES `course` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `student_has_course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `student_has_course` (
  `student_id` INT NOT NULL,
  `course_code` INT NOT NULL,
  `evaluation` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`student_id`, `course_code`),
  INDEX `fk_student_has_course_course1_idx` (`course_code` ASC) VISIBLE,
  INDEX `fk_student_has_course_student1_idx` (`student_id` ASC) VISIBLE,
  CONSTRAINT `fk_student_has_course_student1`
    FOREIGN KEY (`student_id`)
    REFERENCES `student` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_has_course_course1`
    FOREIGN KEY (`course_code`)
    REFERENCES `course` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `exam`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `year` YEAR NULL,
  `semester` INT NULL,
  `course_code` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_exam_course1_idx` (`course_code` ASC) VISIBLE,
  CONSTRAINT `fk_exam_course1`
    FOREIGN KEY (`course_code`)
    REFERENCES `course` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `student_has_exam`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `student_has_exam` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `exam_id` INT NOT NULL,
  `score` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_student_has_exam_exam1_idx` (`exam_id` ASC) VISIBLE,
  INDEX `fk_student_has_exam_student1_idx` (`student_id` ASC) VISIBLE,
  CONSTRAINT `fk_student_has_exam_student1`
    FOREIGN KEY (`student_id`)
    REFERENCES `student` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_has_exam_exam1`
    FOREIGN KEY (`exam_id`)
    REFERENCES `exam` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Inserting dummy data into the `faculty` table
INSERT INTO `faculty` (`name`) VALUES
('Engineering'),
('Science'),
('Arts');

-- Inserting dummy data into the `department` table
INSERT INTO `department` (`name`, `faculty_id`) VALUES
('Computer Science', 1),
('Electrical Engineering', 1),
('Physics', 2),
('Chemistry', 2),
('English Literature', 3),
('History', 3);

-- Inserting dummy data into the `program` table
INSERT INTO `program` (`name`, `department_id`) VALUES
('Computer Engineering', 1),
('Software Engineering', 1),
('Electrical Engineering', 2),
('Physics', 3),
('Chemistry', 4),
('English Literature', 5),
('History', 6);

-- Inserting dummy data into the `student` table
INSERT INTO `student` (`id`, `name`, `gender`, `birthdate`, `program_id`) VALUES
(1, 'John Doe', 'Male', '2000-05-15', 1),
(2, 'Jane Smith', 'Female', '2001-03-20', 1),
(3, 'Bob Johnson', 'Male', '2000-11-10', 2),
(4, 'Alice Brown', 'Female', '2001-07-25', 2),
(5, 'Charlie Lee', 'Male', '2000-09-05', 3),
(6, 'Emily Davis', 'Female', '2000-12-30', 3);

-- Inserting dummy data into the `course` table
INSERT INTO `course` (`code`, `name`, `lecturing_hours`, `exercise_hours`) VALUES
(101, 'Introduction to Computer Science', 3, 2),
(102, 'Database Management Systems', 4, 3),
(103, 'Linear Algebra', 3, 2),
(104, 'Organic Chemistry', 4, 3),
(105, 'British Literature', 3, 2),
(106, 'World History', 4, 3);

-- Inserting dummy data into the `lecturer` table
INSERT INTO `lecturer` (`name`, `department_id`) VALUES
('Prof. Smith', 1),
('Dr. Johnson', 2),
('Prof. Brown', 3),
('Dr. Lee', 4),
('Prof. Davis', 5),
('Dr. Wilson', 6);

-- Inserting dummy data into the `course_has_lecturer` table
INSERT INTO `course_has_lecturer` (`course_code`, `lecturer_id`) VALUES
(101, 1),
(102, 1),
(103, 2),
(104, 3),
(105, 4),
(106, 5);

-- Inserting dummy data into the `evaluation` table
INSERT INTO `evaluation` (`course_code`, `delivery`, `content`, `overall`, `date`) VALUES
(101, 4.5, 4.2, 4.4, '2024-02-17 10:00:00'),
(102, 4.7, 4.5, 4.6, '2024-02-18 09:30:00'),
(103, 4.2, 4.3, 4.2, '2024-02-16 14:15:00'),
(104, 4.0, 4.1, 4.0, '2024-02-15 11:45:00'),
(105, 4.8, 4.7, 4.8, '2024-02-14 13:20:00'),
(106, 4.3, 4.4, 4.3, '2024-02-13 15:00:00');

-- Inserting dummy data into the `student_has_course` table
INSERT INTO `student_has_course` (`student_id`, `course_code`, `evaluation`) VALUES
(1, 101, 1),
(2, 101, 1),
(3, 102, 1),
(4, 102, 0),
(5, 103, 1),
(6, 103, 0);

-- Inserting dummy data into the `exam` table
INSERT INTO `exam` (`year`, `semester`, `course_code`) VALUES
(2023, 1, 101),
(2023, 2, 102),
(2023, 1, 103),
(2023, 2, 104),
(2023, 1, 105),
(2023, 2, 106);

-- Inserting dummy data into the `student_has_exam` table
INSERT INTO `student_has_exam` (`student_id`, `exam_id`, `score`) VALUES
(1, 1, 90),
(2, 1, 85),
(3, 2, 88),
(4, 2, 75),
(5, 3, 92),
(6, 3, 80);
