SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistryDataSets_RegistryElements] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistryDataSets_RegistryElements stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryDataSets_RegistryElements 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-02-20		zbachore		Removed an extra delete logic which should have been deleted.
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryDataSets_RegistryElements',
		@ColumnName VARCHAR(MAX) = 'RegistryDataSetsRegistryElementsID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;

BEGIN TRY
BEGIN TRAN;

SELECT @RegistryVersionID = RegistryVersionID 
FROM dbo.Project WHERE ProjectId = @ProjectID;

WITH Source AS (
SELECT DISTINCT rdsre.RegistryDataSetsRegistryElementsID,
                rdsre.RegistryElementId,
                rdsre.RegistryDataSetId,
                rdsre.CreatedDate,
                rdsre.UpdatedDate
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.RegistryVersionId = p.RegistryVersionId
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryDataSets_RegistryElements rdsre
ON rdsre.RegistryElementId = re.RegistryElementId
WHERE p.ProjectId = @ProjectID
)	
MERGE INTO UnifiedMetadata.rdd.RegistryDataSets_RegistryElements WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryDataSetsRegistryElementsID = T.RegistryDataSetsRegistryElementsID

WHEN NOT MATCHED BY SOURCE 
AND T.RegistryDataSetsRegistryElementsID IN
(
SELECT DISTINCT rdsre.RegistryDataSetsRegistryElementsID
FROM UnifiedMetadata.dbo.RegistryElements re 
INNER JOIN UnifiedMetadata.rdd.RegistryDataSets_RegistryElements rdsre
ON rdsre.RegistryElementId = re.RegistryElementId
WHERE re.RegistryVersionId = @RegistryVersionID
)
THEN DELETE

WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistryElementId, 
S.RegistryDataSetId 

INTERSECT

SELECT
 
		
T.RegistryElementId, 
T.RegistryDataSetId)


THEN UPDATE SET 
RegistryElementId	=	S.RegistryElementId, 
RegistryDataSetId	=	S.RegistryDataSetId ,
UpdatedDate			=	DEFAULT


WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistryDataSetsRegistryElementsID, 
RegistryElementId, 
RegistryDataSetId
) VALUES (
RegistryDataSetsRegistryElementsID, 
RegistryElementId, 
RegistryDataSetId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryDataSetsRegistryElementsID,deleted.RegistryDataSetsRegistryElementsID), 
	CASE WHEN deleted.RegistryDataSetsRegistryElementsID IS NULL 
	AND Inserted.RegistryDataSetsRegistryElementsID IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.RegistryDataSetsRegistryElementsID IS NOT NULL 
	AND Inserted.RegistryDataSetsRegistryElementsID IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.RegistryDataSetsRegistryElementsID IS NOT NULL 
	AND Inserted.RegistryDataSetsRegistryElementsID IS NULL 
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistryDataSets_RegistryElements:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
