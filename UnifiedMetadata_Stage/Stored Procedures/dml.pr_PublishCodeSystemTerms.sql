SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dml].[pr_PublishCodeSystemTerms] @PublishQueueID INT, @ValueSetID INT, @RegistryVersionID INT AS  
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-30
Description:	Defines dml.pr_PublishCodeSystemTerms stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishCodeSystemTerms 1,3,3
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'CodeSystemTerms',
		@ColumnName VARCHAR(MAX) = 'CodeSystemTermID',
		@RequestedTime DATETIME2 = SYSDATETIME()

BEGIN TRY
BEGIN TRAN;

WITH Source AS (

SELECT Distinct
    cst.CodeSystemTermId,
    cst.CodeSystemId,
    cst.CodeSystemTermCode,
    cst.CodeSystemTermName,
    cst.CodeSystemTermDefinition,
    cst.CodeSystemTermAdditionalNote,
    cst.IsActive,
    cst.UpdatedBy
FROM  UnifiedMetadata_Stage.cdd.ValueSetMembers vsm 
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetConceptMembers vscm 
ON vscm.ValueSetMemberId = vsm.ValueSetMemberId 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersions_ValueSetMembers rvvsm 
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = vscm.ConceptId
INNER JOIN UnifiedMetadata_Stage.cdd.CodeSystemTerms cst ON cst.CodeSystemTermId = c.CodeSystemTermId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
UNION 
SELECT DISTINCT
    cst.CodeSystemTermId,
    cst.CodeSystemId,
    cst.CodeSystemTermCode,
    cst.CodeSystemTermName,
    cst.CodeSystemTermDefinition,
    cst.CodeSystemTermAdditionalNote,
    cst.IsActive,
    cst.UpdatedBy
FROM  UnifiedMetadata_Stage.cdd.ValueSetMembers vsm 
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetConceptMembers vscm 
ON vscm.ValueSetMemberId = vsm.ValueSetMemberId 
INNER JOIN cdd.Concepts c ON c.ConceptId = vscm.ConceptId
INNER JOIN cdd.CodeSystemTerms cst ON cst.CodeSystemTermId = c.CodeSystemTermId
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersions_ValueSetMembers rvvsm 
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
UNION
--the following join is to include concepts (and the CodeSystemTerms) that are referrenced by
--the medications table as foreign keys.
SELECT DISTINCT
    cst.CodeSystemTermId,
    cst.CodeSystemId,
    cst.CodeSystemTermCode,
    cst.CodeSystemTermName,
    cst.CodeSystemTermDefinition,
    cst.CodeSystemTermAdditionalNote,
    cst.IsActive,
    cst.UpdatedBy
FROM cdd.ValueSetMembers vsm 
INNER JOIN cdd.ValueSetMedicationMembers vsmm
ON vsmm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN ld.Medications m
ON m.MedicationId = vsmm.MedicationId
INNER JOIN cdd.Concepts c ON c.ConceptId = m.ConceptId
INNER JOIN cdd.CodeSystemTerms cst ON cst.CodeSystemTermId = c.CodeSystemTermId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID

)
	
MERGE INTO UnifiedMetadata.cdd.CodeSystemTerms WITH(TABLOCK) AS T
USING Source AS S
ON S.CodeSystemTermId = T.CodeSystemTermId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CodeSystemId, 
S.CodeSystemTermCode, 
S.CodeSystemTermName, 
S.CodeSystemTermDefinition, 
S.CodeSystemTermAdditionalNote, 
S.IsActive, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.CodeSystemId, 
T.CodeSystemTermCode, 
T.CodeSystemTermName, 
T.CodeSystemTermDefinition, 
T.CodeSystemTermAdditionalNote, 
T.IsActive, 
T.UpdatedBy)


THEN UPDATE SET 
CodeSystemId						=	S.CodeSystemId, 
CodeSystemTermCode						=	S.CodeSystemTermCode, 
CodeSystemTermName						=	S.CodeSystemTermName, 
CodeSystemTermDefinition						=	S.CodeSystemTermDefinition, 
CodeSystemTermAdditionalNote						=	S.CodeSystemTermAdditionalNote, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
CodeSystemTermId, 
CodeSystemId, 
CodeSystemTermCode, 
CodeSystemTermName, 
CodeSystemTermDefinition, 
CodeSystemTermAdditionalNote, 
IsActive, 
UpdatedBy
) VALUES (
CodeSystemTermId, 
CodeSystemId, 
CodeSystemTermCode, 
CodeSystemTermName, 
CodeSystemTermDefinition, 
CodeSystemTermAdditionalNote, 
IsActive, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.CodeSystemTermID,deleted.CodeSystemTermID), 
	CASE WHEN deleted.CodeSystemTermID IS NULL AND Inserted.CodeSystemTermID IS NOT NULL THEN 'Inserted'
	WHEN deleted.CodeSystemTermID IS NOT NULL AND Inserted.CodeSystemTermID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dml.pr_PublishCodeSystemTerms:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
