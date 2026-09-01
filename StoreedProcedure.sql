USE StudentManagementDB;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetStudentResults
    @StudentID INT
AS
BEGIN
    SELECT s.StudentNumber, s.FullName,
           c.CourseCode, c.CourseName,
           e.FinalMark,
           CASE 
               WHEN e.FinalMark >= 50 THEN 'Pass'
               ELSE 'NYC'
           END AS Result
    FROM STUDENT s
    INNER JOIN ENROLMENT e ON s.StudentID = e.StudentID
    INNER JOIN COURSE c ON e.CourseID = c.CourseID
    WHERE s.StudentID = @StudentID;
END;
