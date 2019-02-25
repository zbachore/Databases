SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishConcepts_CodeSystemTerms] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines cdd.pr_PublishConcepts_CodeSystemTerms stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishConcepts_CodeSystemTerms 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Concepts_CodeSystemTerms',
		@ColumnName VARCHAR(MAX) = 'ConceptsCodeSystemTermsID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT ccst.ConceptsCodeSystemTermsID,
                ccst.ConceptId,
                ccst.CodeSystemTermId,
                ccst.CreatedDate,
                ccst.UpdatedDate 
FROM UnifiedMetadata_Stage.dbo.ProjectConcepts pc 
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts_CodeSystemTerms ccst 
ON ccst.ConceptId = pc.ReferenceID
WHERE pc.ProjectId = @ProjectID
)
MERGE INTO UnifiedMetadata.cdd.Concepts_CodeSystemTerms WITH(TABLOCK) AS T
USING Source AS S
ON S.ConceptsCodeSystemTermsID = T.ConceptsCodeSystemTermsID
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ConceptId, 
S.CodeSystemTermId 

INTERSECT

SELECT
 
		
T.ConceptId, 
T.CodeSystemTermId)


THEN UPDATE SET 
ConceptId			=	S.ConceptId, 
CodeSystemTermId	=	S.CodeSystemTermId ,
UpdatedDate			=	DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConceptsCodeSystemTermsID, 
ConceptId, 
CodeSystemTermId
) VALUES (
ConceptsCodeSystemTermsID, 
ConceptId, 
CodeSystemTermId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConceptsCodeSystemTermsID,deleted.ConceptsCodeSystemTermsID), 
	CASE WHEN deleted.ConceptsCodeSystemTermsID IS NULL AND Inserted.ConceptsCodeSystemTermsID IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConceptsCodeSystemTermsID IS NOT NULL AND Inserted.ConceptsCodeSystemTermsID IS NOT NULL THEN 'Updated'
	ELSE NULL END,
	'Publish',
	@RequestedTime, 
	SYSDATETIME()
INTO dbo.PublishLog;

MERGE INTO UnifiedMetadata.cdd.Concepts_CodeSystemTerms WITH(TABLOCK) AS T
USING UnifiedMetadata_Stage.cdd.Concepts_CodeSystemTerms AS S
ON S.ConceptsCodeSystemTermsID = T.ConceptsCodeSystemTermsID

WHEN NOT MATCHED BY SOURCE
THEN DELETE

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	deleted.ConceptsCodeSystemTermsID, 
	CASE WHEN deleted.ConceptsCodeSystemTermsID IS NOT NULL AND Inserted.ConceptsCodeSystemTermsID IS NULL 
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
    SET @ErrorMessage = 'cdd.pr_PublishConcepts_CodeSystemTerms:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
