
------------------------------------------------------------------------------------------------

ALTER FUNCTION fn_IsExamAvailable
(
    @Exam_id INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @StartDateTime DATETIME,
            @EndDateTime   DATETIME,
            @Now           DATETIME = GETDATE();

    SELECT
        @StartDateTime = 
            CAST(Exam_Date AS DATETIME) 
            + CAST(Start_Time AS DATETIME),
        @EndDateTime   = 
            CAST(Exam_Date AS DATETIME) 
            + CAST(End_Time AS DATETIME)
    FROM Exam
    WHERE Exam_id = @Exam_id;

    IF @Now BETWEEN @StartDateTime AND @EndDateTime
        RETURN 1;

    RETURN 0;
END;
GO


----------------------------------------
ALTER PROC SubmitAnswer
(
    @Stud_id INT,
    @Exam_id INT,
    @Question_id INT,
    @Answer_text VARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @is_correct BIT = 0;
    DECLARE @degree INT = 0;

    -- 1️⃣ Check exam availability
    IF dbo.fn_IsExamAvailable(@Exam_id) = 0
    BEGIN
        RAISERROR ('Exam is not available at this time',16,1);
        RETURN;
    END

    -- 2️⃣ Check question belongs to exam
    IF NOT EXISTS (
        SELECT 1 FROM Question_Exam
        WHERE Exam_id = @Exam_id
          AND Quest_id = @Question_id
    )
    BEGIN
        RAISERROR ('Question does not belong to this exam',16,1);
        RETURN;
    END

    -- 3️⃣ Prevent duplicate answer
    IF EXISTS (
        SELECT 1 FROM Stud_Ans
        WHERE St_id = @Stud_id
          AND Exam_id = @Exam_id
          AND Quest_id = @Question_id
    )
    BEGIN
        RAISERROR ('Question already answered',16,1);
        RETURN;
    END

    -- 4️⃣ MCQ
    IF EXISTS (SELECT 1 FROM MCQ WHERE quest_id = @Question_id)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM MCQ
            WHERE quest_id = @Question_id
              AND choice_text = @Answer_text
              AND is_correct = 1
        )
            SET @is_correct = 1;
    END

    -- 5️⃣ True / False
    ELSE IF EXISTS (SELECT 1 FROM [T/F_Answer] WHERE quest_id = @Question_id)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM [T/F_Answer]
            WHERE quest_id = @Question_id
              AND correct_ans = @Answer_text
        )
            SET @is_correct = 1;
    END

    -- 6️⃣ Text Question (Manual correction later)
    ELSE IF EXISTS (SELECT 1 FROM Text_Answer WHERE quest_id = @Question_id)
    BEGIN
        -- Text questions corrected manually
        SET @is_correct = 0;
    END

    -- 7️⃣ Get degree
    IF @is_correct = 1
        SELECT @degree = degree 
        FROM Question 
        WHERE Quest_id = @Question_id;

    -- 8️⃣ Insert answer
    INSERT INTO Stud_Ans
    (
        Ans_Text,
        is_correct,
        degree_given,
        Quest_id,
        St_id,
        Exam_id
    )
    VALUES
    (
        @Answer_text,
        @is_correct,
        @degree,
        @Question_id,
        @Stud_id,
        @Exam_id
    );
END;
GO

