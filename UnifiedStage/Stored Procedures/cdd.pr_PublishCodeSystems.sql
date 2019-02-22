SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishCodeSystems] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines cdd.pr_PublishCodeSystems stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishCodeSystems 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'CodeSystems',
		@ColumnName VARCHAR(MAX) = 'CodeSystemID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    cs.CodeSystemId,
    cs.CodeSystemName,
    cs.CodeSystemOID,
    cs.CodeSystemDescription,
    cs.IsActive,
    cs.UpdatedBy,
    cs.CreatedDate,
    cs.UpdatedDate
FROM UnifiedMetadata_Stage.dbo.ProjectConcepts pc
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = pc.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.CodeSystemterms cst ON cst.CodeSystemTermId = c.CodeSystemTermId
INNER JOIN UnifiedMetadata_Stage.cdd.CodeSystems cs ON cs.CodeSystemId = cst.CodeSystemId
WHERE pc.ProjectID = @ProjectID

UNION 

--This is to take CodeSystems that are not associated with CodeSystemTerms and Concepts
SELECT DISTINCT
    cs.CodeSystemId,
    cs.CodeSystemName,
    cs.CodeSystemOID,
    cs.CodeSystemDescription,
    cs.IsActive,
    cs.UpdatedBy,
    cs.CreatedDate,
    cs.UpdatedDate
FROM UnifiedMetadata_Stage.dbo.ProjectValueSets pvs
    INNER JOIN UnifiedMetadata_Stage.cdd.ValueSets vs ON vs.ValueSetId = pvs.ReferenceID
	INNER JOIN cdd.CodeSystems cs ON cs.CodeSystemId = vs.CodeSystemId
WHERE pvs.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.cdd.CodeSystems WITH(TABLOCK) AS T
USING Source AS S
ON S.CodeSystemId = T.CodeSystemId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CodeSystemName, 
S.CodeSystemOID, 
S.CodeSystemDescription, 
S.IsActive, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.CodeSystemName, 
T.CodeSystemOID, 
T.CodeSystemDescription, 
T.IsActive, 
T.UpdatedBy)


THEN UPDATE SET 
CodeSystemName						=	S.CodeSystemName, 
CodeSystemOID						=	S.CodeSystemOID, 
CodeSystemDescription						=	S.CodeSystemDescription, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
CodeSystemId, 
CodeSystemName, 
CodeSystemOID, 
CodeSystemDescription, 
IsActive, 
UpdatedBy
) VALUES (
CodeSystemId, 
CodeSystemName, 
CodeSystemOID, 
CodeSystemDescription, 
IsActive, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.CodeSystemID,deleted.CodeSystemID), 
	CASE WHEN deleted.CodeSystemID IS NULL AND Inserted.CodeSystemID IS NOT NULL THEN 'Inserted'
	WHEN deleted.CodeSystemID IS NOT NULL AND Inserted.CodeSystemID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishCodeSystems:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
