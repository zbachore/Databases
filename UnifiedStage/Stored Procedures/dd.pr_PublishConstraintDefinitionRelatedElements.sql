SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dd].[pr_PublishConstraintDefinitionRelatedElements] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines dd.pr_PublishConstraintDefinitionRelatedElements stored procedure
___________________________________________________________________________________________________
Example: EXEC dd.pr_PublishConstraintDefinitionRelatedElements 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-12-14		zbachore		Added ConstraintDefinitionRelatedElementGroupId column
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ConstraintDefinitionRelatedElements',
		@ColumnName VARCHAR(MAX) = 'ConstraintDefinitionRelatedElementId',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT = (SELECT RegistryVersionID 
		FROM dbo.Project WHERE ProjectID = @ProjectID)

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT cdre.ConstraintDefinitionRelatedElementId,
				cdre.ConstraintDefinitionId,
				cdre.RegistryElementId,
				cdre.IntValue,
				cdre.DecimalValue,
				cdre.IsNullValue,
				cdre.UpdatedBy,
				cdre.Operator,
				cdre.StringValue,
				cdre.DisplayOrder,
				cdre.ConstraintDefinitionRelatedElementGroupId
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.RegistryVersionId = p.RegistryVersionId
INNER JOIN  UnifiedMetadata_Stage.dd.ConstraintDefinitionRelatedElements cdre
ON cdre.RegistryElementId = re.RegistryElementId
WHERE p.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.dd.ConstraintDefinitionRelatedElements WITH(TABLOCK) AS T
USING Source AS S
ON S.ConstraintDefinitionRelatedElementId = T.ConstraintDefinitionRelatedElementId


WHEN NOT MATCHED BY SOURCE 
AND T.ConstraintDefinitionRelatedElementID 
IN (
SELECT ConstraintDefinitionRelatedElementID 
FROM UnifiedMetadata.dd.ConstraintDefinitionRelatedElements cdre 
INNER JOIN UnifiedMetadata.rdd.RegistryElements re 
ON re.RegistryElementId = cdre.RegistryElementId
WHERE re.RegistryVersionId = @RegistryVersionID
)
THEN DELETE


WHEN MATCHED AND NOT EXISTS
(
	SELECT 
	S.ConstraintDefinitionId, 
	S.RegistryElementId, 
	S.IntValue, 
	S.DecimalValue, 
	S.IsNullValue, 
	S.UpdatedBy, 
	S.Operator, 
	S.StringValue, 
	S.DisplayOrder,
	S.ConstraintDefinitionRelatedElementGroupId

	INTERSECT

	SELECT	
	T.ConstraintDefinitionId, 
	T.RegistryElementId, 
	T.IntValue, 
	T.DecimalValue, 
	T.IsNullValue, 
	T.UpdatedBy, 
	T.Operator, 
	T.StringValue, 
	T.DisplayOrder,
	T.ConstraintDefinitionRelatedElementGroupId
)


THEN UPDATE SET 
ConstraintDefinitionId			=	S.ConstraintDefinitionId, 
RegistryElementId				=	S.RegistryElementId, 
IntValue						=	S.IntValue, 
DecimalValue					=	S.DecimalValue, 
IsNullValue						=	S.IsNullValue, 
UpdatedBy						=	S.UpdatedBy, 
Operator						=	S.Operator, 
StringValue						=	S.StringValue, 
DisplayOrder					=	S.DisplayOrder ,
ConstraintDefinitionRelatedElementGroupId = S.ConstraintDefinitionRelatedElementGroupId,
UpdatedDate						=	DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConstraintDefinitionRelatedElementId, 
ConstraintDefinitionId, 
RegistryElementId, 
IntValue, 
DecimalValue, 
IsNullValue, 
UpdatedBy, 
Operator, 
StringValue, 
DisplayOrder,
ConstraintDefinitionRelatedElementGroupId
) VALUES (
ConstraintDefinitionRelatedElementId, 
ConstraintDefinitionId, 
RegistryElementId, 
IntValue, 
DecimalValue, 
IsNullValue, 
UpdatedBy, 
Operator, 
StringValue, 
DisplayOrder,
ConstraintDefinitionRelatedElementGroupId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConstraintDefinitionRelatedElementId,deleted.ConstraintDefinitionRelatedElementId), 
	CASE WHEN deleted.ConstraintDefinitionRelatedElementId IS NULL 
	AND Inserted.ConstraintDefinitionRelatedElementId IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.ConstraintDefinitionRelatedElementId IS NOT NULL 
	AND Inserted.ConstraintDefinitionRelatedElementId IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.ConstraintDefinitionRelatedElementId IS NOT NULL 
	AND Inserted.ConstraintDefinitionRelatedElementId IS NULL 
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
    SET @ErrorMessage = 'dd.pr_PublishConstraintDefinitionRelatedElements:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