-----------------------------------
ALTER PROC CalculateResult
(
    @Stud_id INT,
    @Exam_id INT,
    @Crs_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @final_degree INT;

    SELECT @final_degree = ISNULL(SUM(degree_given),0)
    FROM Stud_Ans
    WHERE St_id = @Stud_id
      AND Exam_id = @Exam_id;

    -- Delete old result if exists
    DELETE FROM Course_Result
    WHERE St_id = @Stud_id
      AND Exam_id = @Exam_id;

    INSERT INTO Course_Result
    (
        St_ID,
        Exam_id,
        Crs_id,
        final_degree,
        is_passed
    )
    VALUES
    (
        @Stud_id,
        @Exam_id,
        @Crs_id,
        @final_degree,
        CASE
            WHEN @final_degree >= (
                SELECT Min_degree 
                FROM Course 
                WHERE Crs_id = @Crs_id
            )
            THEN 1 ELSE 0
        END
    );
END;
GO
--------------------------------------------------

ALTER PROC AddCourse
(
    @Crs_name     VARCHAR(100),
    @Crs_desc     VARCHAR(300),
    @Max_degree   INT,
    @Min_degree   INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1️⃣ Check duplicate course name
    IF EXISTS (SELECT 1 FROM Course WHERE Crs_name = @Crs_name)
    BEGIN
        RAISERROR ('Course already exists',16,1);
        RETURN;
    END

    -- 2️⃣ Check degrees logic
    IF @Min_degree >= @Max_degree
    BEGIN
        RAISERROR ('Min degree must be less than Max degree',16,1);
        RETURN;
    END

    IF @Min_degree < 0 OR @Max_degree <= 0
    BEGIN
        RAISERROR ('Degrees must be positive values',16,1);
        RETURN;
    END

    INSERT INTO Course
    (
        Crs_name,
        Description,
        Max_degree,
        Min_degree
    )
    VALUES
    (
        @Crs_name,
        @Crs_desc,
        @Max_degree,
        @Min_degree
    );
END;
GO

--------------------------------------------
ALTER PROC AddInstructor
(
    @F_name VARCHAR(100),
    @L_name VARCHAR(100),
    @email  VARCHAR(100),
    @user_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1️⃣ Email uniqueness
    IF EXISTS (SELECT 1 FROM Instructor WHERE email = @email)
    BEGIN
        RAISERROR ('Instructor email already exists',16,1);
        RETURN;
    END

    -- 2️⃣ Check user exists
    IF NOT EXISTS (SELECT 1 FROM [User] WHERE Usr_ID = @user_id)
    BEGIN
        RAISERROR ('User does not exist',16,1);
        RETURN;
    END

    -- 3️⃣ Check role
    IF NOT EXISTS (
        SELECT 1 FROM [User]
        WHERE Usr_ID = @user_id
          AND Role = 'Instructor'
    )
    BEGIN
        RAISERROR ('User is not assigned as Instructor',16,1);
        RETURN;
    END

    -- 4️⃣ Prevent duplicate user usage
    IF EXISTS (SELECT 1 FROM Instructor WHERE Usr_ID = @user_id)
    BEGIN
        RAISERROR ('User already linked to another instructor',16,1);
        RETURN;
    END

    INSERT INTO Instructor
    (
        Fname,
        Lname,
        email,
        Usr_ID
    )
    VALUES
    (
        @F_name,
        @L_name,
        @email,
        @user_id
    );
END;
GO
--------------------------------------------
ALTER PROC AddStudent
(
    @F_name     VARCHAR(50),
    @L_name     VARCHAR(50),
    @Email      VARCHAR(100),
    @user_id    INT,
    @mngr_id    INT,
    @IntakeID   INT,
    @branchID   INT,
    @track_id   INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1️⃣ Email uniqueness
    IF EXISTS (SELECT 1 FROM Student WHERE Email = @Email)
    BEGIN
        RAISERROR ('Student email already exists',16,1);
        RETURN;
    END

    -- 2️⃣ Check user exists
    IF NOT EXISTS (SELECT 1 FROM [User] WHERE Usr_ID = @user_id)
    BEGIN
        RAISERROR ('User does not exist',16,1);
        RETURN;
    END

    -- 3️⃣ Check role
    IF NOT EXISTS (
        SELECT 1 FROM [User]
        WHERE Usr_ID = @user_id
          AND Role = 'Student'
    )
    BEGIN
        RAISERROR ('User is not assigned as Student',16,1);
        RETURN;
    END

    -- 4️⃣ Prevent duplicate user usage
    IF EXISTS (SELECT 1 FROM Student WHERE Usr_ID = @user_id)
    BEGIN
        RAISERROR ('User already linked to another student',16,1);
        RETURN;
    END

    -- 5️⃣ Validate foreign keys
    IF NOT EXISTS (SELECT 1 FROM Intake WHERE Intk_ID = @IntakeID)
    BEGIN
        RAISERROR ('Invalid Intake ID',16,1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Branch WHERE Brn_ID = @branchID)
    BEGIN
        RAISERROR ('Invalid Branch ID',16,1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Track WHERE Track_ID = @track_id)
    BEGIN
        RAISERROR ('Invalid Track ID',16,1);
        RETURN;
    END

    INSERT INTO Student
    (
        St_Fname,
        St_Lname,
        Email,
        Usr_ID,
        mngr_id,
        Intk_ID,
        Brn_ID,
        track_id
    )
    VALUES
    (
        @F_name,
        @L_name,
        @Email,
        @user_id,
        @mngr_id,
        @IntakeID,
        @branchID,
        @track_id
    );
END;
GO

----------------------------------------------------
ALTER PROC AddIntake
(
    @intake_name VARCHAR(50),
    @start_year date,
    @end_year   date,
    @training_mngr INT,
    @branchID INT,
    @track_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate years
    IF @start_year >= @end_year
    BEGIN
        RAISERROR ('Invalid intake years',16,1);
        RETURN;
    END

    -- Validate training manager
    IF NOT EXISTS (SELECT 1 FROM Training_Manager WHERE Mngr_ID = @training_mngr)
    BEGIN
        RAISERROR ('Training Manager does not exist',16,1);
        RETURN;
    END

    -- Validate branch
    IF NOT EXISTS (SELECT 1 FROM Branch WHERE Brn_ID = @branchID)
    BEGIN
        RAISERROR ('Branch does not exist',16,1);
        RETURN;
    END

    -- Validate track
    IF NOT EXISTS (SELECT 1 FROM Track WHERE Track_ID = @track_id)
    BEGIN
        RAISERROR ('Track does not exist',16,1);
        RETURN;
    END

    -- Prevent duplicate intake name in same branch
    IF EXISTS (SELECT 1 FROM Intake WHERE Intake_Name = @intake_name AND Brn_ID = @branchID)
    BEGIN
        RAISERROR ('Intake already exists for this branch',16,1);
        RETURN;
    END

    INSERT INTO Intake
    (
        Intake_Name,
        Start_Year,
        End_Year,
        Mngr_ID,
        Brn_ID,
        Track_ID
    )
    VALUES
    (
        @intake_name,
        @start_year,
        @end_year,
        @training_mngr,
        @branchID,
        @track_id
    );
END;
GO

------------------------------------------------

ALTER PROC AddBranch
(
    @branch_name VARCHAR(100),
    @dept_id INT,
    @mngr_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate department
    IF NOT EXISTS (SELECT 1 FROM Department WHERE Dept_ID = @dept_id)
    BEGIN
        RAISERROR ('Department does not exist',16,1);
        RETURN;
    END

    -- Validate manager
    IF NOT EXISTS (SELECT 1 FROM Training_Manager WHERE Mngr_ID = @mngr_id)
    BEGIN
        RAISERROR ('Training Manager does not exist',16,1);
        RETURN;
    END

    -- Prevent duplicate branch
    IF EXISTS (SELECT 1 FROM Branch WHERE Branch_Name = @branch_name AND Dept_ID = @dept_id)
    BEGIN
        RAISERROR ('Branch already exists in this department',16,1);
        RETURN;
    END

    INSERT INTO Branch
    (
        Branch_Name,
        Dept_ID,
        Mngr_ID
    )
    VALUES
    (
        @branch_name,
        @dept_id,
        @mngr_id
    );
END;
GO

------------------------------------------------
ALTER PROC AddTrack
(
    @track_name VARCHAR(100),
    @mngr_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate manager
    IF NOT EXISTS (SELECT 1 FROM Training_Manager WHERE Mngr_ID = @mngr_id)
    BEGIN
        RAISERROR ('Training Manager does not exist',16,1);
        RETURN;
    END

    -- Prevent duplicate track
    IF EXISTS (SELECT 1 FROM Track WHERE Track_Name = @track_name AND Mngr_ID = @mngr_id)
    BEGIN
        RAISERROR ('Track already exists for this manager',16,1);
        RETURN;
    END

    INSERT INTO Track
    (
        Track_Name,
        Mngr_ID
    )
    VALUES
    (
        @track_name,
        @mngr_id
    );
END;
GO
------------------------------------------------
CREATE OR ALTER PROC CreateExamRandom
(
    @Exam_type VARCHAR(20),
    @Exam_date DATE,
    @Start_time TIME,
    @End_time TIME,
    @Total_time INT,
    @Allowance_option BIT,
    @Year INT,
    @Crs_id INT,
    @inst_id INT,
    @intakeID INT,
    @Num_MCQ INT,
    @Num_TF INT,
    @Num_Text INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Exam_id INT;

    -- Validate time
    IF @End_time <= @Start_time
    BEGIN
        RAISERROR ('End time must be after start time',16,1);
        RETURN;
    END

    -- Validate course
    IF NOT EXISTS (SELECT 1 FROM Course WHERE Crs_ID = @Crs_id)
    BEGIN
        RAISERROR('Course does not exist',16,1);
        RETURN;
    END

    -- Validate instructor
    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE Ins_ID = @inst_id)
    BEGIN
        RAISERROR('Instructor does not exist',16,1);
        RETURN;
    END

    -- Validate intake
    IF NOT EXISTS (SELECT 1 FROM Intake WHERE Intk_ID = @intakeID)
    BEGIN
        RAISERROR('Intake does not exist',16,1);
        RETURN;
    END

    -- Insert exam
    INSERT INTO Exam
    (
        Exam_type,
        Exam_date,
        Start_time,
        End_time,
        Total_time,
        Allowance_option,
        Year,
        Crs_id,
        Ins_ID,
        Intk_ID
    )
    VALUES
    (
        @Exam_type,
        @Exam_date,
        @Start_time,
        @End_time,
        @Total_time,
        @Allowance_option,
        @Year,
        @Crs_id,
        @inst_id,
        @intakeID
    );

    SET @Exam_id = SCOPE_IDENTITY();

    -- MCQ
    INSERT INTO Question_Exam(Exam_id, Quest_id)
    SELECT TOP (@Num_MCQ) @Exam_id, Q.Quest_id
    FROM Question Q
    JOIN Crs_Questions CQ ON Q.Quest_id = CQ.Quest_id
    WHERE CQ.Crs_id = @Crs_id
      AND Q.Quest_type = 'MCQ'
    ORDER BY NEWID();

    -- TF
    INSERT INTO Question_Exam(Exam_id, Quest_id)
    SELECT TOP (@Num_TF) @Exam_id, Q.Quest_id
    FROM Question Q
    JOIN Crs_Questions CQ ON Q.Quest_id = CQ.Quest_id
    WHERE CQ.Crs_id = @Crs_id
      AND Q.Quest_type = 'TF'
    ORDER BY NEWID();

    -- TEXT
    INSERT INTO Question_Exam(Exam_id, Quest_id)
    SELECT TOP (@Num_Text) @Exam_id, Q.Quest_id
    FROM Question Q
    JOIN Crs_Questions CQ ON Q.Quest_id = CQ.Quest_id
    WHERE CQ.Crs_id = @Crs_id
      AND Q.Quest_type = 'TEXT'
    ORDER BY NEWID();
END;
GO


---------------------------------------
CREATE OR ALTER PROC CreateExamManual
(
    @Exam_type VARCHAR(20),
    @Exam_date DATE,
    @Start_time TIME,
    @End_time TIME,
    @Total_time INT,
    @Allowance_option BIT,
    @Year INT,
    @Crs_id INT,
    @inst_id INT,
    @intakeID INT,
    @Question_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Exam_id INT;

    -- Validate time
    IF @End_time <= @Start_time
    BEGIN
        RAISERROR ('End time must be after start time',16,1);
        RETURN;
    END

    -- Validate course, instructor, intake, question
    IF NOT EXISTS (SELECT 1 FROM Course WHERE Crs_ID = @Crs_id)
    BEGIN
        RAISERROR('Course does not exist',16,1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE Ins_ID = @inst_id)
    BEGIN
        RAISERROR('Instructor does not exist',16,1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Intake WHERE Intk_ID = @intakeID)
    BEGIN
        RAISERROR('Intake does not exist',16,1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Question WHERE Quest_ID = @Question_id)
    BEGIN
        RAISERROR('Question does not exist',16,1);
        RETURN;
    END

    -- Insert or reuse existing exam
    IF NOT EXISTS (
        SELECT 1 FROM Exam
        WHERE Crs_id = @Crs_id
          AND Ins_ID = @inst_id
          AND Intk_ID = @intakeID
          AND Year = @Year
    )
    BEGIN
        INSERT INTO Exam
        (
            Exam_type,
            Exam_date,
            Start_time,
            End_time,
            Total_time,
            Allowance_option,
            Year,
            Crs_id,
            Ins_ID,
            Intk_ID
        )
        VALUES
        (
            @Exam_type,
            @Exam_date,
            @Start_time,
            @End_time,
            @Total_time,
            @Allowance_option,
            @Year,
            @Crs_id,
            @inst_id,
            @intakeID
        );

        SET @Exam_id = SCOPE_IDENTITY();
    END
    ELSE
    BEGIN
        SELECT @Exam_id = Exam_id
        FROM Exam
        WHERE Crs_id = @Crs_id
          AND Ins_ID = @inst_id
          AND Intk_ID = @intakeID
          AND Year = @Year;
    END

    -- Insert question into exam
    IF NOT EXISTS (
        SELECT 1 FROM Question_Exam
        WHERE Exam_id = @Exam_id AND Quest_id = @Question_id
    )
    BEGIN
        INSERT INTO Question_Exam(Exam_id, Quest_id)
        VALUES (@Exam_id, @Question_id);
    END
END;
GO

--------------------------------------------
CREATE OR ALTER PROCEDURE sp_CreateUser
(
    @Username VARCHAR(50),
    @Password VARCHAR(100),
    @Role VARCHAR(20),
	@isactive bit
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if username already exists
    IF EXISTS (SELECT 1 FROM [User] WHERE User_Name = @Username)
    BEGIN
        RAISERROR('Username already exists',16,1);
        RETURN;
    END

    -- Insert new user
    INSERT INTO [User] (User_Name, Pass, Role,Is_active)
    VALUES (@Username, @Password, @Role,@isactive);
END;
GO
------------------------------------------------
CREATE OR ALTER PROCEDURE sp_Login
(
    @Username VARCHAR(50),
    @Password VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM [User]
        WHERE User_Name = @Username
          AND Pass = @Password
    )
        SELECT 'Login Successful' AS Result;
    ELSE
        SELECT 'Invalid Credentials' AS Result;
END;
GO

