SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishDataElements_ValueSets] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 25 2018 10:16AM
Description:	Defines cdd.pr_PublishDataElements_ValueSets stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishDataElements_ValueSets 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-02-08		zbachore		Modified the delete logic
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DataElements_ValueSets',
		@ColumnName VARCHAR(MAX) = 'DataElementsValueSetsID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;

BEGIN TRY
BEGIN TRAN;

SELECT @RegistryVersionID = RegistryVersionID 
FROM dbo.Project 
WHERE ProjectID = @ProjectID;

WITH Source AS (
SELECT DISTINCT devs.DataElementsValueSetsID,
				devs.DataElementId,
				devs.ValueSetId				
FROM UnifiedMetadata_Stage.dbo.ProjectDataElements pde 
INNER JOIN UnifiedMetadata_Stage.cdd.DataElements_ValueSets devs 
ON devs.DataElementId = pde.ReferenceID
INNER JOIN UnifiedMetadata_Stage.dbo.ProjectValueSets pvs 
ON pvs.ProjectId = pde.ProjectId
AND pvs.ReferenceID = devs.ValueSetId
WHERE pde.ProjectId = @ProjectID
)
MERGE INTO UnifiedMetadata.cdd.DataElements_ValueSets WITH(TABLOCK) AS T
USING Source AS S
ON S.DataElementsValueSetsID = T.DataElementsValueSetsID

WHEN NOT MATCHED BY SOURCE
AND T.DataElementsValueSetsID IN 
(
SELECT DISTINCT
    devs.DataElementsValueSetsID
FROM UnifiedMetadata.cdd.DataElements_ValueSets devs
    INNER JOIN UnifiedMetadata.cdd.DataElements de
        ON de.DataElementId = devs.DataElementId
    INNER JOIN UnifiedMetadata.rdd.RegistryElements re
        ON re.DataElementId = de.DataElementId
    INNER JOIN UnifiedMetadata.cdd.ValueSets vs
        ON devs.ValueSetId = vs.ValueSetId
    INNER JOIN UnifiedMetadata.cdd.ValueSetMembers vsm
        ON vs.ValueSetId = vsm.ValueSetId
    INNER JOIN UnifiedMetadata.rdd.RegistryVersions_ValueSetMembers rvvsm
        ON vsm.ValueSetMemberId = rvvsm.ValueSetMemberId
WHERE rvvsm.RegistryVersionId = re.RegistryVersionId
      AND re.RegistryVersionId = @RegistryVersionID
)
THEN DELETE


WHEN MATCHED AND NOT EXISTS
(
	SELECT 
	S.DataElementId, 
	S.ValueSetId 

	INTERSECT

	SELECT 	
	T.DataElementId, 
	T.ValueSetId
)
THEN UPDATE SET 
DataElementId	=	S.DataElementId, 
ValueSetId		=	S.ValueSetId ,
UpdatedDate		= DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DataElementsValueSetsID, 
DataElementId, 
ValueSetId
) VALUES (
DataElementsValueSetsID, 
DataElementId, 
ValueSetId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.DataElementsValueSetsID,deleted.DataElementsValueSetsID), 
	CASE WHEN deleted.DataElementsValueSetsID IS NULL 
	AND Inserted.DataElementsValueSetsID IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.DataElementsValueSetsID IS NOT NULL 
	AND Inserted.DataElementsValueSetsID IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.DataElementsValueSetsID IS NOT NULL 
	AND Inserted.DataElementsValueSetsID IS NULL 
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
    SET @ErrorMessage = 'cdd.pr_PublishDataElements_ValueSets:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
