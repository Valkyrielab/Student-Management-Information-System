USE StudentManagementDB
GO

SELECT c.CourseCode, c.CourseName, e.StudentID
FROM COURSE c
LEFT JOIN ENROLMENT e ON c.CourseID = e.CourseID;
