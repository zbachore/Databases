SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [form].[pr_PublishFormSectionTypes] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines form.pr_PublishFormSectionTypes stored procedure
___________________________________________________________________________________________________
Example: EXEC form.pr_PublishFormSectionTypes 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'FormSectionTypes',
		@ColumnName VARCHAR(MAX) = 'FormSectionTypeId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT fst.FormSectionTypeId,
       fst.FormSectionTypeName,
       fst.FormSectionTypeShortName,
       fst.FormSectionTypeDescription,
       fst.IsRepeatable,
       fst.UpdatedBy,
       fst.CreatedDate,
       fst.UpdatedDate
FROM UnifiedMetadata_Stage.dbo.Project AS p
    INNER JOIN UnifiedMetadata_Stage.form.Forms f
        ON f.RegistryVersionId = p.RegistryVersionId
	INNER JOIN UnifiedMetadata_Stage.form.FormPages fp
	ON fp.FormId = f.FormId
	INNER JOIN UnifiedMetadata_Stage.form.FormSections fs 
	ON fs.FormPageId = fp.FormPageId
    INNER JOIN UnifiedMetadata_Stage.form.FormSectionTypes fst 
	ON fst.FormSectionTypeId = fs.FormSectionTypeId
	WHERE p.ProjectId = @ProjectID
	)
MERGE INTO UnifiedMetadata.form.FormSectionTypes WITH(TABLOCK) AS T
USING Source AS S
ON S.FormSectionTypeId = T.FormSectionTypeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.FormSectionTypeName, 
S.FormSectionTypeShortName, 
S.FormSectionTypeDescription, 
S.IsRepeatable, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.FormSectionTypeName, 
T.FormSectionTypeShortName, 
T.FormSectionTypeDescription, 
T.IsRepeatable, 
T.UpdatedBy)


THEN UPDATE SET 
FormSectionTypeName						=	S.FormSectionTypeName, 
FormSectionTypeShortName						=	S.FormSectionTypeShortName, 
FormSectionTypeDescription						=	S.FormSectionTypeDescription, 
IsRepeatable						=	S.IsRepeatable, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
FormSectionTypeId, 
FormSectionTypeName, 
FormSectionTypeShortName, 
FormSectionTypeDescription, 
IsRepeatable, 
UpdatedBy
) VALUES (
FormSectionTypeId, 
FormSectionTypeName, 
FormSectionTypeShortName, 
FormSectionTypeDescription, 
IsRepeatable, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormSectionTypeId,deleted.FormSectionTypeId), 
	CASE WHEN deleted.FormSectionTypeId IS NULL AND Inserted.FormSectionTypeId IS NOT NULL THEN 'Inserted'
	WHEN deleted.FormSectionTypeId IS NOT NULL AND Inserted.FormSectionTypeId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'form.pr_PublishFormSectionTypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
