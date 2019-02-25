SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishConceptSynonyms] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines cdd.pr_PublishConceptSynonyms stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishConceptSynonyms 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/21/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/21/2018     rkakani		Removed columns cs.CreatedDate,cs.UpdatedDate from the source as these fields are not required 

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ConceptSynonyms',
		@ColumnName VARCHAR(MAX) = 'ConceptSynonymId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT cs.ConceptSynonymId,
				cs.ConceptId,
				cs.[Name],
				cs.UpdatedBy
				
FROM UnifiedMetadata_Stage.dbo.ProjectConcepts pc 
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = pc.ReferenceID 
INNER JOIN UnifiedMetadata_Stage.cdd.ConceptSynonyms cs ON cs.ConceptId = c.ConceptId
WHERE pc.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.cdd.ConceptSynonyms WITH(TABLOCK) AS T
USING Source AS S
ON S.ConceptSynonymId = T.ConceptSynonymId
WHEN MATCHED AND NOT EXISTS
(
	SELECT 
	S.ConceptId, 
	S.Name, 
	S.UpdatedBy
	INTERSECT
	SELECT 	
	T.ConceptId, 
	T.Name, 
	T.UpdatedBy
)
THEN UPDATE SET 
ConceptId			=	S.ConceptId, 
Name				=	S.Name, 
UpdatedBy			=	S.UpdatedBy ,
UpdatedDate			=	DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConceptSynonymId, 
ConceptId, 
Name, 
UpdatedBy
) VALUES (
ConceptSynonymId, 
ConceptId, 
Name, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConceptSynonymId, deleted.ConceptSynonymId), 
	CASE WHEN deleted.ConceptSynonymId IS NULL AND Inserted.ConceptSynonymId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConceptSynonymId IS NOT NULL AND Inserted.ConceptSynonymId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishConceptSynonyms:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
