SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [form].[pr_PublishFormSections] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines form.pr_PublishFormSections stored procedure
___________________________________________________________________________________________________
Example: EXEC form.pr_PublishFormSections 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns fs.CreatedDate,fs.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'FormSections',
		@ColumnName VARCHAR(MAX) = 'FormSectionId',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT,
		@FormID INT;

BEGIN TRY
BEGIN TRAN;

SELECT @RegistryVersionID = RegistryVersionID 
FROM dbo.project WHERE ProjectId = @ProjectID 

SELECT @FormID = FormID 
FROM form.forms WHERE RegistryVersionId = @RegistryVersionID

MERGE INTO UnifiedMetadata.form.FormSections T 
USING UnifiedMetadata_Stage.form.FormSections S 
ON S.FormSectionId = T.FormSectionId

WHEN NOT MATCHED BY SOURCE
AND EXISTS (
SELECT fs.FormSectionID
FROM UnifiedMetadata.form.FormSections fs 
WHERE fs.FormPageId IN (SELECT formPageID 
FROM UnifiedMetadata.form.FormPages 
WHERE formID = @FormID)
EXCEPT
SELECT fs.FormSectionID
FROM UnifiedMetadata_Stage.form.FormSections fs 
)
THEN DELETE

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormSectionId,deleted.FormSectionId), 
	CASE 
	WHEN deleted.FormSectionId IS NOT NULL 
	AND Inserted.FormSectionId IS NULL 
	THEN 'Deleted'

	ELSE NULL END,
	'Publish',
	@RequestedTime, 
	SYSDATETIME()
INTO dbo.PublishLog;

WITH Source AS (
SELECT DISTINCT fs.FormSectionId,
				fs.FormPageId,
				fs.ParentFormSectionId,
				fs.FormSectionTypeId,
				fs.DynamicFormElementId,
				fs.FormSectionTitle,
				fs.FormSectionShortName,
				fs.FormSectionDescription,
				fs.UiProperties,
				fs.UpdatedBy,
				fs.DisplayOrder,
				fs.IdentityFormElementId,
				fs.FormSectionHelpText
FROM UnifiedMetadata_Stage.form.FormSections fs 
WHERE fs.FormPageId IN (SELECT formPageID FROM form.FormPages 
WHERE formID = @FormID)
	)		
MERGE INTO UnifiedMetadata.form.FormSections WITH(TABLOCK) AS T
USING Source AS S
ON S.FormSectionId = T.FormSectionId

WHEN MATCHED AND NOT EXISTS
(SELECT 
S.FormPageId, 
S.ParentFormSectionId, 
S.FormSectionTypeId, 
S.DynamicFormElementId, 
S.FormSectionTitle, 
S.FormSectionShortName, 
S.FormSectionDescription, 
S.UiProperties, 
S.UpdatedBy, 
S.DisplayOrder, 
S.IdentityFormElementId, 
S.FormSectionHelpText 
INTERSECT
SELECT		
T.FormPageId, 
T.ParentFormSectionId, 
T.FormSectionTypeId, 
T.DynamicFormElementId, 
T.FormSectionTitle, 
T.FormSectionShortName, 
T.FormSectionDescription, 
T.UiProperties, 
T.UpdatedBy, 
T.DisplayOrder, 
T.IdentityFormElementId, 
T.FormSectionHelpText)
THEN UPDATE SET 
FormPageId						=	S.FormPageId, 
ParentFormSectionId				=	S.ParentFormSectionId, 
FormSectionTypeId				=	S.FormSectionTypeId, 
DynamicFormElementId			=	S.DynamicFormElementId, 
FormSectionTitle			    =	S.FormSectionTitle, 
FormSectionShortName			=	S.FormSectionShortName, 
FormSectionDescription			=	S.FormSectionDescription, 
UiProperties					=	S.UiProperties, 
UpdatedBy						=	S.UpdatedBy, 
DisplayOrder					=	S.DisplayOrder, 
IdentityFormElementId			=	S.IdentityFormElementId, 
FormSectionHelpText				=	S.FormSectionHelpText ,
UpdatedDate			            = DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
FormSectionId, 
FormPageId, 
ParentFormSectionId, 
FormSectionTypeId, 
DynamicFormElementId, 
FormSectionTitle, 
FormSectionShortName, 
FormSectionDescription, 
UiProperties, 
UpdatedBy, 
DisplayOrder, 
IdentityFormElementId, 
FormSectionHelpText
) VALUES (
FormSectionId, 
FormPageId, 
ParentFormSectionId, 
FormSectionTypeId, 
DynamicFormElementId, 
FormSectionTitle, 
FormSectionShortName, 
FormSectionDescription, 
UiProperties, 
UpdatedBy, 
DisplayOrder, 
IdentityFormElementId, 
FormSectionHelpText)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormSectionId,deleted.FormSectionId), 
	CASE WHEN deleted.FormSectionId IS NULL 
	AND Inserted.FormSectionId IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.FormSectionId IS NOT NULL 
	AND Inserted.FormSectionId IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.FormSectionId IS NOT NULL 
	AND Inserted.FormSectionId IS NULL 
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
    SET @ErrorMessage = 'form.pr_PublishFormSections:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
