SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistryVersionConfigurations] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistryVersionConfigurations stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryVersionConfigurations 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns rvc.CreatedDate,rvc.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryVersionConfigurations',
		@ColumnName VARCHAR(MAX) = 'RegistryVersionConfigurationId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT rvc.RegistryVersionConfigurationId,
				rvc.RegistryVersionConfigurationName,
				rvc.RegistryVersionConfigurationValue,
				rvc.RegistryVersionId,
				rvc.UpdatedBy			
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersionConfigurations rvc 
ON rvc.RegistryVersionId = p.RegistryVersionId
WHERE p.ProjectId = @ProjectID
)	
MERGE INTO UnifiedMetadata.rdd.RegistryVersionConfigurations WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryVersionConfigurationId = T.RegistryVersionConfigurationId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistryVersionConfigurationName, 
S.RegistryVersionConfigurationValue, 
S.RegistryVersionId, 
S.UpdatedBy
INTERSECT
SELECT		
T.RegistryVersionConfigurationName, 
T.RegistryVersionConfigurationValue, 
T.RegistryVersionId, 
T.UpdatedBy)
THEN UPDATE SET 
RegistryVersionConfigurationName		=	S.RegistryVersionConfigurationName, 
RegistryVersionConfigurationValue		=	S.RegistryVersionConfigurationValue, 
RegistryVersionId						=	S.RegistryVersionId, 
UpdatedBy						        =	S.UpdatedBy ,
UpdatedDate			                    = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistryVersionConfigurationId, 
RegistryVersionConfigurationName, 
RegistryVersionConfigurationValue, 
RegistryVersionId, 
UpdatedBy
) VALUES (
RegistryVersionConfigurationId, 
RegistryVersionConfigurationName, 
RegistryVersionConfigurationValue, 
RegistryVersionId, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryVersionConfigurationId,deleted.RegistryVersionConfigurationId), 
	CASE WHEN deleted.RegistryVersionConfigurationId IS NULL AND Inserted.RegistryVersionConfigurationId IS NOT NULL THEN 'Inserted'
	WHEN deleted.RegistryVersionConfigurationId IS NOT NULL AND Inserted.RegistryVersionConfigurationId IS NOT NULL THEN 'Updated'
	ELSE NULL END,
	'Publish',
	@RequestedTime, 
	SYSDATETIME()
INTO dbo.PublishLog;
COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = 'rdd.pr_PublishRegistryVersionConfigurations:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
