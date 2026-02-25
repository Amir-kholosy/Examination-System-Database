
USE [ProjectDE_EXAM]
GO

---- [User]


--  Primary Key (PK)
ALTER TABLE [dbo].[User] ADD CONSTRAINT [PK_User] 
PRIMARY KEY CLUSTERED ([Usr_ID] ASC)
GO

--  Unique Constraint (UQ)
ALTER TABLE [dbo].[User] ADD CONSTRAINT [UQ_User_User_Name] 
UNIQUE NONCLUSTERED ([User_Name] ASC)
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[User] ADD CONSTRAINT [CK_User_Role] 
CHECK ([Role] IN ('Student', 'Instructor', 'Training_Manager'))
GO

------------------------------

-----[Course]


--  Primary Key (PK)
ALTER TABLE [dbo].[Course] ADD CONSTRAINT [PK_Course] 
PRIMARY KEY CLUSTERED ([Crs_ID] ASC)
GO

--  Unique Constraint (UQ)
ALTER TABLE [dbo].[Course] ADD CONSTRAINT [UQ_Course_Crs_Name] 
UNIQUE NONCLUSTERED ([Crs_Name] ASC)
GO

--  Check Constraints (CK)
ALTER TABLE [dbo].[Course] ADD CONSTRAINT [CK_Course_Min_Degree] 
CHECK ([Min_Degree] >= 0)
GO

ALTER TABLE [dbo].[Course] ADD CONSTRAINT [CK_Course_Max_Degree] 
CHECK ([Max_Degree] >= 0)
GO

ALTER TABLE [dbo].[Course] ADD CONSTRAINT [CK_Course_Degree] 
CHECK ([Min_Degree] <= [Max_Degree])
GO

ALTER TABLE [dbo].[Course] ADD CONSTRAINT [CK_Course_Name] 
CHECK (LEN(LTRIM(RTRIM([Crs_Name]))) > 0)
GO

----------------------------------------


-----[Question]



--  Primary Key (PK)
ALTER TABLE [dbo].[Question] ADD CONSTRAINT [PK_Question] 
PRIMARY KEY CLUSTERED ([Quest_ID] ASC)
GO

--  Check Constraints (CK)
ALTER TABLE [dbo].[Question] ADD CONSTRAINT [CK_Question_Degree] 
CHECK ([Degree] > 0)
GO

ALTER TABLE [dbo].[Question] ADD CONSTRAINT [CK_Question_Type] 
CHECK ([Quest_Type] IN ('Multiple Choice', 'True & False', 'Text'))
GO


-------------------------------------

----[Training_Manager]



--  Primary Key (PK)
ALTER TABLE [dbo].[Training_Manager] ADD CONSTRAINT [PK_Training_Manager] 
PRIMARY KEY CLUSTERED ([Mngr_ID] ASC)
GO

--  Unique Constraint (UQ)
ALTER TABLE [dbo].[Training_Manager] ADD CONSTRAINT [UQ_Training_Manager_Email] 
UNIQUE NONCLUSTERED ([Email] ASC)
GO

--  Foreign Key (FK)
ALTER TABLE [dbo].[Training_Manager] ADD CONSTRAINT [FK_Training_Manager_User] 
FOREIGN KEY ([Usr_ID]) REFERENCES [dbo].[User]([Usr_ID])
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[Training_Manager] ADD CONSTRAINT [CK_Training_Manager_Email] 
CHECK ([Email] LIKE '%@%.%')
GO


------------------------------------------

----[Instructor]



--  Primary Key (PK)
ALTER TABLE [dbo].[Instructor] ADD CONSTRAINT [PK_Instructor] 
PRIMARY KEY CLUSTERED ([Ins_ID] ASC)
GO

--  Unique Constraint (UQ)
ALTER TABLE [dbo].[Instructor] ADD CONSTRAINT [UQ_Instructor_Email] 
UNIQUE NONCLUSTERED ([Email] ASC)
GO

--  Foreign Key (FK)
ALTER TABLE [dbo].[Instructor] ADD CONSTRAINT [FK_Instructor_User] 
FOREIGN KEY ([Usr_ID]) REFERENCES [dbo].[User]([Usr_ID])
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[Instructor] ADD CONSTRAINT [CK_Instructor_Email] 
CHECK ([Email] LIKE '%@%.%')
GO


