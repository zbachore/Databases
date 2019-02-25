SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishValueSetConceptMembers] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines cdd.pr_PublishValueSetConceptMembers stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishValueSetConceptMembers 6,1
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
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pc 
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetMembers vsm 
ON vsm.ValueSetMemberId = pc.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetConceptMembers vscm ON vscm.ValueSetMemberId = pc.ReferenceID
WHERE pc.ProjectId = @ProjectID
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
ConceptId						=	S.ConceptId ,
UpdatedDate			= DEFAULT

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
	ISNULL(inserted.ValueSetMemberId, deleted.ValueSetMemberID), 
	CASE WHEN deleted.ValueSetMemberId IS NULL 
	AND Inserted.ValueSetMemberId IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.ValueSetMemberId IS NOT NULL 
	AND Inserted.ValueSetMemberId IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.ValueSetMemberId IS NOT NULL 
	AND Inserted.ValueSetMemberId IS NULL 
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
    SET @ErrorMessage = 'cdd.pr_PublishValueSetConceptMembers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
