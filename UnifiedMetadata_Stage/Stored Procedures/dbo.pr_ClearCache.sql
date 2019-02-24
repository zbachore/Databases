SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[pr_ClearCache] @ProjectID INT, @RegistryVersionID INT = NULL
AS
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	This stored procedure clearsthe cache from 
				UnifiedCache.dbo.ApplicationCache.
___________________________________________________________________________________________________
Example: EXEC dbo.pr_ClearCache NULL,4
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@DeleteSQL VARCHAR(MAX)

BEGIN TRY
BEGIN TRAN;

--Add delete from dbo.DQRCache

SELECT @RegistryVersionID = ISNULL(@RegistryVersionID,RegistryVersionId) 
FROM dbo.Project 
WHERE ProjectID = @ProjectID

SELECT @DeleteSQL = 'DELETE FROM UnifiedCache.dbo.ApplicationCache 
WHERE id = ''rvid-' + CAST(@RegistryVersionID AS VARCHAR(MAX))+ ''''

EXEC(@DeleteSQL)

SELECT @DeleteSQL = 'DELETE FROM UnifiedCache.dbo.DctCache 
WHERE id = ''rvid-' + CAST(@RegistryVersionID AS VARCHAR(MAX))+ ''''

EXEC(@DeleteSQL)

SELECT @DeleteSQL = 'DELETE FROM UnifiedCache.dbo.DqrCache 
WHERE id = ''rvid-' + CAST(@RegistryVersionID AS VARCHAR(MAX))+ ''''

EXEC(@DeleteSQL)

COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = 'cdd.pr_ClearCache:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
