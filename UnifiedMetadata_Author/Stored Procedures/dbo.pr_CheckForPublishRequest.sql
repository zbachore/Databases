SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[pr_CheckForPublishRequest]  AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-05-30
Description:	Defines cdd.pr_CheckForPublishRequest stored procedure
___________________________________________________________________________________________________
Example: EXEC dbo.pr_CheckForPublishRequest 
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-05-30		zbachore		This code used to be embeded in SSIS package.
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max)

BEGIN TRY
BEGIN TRAN;

DECLARE @ProjectID INT,
		@PublishQueueID INT,
		@ServerName VARCHAR(50),
		@PublishStatusID INT,
		@RequestedTime DATETIME,
		@PublishType VARCHAR(50),
		@RegistryVersionID INT, 
		@ValueSetID INT,
		@ServerType VARCHAR(100)

SELECT 
	@PublishQueueID = q.PublishQueueID,
	@ProjectID = q.ProjectID,
	@ServerName = 	CASE 
	 WHEN q.ServerName =	'DEVNCDRTRNDB' THEN 'DEVNCDRTRNDB1'
	 WHEN q.ServerName =	'STGNCDRTRNDB'  THEN 'STGNCDRTRNDB1'
	 WHEN q.ServerName =	'DEVNCDREDWDB'  THEN 'DEVNCDREDWDB1'
	 WHEN q.ServerName =	'STGNCDREDWDB' THEN 'STGNCDREDWDB1'
	 WHEN q.ServerName =	'RLSNCDRTRNDB' THEN 'RLSNCDRTRNDB1'
	 WHEN q.ServerName =	'RLSNCDREDWDB' THEN 'RLSNCDREDWDB1'
	 ELSE q.ServerName END,
	@PublishStatusID = q.PublishStatusID,
	@RequestedTime = q.RequestedTime,
	@PublishType = q.PublishType,
	@RegistryVersionID = CASE WHEN q.RegistryVersionID IS NOT NULL 
							THEN q.RegistryVersionID 
							ELSE (SELECT RegistryVersionId
							FROM dbo.Project 
							WHERE ProjectID = @ProjectID) END,
	@ValueSetID = q.ValueSetID,
	@ServerType = st.ServerType
FROM dbo.PublishQueue q 
INNER JOIN dbo.servers s ON s.ServerName = CASE 
	 WHEN q.ServerName =	'DEVNCDRTRNDB' THEN 'DEVNCDRTRNDB1'
	 WHEN q.ServerName =	'STGNCDRTRNDB'  THEN 'STGNCDRTRNDB1'
	 WHEN q.ServerName =	'DEVNCDREDWDB'	THEN 'DEVNCDREDWDB1'
	 WHEN q.ServerName =	'STGNCDREDWDB' THEN 'STGNCDREDWDB1'
	 WHEN q.ServerName =	'RLSNCDRTRNDB' THEN 'RLSNCDRTRNDB1'
	 WHEN q.ServerName =	'RLSNCDREDWDB' THEN 'RLSNCDREDWDB1'
	 ELSE q.ServerName END
    INNER JOIN dbo.ServerType st
        ON s.ServerTypeID = st.ServerTypeID
    INNER JOIN dbo.ServerEnvironment se
        ON s.ServerEnvironmentID = se.ServerEnvironmentID
WHERE PublishStatusID = 1
 
 

SELECT 
	PublishQueueID =ISNULL(@PublishQueueID, 0),
	ProjectID = ISNULL(@ProjectID,0), 
	ServerName = @ServerName,	
	ISNULL(@ServerName,0),
	PublishStatusID=ISNULL(@PublishStatusID,0),
	RequestedTime = ISNULL(@RequestedTime,'9999-12-31 00:00:00.000'),
	PublishType = @PublishType,
	RegistryVersionID = @RegistryVersionID,
	ValueSetID = @ValueSetID,
	ServerType = @ServerType
COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = 'dbo.pr_CheckForPublishRequest:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
