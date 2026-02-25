USE ProjectDE_EXAM;
GO

/* =========================
   CLEANUP SCRIPT
   ========================= */
EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO
EXEC sp_msforeachtable 'DELETE FROM ?';
GO
EXEC sp_msforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

/* =========================
   1) Users
   ========================= */
INSERT INTO dbo.[User] (User_Name, Pass, Role, Is_active)
VALUES
('tm_ahmed', '123', 'Training_Manager', 1),
('tm_sara',  '123', 'Training_Manager', 1),
('tm_omar',  '123', 'Training_Manager', 1),
('ins_ali',   '123', 'Instructor', 1),
('ins_mona',  '123', 'Instructor', 1),
('ins_yousef','123', 'Instructor', 1),
('st_01', '123', 'Student', 1),
('st_02', '123', 'Student', 1),
('st_03', '123', 'Student', 1),
('st_04', '123', 'Student', 1),
('st_05', '123', 'Student', 1),
('st_06', '123', 'Student', 1),
('st_07', '123', 'Student', 1),
('st_08', '123', 'Student', 1),
('st_09', '123', 'Student', 1),
('st_10', '123', 'Student', 1);
GO

/* =========================
   2) Training Managers
   ========================= */
INSERT INTO dbo.Training_Manager (Fname, Lname, Email, Usr_ID)
SELECT 'Ahmed','Nabil','ahmed.tm@ex.com', Usr_ID FROM dbo.[User] WHERE User_Name='tm_ahmed'
UNION ALL
SELECT 'Sara','Hassan','sara.tm@ex.com',  Usr_ID FROM dbo.[User] WHERE User_Name='tm_sara'
UNION ALL
SELECT 'Omar','Eid',   'omar.tm@ex.com',  Usr_ID FROM dbo.[User] WHERE User_Name='tm_omar';
GO

/* =========================
   3) Department
   ========================= */
INSERT INTO dbo.Department (Dept_Name, Mngr_ID)
VALUES
('Data Engineering', (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='ahmed.tm@ex.com')),
('AI',              (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='sara.tm@ex.com'));
GO

/* =========================
   4) Track
   ========================= */
INSERT INTO dbo.Track (Track_ID, Track_Name, Mngr_ID)
VALUES
(10, 'DE',  (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='ahmed.tm@ex.com')),
(20, 'AI',  (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='sara.tm@ex.com')),
(30, 'BI',  (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='omar.tm@ex.com'));
GO

/* =========================
   5) Branch
   ========================= */
INSERT INTO dbo.Branch (Branch_Name, Dept_ID, Mngr_ID)
VALUES
('Cairo',  (SELECT TOP 1 Dept_ID FROM dbo.Department WHERE Dept_Name='Data Engineering'),
          (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='ahmed.tm@ex.com')),
('Alex',   (SELECT TOP 1 Dept_ID FROM dbo.Department WHERE Dept_Name='AI'),
          (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='sara.tm@ex.com'));
GO

/* =========================
   6) Branch_Track
   ========================= */
INSERT INTO dbo.Branch_Track (Track_ID, Brn_ID)
VALUES
(10, (SELECT TOP 1 Brn_ID FROM dbo.Branch WHERE Branch_Name='Cairo')),
(20, (SELECT TOP 1 Brn_ID FROM dbo.Branch WHERE Branch_Name='Cairo')),
(20, (SELECT TOP 1 Brn_ID FROM dbo.Branch WHERE Branch_Name='Alex')),
(30, (SELECT TOP 1 Brn_ID FROM dbo.Branch WHERE Branch_Name='Alex'));
GO

/* =========================
   7) Intake
   ========================= */
INSERT INTO dbo.Intake (Intake_Name, Start_Year, End_Year, Mngr_ID, Track_ID, Brn_ID)
VALUES
('Intake-45-DE-Cairo', '2025-10-01', '2026-06-30',
 (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='ahmed.tm@ex.com'),
 10, (SELECT TOP 1 Brn_ID FROM dbo.Branch WHERE Branch_Name='Cairo')),

('Intake-45-AI-Alex',  '2025-10-01', '2026-06-30',
 (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='sara.tm@ex.com'),
 20, (SELECT TOP 1 Brn_ID FROM dbo.Branch WHERE Branch_Name='Alex'));
