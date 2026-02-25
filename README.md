The Examination System Database is a SQL Server-based database project designed to manage an online examination environment. The system provides a structured and secure platform for managing question pools, exams, students, instructors, and academic results.

The system allows instructors to create exams by selecting questions from a question pool containing multiple question types, including multiple choice questions, true/false questions, and text-based questions. For objective questions, the system automatically checks student answers and calculates results. For text-based questions, the system stores best-accepted answers and uses text processing techniques and regular expressions to help evaluate student responses, allowing instructors to manually review and grade answers when needed.

The database supports academic management by storing course information, instructor assignments, student records, branches, tracks, and intake details. Each instructor can teach multiple courses, and course teaching assignments may change across different academic years.

The system also provides role-based access control with four types of users:

Administrator

Training Manager

Instructor

Student

Each user role has specific permissions and can only access relevant system functionalities.

The system ensures data integrity using constraints, triggers, stored procedures, and functions. Performance optimization is implemented using indexes, file groups, and proper database design techniques. Security is enforced through SQL Server authentication and permission management.

Additional features include:

Random or manual exam question selection

Time-limited exams with scheduling control

Student answer storage and automatic grading

Daily automatic database backup

Advanced search and reporting capabilities

The project was implemented using Microsoft SQL Server, following database design best practices, naming conventions, and performance optimization techniques.
