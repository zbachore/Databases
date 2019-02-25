SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishCodeSystem_Taxonomy] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines cdd.pr_PublishCodeSystem_Taxonomy stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishCodeSystem_Taxonomy 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'CodeSystem_Taxonomy',
		@ColumnName VARCHAR(MAX) = 'CodeSystemTaxonomyID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT cst.CodeSystemTaxonomyID,
       cst.CodeSystemId,
       cst.TaxonId
FROM UnifiedMetadata_Stage.dbo.ProjectValueSets pvs
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSets vs ON vs.ValueSetId = pvs.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.CodeSystem_Taxonomy cst ON cst.CodeSystemId = vs.CodeSystemId
WHERE pvs.ProjectId = @ProjectID
)
	
MERGE INTO UnifiedMetadata.cdd.CodeSystem_Taxonomy WITH(TABLOCK) AS T
USING Source AS S
ON S.CodeSystemTaxonomyID = T.CodeSystemTaxonomyID
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CodeSystemId, 
S.TaxonId 

INTERSECT

SELECT
 
		
T.CodeSystemId, 
T.TaxonId)


THEN UPDATE SET 
CodeSystemId		=	S.CodeSystemId, 
TaxonId				=	S.TaxonId ,
UpdatedDate			=	DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
CodeSystemTaxonomyID, 
CodeSystemId, 
TaxonId
) VALUES (
CodeSystemTaxonomyID, 
CodeSystemId, 
TaxonId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(Inserted.CodeSystemTaxonomyID, deleted.CodeSystemTaxonomyID), 
	CASE WHEN deleted.CodeSystemTaxonomyID IS NULL AND Inserted.CodeSystemTaxonomyID IS NOT NULL THEN 'Inserted'
	WHEN deleted.CodeSystemTaxonomyID IS NOT NULL AND Inserted.CodeSystemTaxonomyID IS NOT NULL THEN 'Updated'
	ELSE NULL END,
	'Publish',
	@RequestedTime, 
	SYSDATETIME()
INTO dbo.PublishLog;

	
MERGE INTO UnifiedMetadata.cdd.CodeSystem_Taxonomy WITH(TABLOCK) AS T
USING UnifiedMetadata_Stage.cdd.CodeSystem_Taxonomy AS S
ON S.CodeSystemTaxonomyID = T.CodeSystemTaxonomyID

WHEN NOT MATCHED BY SOURCE 
THEN DELETE

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	deleted.CodeSystemTaxonomyID, 
	CASE WHEN deleted.CodeSystemTaxonomyID IS NOT NULL AND Inserted.CodeSystemTaxonomyID IS NULL 
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
    SET @ErrorMessage = 'cdd.pr_PublishCodeSystem_Taxonomy:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
