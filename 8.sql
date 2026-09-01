USE StudentManagementDB
GO

SELECT s.StudentNumber, s.FullName, SUM(p.Amount) AS TotalPaid
FROM STUDENT s
INNER JOIN PAYMENT p ON s.StudentID = p.StudentID
GROUP BY s.StudentNumber, s.FullName;
