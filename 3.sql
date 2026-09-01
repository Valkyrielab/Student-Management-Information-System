USE StudentManagementDB
GO

SELECT s.StudentNumber, s.FullName, c.CourseCode, c.CourseName
FROM STUDENT s
INNER JOIN ENROLMENT e ON s.StudentID = e.StudentID
INNER JOIN COURSE c ON e.CourseID = c.CourseID;
