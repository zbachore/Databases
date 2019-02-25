SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishConceptDefinitionTypes] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines cdd.pr_PublishConceptDefinitionTypes stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishConceptDefinitionTypes 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ConceptDefinitionTypes',
		@ColumnName VARCHAR(MAX) = 'ConceptDefinitionTypeId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    cdt.ConceptDefinitionTypeId,
    cdt.ConceptDefinitionType,
    cdt.ConceptDefinitionDescription,
    cdt.UpdatedBy,
    cdt.CreatedDate,
    cdt.UpdatedDate
FROM UnifiedMetadata_Stage.cdd.ConceptDefinitionTypes cdt
)

MERGE INTO UnifiedMetadata.cdd.ConceptDefinitionTypes WITH(TABLOCK) AS T
USING Source AS S
ON S.ConceptDefinitionTypeId = T.ConceptDefinitionTypeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ConceptDefinitionType, 
S.ConceptDefinitionDescription, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.ConceptDefinitionType, 
T.ConceptDefinitionDescription, 
T.UpdatedBy)


THEN UPDATE SET 
ConceptDefinitionType						=	S.ConceptDefinitionType, 
ConceptDefinitionDescription						=	S.ConceptDefinitionDescription, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConceptDefinitionTypeId, 
ConceptDefinitionType, 
ConceptDefinitionDescription, 
UpdatedBy
) VALUES (
ConceptDefinitionTypeId, 
ConceptDefinitionType, 
ConceptDefinitionDescription, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConceptDefinitionTypeId, deleted.ConceptDefinitionTypeId), 
	CASE WHEN deleted.ConceptDefinitionTypeId IS NULL AND Inserted.ConceptDefinitionTypeId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConceptDefinitionTypeId IS NOT NULL AND Inserted.ConceptDefinitionTypeId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishConceptDefinitionTypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
