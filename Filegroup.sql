-- Create Filegroups
alter database ProjectDE_Exam
add filegroup ProjectTest
-- Adding files to filegroups
alter database ProjectDE_Exam
add file
)
name = 'project_exam'
filename = 'c:\ SQLDATA\project_exam.ndf'
size = 5MB
Maxsize = 20
filegrowth = 10%
(
to filegroup ProjectTest