GO

/* =========================
   8) Instructor
   ========================= */
INSERT INTO dbo.Instructor (Fname, Lname, Email, Usr_ID)
SELECT 'Ali','Mostafa','ali.ins@ex.com', Usr_ID FROM dbo.[User] WHERE User_Name='ins_ali'
UNION ALL
SELECT 'Mona','Kamal', 'mona.ins@ex.com',Usr_ID FROM dbo.[User] WHERE User_Name='ins_mona'
UNION ALL
SELECT 'Yousef','Adel','yousef.ins@ex.com',Usr_ID FROM dbo.[User] WHERE User_Name='ins_yousef';
GO

/* =========================
   9) Course
   ========================= */
INSERT INTO dbo.Course (Crs_Name, Description, Min_Degree, Max_Degree)
VALUES
('SQL Fundamentals', 'Basics of SQL Server', 0, 100),
('Database Design',  'ERD, normalization, constraints', 0, 100),
('Python for Data',  'Python essentials for data work', 0, 100),
('ETL Concepts',     'Pipelines, staging, warehousing', 0, 100);
GO

/* =========================================================================
   =================== START OF SHARED VARIABLE BATCH ======================
   ========================================================================= */

/* =========================
   10) Student
   ========================= */
DECLARE @CairoBrn INT = (SELECT TOP 1 Brn_ID FROM dbo.Branch WHERE Branch_Name='Cairo');
DECLARE @AlexBrn  INT = (SELECT TOP 1 Brn_ID FROM dbo.Branch WHERE Branch_Name='Alex');
DECLARE @IntkDE   INT = (SELECT TOP 1 Intk_ID FROM dbo.Intake WHERE Intake_Name='Intake-45-DE-Cairo');
DECLARE @IntkAI   INT = (SELECT TOP 1 Intk_ID FROM dbo.Intake WHERE Intake_Name='Intake-45-AI-Alex');
DECLARE @MngrDE   INT = (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='ahmed.tm@ex.com');
DECLARE @MngrAI   INT = (SELECT TOP 1 Mngr_ID FROM dbo.Training_Manager WHERE Email='sara.tm@ex.com');

INSERT INTO dbo.Student (St_Fname, St_Lname, Email, Usr_ID, Mngr_ID, Intk_ID, Brn_ID, Track_ID)
SELECT 'Student','01','st01@ex.com', Usr_ID, @MngrDE, @IntkDE, @CairoBrn, 10 FROM dbo.[User] WHERE User_Name='st_01'
UNION ALL
SELECT 'Student','02','st02@ex.com', Usr_ID, @MngrDE, @IntkDE, @CairoBrn, 10 FROM dbo.[User] WHERE User_Name='st_02'
UNION ALL
SELECT 'Student','03','st03@ex.com', Usr_ID, @MngrDE, @IntkDE, @CairoBrn, 10 FROM dbo.[User] WHERE User_Name='st_03'
UNION ALL
SELECT 'Student','04','st04@ex.com', Usr_ID, @MngrDE, @IntkDE, @CairoBrn, 10 FROM dbo.[User] WHERE User_Name='st_04'
UNION ALL
SELECT 'Student','05','st05@ex.com', Usr_ID, @MngrDE, @IntkDE, @CairoBrn, 10 FROM dbo.[User] WHERE User_Name='st_05';

INSERT INTO dbo.Student (St_Fname, St_Lname, Email, Usr_ID, Mngr_ID, Intk_ID, Brn_ID, Track_ID)
SELECT 'Student','06','st06@ex.com', Usr_ID, @MngrAI, @IntkAI, @AlexBrn, 20 FROM dbo.[User] WHERE User_Name='st_06'
UNION ALL
SELECT 'Student','07','st07@ex.com', Usr_ID, @MngrAI, @IntkAI, @AlexBrn, 20 FROM dbo.[User] WHERE User_Name='st_07'
UNION ALL
SELECT 'Student','08','st08@ex.com', Usr_ID, @MngrAI, @IntkAI, @AlexBrn, 20 FROM dbo.[User] WHERE User_Name='st_08'
UNION ALL
SELECT 'Student','09','st09@ex.com', Usr_ID, @MngrAI, @IntkAI, @AlexBrn, 20 FROM dbo.[User] WHERE User_Name='st_09'
UNION ALL
SELECT 'Student','10','st10@ex.com', Usr_ID, @MngrAI, @IntkAI, @AlexBrn, 20 FROM dbo.[User] WHERE User_Name='st_10';

