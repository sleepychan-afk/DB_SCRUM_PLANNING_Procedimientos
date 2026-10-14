
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Features_Insert]
    @featureSummary              VARCHAR(500),
    @featureDescription          VARCHAR(2000),
    @featuresAcceptanceCriteria  VARCHAR(4000),
    @featureParentLink           INT,
    @featureOwner                INT,
    @featureStatus               INT,
    @featureCreatorId            INT,
    @featureStartDate            DATE = NULL,
    @featureDueDate              DATE = NULL,
    @featurePriority             INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_GENERAL].[TBL_Features]
        (featureSummary, featureDescription, featuresAcceptanceCriteria, featureParentLink, featureOwner, featureStartDate, featureDueDate, featurePriority, featureStatus, featureCreationDate, featureCreatorId)
    VALUES
        (@featureSummary, @featureDescription, @featuresAcceptanceCriteria, @featureParentLink, @featureOwner, @featureStartDate, @featureDueDate, @featurePriority, @featureStatus, GETDATE(), @featureCreatorId);

    SELECT SCOPE_IDENTITY() AS featureId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Features_Update]
    @featureId                   INT,
    @featureSummary              VARCHAR(500),
    @featureDescription          VARCHAR(2000),
    @featuresAcceptanceCriteria  VARCHAR(4000),
    @featureParentLink           INT,
    @featureOwner                INT,
    @featureStatus               INT,
    @featureModificatorId        INT,
    @featureStartDate            DATE = NULL,
    @featureDueDate              DATE = NULL,
    @featurePriority             INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_GENERAL].[TBL_Features]
    SET featureSummary             = @featureSummary,
        featureDescription         = @featureDescription,
        featuresAcceptanceCriteria = @featuresAcceptanceCriteria,
        featureParentLink          = @featureParentLink,
        featureOwner               = @featureOwner,
        featureStartDate           = @featureStartDate,
        featureDueDate             = @featureDueDate,
        featurePriority            = @featurePriority,
        featureStatus              = @featureStatus,
        featureModificationDate    = GETDATE(),
        featureModificatorId       = @featureModificatorId
    WHERE featureId = @featureId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Features_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT featureId,
           featureSummary,
           featureDescription,
           featuresAcceptanceCriteria,
           featureParentLink,
           featureOwner,
           featureStartDate,
           featureDueDate,
           featurePriority,
           featureStatus,
           featureCreationDate,
           featureCreatorId,
           featureModificationDate,
           featureModificatorId
    FROM [SQM_GENERAL].[TBL_Features]
    ORDER BY featureId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
