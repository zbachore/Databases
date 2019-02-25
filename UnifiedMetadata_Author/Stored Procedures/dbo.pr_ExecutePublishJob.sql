SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[pr_ExecutePublishJob]
AS
BEGIN
/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			UMDT-4942
Developer:		zbachore
Date:			2018-11-28
Description:	This procedure checkes the dbo.PublishQueue table and executes the specific 
				job for which the queue is submitted. Instead of having all the publish jobs
				run on schedule, we only execute a job if there is a queue
___________________________________________________________________________________________________
Example: 
EXEC dbo.pr_ExecutePublishJob 
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-12-12		zbachore		Removed the following comment because the jobs exist now:
								--The Production Publish Jobs currently do not exist. They need to be created.
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max) = 'An error occurred in procedure: ',
		@Procedure VARCHAR(MAX) =   OBJECT_NAME(@@PROCID),
		@ServerName VARCHAR(50)

BEGIN TRY
BEGIN TRAN;

SELECT @ServerName = ServerName FROM dbo.PublishQueue 
WHERE PublishStatusID = 1

IF @ServerName LIKE '%DEVNCDRTRNDB%'
BEGIN
EXEC MSDB.dbo.sp_start_job N'PublishMetadata_DEVNCDRTRNDB';  
END

ELSE IF @ServerName LIKE '%DEVNCDREDWDB%'
BEGIN
EXEC MSDB.dbo.sp_start_job N'PublishMetadata_DEVNCDREDWDB';  
END

ELSE IF @ServerName LIKE '%RLSNCDREDWDB%'
BEGIN
EXEC MSDB.dbo.sp_start_job N'PublishMetadata_RLSNCDREDWDB';  
END

ELSE IF @ServerName LIKE '%RLSNCDRTRNDB%'
BEGIN
EXEC MSDB.dbo.sp_start_job N'PublishMetadata_RLSNCDRTRNDB';  
END

ELSE IF @ServerName LIKE '%STGNCDREDWDB%'
BEGIN
EXEC MSDB.dbo.sp_start_job N'PublishMetadata_STGNCDREDWDB';  
END

ELSE IF @ServerName LIKE '%STGNCDRICDDB1\EDW%'
BEGIN
EXEC MSDB.dbo.sp_start_job N'PublishMetadata_STGNCDRICDDB1\EDW';  
END

ELSE IF @ServerName LIKE '%STGNCDRTRNDB%'
BEGIN
EXEC MSDB.dbo.sp_start_job N'PublishMetadata_STGNCDRTRNDB';  
END

--Production Servers:
ELSE IF @ServerName LIKE '%PRDNCDRTRNDB%'
BEGIN
EXEC MSDB.dbo.sp_start_job N'PublishMetadata_PRDNCDRTRNDB';  
END

ELSE IF @ServerName LIKE '%PRDNCDREDWDB%'
BEGIN
EXEC MSDB.dbo.sp_start_job N'PublishMetadata_PRDNCDREDWDB';  
END

COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = @ErrorMessage + @Procedure + ':' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