---------------------------------------------


----[Department]



--  Primary Key (PK)
ALTER TABLE [dbo].[Department] ADD CONSTRAINT [PK_Department] 
PRIMARY KEY CLUSTERED ([Dept_ID] ASC)
GO

--  Unique Constraint (UQ)
ALTER TABLE [dbo].[Department] ADD CONSTRAINT [UQ_Department_Dept_Name] 
UNIQUE NONCLUSTERED ([Dept_Name] ASC)
GO

--  Foreign Key (FK)
ALTER TABLE [dbo].[Department] ADD CONSTRAINT [FK_Department_Training_Manager] 
FOREIGN KEY ([Mngr_ID]) REFERENCES [dbo].[Training_Manager]([Mngr_ID])
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[Department] ADD CONSTRAINT [CK_Department_Name] 
CHECK (LEN(LTRIM(RTRIM([Dept_Name]))) > 0)
GO



----------------------------------------------


----[Track]



--  Primary Key (PK)
ALTER TABLE [dbo].[Track] ADD CONSTRAINT [PK_Track] 
PRIMARY KEY CLUSTERED ([Track_ID] ASC)
GO

--  Unique Constraint (UQ)
ALTER TABLE [dbo].[Track] ADD CONSTRAINT [UQ_Track_Track_Name] 
UNIQUE NONCLUSTERED ([Track_Name] ASC)
GO

--  Foreign Key (FK)
ALTER TABLE [dbo].[Track] ADD CONSTRAINT [FK_Track_Training_Manager] 
FOREIGN KEY ([Mngr_ID]) REFERENCES [dbo].[Training_Manager]([Mngr_ID])
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[Track] ADD CONSTRAINT [CK_Track_Name] 
CHECK (LEN(LTRIM(RTRIM([Track_Name]))) > 0)
GO


----------------------------------------------

----[Branch]

-

--  Primary Key (PK)
ALTER TABLE [dbo].[Branch] ADD CONSTRAINT [PK_Branch] 
PRIMARY KEY CLUSTERED ([Brn_ID] ASC)
GO

--  Unique Constraint (UQ)
ALTER TABLE [dbo].[Branch] ADD CONSTRAINT [UQ_Branch_Branch_Name] 
UNIQUE NONCLUSTERED ([Branch_Name] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Branch] ADD CONSTRAINT [FK_Branch_Department] 
FOREIGN KEY ([Dept_ID]) REFERENCES [dbo].[Department]([Dept_ID])
GO

ALTER TABLE [dbo].[Branch] ADD CONSTRAINT [FK_Branch_Training_Manager] 
FOREIGN KEY ([Mngr_ID]) REFERENCES [dbo].[Training_Manager]([Mngr_ID])
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[Branch] ADD CONSTRAINT [CK_Branch_Name] 
CHECK (LEN(LTRIM(RTRIM([Branch_Name]))) > 0)
GO




-----------------------------------------------


---- [Branch_Track]



--  Primary Key (PK) - Composite
ALTER TABLE [dbo].[Branch_Track] ADD CONSTRAINT [PK_Branch_Track] 
PRIMARY KEY CLUSTERED ([Track_ID] ASC, [Brn_ID] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Branch_Track] ADD CONSTRAINT [FK_Branch_Track_Branch] 
FOREIGN KEY ([Brn_ID]) REFERENCES [dbo].[Branch]([Brn_ID])
GO

ALTER TABLE [dbo].[Branch_Track] ADD CONSTRAINT [FK_Branch_Track_Track] 
FOREIGN KEY ([Track_ID]) REFERENCES [dbo].[Track]([Track_ID])
GO




------------------------------------------------


----[Intake]



--  Primary Key (PK)
ALTER TABLE [dbo].[Intake] ADD CONSTRAINT [PK_Intake] 
PRIMARY KEY CLUSTERED ([Intk_ID] ASC)
GO

--  Unique Constraint (UQ)
ALTER TABLE [dbo].[Intake] ADD CONSTRAINT [UQ_Intake_Intake_Name] 
UNIQUE NONCLUSTERED ([Intake_Name] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Intake] ADD CONSTRAINT [FK_Intake_Training_Manager] 
FOREIGN KEY ([Mngr_ID]) REFERENCES [dbo].[Training_Manager]([Mngr_ID])
GO

