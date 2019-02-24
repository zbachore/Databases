SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishConcepts] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines cdd.pr_PublishConcepts stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishConcepts 3, 1
select * from dbo.PUblishLog
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Concepts',
		@ColumnName VARCHAR(MAX) = 'ConceptID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    c.ConceptId,
    c.CodeSystemTermId,
    c.ConceptName,
    c.DomainConceptId,
    c.IsActive,
    c.StartDate,
    c.EndDate,
    c.UpdatedBy,
    c.Synonyms
FROM  UnifiedMetadata_Stage.dbo.ProjectConcepts pc 
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = pc.ReferenceID
WHERE pc.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.cdd.Concepts WITH(TABLOCK) AS T
USING Source AS S
ON S.ConceptId = T.ConceptId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CodeSystemTermId, 
S.ConceptName, 
S.DomainConceptId, 
S.IsActive, 
S.StartDate, 
S.EndDate, 
S.UpdatedBy, 
S.Synonyms 

INTERSECT

SELECT
 
		
T.CodeSystemTermId, 
T.ConceptName, 
T.DomainConceptId, 
T.IsActive, 
T.StartDate, 
T.EndDate, 
T.UpdatedBy, 
T.Synonyms)


THEN UPDATE SET 
CodeSystemTermId	=	S.CodeSystemTermId, 
ConceptName			=	S.ConceptName, 
DomainConceptId		=	S.DomainConceptId, 
IsActive			=	S.IsActive, 
StartDate			=	S.StartDate, 
EndDate				=	S.EndDate, 
UpdatedBy			=	S.UpdatedBy, 
Synonyms			=	S.Synonyms ,
UpdatedDate			=	DEFAULT


WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConceptId, 
CodeSystemTermId, 
ConceptName, 
DomainConceptId, 
IsActive, 
StartDate, 
EndDate, 
UpdatedBy, 
Synonyms
) VALUES (
ConceptId, 
CodeSystemTermId, 
ConceptName, 
DomainConceptId, 
IsActive, 
StartDate, 
EndDate, 
UpdatedBy, 
Synonyms)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConceptID, deleted.ConceptId), 
	CASE WHEN deleted.ConceptID IS NULL AND Inserted.ConceptId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConceptID IS NOT NULL AND Inserted.ConceptId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishConcepts:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
