SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [edw].[pr_PublishEntities] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines edw.pr_PublishEntities stored procedure
___________________________________________________________________________________________________
Example: EXEC edw.pr_PublishEntities 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Entities',
		@ColumnName VARCHAR(MAX) = 'EntityID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;
WITH Source AS (
SELECT DISTINCT e.EntityId,
       e.SchemaName,
       e.EntityName,
       e.EntityDescription,
       e.IsActive,
       e.UpdatedBy,
       e.WorkflowConceptId,
       e.DomainConceptId 
FROM UnifiedMetadata_Stage.edw.Entities e 
)
MERGE INTO UnifiedMetadata.edw.Entities WITH(TABLOCK) AS T
USING Source AS S
ON S.EntityId = T.EntityId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.SchemaName, 
S.EntityName, 
S.EntityDescription, 
S.IsActive,  
S.WorkflowConceptId, 
S.DomainConceptId 

INTERSECT

SELECT
 
		
T.SchemaName, 
T.EntityName, 
T.EntityDescription, 
T.IsActive, 
T.WorkflowConceptId, 
T.DomainConceptId)


THEN UPDATE SET 
SchemaName						=	S.SchemaName, 
EntityName						=	S.EntityName, 
EntityDescription						=	S.EntityDescription, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy, 
WorkflowConceptId						=	S.WorkflowConceptId, 
DomainConceptId						=	S.DomainConceptId ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
EntityId, 
SchemaName, 
EntityName, 
EntityDescription, 
IsActive, 
UpdatedBy, 
WorkflowConceptId, 
DomainConceptId
) VALUES (
EntityId, 
SchemaName, 
EntityName, 
EntityDescription, 
IsActive, 
UpdatedBy, 
WorkflowConceptId, 
DomainConceptId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.EntityID,deleted.EntityID), 
	CASE WHEN deleted.EntityID IS NULL AND Inserted.EntityID IS NOT NULL THEN 'Inserted'
	WHEN deleted.EntityID IS NOT NULL AND Inserted.EntityID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'edw.pr_PublishEntities:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
