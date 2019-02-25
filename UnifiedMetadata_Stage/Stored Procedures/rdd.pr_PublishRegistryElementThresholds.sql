SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistryElementThresholds] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistryElementThresholds stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryElementThresholds 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns ret.CreatedDate,ret.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryElementThresholds',
		@ColumnName VARCHAR(MAX) = 'RegistryElementThresholdId',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;

BEGIN TRY
BEGIN TRAN;

SELECT @RegistryVersionID = RegistryVersionID 
FROM dbo.Project WHERE ProjectId = @ProjectID;

WITH Source AS (
SELECT DISTINCT ret.RegistryElementThresholdId,
				ret.RegistryElementId,
				ret.Threshold,
				ret.CompositeId,
				ret.StartDate,
				ret.EndDate,
				ret.RegistryVersionId,
				ret.UpdatedBy,
				ret.FormSectionId,
				ret.FormPageId
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.RegistryVersionId = p.RegistryVersionId 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElementThresholds ret 
ON ret.RegistryElementId = re.RegistryElementId
WHERE p.ProjectId = @ProjectID
)	
MERGE INTO UnifiedMetadata.rdd.RegistryElementThresholds  AS T
USING Source AS S
ON S.RegistryElementThresholdId = T.RegistryElementThresholdId

WHEN NOT MATCHED BY SOURCE
AND T.RegistryElementThresholdId in (
SELECT ret.RegistryElementThresholdId
FROM UnifiedMetadata.rdd.RegistryElements re 
INNER JOIN UnifiedMetadata.rdd.RegistryElementThresholds ret 
ON ret.RegistryElementId = re.RegistryElementId
WHERE re.RegistryVersionId = @RegistryVersionID
)
THEN DELETE

WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistryElementId, 
S.Threshold, 
S.CompositeId, 
S.StartDate, 
S.EndDate, 
S.RegistryVersionId, 
S.UpdatedBy, 
S.FormSectionId, 
S.FormPageId 
INTERSECT
SELECT		
T.RegistryElementId, 
T.Threshold, 
T.CompositeId, 
T.StartDate, 
T.EndDate, 
T.RegistryVersionId, 
T.UpdatedBy, 
T.FormSectionId, 
T.FormPageId)
THEN UPDATE SET 
RegistryElementId		=	S.RegistryElementId, 
Threshold				=	S.Threshold, 
CompositeId				=	S.CompositeId, 
StartDate				=	S.StartDate, 
EndDate					=	S.EndDate, 
RegistryVersionId		=	S.RegistryVersionId, 
UpdatedBy			    =	S.UpdatedBy, 
FormSectionId		    =	S.FormSectionId, 
FormPageId				=	S.FormPageId ,
UpdatedDate			    = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistryElementThresholdId, 
RegistryElementId, 
Threshold, 
CompositeId, 
StartDate, 
EndDate, 
RegistryVersionId, 
UpdatedBy, 
FormSectionId, 
FormPageId
) VALUES (
RegistryElementThresholdId, 
RegistryElementId, 
Threshold, 
CompositeId, 
StartDate, 
EndDate, 
RegistryVersionId, 
UpdatedBy, 
FormSectionId, 
FormPageId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryElementThresholdId,deleted.RegistryElementThresholdId), 
	CASE WHEN deleted.RegistryElementThresholdId IS NULL 
	AND Inserted.RegistryElementThresholdId IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.RegistryElementThresholdId IS NOT NULL 
	AND Inserted.RegistryElementThresholdId IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.RegistryElementThresholdId IS NOT NULL 
	AND Inserted.RegistryElementThresholdId IS NULL 
	THEN 'Deleted'
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistryElementThresholds:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
