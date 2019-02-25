SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishCodeSystems] 
@PublishQueueID INT, @ValueSetID INT, @RegistryVersionID INT AS
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines dml.pr_PublishCodeSystems stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishCodeSystems 1,3,3
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'CodeSystems',
		@ColumnName VARCHAR(MAX) = 'CodeSystemID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    cs.CodeSystemId,
    cs.CodeSystemName,
    cs.CodeSystemOID,
    cs.CodeSystemDescription,
    cs.IsActive,
    cs.UpdatedBy,
    cs.CreatedDate,
    cs.UpdatedDate
FROM  UnifiedMetadata_Stage.cdd.ValueSetMembers vsm 
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetConceptMembers vscm 
ON vscm.ValueSetMemberId = vsm.ValueSetMemberId 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersions_ValueSetMembers rvvsm 
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = vscm.ConceptId
INNER JOIN UnifiedMetadata_Stage.cdd.CodeSystemTerms cst ON cst.CodeSystemTermId = c.CodeSystemTermId
INNER JOIN UnifiedMetadata_Stage.cdd.CodeSystems cs ON cs.CodeSystemId = cst.CodeSystemId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID

UNION 

--This is to take CodeSystems that are not associated with CodeSystemTerms and Concepts
SELECT DISTINCT
    cs.CodeSystemId,
    cs.CodeSystemName,
    cs.CodeSystemOID,
    cs.CodeSystemDescription,
    cs.IsActive,
    cs.UpdatedBy,
    cs.CreatedDate,
    cs.UpdatedDate
FROM UnifiedMetadata_Stage.cdd.ValueSets vs 
INNER JOIN cdd.CodeSystems cs ON cs.CodeSystemId = vs.CodeSystemId
WHERE vs.ValueSetId = @ValueSetID
)

MERGE INTO UnifiedMetadata.cdd.CodeSystems WITH(TABLOCK) AS T
USING Source AS S
ON S.CodeSystemId = T.CodeSystemId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CodeSystemName, 
S.CodeSystemOID, 
S.CodeSystemDescription, 
S.IsActive, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.CodeSystemName, 
T.CodeSystemOID, 
T.CodeSystemDescription, 
T.IsActive, 
T.UpdatedBy)


THEN UPDATE SET 
CodeSystemName						=	S.CodeSystemName, 
CodeSystemOID						=	S.CodeSystemOID, 
CodeSystemDescription						=	S.CodeSystemDescription, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
CodeSystemId, 
CodeSystemName, 
CodeSystemOID, 
CodeSystemDescription, 
IsActive, 
UpdatedBy
) VALUES (
CodeSystemId, 
CodeSystemName, 
CodeSystemOID, 
CodeSystemDescription, 
IsActive, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.CodeSystemID,deleted.CodeSystemID), 
	CASE WHEN deleted.CodeSystemID IS NULL AND Inserted.CodeSystemID IS NOT NULL THEN 'Inserted'
	WHEN deleted.CodeSystemID IS NOT NULL AND Inserted.CodeSystemID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dml.pr_PublishCodeSystems:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
