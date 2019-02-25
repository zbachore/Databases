SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dd].[pr_PublishTaxonomy] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines dd.pr_PublishTaxonomy stored procedure
___________________________________________________________________________________________________
Example: EXEC dd.pr_PublishTaxonomy 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Taxonomy',
		@ColumnName VARCHAR(MAX) = 'TaxonId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
--Take taxons from ValueSets_Taxonomy
SELECT DISTINCT t.TaxonId,
       t.ParentTaxonId,
       t.TaxonName,
       t.TaxonDescription,
       t.UpdatedBy,
       t.CreatedDate,
       t.UpdatedDate,
       t.DisplayOrder 
FROM UnifiedMetadata_Stage.dbo.ProjectValueSets vs
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSets_Taxonomy vst 
ON vst.ValueSetId = vs.ReferenceID
INNER JOIN UnifiedMetadata_Stage.dd.Taxonomy t ON t.TaxonId = vst.TaxonId
WHERE vs.ProjectId = @ProjectID

UNION 
--Take Taxons used by Concepts_Taxonomy
SELECT DISTINCT t.TaxonId,
       t.ParentTaxonId,
       t.TaxonName,
       t.TaxonDescription,
       t.UpdatedBy,
       t.CreatedDate,
       t.UpdatedDate,
       t.DisplayOrder 
FROM UnifiedMetadata_Stage.dbo.ProjectConcepts pc 
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = pc.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts_Taxonomy ct ON ct.ConceptId = c.ConceptId
INNER JOIN UnifiedMetadata_Stage.dd.Taxonomy t ON t.TaxonId = ct.TaxonId
WHERE pc.ProjectId = @ProjectID

UNION 
--take Taxons used by CodeSystems_Taxonomy 
SELECT DISTINCT t.TaxonId,
       t.ParentTaxonId,
       t.TaxonName,
       t.TaxonDescription,
       t.UpdatedBy,
       t.CreatedDate,
       t.UpdatedDate,
       t.DisplayOrder
FROM UnifiedMetadata_Stage.dbo.ProjectConcepts pc 
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = pc.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.CodeSystemTerms_Taxonomy cstt ON cstt.CodeSystemTermId = c.CodeSystemTermId
INNER JOIN UnifiedMetadata_Stage.dd.Taxonomy t ON t.TaxonId = cstt.TaxonId
WHERE pc.ProjectId = @ProjectID


)	
MERGE INTO UnifiedMetadata.dd.Taxonomy WITH(TABLOCK) AS T
USING Source AS S
ON S.TaxonId = T.TaxonId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ParentTaxonId, 
S.TaxonName, 
S.TaxonDescription, 
S.UpdatedBy, 
S.DisplayOrder 

INTERSECT

SELECT
 
		
T.ParentTaxonId, 
T.TaxonName, 
T.TaxonDescription, 
T.UpdatedBy, 
T.DisplayOrder)


THEN UPDATE SET 
ParentTaxonId			=	S.ParentTaxonId, 
TaxonName				=	S.TaxonName, 
TaxonDescription		=	S.TaxonDescription, 
UpdatedBy				=	S.UpdatedBy, 
DisplayOrder			=	S.DisplayOrder ,
UpdatedDate				=	DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
TaxonId, 
ParentTaxonId, 
TaxonName, 
TaxonDescription, 
UpdatedBy, 
DisplayOrder
) VALUES (
TaxonId, 
ParentTaxonId, 
TaxonName, 
TaxonDescription, 
UpdatedBy, 
DisplayOrder)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.TaxonId, deleted.TaxonID), 
	CASE WHEN deleted.TaxonId IS NULL AND Inserted.TaxonId IS NOT NULL THEN 'Inserted'
	WHEN deleted.TaxonId IS NOT NULL AND Inserted.TaxonId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dd.pr_PublishTaxonomy:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
