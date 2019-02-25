SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ld].[pr_PublishMedicationCategories] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines ld.pr_PublishMedicationCategories stored procedure
___________________________________________________________________________________________________
Example: EXEC ld.pr_PublishMedicationCategories
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-05-10		zbachore		Added the Union with a join to m.MedicationSubCategoryID
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'MedicationCategories',
		@ColumnName VARCHAR(MAX) = 'MedicationCategoryID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;
WITH Source AS (
SELECT DISTINCT mc.MedicationCategoryId,
				mc.MedicationCategoryName,
				mc.UpdatedBy,
			    mc.DisplayOrder
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pvsm
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetMedicationMembers vsmm ON vsmm.ValueSetMemberId = pvsm.ReferenceID
INNER JOIN UnifiedMetadata_Stage.ld.Medications m ON m.MedicationId = vsmm.MedicationId
INNER JOIN UnifiedMetadata_Stage.ld.MedicationCategories mc ON mc.MedicationCategoryId = m.MedicationCategoryId
WHERE pvsm.ProjectId = @ProjectID
UNION 
SELECT DISTINCT mc.MedicationCategoryId,
				mc.MedicationCategoryName,
				mc.UpdatedBy,
			    mc.DisplayOrder
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pvsm
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetMedicationMembers vsmm ON vsmm.ValueSetMemberId = pvsm.ReferenceID
INNER JOIN UnifiedMetadata_Stage.ld.Medications m ON m.MedicationId = vsmm.MedicationId
INNER JOIN UnifiedMetadata_Stage.ld.MedicationCategories mc ON mc.MedicationCategoryId = m.MedicationSubCategoryId
WHERE pvsm.ProjectId = @ProjectID
)
MERGE INTO UnifiedMetadata.ld.MedicationCategories WITH(TABLOCK) AS T
USING Source AS S
ON S.MedicationCategoryId = T.MedicationCategoryId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.MedicationCategoryName, 
S.UpdatedBy, 
S.DisplayOrder 
INTERSECT
SELECT		
T.MedicationCategoryName, 
T.UpdatedBy, 
T.DisplayOrder)
THEN UPDATE SET 
MedicationCategoryName	  =	S.MedicationCategoryName, 
UpdatedBy				  =	S.UpdatedBy, 
DisplayOrder			  =	S.DisplayOrder ,
UpdatedDate			      = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
MedicationCategoryId, 
MedicationCategoryName, 
UpdatedBy, 
DisplayOrder
) VALUES (
MedicationCategoryId, 
MedicationCategoryName, 
UpdatedBy, 
DisplayOrder)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.MedicationCategoryID,deleted.MedicationCategoryID), 
	CASE WHEN deleted.MedicationCategoryID IS NULL AND Inserted.MedicationCategoryID IS NOT NULL THEN 'Inserted'
	WHEN deleted.MedicationCategoryID IS NOT NULL AND Inserted.MedicationCategoryID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'ld.pr_PublishMedicationCategories:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
