SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ld].[pr_PublishMedications] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines ld.pr_PublishMedications stored procedure
___________________________________________________________________________________________________
Example: EXEC ld.pr_PublishMedications 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns m.CreatedDate,m.UpdatedDate from the source as these fields are not required 
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
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pvsm
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetMedicationMembers vsmm ON vsmm.ValueSetMemberId = pvsm.ReferenceID
INNER JOIN UnifiedMetadata_Stage.ld.Medications m ON m.MedicationId = vsmm.MedicationId
WHERE pvsm.ProjectId = @ProjectID
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
    SET @ErrorMessage = 'ld.pr_PublishMedications:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
