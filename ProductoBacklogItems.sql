
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_ProductBacklogItems_Insert]
    @PBISummary              VARCHAR(500),
    @PBIDescription          VARCHAR(2000),
    @PBIsAcceptanceCriteria  VARCHAR(4000),
    @PBIOwner                INT,
    @PBIParentLink           INT,
    @PBIStatus               INT,
    @PBICreatorId            INT,
    @PBIStoryPoint           INT = NULL,
    @PBIStartDate            DATE = NULL,
    @PBIDueDate              DATE = NULL,
    @PBIPriority             INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_GENERAL].[TBL_ProductBacklogItems]
        (PBISummary, PBIDescription, PBIsAcceptanceCriteria, PBIOwner, PBIParentLink, PBIStoryPoint, PBIStartDate, PBIDueDate, PBIPriority, PBIStatus, PBICreationDate, PBICreatorId)
    VALUES
        (@PBISummary, @PBIDescription, @PBIsAcceptanceCriteria, @PBIOwner, @PBIParentLink, @PBIStoryPoint, @PBIStartDate, @PBIDueDate, @PBIPriority, @PBIStatus, GETDATE(), @PBICreatorId);

    SELECT SCOPE_IDENTITY() AS PBIId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_ProductBacklogItems_Update]
    @PBIId                   INT,
    @PBISummary              VARCHAR(500),
    @PBIDescription          VARCHAR(2000),
    @PBIsAcceptanceCriteria  VARCHAR(4000),
    @PBIOwner                INT,
    @PBIParentLink           INT,
    @PBIStatus               INT,
    @PBIModificatorId        INT,
    @PBIStoryPoint           INT = NULL,
    @PBIStartDate            DATE = NULL,
    @PBIDueDate              DATE = NULL,
    @PBIPriority             INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_GENERAL].[TBL_ProductBacklogItems]
    SET PBISummary             = @PBISummary,
        PBIDescription         = @PBIDescription,
        PBIsAcceptanceCriteria = @PBIsAcceptanceCriteria,
        PBIOwner               = @PBIOwner,
        PBIParentLink          = @PBIParentLink,
        PBIStoryPoint          = @PBIStoryPoint,
        PBIStartDate           = @PBIStartDate,
        PBIDueDate             = @PBIDueDate,
        PBIPriority            = @PBIPriority,
        PBIStatus              = @PBIStatus,
        PBIModificationDate    = GETDATE(),
        PBIModificatorId       = @PBIModificatorId
    WHERE PBIId = @PBIId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_ProductBacklogItems_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT PBIId,
           PBISummary,
           PBIDescription,
           PBIsAcceptanceCriteria,
           PBIOwner,
           PBIParentLink,
           PBIStoryPoint,
           PBIStartDate,
           PBIDueDate,
           PBIPriority,
           PBIStatus,
           PBICreationDate,
           PBICreatorId,
           PBIModificationDate,
           PBIModificatorId
    FROM [SQM_GENERAL].[TBL_ProductBacklogItems]
    ORDER BY PBIId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
