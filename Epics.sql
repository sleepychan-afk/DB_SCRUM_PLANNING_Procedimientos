
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Epics_Insert]
    @epicName         VARCHAR(100),
    @epicSummary      VARCHAR(500),
    @epicDescription  VARCHAR(4000),
    @epicParentLink   INT,
    @epicOwner        INT,
    @epicStatus       INT,
    @epicCreatorId    INT,
    @epicStartDate    DATE = NULL,
    @epicDueDate      DATE = NULL,
    @epicPriority     INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_GENERAL].[TBL_Epics]
        (epicName, epicSummary, epicDescription, epicParentLink, epicOwner, epicStartDate, epicDueDate, epicPriority, epicStatus, epicCreationDate, epicCreatorId)
    VALUES
        (@epicName, @epicSummary, @epicDescription, @epicParentLink, @epicOwner, @epicStartDate, @epicDueDate, @epicPriority, @epicStatus, GETDATE(), @epicCreatorId);

    SELECT SCOPE_IDENTITY() AS epicId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Epics_Update]
    @epicId             INT,
    @epicName           VARCHAR(100),
    @epicSummary        VARCHAR(500),
    @epicDescription    VARCHAR(4000),
    @epicParentLink     INT,
    @epicOwner          INT,
    @epicStatus         INT,
    @epicModificatorId  INT,
    @epicStartDate      DATE = NULL,
    @epicDueDate        DATE = NULL,
    @epicPriority       INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_GENERAL].[TBL_Epics]
    SET epicName             = @epicName,
        epicSummary          = @epicSummary,
        epicDescription      = @epicDescription,
        epicParentLink       = @epicParentLink,
        epicOwner            = @epicOwner,
        epicStartDate        = @epicStartDate,
        epicDueDate          = @epicDueDate,
        epicPriority         = @epicPriority,
        epicStatus           = @epicStatus,
        epicModificationDate = GETDATE(),
        epicModificatorId    = @epicModificatorId
    WHERE epicId = @epicId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Epics_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT epicId,
           epicName,
           epicSummary,
           epicDescription,
           epicParentLink,
           epicOwner,
           epicStartDate,
           epicDueDate,
           epicPriority,
           epicStatus,
           epicCreationDate,
           epicCreatorId,
           epicModificationDate,
           epicModificatorId
    FROM [SQM_GENERAL].[TBL_Epics]
    ORDER BY epicId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
