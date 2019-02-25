SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [form].[pr_PublishFormTypes] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines form.pr_PublishFormTypes stored procedure
___________________________________________________________________________________________________
Example: EXEC form.pr_PublishFormTypes 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns fscd.CreatedDate,fscd.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'FormTypes',
		@ColumnName VARCHAR(MAX) = 'FormTypeID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;
WITH Source AS (
SELECT DISTINCT ft.FormTypeId,
				ft.FormTypeName,
				ft.FormTypeDescription,
				ft.UpdatedBy				 
FROM UnifiedMetadata_Stage.dbo.Project AS p
    INNER JOIN UnifiedMetadata_Stage.form.Forms f
        ON f.RegistryVersionId = p.RegistryVersionId
    INNER JOIN UnifiedMetadata_Stage.form.FormTypes ft 
	ON ft.FormTypeId = f.FormTypeId
	WHERE p.ProjectId = @ProjectID
	)	
MERGE INTO UnifiedMetadata.form.FormTypes WITH(TABLOCK) AS T
USING Source AS S
ON S.FormTypeId = T.FormTypeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.FormTypeName, 
S.FormTypeDescription, 
S.UpdatedBy 
INTERSECT
SELECT		
T.FormTypeName, 
T.FormTypeDescription, 
T.UpdatedBy)
THEN UPDATE SET 
FormTypeName		 =	S.FormTypeName, 
FormTypeDescription	 =	S.FormTypeDescription, 
UpdatedBy			 =	S.UpdatedBy ,
UpdatedDate			 = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
FormTypeId, 
FormTypeName, 
FormTypeDescription, 
UpdatedBy
) VALUES (
FormTypeId, 
FormTypeName, 
FormTypeDescription, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormTypeID,deleted.FormTypeID), 
	CASE WHEN deleted.FormTypeID IS NULL AND Inserted.FormTypeID IS NOT NULL THEN 'Inserted'
	WHEN deleted.FormTypeID IS NOT NULL AND Inserted.FormTypeID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'form.pr_PublishFormTypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
