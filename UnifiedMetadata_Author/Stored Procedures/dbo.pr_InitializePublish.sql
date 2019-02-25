SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[pr_InitializePublish]
@ServerName VARCHAR(50), 
@ProjectID INT, @UserName VARCHAR(50) = NULL,
@PublishType VARCHAR(50) = 'Project' 
AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines dbo.pr_InitializePublish stored procedure
___________________________________________________________________________________________________
Example: EXEC dbo.pr_InitializePublish 3, 1
select * from dbo.PUblishQueue
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-01-09		zbachore		Added code to prevent publishing to production servers
								if the StartDate of the registry is in the future
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@StartDate DATETIME2(3)

BEGIN TRY
BEGIN TRAN;

/********************************************************
This is to stop unintended publishing of a registry
whose StartDate is in the future
********************************************************/
SELECT @StartDate = MAX(rv.StartDate)
FROM dbo.Project p
    INNER JOIN rdd.RegistryVersions rv
        ON rv.RegistryVersionId = p.RegistryVersionId
WHERE p.ProjectId = @ProjectID;

IF EXISTS (
SELECT PublishStatusID
FROM dbo.PublishQueue 
WHERE PublishStatusID = 1
)
BEGIN
SELECT @ErrorMessage = 'A queue has already been set up'; 
THROW 50000,@ErrorMessage,1
END

ELSE IF EXISTS (
SELECT PublishStatusID
FROM dbo.PublishQueue 
WHERE PublishStatusID = 2
)
BEGIN
SELECT @ErrorMessage = 'Another publishing session is in progress!'; 
THROW 50000,@ErrorMessage,1
END

ELSE IF @StartDate > GETDATE()
AND @ServerName IN (
					'PRDNCDRTRNDB1',
					'PRDNCDRTRNDB2',
					'RDPRDNCDRTRNDB1',
					'PRDNCDREDWDB1',
					'PRDNCDREDWDB2',
					'RDPRDNCDREDWDB1',
					'PRDNCDRTRNDB',
					'PRDNCDREDWDB'
					)
BEGIN
SELECT @ErrorMessage = 'Publishing to production server is not allowed for this Registry at this time! 
The StartDate for this registry is ' + CAST(@StartDate AS VARCHAR);
THROW 50000,@ErrorMessage,1
END

ELSE IF @ServerName NOT IN (
					'DEVNCDRTRNDB1',
					'DEVNCDREDWDB1',
					'DEVNCDREDWDB',
					'DEVNCDRTRNDB',
					'STGNCDRTRNDB1',
					'STGNCDRTRNDB',
					'STGNCDREDWDB1', 
					'STGNCDREDWDB',
					'STGNCDRICDDB1\EDW',
					'RLSNCDRTRNDB1',
					'RLSNCDRTRNDB',
					'RLSNCDREDWDB1',
					'RLSNCDREDWDB',
					'PRDNCDRTRNDB1',
					'PRDNCDRTRNDB2',
					'RDPRDNCDRTRNDB1',
					'PRDNCDREDWDB1',
					'PRDNCDREDWDB2',
					'RDPRDNCDREDWDB1',
					'PRDNCDRTRNDB',
					'PRDNCDREDWDB'
					)
BEGIN 
SELECT @ErrorMessage = 'Server does not exist. Please check the spelling or verify that this server exists!';
THROW 50000,@ErrorMessage,1
END

ELSE
BEGIN
INSERT INTO dbo.PublishQueue
(
    ServerName,
    ProjectID,
	PublishType,
	RequestedBy
)
VALUES
(   
    @ServerName,            -- ServerName - varchar(50)
    @ProjectID,
	@PublishType,
	ISNULL(@UserName,SUSER_NAME())            -- ProjectID - int
    )
END

COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = 'dbo.pr_InitializePublish:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END

GO
