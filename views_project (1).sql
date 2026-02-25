
CREATE VIEW vw_QuestionPool
AS
SELECT
    Q.Quest_ID,
    Q.Quest_type,
    Q.Quest_text,
    Q.degree,
    CQ.Crs_id
FROM Question Q
JOIN crs_questions CQ
    ON Q.Quest_id = CQ.Quest_id;

go

	CREATE VIEW vw_StudentResults
AS
SELECT
    S.St_ID,
    S.St_Fname,
    S.St_Lname,
    C.Crs_name,
    CR.final_degree,
    CR.is_passed
FROM Course_Result CR
JOIN Student S ON CR.St_ID = S.St_ID
JOIN Course C ON CR.Crs_id = C.Crs_id;
GO
-------------------------------------
CREATE VIEW vw_TextAnswersReview
AS
SELECT
    S.St_ID,
    Q.Quest_Text,
    SA.Ans_Text,
    SA.is_correct
FROM stud_ans SA
JOIN Question Q ON SA.Quest_ID = Q.Quest_ID
JOIN Student S ON SA.St_ID = S.St_ID
WHERE Q.Quest_Type = 'Text';
go


CREATE VIEW vw_Courses
AS
SELECT
    Crs_id,
    Crs_name,
    Description,
    Max_degree,
    Min_degree
FROM Course;
GO


CREATE VIEW vw_CourseInstructorByYear
AS
SELECT
    C.Crs_name,
    I.Fname,
    ICC.Ins_year,
    INTAKE.intake_name
FROM Instructor_Course ICC
JOIN Course C
    ON ICC.Crs_id = C.Crs_id
JOIN Instructor I
    ON ICC.Ins_ID = I.Ins_ID
JOIN intake INTAKE
    ON ICC.Intk_ID = INTAKE.Intk_ID;
GO



CREATE VIEW vw_StudentsDistribution
AS
SELECT
    B.branch_name,
    T.track_name,
    I.intake_name,
    COUNT(S.St_id) AS TotalStudents
FROM Student S
JOIN branch B ON S.Brn_ID = B.Brn_ID
JOIN track  T ON S.track_id = T.track_id
JOIN intake I ON S.Intk_ID = I.Intk_ID
GROUP BY
    B.branch_name,
    T.track_name,
    I.intake_name;
GO
--////////////////////////////////////////
CREATE VIEW vw_Intakes
AS
SELECT
    I.Intk_ID,
    I.Intake_Name,
    I.start_year,
    I.end_year,
    B.branch_name,
    T.track_name
FROM intake I
JOIN branch B ON I.Brn_ID = B.Brn_ID
JOIN track  T ON I.track_id = T.track_id;
GO

CREATE VIEW vw_ExamDetails
AS
SELECT
    E.Exam_id,
    E.Exam_type,
    B.branch_name,
    T.track_name,
    I.intake_name,
    E.Start_time,
    E.End_time,
    E.Total_time
FROM Exam E
JOIN intake I ON E.Intk_ID = I.Intk_ID
JOIN branch B ON I.Brn_ID = B.Brn_ID
JOIN track  T ON I.track_id = T.track_id;
GO
-----------------------------------------------------------------------
CREATE VIEW vw_ExamQuestions
AS
SELECT
    E.Exam_id,
    Q.Quest_text,
    QE.degree
FROM Question_Exam QE
JOIN Question Q ON QE.Quest_id = Q.Quest_id
JOIN Exam E ON QE.Exam_id = E.Exam_id;	
GO
-----------------------------------------------------------------------
CREATE VIEW vw_InstructorCourses
AS
SELECT
    I.Fname,
    C.Crs_name
FROM Instructor_Course IC
JOIN Instructor I ON IC.Ins_ID = I.Ins_ID
JOIN Course C ON IC.Crs_id = C.Crs_id;
