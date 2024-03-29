-- MySQL Script generated by MySQL Workbench
-- Sun Feb 18 22:30:50 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

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
  `program_id` INT NOT NULL,
  PRIMARY KEY (`code`),
  INDEX `fk_course_program1_idx` (`program_id` ASC) VISIBLE,
  CONSTRAINT `fk_course_program1`
    FOREIGN KEY (`program_id`)
    REFERENCES `program` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- INSERT DUMMY DATA

INSERT INTO `faculty` (`name`) VALUES
('Engineering'),
('Science'),
('Arts');
INSERT INTO `department` (`name`, `faculty_id`) VALUES
('Computer Science', 2),
('Electrical Engineering', 1),
('Mathematics', 2),
('History', 3);
INSERT INTO `program` (`name`, `department_id`) VALUES
('Computer Engineering', 1),
('Data Science', 2),
('Mechanical Engineering', 1),
('Pure Mathematics', 3);
INSERT INTO `student` (`id`, `name`, `gender`, `birthdate`, `program_id`) VALUES
(1, 'John Doe', 'Male', '2000-05-15', 1),
(2, 'Jane Smith', 'Female', '1999-09-20', 2),
(3, 'Michael Johnson', 'Male', '2001-03-10', 3),
(4, 'Emily Brown', 'Female', '2000-12-05', 4);
INSERT INTO `course` (`code`, `name`, `lecturing_hours`, `exercise_hours`, `program_id`) VALUES
(101, 'Introduction to Programming', 3, 2, 1),
(102, 'Database Management', 2, 2, 2),
(103, 'Linear Algebra', 4, 1, 3),
(104, 'World History', 3, 0, 4);
INSERT INTO `lecturer` (`name`, `department_id`) VALUES
('Dr. Smith', 1),
('Prof. Johnson', 2),
('Dr. Brown', 3),
('Prof. White', 4);
INSERT INTO `course_has_lecturer` (`course_code`, `lecturer_id`) VALUES
(101, 1),
(102, 2),
(103, 3),
(104, 4);
INSERT INTO `evaluation` (`course_code`, `delivery`, `content`, `overall`, `date`) VALUES
(101, 4.5, 4.2, 4.4, '2023-05-01'),
(102, 4.0, 4.1, 4.2, '2023-06-15'),
(103, 4.2, 4.3, 4.4, '2023-04-20'),
(104, 3.8, 4.0, 4.0, '2023-07-10');
INSERT INTO `student_has_course` (`student_id`, `course_code`, `evaluation`) VALUES
(1, 101, 1),
(2, 102, 1),
(3, 103, 1),
(4, 104, 1);
INSERT INTO `exam` (`year`, `semester`, `course_code`) VALUES
('2023', 1, 101),
('2023', 2, 102),
('2023', 1, 103),
('2023', 2, 104);
INSERT INTO `student_has_exam` (`student_id`, `exam_id`, `score`) VALUES
(1, 1, 85),
(2, 2, 78),
(3, 3, 92),
(4, 4, 80);