
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_BusinessValues_Insert]
    @businessValueName       VARCHAR(80),
    @businessValueCreatorId  INT,
    @businessValueEnable     BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_CATALOGS].[TBL_BusinessValues]
        (businessValueName, businessValueEnable, businessValueCreationDate, businessValueCreatorId)
    VALUES
        (@businessValueName, @businessValueEnable, GETDATE(), @businessValueCreatorId);

    SELECT SCOPE_IDENTITY() AS businessValueId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_BusinessValues_Update]
    @businessValueId             INT,
    @businessValueName           VARCHAR(80),
    @businessValueEnable         BIT,
    @businessValueModificatorId  INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_CATALOGS].[TBL_BusinessValues]
    SET businessValueName             = @businessValueName,
        businessValueEnable           = @businessValueEnable,
        businessValueModificationDate = GETDATE(),
        businessValueModificatorId    = @businessValueModificatorId
    WHERE businessValueId = @businessValueId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_CATALOGS].[usp_BusinessValues_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT businessValueId,
           businessValueName,
           businessValueEnable,
           businessValueCreationDate,
           businessValueCreatorId,
           businessValueModificationDate,
           businessValueModificatorId
    FROM [SQM_CATALOGS].[TBL_BusinessValues]
    ORDER BY businessValueId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
