
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Tasks_Insert]
    @taskSummary           VARCHAR(500),
    @taskDescription       VARCHAR(2000),
    @taskOwner             INT,
    @taskParentLink        INT,
    @taskStatus            INT,
    @taskCreatorId         INT,
    @taskOriginalEstimate  INT = NULL,
    @taskCompletedWork     INT = NULL,
    @taskRemaningWork      INT = NULL,
    @taskStartDate         DATE = NULL,
    @taskCompletedDate     DATE = NULL,
    @taskDueDate           DATE = NULL,
    @taskActivityType      INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_GENERAL].[TBL_Tasks]
        (taskSummary, taskDescription, taskOwner, taskParentLink, taskOriginalEstimate, taskCompletedWork, taskRemaningWork, taskStartDate, taskCompletedDate, taskDueDate, taskActivityType, taskStatus, taskCreationDate, taskCreatorId)
    VALUES
        (@taskSummary, @taskDescription, @taskOwner, @taskParentLink, @taskOriginalEstimate, @taskCompletedWork, @taskRemaningWork, @taskStartDate, @taskCompletedDate, @taskDueDate, @taskActivityType, @taskStatus, GETDATE(), @taskCreatorId);

    SELECT SCOPE_IDENTITY() AS taskId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Tasks_Update]
    @taskId                INT,
    @taskSummary           VARCHAR(500),
    @taskDescription       VARCHAR(2000),
    @taskOwner             INT,
    @taskParentLink        INT,
    @taskStatus            INT,
    @taskModificatorId     INT,
    @taskOriginalEstimate  INT = NULL,
    @taskCompletedWork     INT = NULL,
    @taskRemaningWork      INT = NULL,
    @taskStartDate         DATE = NULL,
    @taskCompletedDate     DATE = NULL,
    @taskDueDate           DATE = NULL,
    @taskActivityType      INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_GENERAL].[TBL_Tasks]
    SET taskSummary          = @taskSummary,
        taskDescription      = @taskDescription,
        taskOwner            = @taskOwner,
        taskParentLink       = @taskParentLink,
        taskOriginalEstimate = @taskOriginalEstimate,
        taskCompletedWork    = @taskCompletedWork,
        taskRemaningWork     = @taskRemaningWork,
        taskStartDate        = @taskStartDate,
        taskCompletedDate    = @taskCompletedDate,
        taskDueDate          = @taskDueDate,
        taskActivityType     = @taskActivityType,
        taskStatus           = @taskStatus,
        taskModificationDate = GETDATE(),
        taskModificatorId    = @taskModificatorId
    WHERE taskId = @taskId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_GENERAL].[usp_Tasks_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT taskId,
           taskSummary,
           taskDescription,
           taskOwner,
           taskParentLink,
           taskOriginalEstimate,
           taskCompletedWork,
           taskRemaningWork,
           taskStartDate,
           taskCompletedDate,
           taskDueDate,
           taskActivityType,
           taskStatus,
           taskCreationDate,
           taskCreatorId,
           taskModificationDate,
           taskModificatorId
    FROM [SQM_GENERAL].[TBL_Tasks]
    ORDER BY taskId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
