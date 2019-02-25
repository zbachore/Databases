SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dml].[pr_PublishConstraintDefinitionRelatedElements] 
@PublishQueueID INT, @ValueSetID INT, @RegistryVersionID INT
AS
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			UMDT-4692
Developer:		zbachore
Date:			November 2, 2018
Description:	Defines dml.pr_PublishConstraintDefinitionRelatedElements stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishConstraintDefinitionRelatedElements 3,360,6
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max) = 'An error occurred in procedure: ',
		@Procedure VARCHAR(MAX) =   OBJECT_NAME(@@PROCID),
		@TableName VARCHAR(MAX) = 'ConstraintDefinitionRelatedElements',
		@ColumnName VARCHAR(MAX) = 'ConstraintDefinitionRelatedElementId',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@constraintIds varchar(max),
		@selectConstraintDefinitionRelatedElement Varchar(max)

BEGIN TRY
BEGIN TRAN;

--Identify the ConstraintDefinitionIDs:
Select @constraintIds = RegistryVersionConfigurationValue 
FROM rdd.RegistryVersionConfigurations 
WHERE RegistryVersionId  = @registryVersionId and 
RegistryVersionConfigurationName = CONCAT('DLEnableElementConstraints-',@valuesetId)

If(@constraintIds IS NOT null)
BEGIN
DROP TABLE IF EXISTS dml.ConstraintDefinitionRelatedElements

Set @selectConstraintDefinitionRelatedElement = 
'Select * into dml.ConstraintDefinitionRelatedElements From dd.ConstraintDefinitionRelatedElements 
where ConstraintDefinitionId In (' + @constraintIds +')'

--Insert into the table that will be used as a source:
Exec(@selectConstraintDefinitionRelatedElement)

MERGE INTO UnifiedMetadata.dd.ConstraintDefinitionRelatedElements WITH(TABLOCK) AS T
USING UnifiedMetadata_Stage.dml.ConstraintDefinitionRelatedElements AS S
ON S.ConstraintDefinitionRelatedElementId = T.ConstraintDefinitionRelatedElementId
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
	S.DisplayOrder 

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
	T.DisplayOrder
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
UpdatedDate						=	DEFAULT



OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(deleted.ConstraintDefinitionRelatedElementId,inserted.ConstraintDefinitionRelatedElementId), 
	CASE WHEN deleted.ConstraintDefinitionRelatedElementId IS NULL AND Inserted.ConstraintDefinitionRelatedElementId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConstraintDefinitionRelatedElementId IS NOT NULL AND Inserted.ConstraintDefinitionRelatedElementId IS NOT NULL THEN 'Updated'
	ELSE NULL END,
	'Publish',
	@RequestedTime, 
	SYSDATETIME()
INTO dbo.PublishLog;
END

COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = @ErrorMessage + @Procedure + ':' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