ALTER TABLE [dbo].[Intake] ADD CONSTRAINT [FK_Intake_Track] 
FOREIGN KEY ([Track_ID]) REFERENCES [dbo].[Track]([Track_ID])
GO

ALTER TABLE [dbo].[Intake] ADD CONSTRAINT [FK_Intake_Branch] 
FOREIGN KEY ([Brn_ID]) REFERENCES [dbo].[Branch]([Brn_ID])
GO

--  Check Constraints (CK)
ALTER TABLE [dbo].[Intake] ADD CONSTRAINT [CK_Intake_Name] 
CHECK (LEN(LTRIM(RTRIM([Intake_Name]))) > 0)
GO

ALTER TABLE [dbo].[Intake] ADD CONSTRAINT [CK_Intake_Year_Range] 
CHECK ([End_Year] > [Start_Year])
GO






-------------------------------------------------

----[Student]




--  Primary Key (PK)
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [PK_Student] 
PRIMARY KEY CLUSTERED ([St_ID] ASC)
GO

--  Unique Constraint (UQ)
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [UQ_Student_Email] 
UNIQUE NONCLUSTERED ([Email] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_User] 
FOREIGN KEY ([Usr_ID]) REFERENCES [dbo].[User]([Usr_ID])
GO

ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_Training_Manager] 
FOREIGN KEY ([Mngr_ID]) REFERENCES [dbo].[Training_Manager]([Mngr_ID])
GO

ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_Intake] 
FOREIGN KEY ([Intk_ID]) REFERENCES [dbo].[Intake]([Intk_ID])
GO

ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_Branch] 
FOREIGN KEY ([Brn_ID]) REFERENCES [dbo].[Branch]([Brn_ID])
GO

ALTER TABLE [dbo].[Student] ADD CONSTRAINT [FK_Student_Track] 
FOREIGN KEY ([Track_ID]) REFERENCES [dbo].[Track]([Track_ID])
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[Student] ADD CONSTRAINT [CK_Student_Email] 
CHECK ([Email] LIKE '%@%.%')
GO






--------------------------------------------------


--- [Crs_Questions]



--  Primary Key (PK) - Composite
ALTER TABLE [dbo].[Crs_Questions] ADD CONSTRAINT [PK_Crs_Questions] 
PRIMARY KEY CLUSTERED ([Quest_ID] ASC, [Crs_ID] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Crs_Questions] ADD CONSTRAINT [FK_Crs_Questions_Course] 
FOREIGN KEY ([Crs_ID]) REFERENCES [dbo].[Course]([Crs_ID])
GO

ALTER TABLE [dbo].[Crs_Questions] ADD CONSTRAINT [FK_Crs_Questions_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question]([Quest_ID])
GO


----------------------------------------------


----[MCQ]


USE [ProjectDE_EXAM]
GO

--  Primary Key (PK)
ALTER TABLE [dbo].[MCQ] ADD CONSTRAINT [PK_MCQ] 
PRIMARY KEY CLUSTERED ([Choice_ID] ASC)
GO

--  Foreign Key (FK)
ALTER TABLE [dbo].[MCQ] ADD CONSTRAINT [FK_MCQ_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question]([Quest_ID])
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[MCQ] ADD CONSTRAINT [CK_MCQ_Is_Correct] 
CHECK ([Is_Correct] IN (0, 1))
GO



-----------------------------------------------

---- [T/F_Answer]



--  Primary Key (PK)
ALTER TABLE [dbo].[T/F_Answer] ADD CONSTRAINT [PK_T/F_Answer] 
PRIMARY KEY CLUSTERED ([Quest_ID] ASC)
GO

--  Foreign Key (FK)
ALTER TABLE [dbo].[T/F_Answer] ADD CONSTRAINT [FK_T/F_Answer_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question]([Quest_ID])
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[T/F_Answer] ADD CONSTRAINT [CK_TF_Answer_Correct] 
CHECK ([Correct_Ans] IN ('True', 'False'))
GO


------------------------------------------------

----


[Text_Answer]