/* =========================
   11) Instructor_Course
   ========================= */
DECLARE @InsAli  INT = (SELECT TOP 1 Ins_ID FROM dbo.Instructor WHERE Email='ali.ins@ex.com');
DECLARE @InsMona INT = (SELECT TOP 1 Ins_ID FROM dbo.Instructor WHERE Email='mona.ins@ex.com');
DECLARE @SQL     INT = (SELECT TOP 1 Crs_ID FROM dbo.Course WHERE Crs_Name='SQL Fundamentals');
DECLARE @DBD     INT = (SELECT TOP 1 Crs_ID FROM dbo.Course WHERE Crs_Name='Database Design');
DECLARE @PY      INT = (SELECT TOP 1 Crs_ID FROM dbo.Course WHERE Crs_Name='Python for Data');
DECLARE @ETL     INT = (SELECT TOP 1 Crs_ID FROM dbo.Course WHERE Crs_Name='ETL Concepts');

INSERT INTO dbo.Instructor_Course (Ins_ID, Crs_ID, Ins_year, Brn_ID, Track_ID, Intk_ID)
VALUES
(@InsAli,  @SQL, 2026, @CairoBrn, 10, @IntkDE),
(@InsAli,  @DBD, 2026, @CairoBrn, 10, @IntkDE),
(@InsMona, @PY,  2026, @AlexBrn,  20, @IntkAI),
(@InsMona, @ETL, 2026, @AlexBrn,  20, @IntkAI);

/* =========================
   12) Exam
   ========================= */
INSERT INTO dbo.Exam (Exam_Type, Start_Time, End_Time, Total_Time, Exam_Date, [Year], Allowance_Option, Intk_ID, Crs_ID, Ins_ID)
VALUES
('Final', '10:00', '12:00', 120, '2026-02-20', 2026, 1, @IntkDE, @SQL, @InsAli),
('Quiz',  '13:00', '14:00',  60, '2026-02-21', 2026, 0, @IntkDE, @DBD, @InsAli),
('Final', '11:00', '13:00', 120, '2026-02-22', 2026, 1, @IntkAI, @PY,  @InsMona);

/* =========================
   13) Question + Answers
   ========================= */
INSERT INTO dbo.Question (Quest_Type, Quest_Text, Degree)
VALUES
('Multiple Choice', 'Which keyword is used to filter rows in SQL?', 5),
('Multiple Choice', 'Which constraint enforces uniqueness?', 5),
('True & False',    'A primary key can contain NULL.', 5),
('True & False',    'FOREIGN KEY ensures referential integrity.', 5),
('Text',            'Define normalization in DB design (short).', 10),
('Text',            'Explain what an index does.', 10);

DECLARE @Q1 INT = (SELECT MIN(Quest_ID) FROM dbo.Question);
DECLARE @Q2 INT = @Q1 + 1;
DECLARE @Q3 INT = @Q1 + 2;
DECLARE @Q4 INT = @Q1 + 3;
DECLARE @Q5 INT = @Q1 + 4;
DECLARE @Q6 INT = @Q1 + 5;

INSERT INTO dbo.MCQ (Choice_Text, Is_Correct, Quest_ID)
VALUES
('WHERE', 1, @Q1), ('GROUP BY', 0, @Q1), ('ORDER BY', 0, @Q1), ('HAVING', 0, @Q1),
('UNIQUE', 1, @Q2), ('DEFAULT', 0, @Q2), ('CHECK', 0, @Q2), ('IDENTITY', 0, @Q2);

INSERT INTO dbo.[T/F_Answer] (Quest_ID, Correct_Ans)
VALUES (@Q3, 'False'), (@Q4, 'True');

INSERT INTO dbo.Text_Answer (Script_Correct_Ans, Quest_ID, regex)
VALUES
('Normalization is organizing tables to reduce redundancy and improve integrity.', @Q5, NULL),
('Index speeds up data retrieval by providing a fast lookup structure.', @Q6, NULL);

/* =========================
   14) Crs_Questions
   ========================= */
