SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [form].[pr_PublishForms] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines form.pr_PublishForms stored procedure
___________________________________________________________________________________________________
Example: EXEC form.pr_PublishForms 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns f.CreatedDate,f.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Forms',
		@ColumnName VARCHAR(MAX) = 'FormID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;
WITH Source AS (
SELECT DISTINCT f.FormId,
				f.RegistryVersionId,
				f.FormTypeId,
				f.FormName,
				f.FormDescription,
				f.UpdatedBy       
FROM UnifiedMetadata_Stage.dbo.Project p 
INNER JOIN UnifiedMetadata_Stage.form.Forms f ON f.RegistryVersionId = p.RegistryVersionId
WHERE p.ProjectId = @ProjectID
)
MERGE INTO UnifiedMetadata.form.Forms WITH(TABLOCK) AS T
USING Source AS S
ON S.FormId = T.FormId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistryVersionId, 
S.FormTypeId, 
S.FormName, 
S.FormDescription, 
S.UpdatedBy 
INTERSECT
SELECT		
T.RegistryVersionId, 
T.FormTypeId, 
T.FormName, 
T.FormDescription, 
T.UpdatedBy)
THEN UPDATE SET 
RegistryVersionId				=	S.RegistryVersionId, 
FormTypeId						=	S.FormTypeId, 
FormName						=	S.FormName, 
FormDescription					=	S.FormDescription, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate						=	DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
FormId, 
RegistryVersionId, 
FormTypeId, 
FormName, 
FormDescription, 
UpdatedBy
) VALUES (
FormId, 
RegistryVersionId, 
FormTypeId, 
FormName, 
FormDescription, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormID,deleted.FormID), 
	CASE WHEN deleted.FormID IS NULL AND Inserted.FormID IS NOT NULL THEN 'Inserted'
	WHEN deleted.FormID IS NOT NULL AND Inserted.FormID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'form.pr_PublishForms:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
