SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistryVersionComposites] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistryVersionComposites stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryVersionComposites 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryVersionComposites',
		@ColumnName VARCHAR(MAX) = 'RegistryVersionCompositeId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT rvc.RegistryVersionCompositeId,
                rvc.CompositeId,
                rvc.RegistryVersionId,
                rvc.Threshold,
                rvc.StartDate,
                rvc.EndDate,
                rvc.UpdatedBy,
                rvc.CreatedDate,
                rvc.UpdatedDate 
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersionComposites rvc 
ON rvc.RegistryVersionId = p.RegistryVersionId
WHERE p.ProjectId = @ProjectID
)	
MERGE INTO UnifiedMetadata.rdd.RegistryVersionComposites WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryVersionCompositeId = T.RegistryVersionCompositeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CompositeId, 
S.RegistryVersionId, 
S.Threshold, 
S.StartDate, 
S.EndDate, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.CompositeId, 
T.RegistryVersionId, 
T.Threshold, 
T.StartDate, 
T.EndDate, 
T.UpdatedBy)


THEN UPDATE SET 
CompositeId						=	S.CompositeId, 
RegistryVersionId						=	S.RegistryVersionId, 
Threshold						=	S.Threshold, 
StartDate						=	S.StartDate, 
EndDate						=	S.EndDate, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistryVersionCompositeId, 
CompositeId, 
RegistryVersionId, 
Threshold, 
StartDate, 
EndDate, 
UpdatedBy
) VALUES (
RegistryVersionCompositeId, 
CompositeId, 
RegistryVersionId, 
Threshold, 
StartDate, 
EndDate, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryVersionCompositeId,deleted.RegistryVersionCompositeId), 
	CASE WHEN deleted.RegistryVersionCompositeId IS NULL AND Inserted.RegistryVersionCompositeId IS NOT NULL THEN 'Inserted'
	WHEN deleted.RegistryVersionCompositeId IS NOT NULL AND Inserted.RegistryVersionCompositeId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistryVersionComposites:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
