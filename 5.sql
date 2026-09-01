USE StudentManagementDB
GO

SELECT s.StudentNumber, s.FullName
FROM STUDENT s
LEFT JOIN ENROLMENT e ON s.StudentID = e.StudentID
WHERE e.CourseID IS NULL;