--  Primary Key (PK)
ALTER TABLE [dbo].[Text_Answer] ADD CONSTRAINT [PK_Text_Answer] 
PRIMARY KEY CLUSTERED ([Txt_answer_ID] ASC)
GO

--  Foreign Key (FK)
ALTER TABLE [dbo].[Text_Answer] ADD CONSTRAINT [FK_Text_Answer_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question]([Quest_ID])
GO



--------------------------------------------------

----[Exam]



--  Primary Key (PK)
ALTER TABLE [dbo].[Exam] ADD CONSTRAINT [PK_Exam] 
PRIMARY KEY CLUSTERED ([Exam_ID] ASC)
GO

--  Unique Constraint (UQ)
ALTER TABLE [dbo].[Exam] ADD CONSTRAINT [UQ_Exam_Exam_Code] 
UNIQUE NONCLUSTERED ([Exam_Code] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Exam] ADD CONSTRAINT [FK_Exam_Course] 
FOREIGN KEY ([Crs_ID]) REFERENCES [dbo].[Course]([Crs_ID])
GO

ALTER TABLE [dbo].[Exam] ADD CONSTRAINT [FK_Exam_Instructor] 
FOREIGN KEY ([Ins_ID]) REFERENCES [dbo].[Instructor]([Ins_ID])
GO

ALTER TABLE [dbo].[Exam] ADD CONSTRAINT [FK_Exam_Intake] 
FOREIGN KEY ([Intk_ID]) REFERENCES [dbo].[Intake]([Intk_ID])
GO

--  Check Constraints (CK)
ALTER TABLE [dbo].[Exam] ADD CONSTRAINT [CK_Exam_Dates] 
CHECK ([End_Time] > [Start_Time])
GO

ALTER TABLE [dbo].[Exam] ADD CONSTRAINT [CK_Exam_Allowance] 
CHECK ([Allowance_Option] IN ('Allowed', 'Not Allowed'))
GO


---------------------------------------------------


---[Question_Exam]



--  Primary Key (PK) - Composite
ALTER TABLE [dbo].[Question_Exam] ADD CONSTRAINT [PK_Question_Exam] 
PRIMARY KEY CLUSTERED ([Exam_ID] ASC, [Quest_ID] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Question_Exam] ADD CONSTRAINT [FK_Question_Exam_Exam] 
FOREIGN KEY ([Exam_ID]) REFERENCES [dbo].[Exam]([Exam_ID])
GO

ALTER TABLE [dbo].[Question_Exam] ADD CONSTRAINT [FK_Question_Exam_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question]([Quest_ID])
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[Question_Exam] ADD CONSTRAINT [CK_Question_Exam_Degree] 
CHECK ([Degree] > 0)
GO



--------------------------------------------------

---[Stud_Exam]




--  Primary Key (PK) - Composite
ALTER TABLE [dbo].[Stud_Exam] ADD CONSTRAINT [PK_Stud_Exam] 
PRIMARY KEY CLUSTERED ([St_ID] ASC, [Exam_ID] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Stud_Exam] ADD CONSTRAINT [FK_Stud_Exam_Student] 
FOREIGN KEY ([St_ID]) REFERENCES [dbo].[Student]([St_ID])
GO

ALTER TABLE [dbo].[Stud_Exam] ADD CONSTRAINT [FK_Stud_Exam_Exam] 
FOREIGN KEY ([Exam_ID]) REFERENCES [dbo].[Exam]([Exam_ID])
GO



------------------------------------------------


----[Stud_Ans]



--  Primary Key (PK)
ALTER TABLE [dbo].[Stud_Ans] ADD CONSTRAINT [PK_Stud_Ans] 
PRIMARY KEY CLUSTERED ([Std_ans_ID] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Stud_Ans] ADD CONSTRAINT [FK_Stud_Ans_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question]([Quest_ID])
GO

ALTER TABLE [dbo].[Stud_Ans] ADD CONSTRAINT [FK_Stud_Ans_Stud_Exam] 
FOREIGN KEY ([St_ID], [Exam_ID]) 
REFERENCES [dbo].[Stud_Exam]([St_ID], [Exam_ID])
GO

