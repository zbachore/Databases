SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [form].[pr_PublishFormPages] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines form.pr_PublishFormPages stored procedure
___________________________________________________________________________________________________
Example: EXEC form.pr_PublishFormPages 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-01-23		zbachore		Added UiProperties column
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'FormPages',
		@ColumnName VARCHAR(MAX) = 'FormPageID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT,
		@FormID INT;

BEGIN TRY
BEGIN TRAN;

SELECT @RegistryVersionID = RegistryVersionID 
FROM dbo.project WHERE ProjectId = @ProjectID 

SELECT @FormID = FormID 
FROM form.forms WHERE RegistryVersionId = @RegistryVersionID;

WITH Source AS (
SELECT DISTINCT fp.FormPageId,
				fp.FormId,
				fp.ParentFormPageId,
				fp.FormPageLocationId,
				fp.FormPageTitle,
				fp.FormPageShortName,
				fp.FormPageDescription,
				fp.IsRepeatable,
				fp.DisplayOrder,
				fp.UpdatedBy,
				fp.IdentityFormElementId,
				fp.UiProperties
FROM UnifiedMetadata_Stage.form.FormPages fp
WHERE fp.FormId = @FormID 
)
	
MERGE INTO UnifiedMetadata.form.FormPages WITH(TABLOCK) AS T
USING Source AS S
ON S.FormPageId = T.FormPageId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.FormId, 
S.ParentFormPageId, 
S.FormPageLocationId, 
S.FormPageTitle, 
S.FormPageShortName, 
S.FormPageDescription, 
S.IsRepeatable, 
S.DisplayOrder, 
S.UpdatedBy, 
S.IdentityFormElementId,
S.UiProperties
INTERSECT
SELECT		
T.FormId, 
T.ParentFormPageId, 
T.FormPageLocationId, 
T.FormPageTitle, 
T.FormPageShortName, 
T.FormPageDescription, 
T.IsRepeatable, 
T.DisplayOrder, 
T.UpdatedBy, 
T.IdentityFormElementId,
T.UiProperties
)
THEN UPDATE SET 
FormId						    =	S.FormId, 
ParentFormPageId				=	S.ParentFormPageId, 
FormPageLocationId				=	S.FormPageLocationId, 
FormPageTitle					=	S.FormPageTitle, 
FormPageShortName				=	S.FormPageShortName, 
FormPageDescription				=	S.FormPageDescription, 
IsRepeatable					=	S.IsRepeatable, 
DisplayOrder					=	S.DisplayOrder, 
UpdatedBy						=	S.UpdatedBy, 
IdentityFormElementId			=	S.IdentityFormElementId ,
UiProperties					=	S.UiProperties,
UpdatedDate			            = DEFAULT

WHEN NOT MATCHED BY SOURCE 
AND EXISTS (
SELECT formPageID 
FROM UnifiedMetadata.form.FormPages fp
WHERE fp.FormId = @FormID 
EXCEPT
SELECT FormPageID 
FROM UnifiedMetadata_Stage.form.FormPages fp 
)
THEN DELETE

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
FormPageId, 
FormId, 
ParentFormPageId, 
FormPageLocationId, 
FormPageTitle, 
FormPageShortName, 
FormPageDescription, 
IsRepeatable, 
DisplayOrder, 
UpdatedBy, 
IdentityFormElementId,
UiProperties
) VALUES (
FormPageId, 
FormId, 
ParentFormPageId, 
FormPageLocationId, 
FormPageTitle, 
FormPageShortName, 
FormPageDescription, 
IsRepeatable, 
DisplayOrder, 
UpdatedBy, 
IdentityFormElementId,
UiProperties)
OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormPageID, deleted.FormPageID), 
	CASE WHEN deleted.FormPageID IS NULL 
	AND Inserted.FormPageID IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.FormPageID IS NOT NULL 
	AND Inserted.FormPageID IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.FormPageID IS NOT NULL 
	AND Inserted.FormPageID IS NULL 
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
    SET @ErrorMessage = 'form.pr_PublishFormPages:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
