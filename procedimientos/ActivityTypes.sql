
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_ActivityTypes_Insert]
    @activityTypeName       VARCHAR(80),
    @activityTypeCreatorId  INT,
    @activityTypeEnable     BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_CATALOGS].[TBL_ActivityTypes]
        (activityTypeName, activityTypeEnable, activityTypeCreationDate, activityTypeCreatorId)
    VALUES
        (@activityTypeName, @activityTypeEnable, GETDATE(), @activityTypeCreatorId);

    SELECT SCOPE_IDENTITY() AS activityTypeId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_ActivityTypes_Update]
    @activityTypeId             INT,
    @activityTypeName           VARCHAR(80),
    @activityTypeEnable         BIT,
    @activityTypeModificatorId  INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_CATALOGS].[TBL_ActivityTypes]
    SET activityTypeName             = @activityTypeName,
        activityTypeEnable           = @activityTypeEnable,
        activityTypeModificationDate = GETDATE(),
        activityTypeModificatorId    = @activityTypeModificatorId
    WHERE activityTypeId = @activityTypeId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_ActivityTypes_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT activityTypeId,
           activityTypeName,
           activityTypeEnable,
           activityTypeCreationDate,
           activityTypeCreatorId,
           activityTypeModificationDate,
           activityTypeModificatorId
    FROM [SQM_CATALOGS].[TBL_ActivityTypes]
    ORDER BY activityTypeId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