INSERT INTO dbo.Crs_Questions (Quest_ID, Crs_ID)
VALUES
(@Q1, @SQL), (@Q2, @SQL), (@Q3, @SQL),
(@Q4, @DBD), (@Q5, @DBD),
(@Q6, @SQL);

/* =========================
   15) Question_Exam
   ========================= */
DECLARE @Exam1 INT = (SELECT TOP 1 Exam_ID FROM dbo.Exam WHERE Crs_ID=@SQL ORDER BY Exam_ID);
DECLARE @Exam2 INT = (SELECT TOP 1 Exam_ID FROM dbo.Exam WHERE Crs_ID=@DBD ORDER BY Exam_ID);
DECLARE @Exam3 INT = (SELECT TOP 1 Exam_ID FROM dbo.Exam WHERE Crs_ID=@PY  ORDER BY Exam_ID);

INSERT INTO dbo.Question_Exam (Exam_ID, Quest_ID, Degree)
VALUES
(@Exam1, @Q1, 5), (@Exam1, @Q2, 5), (@Exam1, @Q3, 5), (@Exam1, @Q6, 10),
(@Exam2, @Q4, 5), (@Exam2, @Q5, 10),
(@Exam3, @Q1, 5), (@Exam3, @Q4, 5);

/* =========================
   16) Stud_Exam
   ========================= */
DECLARE @St1 INT = (SELECT TOP 1 St_ID FROM dbo.Student WHERE Email='st01@ex.com');
DECLARE @St2 INT = (SELECT TOP 1 St_ID FROM dbo.Student WHERE Email='st02@ex.com');
DECLARE @St6 INT = (SELECT TOP 1 St_ID FROM dbo.Student WHERE Email='st06@ex.com');

INSERT INTO dbo.Stud_Exam (St_ID, Exam_ID)
VALUES
(@St1, @Exam1), (@St2, @Exam1), (@St1, @Exam2), (@St6, @Exam3);

/* =========================
   17) Stud_Ans
   ========================= */
INSERT INTO dbo.Stud_Ans (Ans_Text, Is_Correct, Degree_given, Quest_ID, St_ID, Exam_ID)
VALUES
('WHERE', 1, 5, @Q1, @St1, @Exam1),
('UNIQUE',1, 5, @Q2, @St1, @Exam1),
('True',  0, 0, @Q3, @St1, @Exam1),
('WHERE', 1, 5, @Q1, @St2, @Exam1);

/* =========================
   18) Course_Result
   ========================= */
INSERT INTO dbo.Course_Result (Final_Degree, Is_Passed, St_ID, Exam_ID, Crs_ID)
VALUES
(15, 1, @St1, @Exam1, @SQL),
(10, 1, @St2, @Exam1, @SQL),
(10, 1, @St1, @Exam2, @DBD),
(5,  0, @St6, @Exam3, @PY);

/* =========================
   19) Stud_Crs
   ========================= */
INSERT INTO dbo.Stud_Crs (Crs_ID, St_ID)
VALUES
(@SQL, @St1), (@DBD, @St1),
(@SQL, @St2),
(@PY,  @St6), (@ETL, @St6);
GO






USE [ProjectDE_EXAM]
GO
ALTER TABLE [dbo].[User] 
ADD CONSTRAINT DF_User_IsActive DEFAULT 1 FOR Is_active;

SELECT definition
FROM sys.check_constraints
WHERE name = 'CK_User_Role';

-- Users
DECLARE @Usr_tmngr1 INT, @Usr_tmngr2 INT, @Usr_ins1 INT, @Usr_st1 INT;

INSERT INTO [dbo].[User] (User_Name, Pass, Role, Is_active)
VALUES
('tmngr1', 'Pass@123', 'Training_Manager', 1),
('tmngr2', 'Pass@123', 'Training_Manager', 1),
('instr1', 'Pass@123', 'Instructor', 1),
('stud1', 'Pass@123', 'Student', 1);

-- Store IDs
SET @Usr_tmngr1 = SCOPE_IDENTITY() - 3;
SET @Usr_tmngr2 = SCOPE_IDENTITY() - 2;
SET @Usr_ins1 = SCOPE_IDENTITY() - 1;
SET @Usr_st1 = SCOPE_IDENTITY();


