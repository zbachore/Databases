SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dd].[pr_PublishConstraintDefinitionRelatedElementGroups]
@ProjectID INT, @PublishQueueID int AS 
BEGIN
/**************************************************************************************************
Project:		Metadata Tool
JIRA:			UMDT-4711
Developer:		zbachore
Date:			2018-09-07
Description:	This procedure loads data to the target table incrementally
___________________________________________________________________________________________________
Example: 
EXEC dd.pr_PublishConstraintDefinitionRelatedElementGroups 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-12-14		zbachore		Added Distinct to handle duplicates and added UpdatedBy column
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ConstraintDefinitionRelatedElementGroups',
		@ColumnName VARCHAR(MAX) = 'ConstraintDefinitionRelatedElementGroupId',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryID INT;

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT cdreg.ConstraintDefinitionRelatedElementGroupId
      ,cdreg.GroupOperator
      ,cdreg.GroupOrder
	  ,cdreg.UpdatedBy
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.RegistryVersionId = p.RegistryVersionId
INNER JOIN  UnifiedMetadata_Stage.dd.ConstraintDefinitionRelatedElements cdre
ON cdre.RegistryElementId = re.RegistryElementId
INNER JOIN UnifiedMetadata_Stage.dd.ConstraintDefinitionRelatedElementGroups cdreg
ON cdre.ConstraintDefinitionRelatedElementGroupId = cdreg.ConstraintDefinitionRelatedElementGroupId
WHERE p.ProjectId = @ProjectID
)
MERGE INTO UnifiedMetadata.dd.ConstraintDefinitionRelatedElementGroups WITH(TABLOCK) AS T
USING Source AS S
ON S.ConstraintDefinitionRelatedElementGroupID = T.ConstraintDefinitionRelatedElementGroupId
WHEN MATCHED AND NOT EXISTS  
(
SELECT s.GroupOperator
      ,s.GroupOrder
	   INTERSECT 
SELECT T.GroupOperator
      ,T.GroupOrder
)
THEN UPDATE SET 
	    GroupOperator	= s.GroupOperator,
		GroupOrder		= s.GroupOrder,
		UpdatedBy		= s.UpdatedBy,
	    UpdatedDate		=	DEFAULT 

WHEN NOT MATCHED BY TARGET
THEN INSERT
(ConstraintDefinitionRelatedElementGroupId,
 GroupOperator,
 GroupOrder,
 UpdatedBy
 ) VALUES (
 ConstraintDefinitionRelatedElementGroupId,
 GroupOperator,
 GroupOrder,
 UpdatedBy
 )

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConstraintDefinitionRelatedElementGroupId,deleted.ConstraintDefinitionRelatedElementGroupId), 
	CASE WHEN deleted.ConstraintDefinitionRelatedElementGroupId IS NULL AND Inserted.ConstraintDefinitionRelatedElementGroupId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConstraintDefinitionRelatedElementGroupId IS NOT NULL AND Inserted.ConstraintDefinitionRelatedElementGroupId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dd.pr_PublishConstraintDefinitionRelatedElementGroups:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END

GO
