SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[pr_UpdateRegistryStartEndTime]
AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-25
Description:	
___________________________________________________________________________________________________
Example: Exec dbo.pr_UpdateRegistryStartEndTime
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
--Variables:
DECLARE @ErrorMessage varchar(max) = ' '

BEGIN TRY


IF @@SERVERNAME = 'STGNCDRTRNDB1'
BEGIN
UPDATE UnifiedMetadata.rdd.RegistryVersions
SET StartDate = '2017-01-01',
UpdatedBy = SUSER_NAME(),
UpdatedDate = SYSDATETIME()
WHERE RegistryVersionId = 6;

UPDATE UnifiedMetadata.rdd.RegistryVersions
SET EndDate = '2016-12-31',
UpdatedBy = SUSER_NAME(),
UpdatedDate = SYSDATETIME()
WHERE RegistryVersionId = 17


UPDATE UnifiedMetadata.rdd.RegistryVersions 
SET StartDate = '2018-01-01 00:00:00.000',
UpdatedBy = SUSER_NAME(),
UpdatedDate = SYSDATETIME()
WHERE RegistryVersionID = 5

END

END TRY
BEGIN CATCH
	set @ErrorMessage =  'An error occurred in stored procedure dbo.pr_UpdateRegistryStartEndTime: '+error_message();
	THROW 50000,@ErrorMessage, 1 ;
	RETURN -1;
END CATCH
END
GO
