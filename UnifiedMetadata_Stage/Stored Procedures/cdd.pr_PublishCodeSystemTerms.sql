SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishCodeSystemTerms] @ProjectID int, @PublishQueueID INT AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines cdd.pr_PublishCodeSystemTerms stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishCodeSystemTerms 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'CodeSystemTerms',
		@ColumnName VARCHAR(MAX) = 'CodeSystemTermID',
		@RequestedTime DATETIME2 = SYSDATETIME()

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT Distinct
    cst.CodeSystemTermId,
    cst.CodeSystemId,
    cst.CodeSystemTermCode,
    cst.CodeSystemTermName,
    cst.CodeSystemTermDefinition,
    cst.CodeSystemTermAdditionalNote,
    cst.IsActive,
    cst.UpdatedBy
FROM UnifiedMetadata_Stage.dbo.ProjectConcepts pc
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = pc.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.CodeSystemterms cst ON cst.CodeSystemTermId = c.CodeSystemTermId
WHERE pc.ProjectID = @ProjectID	
--the top query may not be needed. Check with Josh.
--the query below seems to be getting all the rows
UNION 
SELECT Distinct
    cst.CodeSystemTermId,
    cst.CodeSystemId,
    cst.CodeSystemTermCode,
    cst.CodeSystemTermName,
    cst.CodeSystemTermDefinition,
    cst.CodeSystemTermAdditionalNote,
    cst.IsActive,
    cst.UpdatedBy
FROM UnifiedMetadata_Stage.dbo.ProjectConcepts pc
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts_CodeSystemTErms ccst ON ccst.ConceptId = pc.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.CodeSystemterms cst ON cst.CodeSystemTermId = ccst.CodeSystemTermId
WHERE pc.ProjectID = @ProjectID
--Concepts_CodeSystemTErms
)
	
MERGE INTO UnifiedMetadata.cdd.CodeSystemTerms WITH(TABLOCK) AS T
USING Source AS S
ON S.CodeSystemTermId = T.CodeSystemTermId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CodeSystemId, 
S.CodeSystemTermCode, 
S.CodeSystemTermName, 
S.CodeSystemTermDefinition, 
S.CodeSystemTermAdditionalNote, 
S.IsActive, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.CodeSystemId, 
T.CodeSystemTermCode, 
T.CodeSystemTermName, 
T.CodeSystemTermDefinition, 
T.CodeSystemTermAdditionalNote, 
T.IsActive, 
T.UpdatedBy)


THEN UPDATE SET 
CodeSystemId						=	S.CodeSystemId, 
CodeSystemTermCode						=	S.CodeSystemTermCode, 
CodeSystemTermName						=	S.CodeSystemTermName, 
CodeSystemTermDefinition						=	S.CodeSystemTermDefinition, 
CodeSystemTermAdditionalNote						=	S.CodeSystemTermAdditionalNote, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
CodeSystemTermId, 
CodeSystemId, 
CodeSystemTermCode, 
CodeSystemTermName, 
CodeSystemTermDefinition, 
CodeSystemTermAdditionalNote, 
IsActive, 
UpdatedBy
) VALUES (
CodeSystemTermId, 
CodeSystemId, 
CodeSystemTermCode, 
CodeSystemTermName, 
CodeSystemTermDefinition, 
CodeSystemTermAdditionalNote, 
IsActive, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.CodeSystemTermID,deleted.CodeSystemTermID), 
	CASE WHEN deleted.CodeSystemTermID IS NULL AND Inserted.CodeSystemTermID IS NOT NULL THEN 'Inserted'
	WHEN deleted.CodeSystemTermID IS NOT NULL AND Inserted.CodeSystemTermID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishCodeSystemTerms:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
