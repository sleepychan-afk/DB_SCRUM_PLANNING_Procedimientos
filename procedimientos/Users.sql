
USE [DB_SCRUM_PLANNING]
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Users_Insert]
    @userFullName   VARCHAR(80),
    @userName       VARCHAR(80),
    @userEmail      VARCHAR(80),
    @userPassword   VARCHAR(100),
    @userRolId      INT,
    @userCreatorId  INT,
    @userEnable     BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [SQM_SECURITY].[TBL_Users]
        (userFullName, userName, userEmail, userPassword, userRolId, userEnable, userCreationDate, userCreatorId, userModificationDate)
    VALUES
        (@userFullName, @userName, @userEmail, HASHBYTES('SHA2_256', @userPassword), @userRolId, @userEnable, GETDATE(), @userCreatorId, GETDATE());

    SELECT SCOPE_IDENTITY() AS userId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Users_Update]
    @userId             INT,
    @userFullName       VARCHAR(80),
    @userName           VARCHAR(80),
    @userEmail          VARCHAR(80),
    @userRolId          INT,
    @userEnable         BIT,
    @userModificatorId  INT,
    @userPassword       VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [SQM_SECURITY].[TBL_Users]
    SET userFullName         = @userFullName,
        userName             = @userName,
        userEmail            = @userEmail,
        userPassword         = CASE WHEN @userPassword IS NULL THEN userPassword ELSE HASHBYTES('SHA2_256', @userPassword) END,
        userRolId            = @userRolId,
        userEnable           = @userEnable,
        userModificationDate = GETDATE(),
        userModificatorId    = @userModificatorId
    WHERE userId = @userId;
END
GO

CREATE OR ALTER PROCEDURE [SQM_SECURITY].[usp_Users_List]
    @pageNumber INT = 1,
    @pageSize   INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   < 1 SET @pageSize   = 10;

    SELECT userId,
           userFullName,
           userName,
           userEmail,
           userRolId,
           userEnable,
           userCreationDate,
           userCreatorId,
           userModificationDate,
           userModificatorId
    FROM [SQM_SECURITY].[TBL_Users]
    ORDER BY userId
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END
GO
