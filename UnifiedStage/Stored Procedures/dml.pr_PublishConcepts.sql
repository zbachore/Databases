SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishConcepts] @PublishQueueID INT, @ValueSetID INT, @RegistryVersionID INT AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-18
Description:	Defines dml.pr_PublishConcepts stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishConcepts 1,3, 3
select * from dbo.PUblishLog
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-05-14		zbachore		Added a new result set(UNION) to include Concepts
								that are referrenced by ld.Medications as foreign Keys.
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Concepts',
		@ColumnName VARCHAR(MAX) = 'ConceptID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    c.ConceptId,
    c.CodeSystemTermId,
    c.ConceptName,
    c.DomainConceptId,
    c.IsActive,
    c.StartDate,
    c.EndDate,
    c.UpdatedBy,
    c.Synonyms
FROM  UnifiedMetadata_Stage.cdd.ValueSetMembers vsm 
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetConceptMembers vscm 
ON vscm.ValueSetMemberId = vsm.ValueSetMemberId 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersions_ValueSetMembers rvvsm 
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = vscm.ConceptId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
UNION
--the following join is to include concepts that are referrenced by
--the medications table as foreign keys.
SELECT DISTINCT
    c.ConceptId,
    c.CodeSystemTermId,
    c.ConceptName,
    c.DomainConceptId,
    c.IsActive,
    c.StartDate,
    c.EndDate,
    c.UpdatedBy,
    c.Synonyms
FROM cdd.ValueSetMembers vsm 
INNER JOIN cdd.ValueSetMedicationMembers vsmm
ON vsmm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN ld.Medications m
ON m.MedicationId = vsmm.MedicationId
INNER JOIN cdd.Concepts c ON c.ConceptId = m.ConceptId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID

)

MERGE INTO UnifiedMetadata.cdd.Concepts WITH(TABLOCK) AS T
USING Source AS S
ON S.ConceptId = T.ConceptId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CodeSystemTermId, 
S.ConceptName, 
S.DomainConceptId, 
S.IsActive, 
S.StartDate, 
S.EndDate, 
S.UpdatedBy, 
S.Synonyms 

INTERSECT

SELECT
 
		
T.CodeSystemTermId, 
T.ConceptName, 
T.DomainConceptId, 
T.IsActive, 
T.StartDate, 
T.EndDate, 
T.UpdatedBy, 
T.Synonyms)


THEN UPDATE SET 
CodeSystemTermId	=	S.CodeSystemTermId, 
ConceptName			=	S.ConceptName, 
DomainConceptId		=	S.DomainConceptId, 
IsActive			=	S.IsActive, 
StartDate			=	S.StartDate, 
EndDate				=	S.EndDate, 
UpdatedBy			=	S.UpdatedBy, 
Synonyms			=	S.Synonyms ,
UpdatedDate			=	DEFAULT


WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConceptId, 
CodeSystemTermId, 
ConceptName, 
DomainConceptId, 
IsActive, 
StartDate, 
EndDate, 
UpdatedBy, 
Synonyms
) VALUES (
ConceptId, 
CodeSystemTermId, 
ConceptName, 
DomainConceptId, 
IsActive, 
StartDate, 
EndDate, 
UpdatedBy, 
Synonyms)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConceptId,deleted.ConceptId), 
	CASE WHEN deleted.ConceptID IS NULL AND Inserted.ConceptId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConceptID IS NOT NULL AND Inserted.ConceptId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dml.pr_PublishConcepts:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
