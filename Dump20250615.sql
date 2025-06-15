//Earlier i tried to export the file from Mysql workbench itself through server, but it seemed so cluttered it the repo. Thatswhy i am directly writing the commands below.




CREATE DATABASE StudentAllotment;
USE StudentAllotment;

-- Create tables
CREATE TABLE StudentDetails (
    StudentId VARCHAR(20) PRIMARY KEY,
    StudentName VARCHAR(100),
    GPA FLOAT,
    Branch VARCHAR(10),
    Section VARCHAR(10)
);

CREATE TABLE SubjectDetails (
    SubjectId VARCHAR(20) PRIMARY KEY,
    SubjectName VARCHAR(100),
    MaxSeats INT,
    RemainingSeats INT
);

CREATE TABLE StudentPreference (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20),
    Preference INT,
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId)
);

CREATE TABLE Allotments (
    SubjectId VARCHAR(20),
    StudentId VARCHAR(20)
);

CREATE TABLE UnallotedStudents (
    StudentId VARCHAR(20)
);


-- Insert StudentDetails
INSERT INTO StudentDetails VALUES
('159103036', 'Mohit Agarwal', 8.9, 'CCE', 'A'),
('159103037', 'Rohit Agarwal', 5.2, 'CCE', 'A'),
('159103038', 'Shohit Garg', 7.1, 'CCE', 'B'),
('159103039', 'Mrinal Malhotra', 7.9, 'CCE', 'A'),
('159103040', 'Mehreet Singh', 5.6, 'CCE', 'A'),
('159103041', 'Arjun Tehlan', 9.2, 'CCE', 'B');

-- Insert SubjectDetails
INSERT INTO SubjectDetails VALUES
('PO1491', 'Basics of Political Science', 60, 2),
('PO1492', 'Basics of Accounting', 120, 119),
('PO1493', 'Basics of Financial Markets', 90, 90),
('PO1494', 'Eco philosophy', 60, 50),
('PO1495', 'Automotive Trends', 60, 60);

-- Insert Preferences for each student (example)
INSERT INTO StudentPreference VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 2),
('159103036', 'PO1493', 3),
('159103036', 'PO1494', 4),
('159103036', 'PO1495', 5),

('159103037', 'PO1491', 1),
('159103037', 'PO1492', 2),
('159103037', 'PO1493', 3),
('159103037', 'PO1494', 4),
('159103037', 'PO1495', 5),

('159103038', 'PO1492', 1),
('159103038', 'PO1493', 2),
('159103038', 'PO1491', 3),
('159103038', 'PO1495', 4),
('159103038', 'PO1494', 5),

('159103039', 'PO1491', 1),
('159103039', 'PO1492', 2),
('159103039', 'PO1493', 3),
('159103039', 'PO1494', 4),
('159103039', 'PO1495', 5),

('159103040', 'PO1491', 1),
('159103040', 'PO1492', 2),
('159103040', 'PO1493', 3),
('159103040', 'PO1494', 4),
('159103040', 'PO1495', 5),

('159103041', 'PO1492', 1),
('159103041', 'PO1491', 2),
('159103041', 'PO1493', 3),
('159103041', 'PO1494', 4),
('159103041', 'PO1495', 5);


DELIMITER $$

CREATE PROCEDURE AllocateSubjects()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_studentId VARCHAR(20);
    DECLARE v_subjectId VARCHAR(20);
    DECLARE preference INT;
    DECLARE remaining INT;
    DECLARE got_allotted INT;

    DECLARE cur CURSOR FOR
        SELECT StudentId FROM StudentDetails ORDER BY GPA DESC;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_studentId;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET preference = 1;
        SET got_allotted = 0;

        subject_loop: WHILE preference <= 5 DO
            -- Prevent multiple row error
            SELECT SubjectId INTO v_subjectId
            FROM StudentPreference
            WHERE StudentId = v_studentId AND Preference = preference
            LIMIT 1;

            SELECT RemainingSeats INTO remaining
            FROM SubjectDetails
            WHERE SubjectId = v_subjectId
            LIMIT 1;

            IF remaining > 0 THEN
                INSERT INTO Allotments (SubjectId, StudentId)
                VALUES (v_subjectId, v_studentId);

                UPDATE SubjectDetails
                SET RemainingSeats = RemainingSeats - 1
                WHERE SubjectId = v_subjectId;

                SET got_allotted = 1;
                LEAVE subject_loop;
            END IF;

            SET preference = preference + 1;
        END WHILE;

        IF got_allotted = 0 THEN
            INSERT INTO UnallotedStudents (StudentId)
            VALUES (v_studentId);
        END IF;

    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;
CALL AllocateSubjects();

SELECT * FROM Allotments;
SELECT * FROM UnallotedStudents;
