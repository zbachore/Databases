SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [form].[pr_PublishFormPageLocations] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines form.pr_PublishFormPageLocations stored procedure
___________________________________________________________________________________________________
Example: EXEC form.pr_PublishFormPageLocations 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'FormPageLocations',
		@ColumnName VARCHAR(MAX) = 'FormPageLocationId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT fpl.FormPageLocationId,
       fpl.FormPageLocationName,
       fpl.FormPageLocationValue,
       fpl.UpdatedBy,
       fpl.CreatedDate,
       fpl.UpdatedDate
FROM UnifiedMetadata_Stage.dbo.Project p
    INNER JOIN UnifiedMetadata_Stage.form.Forms f
        ON f.RegistryVersionId = p.RegistryVersionId
    INNER JOIN UnifiedMetadata_Stage.form.FormPages fp
        ON fp.FormId = f.FormId
    INNER JOIN UnifiedMetadata_Stage.form.FormPageLocations fpl
        ON fpl.FormPageLocationId = fp.FormPageLocationId
WHERE p.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.form.FormPageLocations WITH(TABLOCK) AS T
USING Source AS S
ON S.FormPageLocationId = T.FormPageLocationId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.FormPageLocationName, 
S.FormPageLocationValue, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.FormPageLocationName, 
T.FormPageLocationValue, 
T.UpdatedBy)


THEN UPDATE SET 
FormPageLocationName	=	S.FormPageLocationName, 
FormPageLocationValue	=	S.FormPageLocationValue, 
UpdatedBy				=	S.UpdatedBy ,
UpdatedDate				=	DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
FormPageLocationId, 
FormPageLocationName, 
FormPageLocationValue, 
UpdatedBy
) VALUES (
FormPageLocationId, 
FormPageLocationName, 
FormPageLocationValue, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormPageLocationId,deleted.FormPageLocationId), 
	CASE WHEN deleted.FormPageLocationId IS NULL AND Inserted.FormPageLocationId IS NOT NULL THEN 'Inserted'
	WHEN deleted.FormPageLocationId IS NOT NULL AND Inserted.FormPageLocationId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'form.pr_PublishFormPageLocations:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
