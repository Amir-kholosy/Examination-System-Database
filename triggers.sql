
SELECT name 
FROM sys.triggers
WHERE parent_id = OBJECT_ID('Stud_Ans');

DROP TRIGGER trg_CheckExamTime;



-------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckExamTime_Submit
ON Stud_Ans
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @Exam_id INT,
            @Exam_Date DATE,
            @Start_Time TIME,
            @End_Time TIME,
            @Now DATETIME;

    SELECT TOP 1 @Exam_id = Exam_id
    FROM inserted;

    SELECT 
        @Exam_Date = Exam_Date,
        @Start_Time = Start_Time,
        @End_Time = End_Time
    FROM Exam
    WHERE Exam_id = @Exam_id;

    SET @Now = GETDATE();

    IF @Now NOT BETWEEN 
        CAST(@Exam_Date AS DATETIME) + CAST(@Start_Time AS DATETIME)
        AND
        CAST(@Exam_Date AS DATETIME) + CAST(@End_Time AS DATETIME)
    BEGIN
        RAISERROR('Cannot submit answer outside exam time window.',16,1);
        RETURN;
    END

    -- ✅ INSERT ONLY NON-IDENTITY COLUMNS
    INSERT INTO Stud_Ans
    (
        Ans_Text,
        is_correct,
        degree_given,
        Quest_id,
        St_id,
        Exam_id
    )
    SELECT
        Ans_Text,
        is_correct,
        degree_given,
        Quest_id,
        St_id,
        Exam_id
    FROM inserted;
END;
GO
-----------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckExamWithinIntake
ON Exam
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Intake t ON i.Intk_ID = t.Intk_ID
        WHERE i.Exam_Date NOT BETWEEN t.Start_Year AND t.End_Year
    )
    BEGIN
        RAISERROR('Exam date must be within intake period.',16,1);
        ROLLBACK TRANSACTION;
    END
END;
GO
---------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckGradeLimit
ON Stud_Ans
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Question_Exam qe
            ON qe.Exam_id = i.Exam_id
           AND qe.Quest_id = i.Quest_id
        WHERE i.degree_given < 0
           OR i.degree_given > qe.Degree
    )
    BEGIN
        RAISERROR('Grade exceeds allowed limit.',16,1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-----------------------------------------
CREATE OR ALTER TRIGGER trg_CheckStudentRegistered
ON Stud_Ans
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Exam e ON e.Exam_id = i.Exam_id
        LEFT JOIN Stud_Crs sc 
            ON sc.Crs_id = e.Crs_id
           AND sc.St_id = i.St_id
        WHERE sc.St_id IS NULL
    )
    BEGIN
        RAISERROR('Student is not registered for this exam.',16,1);
        ROLLBACK TRANSACTION;
    END
END;
GO
---------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_PreventDuplicateInstructorCourse
ON Instructor_Course
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Instructor_Course ic
          ON ic.Ins_id = i.Ins_id
         AND ic.Crs_id = i.Crs_id
         AND ic.Ins_year = i.Ins_year
         AND ic.Brn_ID = i.Brn_ID
         AND ic.Track_ID = i.Track_ID
         AND ic.Intk_ID = i.Intk_ID
    )
    BEGIN
        RAISERROR('Duplicate class definition not allowed.',16,1);
        RETURN;
    END

    INSERT INTO Instructor_Course
    SELECT * FROM inserted;
END;
GO
----------------------------------------------
CREATE OR ALTER TRIGGER trg_PreventExamOverlap
ON Exam
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Exam e
            ON e.Intk_ID = i.Intk_ID
           AND e.Exam_Date = i.Exam_Date
           AND e.Exam_id <> i.Exam_id
           AND i.Start_Time < e.End_Time
           AND i.End_Time   > e.Start_Time
    )
    BEGIN
        RAISERROR('Exam schedule overlaps with existing exam.',16,1);
        ROLLBACK TRANSACTION;
    END
END;
GO