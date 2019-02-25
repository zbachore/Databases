SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [form].[pr_PublishFormSectionConstraintDefintitions] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines form.pr_PublishFormSectionConstraintDefintitions stored procedure
___________________________________________________________________________________________________
Example: EXEC form.pr_PublishFormSectionConstraintDefintitions 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-01-24		zbachore		Changed the join to RegistryElements instead of Project
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'FormSectionConstraintDefintitions',
		@ColumnName VARCHAR(MAX) = 'FormSectionConstraintDefintitionsID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;


BEGIN TRY
BEGIN TRAN;

--We need this for deletes
SELECT TOP 1 @RegistryVersionID = RegistryVersionID 
FROM UnifiedMetadata_Stage.dbo.Project 
WHERE ProjectID = @ProjectID;

WITH Source AS (
SELECT DISTINCT fscd.FormSectionConstraintDefintitionsID,
				fscd.FormSectionId,
				fscd.ConstraintDefinitionId    
FROM UnifiedMetadata_Stage.form.Forms f
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re
        ON f.RegistryVersionId = re.RegistryVersionId
	INNER JOIN UnifiedMetadata_Stage.form.FormPages fp
	ON fp.FormId = f.FormId
	INNER JOIN UnifiedMetadata_Stage.form.FormSections fs 
	ON fs.FormPageId = fp.FormPageId
    INNER JOIN UnifiedMetadata_Stage.form.FormSectionConstraintDefintitions fscd
	ON fscd.FormSectionId = fs.FormSectionId
	WHERE re.RegistryVersionId = @RegistryVersionID
	)	
MERGE INTO UnifiedMetadata.form.FormSectionConstraintDefintitions WITH(TABLOCK) AS T
USING Source AS S
ON S.FormSectionConstraintDefintitionsID = T.FormSectionConstraintDefintitionsID

WHEN NOT MATCHED BY SOURCE
AND T.FormSectionConstraintDefintitionsID IN 
(SELECT fscd.FormSectionConstraintDefintitionsID
FROM UnifiedMetadata_Stage.form.Forms f
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re
        ON f.RegistryVersionId = re.RegistryVersionId
	INNER JOIN UnifiedMetadata_Stage.form.FormPages fp
	ON fp.FormId = f.FormId
	INNER JOIN UnifiedMetadata_Stage.form.FormSections fs 
	ON fs.FormPageId = fp.FormPageId
    INNER JOIN UnifiedMetadata_Stage.form.FormSectionConstraintDefintitions fscd
	ON fscd.FormSectionId = fs.FormSectionId
	WHERE re.RegistryVersionId = @RegistryVersionID
	)
	THEN DELETE

WHEN MATCHED AND NOT EXISTS
(SELECT 
S.FormSectionId, 
S.ConstraintDefinitionId 
INTERSECT
SELECT		
T.FormSectionId, 
T.ConstraintDefinitionId)
THEN UPDATE SET 
FormSectionId			=	S.FormSectionId, 
ConstraintDefinitionId	=	S.ConstraintDefinitionId ,
UpdatedDate				=	DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
FormSectionConstraintDefintitionsID, 
FormSectionId, 
ConstraintDefinitionId
) VALUES (
FormSectionConstraintDefintitionsID, 
FormSectionId, 
ConstraintDefinitionId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormSectionConstraintDefintitionsID,deleted.FormSectionConstraintDefintitionsID), 
	CASE WHEN deleted.FormSectionConstraintDefintitionsID IS NULL 
	AND Inserted.FormSectionConstraintDefintitionsID IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.FormSectionConstraintDefintitionsID IS NOT NULL 
	AND Inserted.FormSectionConstraintDefintitionsID IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.FormSectionConstraintDefintitionsID IS NOT NULL 
	AND Inserted.FormSectionConstraintDefintitionsID IS NULL 
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
    SET @ErrorMessage = 'form.pr_PublishFormSectionConstraintDefintitions:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
