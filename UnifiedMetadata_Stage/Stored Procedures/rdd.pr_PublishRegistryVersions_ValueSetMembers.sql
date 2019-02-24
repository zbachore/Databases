SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistryVersions_ValueSetMembers] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistryVersions_ValueSetMembers stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryVersions_ValueSetMembers 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-02-08		zbachore		Modified the delete logic
------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryVersions_ValueSetMembers',
		@ColumnName VARCHAR(MAX) = 'RegistryVersionValueSetMemberId',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;

BEGIN TRY
BEGIN TRAN;

SELECT @RegistryVersionID = RegistryVersionID 
FROM dbo.Project WHERE ProjectID = @ProjectID;

WITH Source AS (
SELECT DISTINCT rvvsm.ValueSetMemberId,
                rvvsm.RegistryVersionId,
                rvvsm.UpdatedBy,
                rvvsm.RegistryVersionValueSetMemberId,
                rvvsm.Label,
                rvvsm.ConceptDefinitionId,
				rvvsm.DisplayOrder
FROM UnifiedMetadata_Stage.dbo.Project p 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.RegistryVersionId = p.RegistryVersionId
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetMembers vsm
ON vsm.ValueSetMemberId = rvvsm.ValueSetMemberId
WHERE p.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.rdd.RegistryVersions_ValueSetMembers WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryVersionValueSetMemberId = T.RegistryVersionValueSetMemberId

WHEN NOT MATCHED BY SOURCE
AND T.RegistryVersionValueSetMemberId IN
(
SELECT DISTINCT
                rvvsm.RegistryVersionValueSetMemberId
FROM UnifiedMetadata.rdd.RegistryVersions_ValueSetMembers rvvsm
INNER JOIN UnifiedMetadata.cdd.ValueSetMembers vsm
ON vsm.ValueSetMemberId = rvvsm.ValueSetMemberId
WHERE rvvsm.RegistryVersionId = @RegistryVersionID
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistryVersions_ValueSetMembers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
