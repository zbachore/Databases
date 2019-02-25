SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishConcepts_Taxonomy] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines cdd.pr_PublishConcepts_Taxonomy stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishConcepts_Taxonomy 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Concepts_Taxonomy',
		@ColumnName VARCHAR(MAX) = 'ConceptsTaxonomyID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT ct.ConceptsTaxonomyID,
       ct.ConceptId,
       ct.TaxonId,
       ct.CreatedDate,
       ct.UpdatedDate 
FROM UnifiedMetadata_Stage.dbo.ProjectConcepts pc 
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = pc.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts_Taxonomy ct ON ct.ConceptId = c.ConceptId
WHERE pc.ProjectId = @ProjectID
)
	
MERGE INTO UnifiedMetadata.cdd.Concepts_Taxonomy WITH(TABLOCK) AS T
USING Source AS S
ON S.ConceptsTaxonomyID = T.ConceptsTaxonomyID
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ConceptId, 
S.TaxonId 

INTERSECT

SELECT
 
		
T.ConceptId, 
T.TaxonId)


THEN UPDATE SET 
ConceptId			=	S.ConceptId, 
TaxonId				=	S.TaxonId ,
UpdatedDate			=	DEFAULT


WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConceptsTaxonomyID, 
ConceptId, 
TaxonId
) VALUES (
ConceptsTaxonomyID, 
ConceptId, 
TaxonId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConceptsTaxonomyID,deleted.ConceptsTaxonomyID), 
	CASE WHEN deleted.ConceptsTaxonomyID IS NULL AND Inserted.ConceptsTaxonomyID IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConceptsTaxonomyID IS NOT NULL AND Inserted.ConceptsTaxonomyID IS NOT NULL THEN 'Updated'
	ELSE NULL END,
	'Publish',
	@RequestedTime, 
	SYSDATETIME()
INTO dbo.PublishLog;

MERGE INTO UnifiedMetadata.cdd.Concepts_Taxonomy WITH(TABLOCK) AS T
USING UnifiedMetadata_Stage.cdd.Concepts_Taxonomy AS S
ON S.ConceptsTaxonomyID = T.ConceptsTaxonomyID

WHEN NOT MATCHED BY SOURCE
THEN DELETE

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	deleted.ConceptsTaxonomyID, 
	CASE WHEN deleted.ConceptsTaxonomyID IS NOT NULL AND Inserted.ConceptsTaxonomyID IS NULL 
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
    SET @ErrorMessage = 'cdd.pr_PublishConcepts_Taxonomy:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
