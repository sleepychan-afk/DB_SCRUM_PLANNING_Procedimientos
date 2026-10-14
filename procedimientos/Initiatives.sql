
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Initiatives_Insert]
    @initiativeSummary        VARCHAR(200),
    @initiativeDescription    VARCHAR(2000),
    @initiativeOwner          INT,
    @initiativeBusinessValue  INT,
    @initiativeStatus         INT,
    @initiativeCreatorId      INT,
    @initiativeGoals          VARCHAR(255) = NULL,
    @initiativeTargetStart    DATE = NULL,
    @initiativeTargetEnd      DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_GENERAL].[TBL_Initiatives]
        (initiativeSummary, initiativeDescription, initiativeOwner, initiativeGoals, initiativeBusinessValue, initiativeTargetStart, initiativeTargetEnd, initiativeStatus, initiativeCreationDate, initiativeCreatorId)
    VALUES
        (@initiativeSummary, @initiativeDescription, @initiativeOwner, @initiativeGoals, @initiativeBusinessValue, @initiativeTargetStart, @initiativeTargetEnd, @initiativeStatus, GETDATE(), @initiativeCreatorId);

    SELECT SCOPE_IDENTITY() AS initiativeId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Initiatives_Update]
    @initiativeId             INT,
    @initiativeSummary        VARCHAR(200),
    @initiativeDescription    VARCHAR(2000),
    @initiativeOwner          INT,
    @initiativeBusinessValue  INT,
    @initiativeStatus         INT,
    @initiativeModificatorId  INT,
    @initiativeGoals          VARCHAR(255) = NULL,
    @initiativeTargetStart    DATE = NULL,
    @initiativeTargetEnd      DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_GENERAL].[TBL_Initiatives]
    SET initiativeSummary          = @initiativeSummary,
        initiativeDescription      = @initiativeDescription,
        initiativeOwner            = @initiativeOwner,
        initiativeGoals            = @initiativeGoals,
        initiativeBusinessValue    = @initiativeBusinessValue,
        initiativeTargetStart      = @initiativeTargetStart,
        initiativeTargetEnd        = @initiativeTargetEnd,
        initiativeStatus           = @initiativeStatus,
        initiativeModificationDate = GETDATE(),
        initiativeModificatorId    = @initiativeModificatorId
    WHERE initiativeId = @initiativeId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Initiatives_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT initiativeId,
           initiativeSummary,
           initiativeDescription,
           initiativeOwner,
           initiativeGoals,
           initiativeBusinessValue,
           initiativeTargetStart,
           initiativeTargetEnd,
           initiativeStatus,
           initiativeCreationDate,
           initiativeCreatorId,
           initiativeModificationDate,
           initiativeModificatorId
    FROM [SQM_GENERAL].[TBL_Initiatives]
    ORDER BY initiativeId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
