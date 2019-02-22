SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dml].[pr_PublishMedicationCategories] @PublishQueueID INT, @ValueSetID INT, @RegistryVersionID INT AS  
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-18
Description:	Defines dml.pr_PublishMedicationCategories stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishMedicationCategories 1,165,3
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
FROM cdd.ValueSetMembers vsm 
INNER JOIN cdd.ValueSetMedicationMembers vsmm
ON vsmm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN ld.Medications m
ON m.MedicationId = vsmm.MedicationId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN UnifiedMetadata_Stage.ld.MedicationCategories mc 
ON mc.MedicationCategoryId = m.MedicationCategoryId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
UNION 
SELECT DISTINCT mc.MedicationCategoryId,
				mc.MedicationCategoryName,
				mc.UpdatedBy,
			    mc.DisplayOrder
FROM cdd.ValueSetMembers vsm 
INNER JOIN cdd.ValueSetMedicationMembers vsmm
ON vsmm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN ld.Medications m
ON m.MedicationId = vsmm.MedicationId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN UnifiedMetadata_Stage.ld.MedicationCategories mc 
ON mc.MedicationCategoryId = m.MedicationSubCategoryId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
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
    SET @ErrorMessage = 'dml.pr_PublishMedicationCategories:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
