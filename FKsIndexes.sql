--stud FKs
CREATE NONCLUSTERED INDEX IX_Student_Manager ON Student(mgr_id);
CREATE NONCLUSTERED INDEX IX_Student_Intake ON Student(intake_id);
CREATE NONCLUSTERED INDEX IX_Student_Branch ON Student(branchID);
CREATE NONCLUSTERED INDEX IX_Student_Track ON Student(track_id);
CREATE NONCLUSTERED INDEX IX_Student_User ON Student(User_id);
--Exam FKs
CREATE NONCLUSTERED INDEX IX_Exam_Course ON Exam(Crs_id);
CREATE NONCLUSTERED INDEX IX_Exam_Instructor ON Exam(inst_id);
CREATE NONCLUSTERED INDEX IX_Exam_Intake ON Exam(intakeID);
--Answer Table Fks
CREATE NONCLUSTERED INDEX IX_StudAns_Student ON stud_ans(Stud_id);
CREATE NONCLUSTERED INDEX IX_StudAns_Exam ON stud_ans(Exam_id);
CREATE NONCLUSTERED INDEX IX_StudAns_Question ON stud_ans(Question_id);
--QuestioType tables FKs
CREATE NONCLUSTERED INDEX IX_MCQ_Question ON MCQ(quest_id);
CREATE NONCLUSTERED INDEX IX_TF_Question ON TF_Answer(quest_id);
CREATE NONCLUSTERED INDEX IX_Text_Question ON textAnswerID(quest_id);
--arganizational Sturcture FKs
CREATE NONCLUSTERED INDEX IX_Track_Manager ON Track(training_mgr);
CREATE NONCLUSTERED INDEX IX_Branch_Department ON Branch(dept_id);
CREATE NONCLUSTERED INDEX IX_Branch_Manager ON Branch(training_mgr);
CREATE NONCLUSTERED INDEX IX_Intake_Manager ON Intake(training_mgr);
CREATE NONCLUSTERED INDEX IX_Intake_Track ON Intake(track_id);
CREATE NONCLUSTERED INDEX IX_Intake_Branch ON Intake(branchID);
CREATE NONCLUSTERED INDEX IX_Department_Manager ON Department(training_mgr);
