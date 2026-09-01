USE StudentManagementDB
GO

SELECT c.CourseCode, c.CourseName, COUNT(e.StudentID) AS StudentCount
FROM COURSE c
LEFT JOIN ENROLMENT e ON c.CourseID = e.CourseID
GROUP BY c.CourseCode, c.CourseName;
