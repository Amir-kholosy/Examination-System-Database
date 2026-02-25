



BEGIN TRY
INSERT INTO Stud_Ans (Ans_Text, is_correct, degree_given, Quest_id, St_id, Exam_id)
VALUES ('Late submission', 1, 5, 46, 144, 14); 





INSERT INTO Exam (Exam_Type, Start_Time, End_Time, Total_Time, Exam_Date, Year, Allowance_Option, Crs_id, Intk_ID, Ins_ID)
VALUES ('final Exam', '10:00', '11:00', 60, '2027-01-01', 2027, 0, 29, 14, 21);


INSERT INTO Stud_Ans (Ans_Text, is_correct, degree_given, Quest_id, St_id, Exam_id)
VALUES ('Too high grade', 1, 20, 46, 144, 14);


INSERT INTO Stud_Ans (Ans_Text, is_correct, degree_given, Quest_id, St_id, Exam_id)
VALUES ('Unregistered student answer', 1, 5, 46, 146, 14);


INSERT INTO Instructor_Course (Ins_id, Crs_id, Ins_year, Brn_ID, Track_ID, Intk_ID)
VALUES (20, 29, 2026, 14, 10, 14); 
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;