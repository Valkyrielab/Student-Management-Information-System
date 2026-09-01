USE StudentManagementDB
GO

SELECT s.StudentNumber, s.FullName, 
       ISNULL(SUM(p.Amount),0) AS TotalPaid,
       (5000 - ISNULL(SUM(p.Amount),0)) AS OutstandingBalance
FROM STUDENT s
LEFT JOIN PAYMENT p ON s.StudentID = p.StudentID
GROUP BY s.StudentNumber, s.FullName
HAVING ISNULL(SUM(p.Amount),0) < 5000;
