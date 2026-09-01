USE StudentManagementDB
GO

SELECT * FROM STUDENT;

Select * FROM STUDENT
WHERE StudentNumber = 'STU002';

SELECT s.StudentNumber, s.FullName, c.CourseCode, c.CourseName
FROM STUDENT s
INNER JOIN ENROLMENT e ON s.StudentID = e.StudentID
INNER JOIN COURSE c ON e.CourseID = c.CourseID;

SELECT c.CourseCode, c.CourseName, e.StudentID
FROM COURSE c
LEFT JOIN ENROLMENT e ON c.CourseID = e.CourseID;

SELECT s.StudentNumber, s.FullName
FROM STUDENT s
LEFT JOIN ENROLMENT e ON s.StudentID = e.StudentID
WHERE e.CourseID IS NULL;

SELECT s.StudentNumber, s.FullName, e.FinalMark
FROM STUDENT s
INNER JOIN ENROLMENT e ON s.StudentID = e.StudentID
WHERE e.FinalMark >= 50;

SELECT c.CourseCode, c.CourseName, AVG(e.FinalMark) AS AverageMark
FROM COURSE c
INNER JOIN ENROLMENT e ON c.CourseID = e.CourseID
GROUP BY c.CourseCode, c.CourseName;

SELECT s.StudentNumber, s.FullName, SUM(p.Amount) AS TotalPaid
FROM STUDENT s
INNER JOIN PAYMENT p ON s.StudentID = p.StudentID
GROUP BY s.StudentNumber, s.FullName;

SELECT s.StudentNumber, s.FullName, 
       ISNULL(SUM(p.Amount),0) AS TotalPaid,
       (5000 - ISNULL(SUM(p.Amount),0)) AS OutstandingBalance
FROM STUDENT s
LEFT JOIN PAYMENT p ON s.StudentID = p.StudentID
GROUP BY s.StudentNumber, s.FullName
HAVING ISNULL(SUM(p.Amount),0) < 5000;

SELECT c.CourseCode, c.CourseName, COUNT(e.StudentID) AS StudentCount
FROM COURSE c
LEFT JOIN ENROLMENT e ON c.CourseID = e.CourseID
GROUP BY c.CourseCode, c.CourseName;
