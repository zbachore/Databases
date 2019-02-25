SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistryElementThresholdRelatedElements] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistryElementThresholdRelatedElements stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryElementThresholdRelatedElements 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns retre.CreatedDate,retre.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryElementThresholdRelatedElements',
		@ColumnName VARCHAR(MAX) = 'RegistryElementThresholdRelatedElementId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT retre.RegistryElementThresholdRelatedElementId,
				retre.RegistryElementThresholdId,
				retre.RegistryElementId,
				retre.UpdatedBy
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.RegistryVersionId = p.RegistryVersionId 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElementThresholdRelatedElements retre 
ON retre.RegistryElementId = re.RegistryElementId
WHERE p.ProjectId = @ProjectID
)
MERGE INTO UnifiedMetadata.rdd.RegistryElementThresholdRelatedElements WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryElementThresholdRelatedElementId = T.RegistryElementThresholdRelatedElementId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistryElementThresholdId, 
S.RegistryElementId, 
S.UpdatedBy 
INTERSECT
SELECT		
T.RegistryElementThresholdId, 
T.RegistryElementId, 
T.UpdatedBy)
THEN UPDATE SET 
RegistryElementThresholdId	=	S.RegistryElementThresholdId, 
RegistryElementId			=	S.RegistryElementId, 
UpdatedBy					=	S.UpdatedBy ,
UpdatedDate			        = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistryElementThresholdRelatedElementId, 
RegistryElementThresholdId, 
RegistryElementId, 
UpdatedBy
) VALUES (
RegistryElementThresholdRelatedElementId, 
RegistryElementThresholdId, 
RegistryElementId, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryElementThresholdRelatedElementId,deleted.RegistryElementThresholdRelatedElementId), 
	CASE WHEN deleted.RegistryElementThresholdRelatedElementId IS NULL AND Inserted.RegistryElementThresholdRelatedElementId IS NOT NULL THEN 'Inserted'
	WHEN deleted.RegistryElementThresholdRelatedElementId IS NOT NULL AND Inserted.RegistryElementThresholdRelatedElementId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistryElementThresholdRelatedElements:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