--  Check Constraints (CK)
ALTER TABLE [dbo].[Stud_Ans] ADD CONSTRAINT [CK_Stud_Ans_Degree] 
CHECK ([Degree_given] >= 0)
GO

ALTER TABLE [dbo].[Stud_Ans] ADD CONSTRAINT [CK_Stud_Ans_Is_Correct] 
CHECK ([Is_Correct] IN (0, 1))
GO




-----------------------------------------------


---- [Stud_Crs]




--  Primary Key (PK) - Composite
ALTER TABLE [dbo].[Stud_Crs] ADD CONSTRAINT [PK_Stud_Crs] 
PRIMARY KEY CLUSTERED ([Crs_ID] ASC, [St_ID] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Stud_Crs] ADD CONSTRAINT [FK_Stud_Crs_Course] 
FOREIGN KEY ([Crs_ID]) REFERENCES [dbo].[Course]([Crs_ID])
GO

ALTER TABLE [dbo].[Stud_Crs] ADD CONSTRAINT [FK_Stud_Crs_Student] 
FOREIGN KEY ([St_ID]) REFERENCES [dbo].[Student]([St_ID])
GO



---------------------------------------------------



----[Instructor_Course]




--  Primary Key (PK) - Composite
ALTER TABLE [dbo].[Instructor_Course] ADD CONSTRAINT [PK_Instructor_Course] 
PRIMARY KEY CLUSTERED ([Ins_ID] ASC, [Crs_ID] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Instructor_Course] ADD CONSTRAINT [FK_Instructor_Course_Instructor] 
FOREIGN KEY ([Ins_ID]) REFERENCES [dbo].[Instructor]([Ins_ID])
GO

ALTER TABLE [dbo].[Instructor_Course] ADD CONSTRAINT [FK_Instructor_Course_Course] 
FOREIGN KEY ([Crs_ID]) REFERENCES [dbo].[Course]([Crs_ID])
GO

ALTER TABLE [dbo].[Instructor_Course] ADD CONSTRAINT [FK_Instructor_Course_Branch] 
FOREIGN KEY ([Brn_ID]) REFERENCES [dbo].[Branch]([Brn_ID])
GO

ALTER TABLE [dbo].[Instructor_Course] ADD CONSTRAINT [FK_Instructor_Course_Track] 
FOREIGN KEY ([Track_ID]) REFERENCES [dbo].[Track]([Track_ID])
GO

ALTER TABLE [dbo].[Instructor_Course] ADD CONSTRAINT [FK_Instructor_Course_Intake] 
FOREIGN KEY ([Intk_ID]) REFERENCES [dbo].[Intake]([Intk_ID])
GO

--  Check Constraint (CK)
ALTER TABLE [dbo].[Instructor_Course] ADD CONSTRAINT [CK_Instructor_Course_Year] 
CHECK ([Ins_year] > 0)
GO





-------------------------------------------------


---- [Course_Result]




--  Primary Key (PK)
ALTER TABLE [dbo].[Course_Result] ADD CONSTRAINT [PK_Course_Result] 
PRIMARY KEY CLUSTERED ([Result_ID] ASC)
GO

--  Foreign Keys (FK)
ALTER TABLE [dbo].[Course_Result] ADD CONSTRAINT [FK_Course_Result_Student] 
FOREIGN KEY ([St_ID]) REFERENCES [dbo].[Student]([St_ID])
GO

ALTER TABLE [dbo].[Course_Result] ADD CONSTRAINT [FK_Course_Result_Exam] 
FOREIGN KEY ([Exam_ID]) REFERENCES [dbo].[Exam]([Exam_ID])
GO

ALTER TABLE [dbo].[Course_Result] ADD CONSTRAINT [FK_Course_Result_Course] 
FOREIGN KEY ([Crs_ID]) REFERENCES [dbo].[Course]([Crs_ID])
GO

--  Check Constraints (CK)
ALTER TABLE [dbo].[Course_Result] ADD CONSTRAINT [CK_Course_Result_Degree] 
CHECK ([Final_Degree] >= 0)
GO

ALTER TABLE [dbo].[Course_Result] ADD CONSTRAINT [CK_Course_Result_Is_Passed] 
CHECK ([Is_Passed] IN (0, 1))
GO




-----------------------------------------------------

