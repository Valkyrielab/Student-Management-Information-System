USE StudentManagementDB;
GO

CREATE VIEW dbo.vw_StudentResults AS
SELECT s.StudentID, s.StudentNumber, s.FullName,
       c.CourseCode, c.CourseName,
       e.FinalMark,
       CASE 
           WHEN e.FinalMark >= 50 THEN 'Pass'
           ELSE 'NYC' -- Not Yet Competent
       END AS Result
FROM STUDENT s
INNER JOIN ENROLMENT e ON s.StudentID = e.StudentID
INNER JOIN COURSE c ON e.CourseID = c.CourseID;
