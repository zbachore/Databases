SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishValueSetConceptMembers] @PublishQueueID INT, @ValueSetID INT, @RegistryVersionID INT AS  
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-18
Description:	Defines dml.pr_PublishValueSetConceptMembers stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishValueSetConceptMembers 3,3
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ValueSetConceptMembers',
		@ColumnName VARCHAR(MAX) = 'ValueSetMemberId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT vscm.ValueSetMemberId,
                vscm.ConceptId
FROM  UnifiedMetadata_Stage.cdd.ValueSetMembers vsm 
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetConceptMembers vscm 
ON vscm.ValueSetMemberId = vsm.ValueSetMemberId 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersions_ValueSetMembers rvvsm 
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = vscm.ConceptId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
)
	
MERGE INTO UnifiedMetadata.cdd.ValueSetConceptMembers WITH(TABLOCK) AS T
USING Source AS S
ON S.ValueSetMemberId = T.ValueSetMemberId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ConceptId 

INTERSECT

SELECT
 
		
T.ConceptId)


THEN UPDATE SET 
ConceptId			=	S.ConceptId ,
UpdatedDate			=	DEFAULT

WHEN NOT MATCHED BY SOURCE
AND T.ValueSetMemberId IN 
(
SELECT ValueSetMemberId 
FROM UnifiedMetadata.cdd.ValueSetConceptMembers 
WHERE ValueSetMemberID NOT IN (SELECT ValueSetMemberID 
FROM UnifiedMetadata_Stage.cdd.ValueSetConceptMembers)
)
THEN DELETE


WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ValueSetMemberId, 
ConceptId
) VALUES (
ValueSetMemberId, 
ConceptId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(deleted.ValueSetMemberId, inserted.ValueSetMemberId), 
	CASE WHEN deleted.ValueSetMemberId IS NULL 
	AND Inserted.ValueSetMemberId IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.ValueSetMemberId IS NOT NULL 
	AND Inserted.ValueSetMemberId IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.ValueSetMemberId IS NOT NULL 
	AND inserted.ValueSetMemberId IS NULL 
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
    SET @ErrorMessage = 'dml.pr_PublishValueSetConceptMembers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
