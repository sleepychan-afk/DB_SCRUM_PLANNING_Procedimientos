
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_TaskComments_Insert]
    @taskCommentParentLink  INT,
    @taskCommentOwner       INT,
    @taskCommentText        NVARCHAR(4000),
    @taskCommentCreatorId   INT,
    @taskCommentStatus      BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_GENERAL].[TBL_TaskComments]
        (taskCommentParentLink, taskCommentOwner, taskCommentText, taskCommentStatus, taskCommentCreationDate, taskCommentCreatorId)
    VALUES
        (@taskCommentParentLink, @taskCommentOwner, @taskCommentText, @taskCommentStatus, GETDATE(), @taskCommentCreatorId);

    SELECT SCOPE_IDENTITY() AS taskCommentId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_TaskComments_Update]
    @taskCommentId             INT,
    @taskCommentParentLink     INT,
    @taskCommentOwner          INT,
    @taskCommentText           NVARCHAR(4000),
    @taskCommentStatus         BIT,
    @taskCommentModificatorId  INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_GENERAL].[TBL_TaskComments]
    SET taskCommentParentLink       = @taskCommentParentLink,
        taskCommentOwner            = @taskCommentOwner,
        taskCommentText             = @taskCommentText,
        taskCommentStatus           = @taskCommentStatus,
        taskCommentModificationDate = GETDATE(),
        taskCommentModificatorId    = @taskCommentModificatorId
    WHERE taskCommentId = @taskCommentId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_TaskComments_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT taskCommentId,
           taskCommentParentLink,
           taskCommentOwner,
           taskCommentText,
           taskCommentStatus,
           taskCommentCreationDate,
           taskCommentCreatorId,
           taskCommentModificationDate,
           taskCommentModificatorId
    FROM [SQM_GENERAL].[TBL_TaskComments]
    ORDER BY taskCommentId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
