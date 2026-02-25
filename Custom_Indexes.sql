
-- unique cuz unames must not repeat
--search by names on login
CREATE UNIQUE NONCLUSTERED INDEX IX_User_Username
ON [User](User_name);
-----------------------------------------------------------------
-- student log in --> system load the available exams
CREATE NONCLUSTERED INDEX IX_StudExam_Student
ON Stud_exam(Stud_id);
-----------------------------------------------------------------
--Used when:student submits exam ,instructor opens results ,system calculates grade
--why composite : search by exam then the student who took it & cuz order is important
CREATE NONCLUSTERED INDEX IX_StudAns_ExamStudent
ON stud_ans(Exam_id, Stud_id);
-----------------------------------------------------------------
-- when ins logs in
CREATE NONCLUSTERED INDEX IX_InsCourse_Ins
ON Ins_crs(Ins_id);
-----------------------------------------------------------------
--when student opens exam instead of  scanning all question for all exams it scans only quests for the exact exam id typed
CREATE NONCLUSTERED INDEX IX_QuestExam_Exam
ON Quest_exam(Exam_id);
-----------------------------------------------------------------


