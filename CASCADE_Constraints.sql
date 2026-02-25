

--CASCADE_Constraints


USE [ProjectDE_EXAM]
GO

/*

    MCQ 
*/
ALTER TABLE [dbo].[MCQ] DROP CONSTRAINT IF EXISTS [FK_MCQ_Question]
GO

ALTER TABLE [dbo].[MCQ] WITH CHECK ADD CONSTRAINT [FK_MCQ_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question] ([Quest_ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[MCQ] CHECK CONSTRAINT [FK_MCQ_Question]
GO


/*

    T/F_Answer 

*/
ALTER TABLE [dbo].[T/F_Answer] DROP CONSTRAINT IF EXISTS [FK_T/F_Answer_Question]
GO

ALTER TABLE [dbo].[T/F_Answer] WITH CHECK ADD CONSTRAINT [FK_T/F_Answer_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question] ([Quest_ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[T/F_Answer] CHECK CONSTRAINT [FK_T/F_Answer_Question]
GO


/*

    Text Answer

*/
ALTER TABLE [dbo].[Text_Answer] DROP CONSTRAINT IF EXISTS [FK_Text_Answer_Question]
GO

ALTER TABLE [dbo].[Text_Answer] WITH CHECK ADD CONSTRAINT [FK_Text_Answer_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question] ([Quest_ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Text_Answer] CHECK CONSTRAINT [FK_Text_Answer_Question]
GO


/*

    Crs_Questions 
*/

ALTER TABLE [dbo].[Crs_Questions] DROP CONSTRAINT IF EXISTS [FK_Crs_Questions_Course]
GO

ALTER TABLE [dbo].[Crs_Questions] WITH CHECK ADD CONSTRAINT [FK_Crs_Questions_Course] 
FOREIGN KEY ([Crs_ID]) REFERENCES [dbo].[Course] ([Crs_ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Crs_Questions] CHECK CONSTRAINT [FK_Crs_Questions_Course]
GO

ALTER TABLE [dbo].[Crs_Questions] DROP CONSTRAINT IF EXISTS [FK_Crs_Questions_Question]
GO

ALTER TABLE [dbo].[Crs_Questions] WITH CHECK ADD CONSTRAINT [FK_Crs_Questions_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question] ([Quest_ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Crs_Questions] CHECK CONSTRAINT [FK_Crs_Questions_Question]
GO


/*
     Question_Exam 
*/

ALTER TABLE [dbo].[Question_Exam] DROP CONSTRAINT IF EXISTS [FK_Question_Exam_Exam]
GO

ALTER TABLE [dbo].[Question_Exam] WITH CHECK ADD CONSTRAINT [FK_Question_Exam_Exam] 
FOREIGN KEY ([Exam_ID]) REFERENCES [dbo].[Exam] ([Exam_ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Question_Exam] CHECK CONSTRAINT [FK_Question_Exam_Exam]
GO

ALTER TABLE [dbo].[Question_Exam] DROP CONSTRAINT IF EXISTS [FK_Question_Exam_Question]
GO

ALTER TABLE [dbo].[Question_Exam] WITH CHECK ADD CONSTRAINT [FK_Question_Exam_Question] 
FOREIGN KEY ([Quest_ID]) REFERENCES [dbo].[Question] ([Quest_ID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Question_Exam] CHECK CONSTRAINT [FK_Question_Exam_Question]
GO

