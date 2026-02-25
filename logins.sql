-- Create logins   
create login Admin_Login      with password = 'Admin@123'
create login Manager_Login    with password = 'Manager@123'
create login Instructor_Login with password = 'Instructor@123'
create login Student_Login    with password = 'Student@123'

-- 
use ProjectDE_Exam
go



create user Admin_User      for login Admin_Login
create user Manager_User    for login Manager_Login
create user Instructor_User for login Instructor_Login
create user Student_User    for login Student_Login

--
create role Admin_Role
create role Manager_Role
create role Instructor_Role
create role Student_Role


--

alter role Admin_Role      add member Admin_User
alter role Manager_Role    add member Manager_User
alter role Instructor_Role add member Instructor_User
alter role Student_Role    add member Student_User


--

deny select, insert, update, delete on schema::dbo to Manager_Role
deny select, insert, update, delete on schema::dbo to Instructor_Role
deny select, insert, update, delete on schema::dbo to Student_Role

--Permissions for manager

grant execute on dbo.AddCourse     to Manager_Role
grant execute on dbo.AddInstructor to Manager_Role
grant execute on dbo.AddStudent    to Manager_Role
grant execute on dbo.AddIntake     to Manager_Role
grant execute on dbo.AddBranch     to Manager_Role
grant execute on dbo.AddTrack      to Manager_Role


-- Permissions for instructor

grant execute on dbo.CreateExamRandom to Instructor_Role
grant execute on dbo.CreateExamManual to Instructor_Role



-- Permissions for student
grant execute on dbo.SubmitAnswer     to Student_Role
grant execute on dbo.CalculateResult  to Student_Role

-- All Permissions for admin
alter role db_owner add member Admin_User