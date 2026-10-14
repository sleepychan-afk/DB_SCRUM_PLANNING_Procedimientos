
USE [DB_SCRUM_PLANNING]
GO


CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Status_Insert]
    @statusName      VARCHAR(80),
    @statusCreatorId INT,
    @statusEnable    BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_CATALOGS].[TBL_Status]
        (statusName, statusCreationDate, statusCreatorId, statusModificationDate, statusEnable)
    VALUES
        (@statusName, GETDATE(), @statusCreatorId, GETDATE(), @statusEnable);

    SELECT SCOPE_IDENTITY() AS statusId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Status_Update]
    @statusId            INT,
    @statusName          VARCHAR(80),
    @statusModificatorId INT,
    @statusEnable        BIT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_CATALOGS].[TBL_Status]
    SET statusName             = @statusName,
        statusModificationDate = GETDATE(),
        statusModificatorId    = @statusModificatorId,
        statusEnable           = @statusEnable
    WHERE statusId = @statusId;
END
GO


CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Status_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    SELECT statusId, statusName, statusCreationDate, statusCreatorId,
           statusModificationDate, statusModificatorId, statusEnable
    FROM [SQM_CATALOGS].[TBL_Status]
    ORDER BY statusId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO

