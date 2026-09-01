USE StudentManagementDB;
GO

CREATE TABLE STUDENT 
(
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentNumber NVARCHAR(20) NOT NULL UNIQUE,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Status NVARCHAR(10) NOT NULL CHECK (Status IN ('Active','Inactive'))
);         
                          
CREATE TABLE LECTURER 
(
    LecturerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE COURSE 
(
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseCode NVARCHAR(20) NOT NULL UNIQUE,
    CourseName NVARCHAR(100) NOT NULL,
    LecturerID INT NOT NULL,
    CONSTRAINT FK_Course_Lecturer FOREIGN KEY (LecturerID) REFERENCES LECTURER(LecturerID)
);

CREATE TABLE ENROLMENT
(
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrolmentDate DATE NOT NULL,
    FinalMark INT NULL CHECK (FinalMark BETWEEN 0 AND 100),
    CONSTRAINT PK_Enrolment PRIMARY KEY (StudentID, CourseID),
    CONSTRAINT FK_Enrolment_Student FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
    CONSTRAINT FK_Enrolment_Course FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID)
);

CREATE TABLE PAYMENT 
(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    PaymentDate DATE NOT NULL,
    ReferenceNumber NVARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT FK_Payment_Student FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID)
);

CREATE TABLE MarkAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    PreviousMark INT NULL,
    NewMark INT NULL,
    ChangedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ChangedBy NVARCHAR(100) NOT NULL
);

INSERT INTO STUDENT (StudentNumber, FullName, Email, Status)
VALUES 
('STU001', 'Alice Mokoena', 'alice@college.ac.za', 'Active'),
('STU002', 'Brian Nkosi', 'brian@college.ac.za', 'Inactive'),
('STU003', 'Cindy Dlamini', 'cindy@college.ac.za', 'Active'),
('STU004', 'David Khumalo', 'david@college.ac.za', 'Active'),
('STU005', 'Evelyn Zulu', 'evelyn@college.ac.za', 'Inactive');


INSERT INTO LECTURER (FullName, Email)
VALUES 
('Prof. John Smith', 'john.smith@college.ac.za'),
('Dr. Thandi Ndlovu', 'thandi.ndlovu@college.ac.za'),
('Mr. Peter Jacobs', 'peter.jacobs@college.ac.za');

INSERT INTO COURSE (CourseCode, CourseName, LecturerID)
VALUES 
('CSE101', 'Intro to Programming', 1),
('CSE102', 'Database Systems', 2),
('CSE103', 'Networks', 3),
('CSE104', 'Legal Tech', 2);

INSERT INTO ENROLMENT (StudentID, CourseID, EnrolmentDate, FinalMark)
VALUES 
(1, 1, '2026-01-15', 78),
(2, 2, '2026-01-16', NULL),
(3, 2, '2026-01-17', 65),
(4, 3, '2026-01-18', 55),
(5, 1, '2026-01-19', 40),
(1, 3, '2026-01-20', 88);

INSERT INTO PAYMENT (StudentID, Amount, PaymentDate, ReferenceNumber)
VALUES 
(1, 5000, '2026-02-01', 'PAY001'),
(2, 4500, '2026-02-02', 'PAY002'),
(3, 5000, '2026-02-03', 'PAY003'),
(4, 3000, '2026-02-04', 'PAY004'),
(5, 2500, '2026-02-05', 'PAY005');