SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dd].[pr_PublishConstraintDefinitionScopes] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines dd.pr_PublishConstraintDefinitionScopes stored procedure
___________________________________________________________________________________________________
Example: EXEC dd.pr_PublishConstraintDefinitionScopes 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ConstraintDefinitionScopes',
		@ColumnName VARCHAR(MAX) = 'ConstraintDefinitionScopeId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT cds.ConstraintDefinitionScopeId,
       cds.ConstraintDefinitionScopeName,
       cds.ConstraintDefinitionScopeDescription,
       cds.UpdatedBy,
       cds.CreatedDate,
       cds.UpdatedDate
FROM UnifiedMetadata_Stage.dbo.Project p
    INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
	ON re.RegistryVersionId = p.RegistryVersionId
	INNER JOIN UnifiedMetadata_Stage.dd.ConstraintDefinitions cd
	ON cd.RegistryElementId = re.RegistryElementId
    INNER JOIN UnifiedMetadata_Stage.dd.ConstraintDefinitionScopes cds
        ON cds.ConstraintDefinitionScopeId = cd.ConstraintDefinitionScopeId
WHERE p.ProjectId = @ProjectID
)
MERGE INTO UnifiedMetadata.dd.ConstraintDefinitionScopes WITH(TABLOCK) AS T
USING Source AS S
ON S.ConstraintDefinitionScopeId = T.ConstraintDefinitionScopeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ConstraintDefinitionScopeName, 
S.ConstraintDefinitionScopeDescription, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.ConstraintDefinitionScopeName, 
T.ConstraintDefinitionScopeDescription, 
T.UpdatedBy)


THEN UPDATE SET 
ConstraintDefinitionScopeName			=	S.ConstraintDefinitionScopeName, 
ConstraintDefinitionScopeDescription	=	S.ConstraintDefinitionScopeDescription, 
UpdatedBy								=	S.UpdatedBy ,
UpdatedDate								=	DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConstraintDefinitionScopeId, 
ConstraintDefinitionScopeName, 
ConstraintDefinitionScopeDescription, 
UpdatedBy
) VALUES (
ConstraintDefinitionScopeId, 
ConstraintDefinitionScopeName, 
ConstraintDefinitionScopeDescription, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConstraintDefinitionScopeId,deleted.ConstraintDefinitionScopeId), 
	CASE WHEN deleted.ConstraintDefinitionScopeId IS NULL AND Inserted.ConstraintDefinitionScopeId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConstraintDefinitionScopeId IS NOT NULL AND Inserted.ConstraintDefinitionScopeId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dd.pr_PublishConstraintDefinitionScopes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
