SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dml].[pr_PublishMedications] 
	@PublishQueueID INT, 
	@ValueSetID INT, 
	@RegistryVersionID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-12
Description:	Defines dml.pr_PublishMedications stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishMedications 1,165,3
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Medications',
		@ColumnName VARCHAR(MAX) = 'MedicationID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT m.MedicationId,
				m.ConceptId,
				m.MedicationCategoryId,
				m.MedicationSubCategoryId,
				m.StartDate,
				m.EndDate,
				m.UpdatedBy				
FROM cdd.ValueSetMembers vsm --done
INNER JOIN cdd.ValueSetMedicationMembers vsmm --done
ON vsmm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN ld.Medications m
ON m.MedicationId = vsmm.MedicationId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
)
MERGE INTO UnifiedMetadata.ld.Medications WITH(TABLOCK) AS T
USING Source AS S
ON S.MedicationId = T.MedicationId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ConceptId, 
S.MedicationCategoryId, 
S.MedicationSubCategoryId, 
S.StartDate, 
S.EndDate, 
S.UpdatedBy 
INTERSECT
SELECT		
T.ConceptId, 
T.MedicationCategoryId, 
T.MedicationSubCategoryId, 
T.StartDate, 
T.EndDate, 
T.UpdatedBy)
THEN UPDATE SET 
ConceptId					=	S.ConceptId, 
MedicationCategoryId		=	S.MedicationCategoryId, 
MedicationSubCategoryId		=	S.MedicationSubCategoryId, 
StartDate					=	S.StartDate, 
EndDate						=	S.EndDate, 
UpdatedBy					=	S.UpdatedBy ,
UpdatedDate			        = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
MedicationId, 
ConceptId, 
MedicationCategoryId, 
MedicationSubCategoryId, 
StartDate, 
EndDate, 
UpdatedBy
) VALUES (
MedicationId, 
ConceptId, 
MedicationCategoryId, 
MedicationSubCategoryId, 
StartDate, 
EndDate, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.MedicationID,deleted.MedicationID), 
	CASE WHEN deleted.MedicationID IS NULL AND Inserted.MedicationID IS NOT NULL THEN 'Inserted'
	WHEN deleted.MedicationID IS NOT NULL AND Inserted.MedicationID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dml.pr_PublishMedications:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
