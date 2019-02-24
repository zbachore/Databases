SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishCodeSystemTerms_Taxonomy] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines cdd.pr_PublishCodeSystemTerms_Taxonomy stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishCodeSystemTerms_Taxonomy 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'CodeSystemTerms_Taxonomy',
		@ColumnName VARCHAR(MAX) = 'CodeSystemTermsTaxonomyID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT cstt.CodeSystemTermsTaxonomyID,
                cstt.CodeSystemTermId,
                cstt.TaxonId,
                cstt.CreatedDate,
                cstt.UpdatedDate 
FROM UnifiedMetadata_Stage.dbo.ProjectConcepts pc 
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = pc.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.CodeSystemTerms_Taxonomy cstt ON cstt.CodeSystemTermId = c.CodeSystemTermId
WHERE pc.ProjectId = @ProjectID
)
	
MERGE INTO UnifiedMetadata.cdd.CodeSystemTerms_Taxonomy WITH(TABLOCK) AS T
USING Source AS S
ON S.CodeSystemTermsTaxonomyID = T.CodeSystemTermsTaxonomyID
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CodeSystemTermId, 
S.TaxonId 

INTERSECT

SELECT
 
		
T.CodeSystemTermId, 
T.TaxonId)


THEN UPDATE SET 
CodeSystemTermId	=	S.CodeSystemTermId, 
TaxonId				=	S.TaxonId ,
UpdatedDate			=	DEFAULT


WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
CodeSystemTermsTaxonomyID, 
CodeSystemTermId, 
TaxonId
) VALUES (
CodeSystemTermsTaxonomyID, 
CodeSystemTermId, 
TaxonId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.CodeSystemTermsTaxonomyID, deleted.CodeSystemTermsTaxonomyID), 
	CASE WHEN deleted.CodeSystemTermsTaxonomyID IS NULL AND Inserted.CodeSystemTermsTaxonomyID IS NOT NULL THEN 'Inserted'
	WHEN deleted.CodeSystemTermsTaxonomyID IS NOT NULL AND Inserted.CodeSystemTermsTaxonomyID IS NOT NULL THEN 'Updated'
	ELSE NULL END,
	'Publish',
	@RequestedTime, 
	SYSDATETIME()
INTO dbo.PublishLog;

MERGE INTO UnifiedMetadata.cdd.CodeSystemTerms_Taxonomy WITH(TABLOCK) AS T
USING UnifiedMetadata_Stage.cdd.CodeSystemTerms_Taxonomy AS S
ON S.CodeSystemTermsTaxonomyID = T.CodeSystemTermsTaxonomyID

WHEN NOT MATCHED BY SOURCE
THEN DELETE

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	deleted.CodeSystemTermsTaxonomyID, 
	CASE WHEN deleted.CodeSystemTermsTaxonomyID IS NOT NULL AND Inserted.CodeSystemTermsTaxonomyID IS NULL 
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
    SET @ErrorMessage = 'cdd.pr_PublishCodeSystemTerms_Taxonomy:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
