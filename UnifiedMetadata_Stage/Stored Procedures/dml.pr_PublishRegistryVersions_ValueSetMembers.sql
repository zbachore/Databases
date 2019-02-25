SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishRegistryVersions_ValueSetMembers] 
	@PublishQueueID int, 
	@ValueSetID INT,
	@RegistryVersionID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-12
Description:	Defines dml.pr_PublishRegistryVersions_ValueSetMembers stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishRegistryVersions_ValueSetMembers 1,244,3
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change 
2019-02-08		zbachore		Modified the delete logic.
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryVersions_ValueSetMembers',
		@ColumnName VARCHAR(MAX) = 'RegistryVersionValueSetMemberId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;
WITH Source AS (
SELECT DISTINCT rvvsm.ValueSetMemberId,
                rvvsm.RegistryVersionId,
                rvvsm.UpdatedBy,
                rvvsm.RegistryVersionValueSetMemberId,
                rvvsm.Label,
                rvvsm.ConceptDefinitionId,
				rvvsm.DisplayOrder
FROM cdd.ValueSetMembers vsm
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
)
	
MERGE INTO UnifiedMetadata.rdd.RegistryVersions_ValueSetMembers WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryVersionValueSetMemberId = T.RegistryVersionValueSetMemberId

WHEN NOT MATCHED BY SOURCE
AND T.RegistryVersionValueSetMemberId IN
(
SELECT DISTINCT
                rvvsm.RegistryVersionValueSetMemberId
FROM UnifiedMetadata.cdd.ValueSetMembers vsm
INNER JOIN UnifiedMetadata.rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
)
THEN DELETE

WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ValueSetMemberId, 
S.RegistryVersionId, 
S.UpdatedBy, 
S.Label, 
S.ConceptDefinitionId,
S.DisplayOrder
INTERSECT
SELECT		
T.ValueSetMemberId, 
T.RegistryVersionId, 
T.UpdatedBy, 
T.Label, 
T.ConceptDefinitionId,
T.DisplayOrder)
THEN UPDATE SET 
ValueSetMemberId			=	S.ValueSetMemberId, 
RegistryVersionId			=	S.RegistryVersionId, 
UpdatedBy					=	S.UpdatedBy, 
Label						=	S.Label, 
ConceptDefinitionId			=	S.ConceptDefinitionId ,
DisplayOrder				=	S.DisplayOrder,
UpdatedDate					=	DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ValueSetMemberId, 
RegistryVersionId, 
UpdatedBy, 
RegistryVersionValueSetMemberId, 
Label, 
ConceptDefinitionId,
DisplayOrder
) VALUES (
ValueSetMemberId, 
RegistryVersionId, 
UpdatedBy, 
RegistryVersionValueSetMemberId, 
Label, 
ConceptDefinitionId,
DisplayOrder)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryVersionValueSetMemberId,deleted.RegistryVersionValueSetMemberId), 
	CASE WHEN deleted.RegistryVersionValueSetMemberId IS NULL 
	AND Inserted.RegistryVersionValueSetMemberId IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.RegistryVersionValueSetMemberId IS NOT NULL 
	AND Inserted.RegistryVersionValueSetMemberId IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.RegistryVersionValueSetMemberId IS NOT NULL 
	AND Inserted.RegistryVersionValueSetMemberId IS NULL 
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
    SET @ErrorMessage = 'dml.pr_PublishRegistryVersions_ValueSetMembers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
