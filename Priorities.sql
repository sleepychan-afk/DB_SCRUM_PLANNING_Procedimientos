
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Priorities_Insert]
    @priorityName       VARCHAR(80),
    @priorityCreatorId  INT,
    @priorityEnable     BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_CATALOGS].[TBL_Priorities]
        (priorityName, priorityEnable, priorityCreationDate, priorityCreatorId)
    VALUES
        (@priorityName, @priorityEnable, GETDATE(), @priorityCreatorId);

    SELECT SCOPE_IDENTITY() AS priorityId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Priorities_Update]
    @priorityId             INT,
    @priorityName           VARCHAR(80),
    @priorityEnable         BIT,
    @priorityModificatorId  INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_CATALOGS].[TBL_Priorities]
    SET priorityName             = @priorityName,
        priorityEnable           = @priorityEnable,
        priorityModificationDate = GETDATE(),
        priorityModificatorId    = @priorityModificatorId
    WHERE priorityId = @priorityId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_Priorities_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT priorityId,
           priorityName,
           priorityEnable,
           priorityCreationDate,
           priorityCreatorId,
           priorityModificationDate,
           priorityModificatorId
    FROM [SQM_CATALOGS].[TBL_Priorities]
    ORDER BY priorityId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
