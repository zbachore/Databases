SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dd].[pr_PublishConstraintDefinitions] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:22AM
Description:	Defines dd.pr_PublishConstraintDefinitions stored procedure
___________________________________________________________________________________________________
Example: EXEC dd.pr_PublishConstraintDefinitions 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-01-23		zbachore		Modified delete logic
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ConstraintDefinitions',
		@ColumnName VARCHAR(MAX) = 'ConstraintDefinitionId',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;


BEGIN TRY
BEGIN TRAN;

--We need this for deletes
SELECT TOP 1 @RegistryVersionID = RegistryVersionID 
FROM UnifiedMetadata_Stage.dbo.Project 
WHERE ProjectID = @ProjectID;

WITH Source AS (
SELECT DISTINCT cd.ConstraintDefinitionId,
                cd.ConstraintTypeId,
                cd.ConstraintReportingLevelId,
                cd.ConstraintDefinitionName,
                cd.ConstraintDefinitionDescription,
                cd.IntValue,
                cd.StringValue,
                cd.UpdatedBy,
                cd.UnitOfMeasureId,
                cd.DecimalValue,
                cd.RegistryElementId,
                cd.ConstraintDefinitionCode,
                cd.ConstraintDefinitionMessage,
                cd.Operator,
                cd.BooleanValue,
                cd.ConstraintDefinitionScopeId,
                cd.DateValue,
                cd.IsNullValue,
                cd.IsQC,
                cd.IsDQR,
                cd.IsCA
FROM UnifiedMetadata_Stage.dd.ConstraintDefinitions cd
INNER JOIN UnifiedMetadata_Stage.cdd.DataElementConstraintDefinitions decd 
ON decd.ConstraintDefinitionId = cd.ConstraintDefinitionId 
INNER JOIN UnifiedMetadata_Stage.cdd.DataElements de 
ON de.DataElementId = decd.DataElementId
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.DataElementId = de.DataElementId
WHERE re.RegistryVersionId = @RegistryVersionID

UNION 

SELECT cd.ConstraintDefinitionId,
       cd.ConstraintTypeId,
       cd.ConstraintReportingLevelId,
       cd.ConstraintDefinitionName,
       cd.ConstraintDefinitionDescription,
       cd.IntValue,
       cd.StringValue,
       cd.UpdatedBy,
       cd.UnitOfMeasureId,
       cd.DecimalValue,
       cd.RegistryElementId,
       cd.ConstraintDefinitionCode,
       cd.ConstraintDefinitionMessage,
       cd.Operator,
       cd.BooleanValue,
       cd.ConstraintDefinitionScopeId,
       cd.DateValue,
       cd.IsNullValue,
       cd.IsQC,
       cd.IsDQR,
       cd.IsCA 
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.RegistryVersionId = p.RegistryVersionId 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements_ConstraintDefinitions recd
ON recd.RegistryElementId = re.RegistryElementId
INNER JOIN UnifiedMetadata_Stage.dd.ConstraintDefinitions cd 
ON cd.ConstraintDefinitionId = recd.ConstraintDefinitionId
WHERE Re.RegistryVersionId = @RegistryVersionID

UNION 
SELECT cd.ConstraintDefinitionId,
       cd.ConstraintTypeId,
       cd.ConstraintReportingLevelId,
       cd.ConstraintDefinitionName,
       cd.ConstraintDefinitionDescription,
       cd.IntValue,
       cd.StringValue,
       cd.UpdatedBy,
       cd.UnitOfMeasureId,
       cd.DecimalValue,
       cd.RegistryElementId,
       cd.ConstraintDefinitionCode,
       cd.ConstraintDefinitionMessage,
       cd.Operator,
       cd.BooleanValue,
       cd.ConstraintDefinitionScopeId,
       cd.DateValue,
       cd.IsNullValue,
       cd.IsQC,
       cd.IsDQR,
       cd.IsCA
FROM UnifiedMetadata_Stage.dbo.Project AS p
    INNER JOIN UnifiedMetadata_Stage.form.Forms f
        ON f.RegistryVersionId = p.RegistryVersionId
	INNER JOIN UnifiedMetadata_Stage.form.FormPages fp
	ON fp.FormId = f.FormId
	INNER JOIN UnifiedMetadata_Stage.form.FormSections fs 
	ON fs.FormPageId = fp.FormPageId
    INNER JOIN UnifiedMetadata_Stage.form.FormSectionConstraintDefintitions fscd
	ON fscd.FormSectionId = fs.FormSectionId
	INNER JOIN UnifiedMetadata_Stage.dd.ConstraintDefinitions cd 
	ON cd.ConstraintDefinitionId = fscd.ConstraintDefinitionId
	WHERE f.RegistryVersionId = @RegistryVersionID

	UNION 

	SELECT cd.ConstraintDefinitionId,
       cd.ConstraintTypeId,
       cd.ConstraintReportingLevelId,
       cd.ConstraintDefinitionName,
       cd.ConstraintDefinitionDescription,
       cd.IntValue,
       cd.StringValue,
       cd.UpdatedBy,
       cd.UnitOfMeasureId,
       cd.DecimalValue,
       cd.RegistryElementId,
       cd.ConstraintDefinitionCode,
       cd.ConstraintDefinitionMessage,
       cd.Operator,
       cd.BooleanValue,
       cd.ConstraintDefinitionScopeId,
       cd.DateValue,
       cd.IsNullValue,
       cd.IsQC,
       cd.IsDQR,
       cd.IsCA
FROM UnifiedMetadata_Stage.dbo.Project p
    INNER JOIN UnifiedMetadata_Stage.form.Forms f
        ON f.RegistryVersionId = p.RegistryVersionId
    INNER JOIN UnifiedMetadata_Stage.form.FormPages fp
        ON fp.FormId = f.FormId
    INNER JOIN UnifiedMetadata_Stage.form.FormPageConstraintDefinitions fpcd
        ON fpcd.FormPageId = fp.FormPageId
	INNER JOIN UnifiedMetadata_Stage.dd.ConstraintDefinitions cd 
	ON cd.ConstraintDefinitionId = fpcd.ConstraintDefinitionId
WHERE f.RegistryVersionId = @RegistryVersionID

UNION 

SELECT cd.ConstraintDefinitionId,
       cd.ConstraintTypeId,
       cd.ConstraintReportingLevelId,
       cd.ConstraintDefinitionName,
       cd.ConstraintDefinitionDescription,
       cd.IntValue,
       cd.StringValue,
       cd.UpdatedBy,
       cd.UnitOfMeasureId,
       cd.DecimalValue,
       cd.RegistryElementId,
       cd.ConstraintDefinitionCode,
       cd.ConstraintDefinitionMessage,
       cd.Operator,
       cd.BooleanValue,
       cd.ConstraintDefinitionScopeId,
       cd.DateValue,
       cd.IsNullValue,
       cd.IsQC,
       cd.IsDQR,
       cd.IsCA
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.RegistryVersionId = p.RegistryVersionId
INNER JOIN  UnifiedMetadata_Stage.dd.ConstraintDefinitionRelatedElements cdre
ON cdre.RegistryElementId = re.RegistryElementId
INNER JOIN UnifiedMetadata_Stage.dd.ConstraintDefinitions cd 
ON cd.ConstraintDefinitionId = cdre.ConstraintDefinitionId
WHERE p.RegistryVersionId = @RegistryVersionID
)
	
