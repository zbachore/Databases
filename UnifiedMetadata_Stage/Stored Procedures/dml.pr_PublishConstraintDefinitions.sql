SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishConstraintDefinitions] 
@PublishQueueID INT, @ValueSetID INT, @RegistryVersionID int
AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			UMDT-4692
Developer:		zbachore
Date:			November 2, 2018
Description:	Defines dml.pr_PublishConstraintDefinitions stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishConstraintDefinitions 3,360,6
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max) = 'An error occurred in procedure: ',
		@Procedure VARCHAR(MAX) =   OBJECT_NAME(@@PROCID),
		@TableName VARCHAR(MAX) = 'ConstraintDefinitions',
		@ColumnName VARCHAR(MAX) = 'ConstraintDefinitionId',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@constraintIds varchar(max),
		@selectConstraintDefinition Varchar(max)


BEGIN TRY
BEGIN TRAN;

--Identify the ConstraintDefinitionIDs:
Select @constraintIds = RegistryVersionConfigurationValue 
FROM rdd.RegistryVersionConfigurations 
WHERE RegistryVersionId  = @registryVersionId and 
RegistryVersionConfigurationName = CONCAT('DLEnableElementConstraints-',@valuesetId)

If(@constraintIds IS NOT null)
BEGIN
DROP TABLE IF EXISTS dml.ConstraintDefinitions

Set @selectConstraintDefinition = 
'Select * into dml.ConstraintDefinitions From dd.ConstraintDefinitions 
where ConstraintDefinitionId In (' + @constraintIds +')'

--Insert into the table that will be used as a source:
Exec(@selectConstraintDefinition);

MERGE INTO UnifiedMetadata.dd.ConstraintDefinitions WITH(TABLOCK) AS T
USING UnifiedMetadata_Stage.dml.ConstraintDefinitions AS S
ON S.ConstraintDefinitionId = T.ConstraintDefinitionId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ConstraintTypeId, 
S.ConstraintReportingLevelId, 
S.ConstraintDefinitionName, 
S.ConstraintDefinitionDescription, 
S.IntValue, 
S.StringValue, 
S.UpdatedBy, 
S.UnitOfMeasureId, 
S.DecimalValue, 
S.RegistryElementId, 
S.ConstraintDefinitionCode, 
S.ConstraintDefinitionMessage, 
S.Operator, 
S.BooleanValue, 
S.ConstraintDefinitionScopeId, 
S.DateValue, 
S.IsNullValue, 
S.IsQC, 
S.IsDQR, 
S.IsCA 

INTERSECT

SELECT
 
		
T.ConstraintTypeId, 
T.ConstraintReportingLevelId, 
T.ConstraintDefinitionName, 
T.ConstraintDefinitionDescription, 
T.IntValue, 
T.StringValue, 
T.UpdatedBy, 
T.UnitOfMeasureId, 
T.DecimalValue, 
T.RegistryElementId, 
T.ConstraintDefinitionCode, 
T.ConstraintDefinitionMessage, 
T.Operator, 
T.BooleanValue, 
T.ConstraintDefinitionScopeId, 
T.DateValue, 
T.IsNullValue, 
T.IsQC, 
T.IsDQR, 
T.IsCA)


THEN UPDATE SET 
ConstraintTypeId				=	S.ConstraintTypeId, 
ConstraintReportingLevelId		=	S.ConstraintReportingLevelId, 
ConstraintDefinitionName		=	S.ConstraintDefinitionName, 
ConstraintDefinitionDescription	=	S.ConstraintDefinitionDescription, 
IntValue						=	S.IntValue, 
StringValue						=	S.StringValue, 
UpdatedBy						=	S.UpdatedBy, 
UnitOfMeasureId					=	S.UnitOfMeasureId, 
DecimalValue					=	S.DecimalValue, 
RegistryElementId				=	S.RegistryElementId, 
ConstraintDefinitionCode		=	S.ConstraintDefinitionCode, 
ConstraintDefinitionMessage		=	S.ConstraintDefinitionMessage, 
Operator						=	S.Operator, 
BooleanValue					=	S.BooleanValue, 
ConstraintDefinitionScopeId		=	S.ConstraintDefinitionScopeId, 
DateValue						=	S.DateValue, 
IsNullValue						=	S.IsNullValue, 
IsQC							=	S.IsQC, 
IsDQR							=	S.IsDQR, 
IsCA							=	S.IsCA ,
UpdatedDate						=	DEFAULT


OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(deleted.ConstraintDefinitionId, inserted.ConstraintDefinitionId), 
	CASE WHEN deleted.ConstraintDefinitionId IS NULL AND Inserted.ConstraintDefinitionId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConstraintDefinitionId IS NOT NULL AND Inserted.ConstraintDefinitionId IS NOT NULL THEN 'Updated'
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
