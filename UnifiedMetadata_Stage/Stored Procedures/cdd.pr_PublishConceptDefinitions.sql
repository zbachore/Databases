SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishConceptDefinitions] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines cdd.pr_PublishConceptDefinitions stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishConceptDefinitions 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ConceptDefinitions',
		@ColumnName VARCHAR(MAX) = 'ConceptDefinitionID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT cd.ConceptDefinitionId,
                cd.ConceptId,
                cd.ConceptDefinitionTypeId,
                cd.ConceptDefinitionName,
                cd.ConceptDefinitionDescription,
                cd.ConceptDefinitionSource,
                cd.StartDate,
                cd.EndDate,
                cd.IsActive,
                cd.UpdatedBy,
                cd.CreatedDate,
                cd.UpdatedDate
FROM UnifiedMetadata_Stage.dbo.ProjectConcepts pc
INNER JOIN UnifiedMetadata_Stage.cdd.Concepts c ON c.ConceptId = pc.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.ConceptDefinitions cd ON cd.ConceptId = c.ConceptId
WHERE pc.ProjectId = @ProjectID
)
	
MERGE INTO UnifiedMetadata.cdd.ConceptDefinitions WITH(TABLOCK) AS T
USING Source AS S
ON S.ConceptDefinitionId = T.ConceptDefinitionId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ConceptId, 
S.ConceptDefinitionTypeId, 
S.ConceptDefinitionName, 
S.ConceptDefinitionDescription, 
S.ConceptDefinitionSource, 
S.StartDate, 
S.EndDate, 
S.IsActive, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.ConceptId, 
T.ConceptDefinitionTypeId, 
T.ConceptDefinitionName, 
T.ConceptDefinitionDescription, 
T.ConceptDefinitionSource, 
T.StartDate, 
T.EndDate, 
T.IsActive, 
T.UpdatedBy)


THEN UPDATE SET 
ConceptId						=	S.ConceptId, 
ConceptDefinitionTypeId						=	S.ConceptDefinitionTypeId, 
ConceptDefinitionName						=	S.ConceptDefinitionName, 
ConceptDefinitionDescription						=	S.ConceptDefinitionDescription, 
ConceptDefinitionSource						=	S.ConceptDefinitionSource, 
StartDate						=	S.StartDate, 
EndDate						=	S.EndDate, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConceptDefinitionId, 
ConceptId, 
ConceptDefinitionTypeId, 
ConceptDefinitionName, 
ConceptDefinitionDescription, 
ConceptDefinitionSource, 
StartDate, 
EndDate, 
IsActive, 
UpdatedBy
) VALUES (
ConceptDefinitionId, 
ConceptId, 
ConceptDefinitionTypeId, 
ConceptDefinitionName, 
ConceptDefinitionDescription, 
ConceptDefinitionSource, 
StartDate, 
EndDate, 
IsActive, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConceptDefinitionId, deleted.ConceptDefinitionId), 
	CASE WHEN deleted.ConceptDefinitionId IS NULL AND Inserted.ConceptDefinitionId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConceptDefinitionId IS NOT NULL AND Inserted.ConceptDefinitionId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishConceptDefinitions:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
