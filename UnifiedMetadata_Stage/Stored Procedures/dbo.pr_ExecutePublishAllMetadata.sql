SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[pr_ExecutePublishAllMetadata] 
@ProjectID INT, 
@PublishQueueID INT, 
@ServerName VARCHAR(50)
AS
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines dbo.pr_ExecutePublishAllMetadata stored procedure
___________________________________________________________________________________________________
Example: EXEC dbo.pr_ExecutePublishAllMetadata 0,0,NULL 'DEVNCDRTRDB1'
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-11-02		zbachore		UMDT-4692
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@Msg VARCHAR(MAX) = '';

BEGIN TRY
BEGIN TRAN;

IF @ServerName IN (
 'DEVNCDRTRNDB1'
,'DEVNCDRTRNDB'
,'DEVNCDRTRNDB'
,'STGNCDRTRNDB1'
,'STGNCDRTRNDB'
,'STGNCDRTRNDB'
,'RLSNCDRTRNDB1'
,'RLSNCDRTRNDB'
,'RLSNCDRTRNDB'
,'PRDNCDRTRNDB1'
,'PRDNCDRTRNDB2'
,'RDPRDNCDRTRNDB1'
,'PRDNCDRTRNDB'
,'PRDNCDRTRNDB'
--EDW Servers:
,'DEVNCDREDWDB1'
,'DEVNCDREDWDB'
,'DEVNCDREDWDB'
,'STGNCDREDWDB1'
,'STGNCDREDWDB'
,'STGNCDRICDDB1\EDW'
,'STGNCDRICDDB1\EDW,2433'
,'STGNCDREDWDB'
,'RLSNCDREDWDB1'
,'RLSNCDREDWDB'
,'RLSNCDREDWDB'
,'PRDNCDREDWDB1'
,'PRDNCDREDWDB2'
,'RDPRDNCDREDWDB1'
,'PRDNCDREDWDB'
,'PRDNCDREDWDB')

BEGIN 
PRINT 'Publishing to the ' + @ServerName + ' server!'
	EXEC dbo.pr_PublishAllMetadata @ProjectID, @PublishQueueID
	SELECT ServerName = @ServerName, Msg = @Msg
END

COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = 'dbo.pr_ExecutePublishAllMetadata:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END


GO
