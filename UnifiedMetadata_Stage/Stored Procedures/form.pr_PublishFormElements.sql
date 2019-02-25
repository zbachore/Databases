SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [form].[pr_PublishFormElements] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines form.pr_PublishFormElements stored procedure
___________________________________________________________________________________________________
Example: EXEC form.pr_PublishFormElements 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns fe.CreatedDate,fe.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'FormElements',
		@ColumnName VARCHAR(MAX) = 'FormElementId',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;

BEGIN TRY
BEGIN TRAN;

SELECT @RegistryVersionID = RegistryVersionID FROM dbo.Project
WHERE ProjectId = @ProjectID; 

MERGE INTO UnifiedMetadata.form.FormElements T
USING UnifiedMetadata_Stage.form.formElements S
ON S.FormElementId = T.FormElementId

WHEN NOT MATCHED BY SOURCE 
AND EXISTS 
(SELECT 
fe.RegistryElementId, 
fe.FormSectionId, 
fe.DynamicFormElementId, 
fe.DynamicFormElementProperty, 
fe.UiProperties, 
fe.UpdatedBy, 
fe.FormElementHelpText, 
fe.IsHidden 
FROM UnifiedMetadata.rdd.RegistryElements re
INNER JOIN UnifiedMetadata.form.FormElements fe
ON fe.RegistryElementId = re.RegistryElementId
AND re.RegistryVersionId = @RegistryVersionID
EXCEPT
SELECT		
S.RegistryElementId, 
S.FormSectionId, 
S.DynamicFormElementId, 
S.DynamicFormElementProperty, 
S.UiProperties, 
S.UpdatedBy, 
S.FormElementHelpText, 
S.IsHidden
FROM UnifiedMetadata_Stage.form.formElements S)
THEN DELETE

	OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormElementId,deleted.FormElementId), 
	CASE 
	WHEN deleted.FormElementId IS NOT NULL 
	AND Inserted.FormElementId IS NULL 
	THEN 'Deleted'
	ELSE NULL END,
	'Publish',
	@RequestedTime, 
	SYSDATETIME()
INTO dbo.PublishLog;



SELECT @RegistryVersionID = RegistryVersionID FROM dbo.Project
WHERE ProjectId = @ProjectID; 

WITH Source AS (
SELECT DISTINCT fe.FormElementId,
				fe.RegistryElementId,
				fe.FormSectionId,
				fe.DynamicFormElementId,
				fe.DynamicFormElementProperty,
				fe.UiProperties,
				fe.UpdatedBy,
				fe.FormElementHelpText,
				fe.IsHidden
FROM UnifiedMetadata_Stage.dbo.Project p
    INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re
        ON re.RegistryVersionId = p.RegistryVersionId
    INNER JOIN UnifiedMetadata_Stage.form.FormElements fe
        ON fe.RegistryElementId = re.RegistryElementId
WHERE p.RegistryVersionId = @RegistryVersionID
)
	
MERGE INTO UnifiedMetadata.form.FormElements WITH(TABLOCK) AS T
USING Source AS S
ON S.FormElementId = T.FormElementId


WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistryElementId, 
S.FormSectionId, 
S.DynamicFormElementId, 
S.DynamicFormElementProperty, 
S.UiProperties, 
S.UpdatedBy, 
S.FormElementHelpText, 
S.IsHidden 
INTERSECT
SELECT		
T.RegistryElementId, 
T.FormSectionId, 
T.DynamicFormElementId, 
T.DynamicFormElementProperty, 
T.UiProperties, 
T.UpdatedBy, 
T.FormElementHelpText, 
T.IsHidden)
THEN UPDATE SET 
RegistryElementId			=	S.RegistryElementId, 
FormSectionId				=	S.FormSectionId, 
DynamicFormElementId		=	S.DynamicFormElementId, 
DynamicFormElementProperty	=	S.DynamicFormElementProperty, 
UiProperties				=	S.UiProperties, 
UpdatedBy					=	S.UpdatedBy, 
FormElementHelpText			=	S.FormElementHelpText, 
IsHidden					=	S.IsHidden ,
UpdatedDate					=	DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
FormElementId, 
RegistryElementId, 
FormSectionId, 
DynamicFormElementId, 
DynamicFormElementProperty, 
UiProperties, 
UpdatedBy, 
FormElementHelpText, 
IsHidden
) VALUES (
FormElementId, 
RegistryElementId, 
FormSectionId, 
DynamicFormElementId, 
DynamicFormElementProperty, 
UiProperties, 
UpdatedBy, 
FormElementHelpText, 
IsHidden)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormElementId,deleted.FormElementId), 
	CASE WHEN deleted.FormElementId IS NULL 
	AND Inserted.FormElementId IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.FormElementId IS NOT NULL 
	AND Inserted.FormElementId IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.FormElementId IS NOT NULL 
	AND Inserted.FormElementId IS NULL 
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
    SET @ErrorMessage = 'form.pr_PublishFormElements:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
