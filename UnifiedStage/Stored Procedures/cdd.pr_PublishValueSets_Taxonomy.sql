SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishValueSets_Taxonomy] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines cdd.pr_PublishValueSets_Taxonomy stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishValueSets_Taxonomy 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-02-08		zbachore		Modified delete logic
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ValueSets_Taxonomy',
		@ColumnName VARCHAR(MAX) = 'ValueSetsTaxonomyID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID int

BEGIN TRY
BEGIN TRAN;

SELECT @RegistryVersionID = RegistryVersionID 
FROM dbo.Project WHERE ProjectID = @ProjectID;

WITH Source AS (
SELECT vst.ValueSetsTaxonomyID,
       vst.ValueSetId,
       vst.TaxonId 
FROM UnifiedMetadata_Stage.dbo.ProjectValueSets pvs 
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSets_Taxonomy vst ON vst.ValueSetId = pvs.ReferenceID
WHERE pvs.ProjectId = @ProjectID
)	
MERGE INTO UnifiedMetadata.cdd.ValueSets_Taxonomy WITH(TABLOCK) AS T
USING Source AS S
ON S.ValueSetsTaxonomyID = T.ValueSetsTaxonomyID

WHEN NOT MATCHED BY SOURCE 
AND T.ValueSetsTaxonomyID IN 
(
SELECT vst.ValueSetsTaxonomyID 
FROM UnifiedMetadata.cdd.ValueSets_Taxonomy vst 
INNER JOIN UnifiedMetadata.cdd.ValueSets vs
ON vs.ValuesetID = vst.ValueSetId
INNER JOIN UnifiedMetadata.cdd.ValueSetMembers vsm 
ON vs.ValueSetId = vsm.ValueSetId
INNER JOIN UnifiedMetadata.rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE rvvsm.RegistryVersionId = @RegistryVersionID
)
THEN DELETE

WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ValueSetId, 
S.TaxonId 
INTERSECT
SELECT		
T.ValueSetId, 
T.TaxonId)

THEN UPDATE SET 
ValueSetId			=	S.ValueSetId, 
TaxonId				=	S.TaxonId ,
UpdatedDate			=	DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ValueSetsTaxonomyID, 
ValueSetId, 
TaxonId
) VALUES (
ValueSetsTaxonomyID, 
ValueSetId, 
TaxonId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ValueSetsTaxonomyID,deleted.ValueSetsTaxonomyID), 
	CASE WHEN deleted.ValueSetsTaxonomyID IS NULL 
	AND Inserted.ValueSetsTaxonomyID IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.ValueSetsTaxonomyID IS NOT NULL 
	AND Inserted.ValueSetsTaxonomyID IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.ValueSetsTaxonomyID IS NOT NULL 
	AND Inserted.ValueSetsTaxonomyID IS NULL 
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
    SET @ErrorMessage = 'cdd.pr_PublishValueSets_Taxonomy:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