DECLARE @Mngr1 INT, @Mngr2 INT;

INSERT INTO [dbo].[Training_Manager] (Fname, Lname, Email, Usr_ID)
VALUES
('Ali', 'Ahmed', 'ali.mngr1@example.com', @Usr_tmngr1),
('Sara', 'Hassan', 'sara.mngr2@example.com', @Usr_tmngr2);

-- Store IDs
SET @Mngr1 = SCOPE_IDENTITY() - 1;
SET @Mngr2 = SCOPE_IDENTITY();


DECLARE @Dept1 INT, @Dept2 INT;

INSERT INTO [dbo].[Department] (Dept_Name, Mngr_ID)
VALUES
('IT', @Mngr1),
('HR', @Mngr2);

SET @Dept1 = SCOPE_IDENTITY() - 1;
SET @Dept2 = SCOPE_IDENTITY();

DECLARE @Brn1 INT, @Brn2 INT;

INSERT INTO [dbo].[Branch] (Branch_Name, Dept_ID, Mngr_ID)
VALUES
('Cairo Branch', @Dept1, @Mngr1),
('Alex Branch', @Dept2, @Mngr2);

SET @Brn1 = SCOPE_IDENTITY() - 1;
SET @Brn2 = SCOPE_IDENTITY();

DECLARE @Track1 INT, @Track2 INT;

INSERT INTO [dbo].[Track] (Track_Name, Mngr_ID)
VALUES
('Software', @Mngr1),
('Management', @Mngr2);

SET @Track1 = SCOPE_IDENTITY() - 1;
SET @Track2 = SCOPE_IDENTITY();

INSERT INTO [dbo].[Branch_Track] (Track_ID, Brn_ID)
VALUES
(@Track1, @Brn1),
(@Track2, @Brn2);

DECLARE @Intk1 INT;

INSERT INTO [dbo].[Intake] (Intake_Name, Start_Year, End_Year, Mngr_ID, Track_ID, Brn_ID)
VALUES
('Intake 2026', '2026-01-01', '2026-12-31', @Mngr1, @Track1, @Brn1);

SET @Intk1 = SCOPE_IDENTITY();
DECLARE @Ins1 INT;

INSERT INTO [dbo].[Instructor] (Fname, Lname, Email, Usr_ID)
VALUES
('Omar', 'Sayed', 'omar.ins1@example.com', @Usr_ins1);

SET @Ins1 = SCOPE_IDENTITY();


DECLARE @Crs1 INT;

INSERT INTO [dbo].[Course] (Crs_Name, Description, Min_Degree, Max_Degree)
VALUES
('SQL Basics', 'Learn SQL', 0, 100);

SET @Crs1 = SCOPE_IDENTITY();


INSERT INTO [dbo].[Instructor_Course] (Ins_ID, Crs_ID, Ins_year, Brn_ID, Track_ID, Intk_ID)
VALUES
(@Ins1, @Crs1, 2026, @Brn1, @Track1, @Intk1);


DECLARE @St1 INT;

INSERT INTO [dbo].[Student] (St_Fname, St_Lname, Email, Usr_ID, Mngr_ID, Intk_ID, Brn_ID, Track_ID)
VALUES
('Ahmed', 'Ali', 'ahmed.st1@example.com', @Usr_st1, @Mngr1, @Intk1, @Brn1, @Track1);

SET @St1 = SCOPE_IDENTITY();

DECLARE @Exam1 INT;

INSERT INTO [dbo].[Exam] (Exam_Type, Start_Time, End_Time, Total_Time, Exam_Date, Year, Allowance_Option, Intk_ID, Crs_ID, Ins_ID)
VALUES
('Final', '09:00', '12:00', 180, '2026-06-01', 2026, 1, @Intk1, @Crs1, @Ins1);

SET @Exam1 = SCOPE_IDENTITY();

INSERT INTO [dbo].[Stud_Crs] (Crs_ID, St_ID) VALUES (@Crs1, @St1);
INSERT INTO [dbo].[Stud_Exam] (St_ID, Exam_ID) VALUES (@St1, @Exam1);

INSERT INTO [dbo].[Course_Result] (Final_Degree, Is_Passed, St_ID, Exam_ID, Crs_ID)
VALUES (95, 1, @St1, @Exam1, @Crs1);





