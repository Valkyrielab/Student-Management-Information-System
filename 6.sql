USE StudentManagementDB
GO

SELECT s.StudentNumber, s.FullName, e.FinalMark
FROM STUDENT s
INNER JOIN ENROLMENT e ON s.StudentID = e.StudentID
WHERE e.FinalMark >= 50;