MERGE INTO UnifiedMetadata.dd.ConstraintDefinitions WITH(TABLOCK) AS T
USING Source AS S
ON S.ConstraintDefinitionId = T.ConstraintDefinitionId

WHEN NOT MATCHED BY SOURCE
AND T.ConstraintDefinitionId IN 
(
SELECT Distinct cd.ConstraintDefinitionId
FROM UnifiedMetadata.dd.ConstraintDefinitions cd
INNER JOIN UnifiedMetadata.cdd.DataElementConstraintDefinitions decd 
ON decd.ConstraintDefinitionId = cd.ConstraintDefinitionId
INNER JOIN UnifiedMetadata.cdd.DataElements de 
ON de.DataElementId = decd.DataElementId 
INNER JOIN UnifiedMetadata.rdd.RegistryElements re
ON re.DataElementId = de.DataElementId
WHERE re.RegistryVersionId = @RegistryVersionID
UNION
--dbo.RegistryElements_ConstraintDefinitions table is created 
--inside pr_PublishRegistryElements_ConstraintDefinitions Sp. 
--to save the rows that were deleted in that procedrue, but they are used
--in another join in this stored procedure;
SELECT Distinct cd.ConstraintDefinitionId 
FROM UnifiedMetadata.rdd.RegistryElements re 
INNER JOIN UnifiedMetadata.dbo.RegistryElements_ConstraintDefinitions recd
ON recd.RegistryElementId = re.RegistryElementId
INNER JOIN UnifiedMetadata.dd.ConstraintDefinitions cd 
ON cd.ConstraintDefinitionId = recd.ConstraintDefinitionId
WHERE re.RegistryVersionId = @RegistryVersionID
UNION 
SELECT DISTINCT cd.ConstraintDefinitionId
FROM UnifiedMetadata.form.Forms f
INNER JOIN UnifiedMetadata.form.FormPages fp
ON fp.FormId = f.FormId
INNER JOIN UnifiedMetadata.form.FormSections fs 
ON fs.FormPageId = fp.FormPageId
INNER JOIN UnifiedMetadata.form.FormSectionConstraintDefintitions fscd
ON fscd.FormSectionId = fs.FormSectionId
INNER JOIN UnifiedMetadata.dd.ConstraintDefinitions cd 
ON cd.ConstraintDefinitionId = fscd.ConstraintDefinitionId
WHERE f.RegistryVersionId = @RegistryVersionID
UNION
SELECT Distinct cd.ConstraintDefinitionId
FROM UnifiedMetadata.form.Forms f
INNER JOIN UnifiedMetadata.form.FormPages fp
ON fp.FormId = f.FormId
INNER JOIN UnifiedMetadata.form.FormPageConstraintDefinitions fpcd
ON fpcd.FormPageId = fp.FormPageId
INNER JOIN UnifiedMetadata.dd.ConstraintDefinitions cd 
ON cd.ConstraintDefinitionId = fpcd.ConstraintDefinitionId
WHERE f.RegistryVersionId = @RegistryVersionID
UNION 
SELECT Distinct cd.ConstraintDefinitionId
FROM UnifiedMetadata.rdd.RegistryElements re 
INNER JOIN  UnifiedMetadata.dd.ConstraintDefinitionRelatedElements cdre
ON cdre.RegistryElementId = re.RegistryElementId
INNER JOIN UnifiedMetadata.dd.ConstraintDefinitions cd 
ON cd.ConstraintDefinitionId = cdre.ConstraintDefinitionId
WHERE re.RegistryVersionId = @RegistryVersionID 
)
THEN DELETE 

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

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConstraintDefinitionId, 
ConstraintTypeId, 
ConstraintReportingLevelId, 
ConstraintDefinitionName, 
ConstraintDefinitionDescription, 
IntValue, 
StringValue, 
UpdatedBy, 
UnitOfMeasureId, 
DecimalValue, 
RegistryElementId, 
ConstraintDefinitionCode, 
ConstraintDefinitionMessage, 
Operator, 
BooleanValue, 
ConstraintDefinitionScopeId, 
DateValue, 
IsNullValue, 
IsQC, 
IsDQR, 
IsCA
) VALUES (
ConstraintDefinitionId, 
ConstraintTypeId, 
ConstraintReportingLevelId, 
ConstraintDefinitionName, 
ConstraintDefinitionDescription, 
IntValue, 
StringValue, 
UpdatedBy, 
UnitOfMeasureId, 
DecimalValue, 
RegistryElementId, 
ConstraintDefinitionCode, 
ConstraintDefinitionMessage, 
Operator, 
BooleanValue, 
ConstraintDefinitionScopeId, 
DateValue, 
IsNullValue, 
IsQC, 
IsDQR, 
IsCA)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConstraintDefinitionId,deleted.ConstraintDefinitionId), 
	CASE WHEN deleted.ConstraintDefinitionId IS NULL 
	AND Inserted.ConstraintDefinitionId IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.ConstraintDefinitionId IS NOT NULL 
	AND Inserted.ConstraintDefinitionId IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.ConstraintDefinitionId IS NOT NULL 
	AND Inserted.ConstraintDefinitionId IS NULL 
	THEN 'DELETED'
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
    SET @ErrorMessage = 'dd.pr_PublishConstraintDefinitions:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
