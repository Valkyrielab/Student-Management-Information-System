USE StudentManagementDB;
GO

CREATE TRIGGER trg_MarkAudit
ON ENROLMENT
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO MarkAudit (StudentID, CourseID, PreviousMark, NewMark, ChangedDate, ChangedBy)
    SELECT d.StudentID, d.CourseID, d.FinalMark, i.FinalMark, GETDATE(), SYSTEM_USER
    FROM deleted d
    INNER JOIN inserted i ON d.StudentID = i.StudentID AND d.CourseID = i.CourseID
    WHERE d.FinalMark <> i.FinalMark;
END;