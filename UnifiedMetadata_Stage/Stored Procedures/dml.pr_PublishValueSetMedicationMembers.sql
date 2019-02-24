SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishValueSetMedicationMembers] 
@PublishQueueID int, @ValueSetID INT, @RegistryVersionID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-12
Description:	Defines cdd.pr_PublishValueSetMedicationMembers stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishValueSetMedicationMembers 1,165,3
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns vsmm.CreatedDate,vsmm.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ValueSetMedicationMembers',
		@ColumnName VARCHAR(MAX) = 'ValueSetMemberId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT vsmm.ValueSetMemberId,
			    vsmm.MedicationId 
FROM cdd.ValueSetMembers vsm
INNER JOIN cdd.ValueSetMedicationMembers vsmm
ON vsmm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
)	
MERGE INTO UnifiedMetadata.cdd.ValueSetMedicationMembers WITH(TABLOCK) AS T
USING Source AS S
ON S.ValueSetMemberId = T.ValueSetMemberId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.MedicationId 
INTERSECT
SELECT		
T.MedicationId)
THEN UPDATE SET 
MedicationId		=	S.MedicationId ,
UpdatedDate			= DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ValueSetMemberId, 
MedicationId
) VALUES (
ValueSetMemberId, 
MedicationId)
OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ValueSetMemberId,deleted.ValueSetMemberId), 
	CASE WHEN deleted.ValueSetMemberId IS NULL AND Inserted.ValueSetMemberId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ValueSetMemberId IS NOT NULL AND Inserted.ValueSetMemberId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dml.pr_PublishValueSetMedicationMembers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
