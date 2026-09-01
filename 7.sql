USE StudentManagementDB
GO

SELECT c.CourseCode, c.CourseName, AVG(e.FinalMark) AS AverageMark
FROM COURSE c
INNER JOIN ENROLMENT e ON c.CourseID = e.CourseID
GROUP BY c.CourseCode, c.CourseName;
