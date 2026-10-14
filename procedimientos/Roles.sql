
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Roles_Insert]
    @rolName       VARCHAR(80),
    @rolCreatorId  INT,
    @rolEnable     BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_SECURITY].[TBL_Roles]
        (rolName, rolEnable, rolCreationDate, rolCreatorId, rolModificationDate)
    VALUES
        (@rolName, @rolEnable, GETDATE(), @rolCreatorId, GETDATE());

    SELECT SCOPE_IDENTITY() AS rolId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Roles_Update]
    @rolId             INT,
    @rolName           VARCHAR(80),
    @rolEnable         BIT,
    @rolModificatorId  INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_SECURITY].[TBL_Roles]
    SET rolName             = @rolName,
        rolEnable           = @rolEnable,
        rolModificationDate = GETDATE(),
        rolModificatorId    = @rolModificatorId
    WHERE rolId = @rolId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Roles_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT rolId,
           rolName,
           rolEnable,
           rolCreationDate,
           rolCreatorId,
           rolModificationDate,
           rolModificatorId
    FROM [SQM_SECURITY].[TBL_Roles]
    ORDER BY rolId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
