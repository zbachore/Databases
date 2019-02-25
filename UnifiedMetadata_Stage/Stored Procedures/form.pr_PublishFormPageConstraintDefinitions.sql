SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [form].[pr_PublishFormPageConstraintDefinitions] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines form.pr_PublishFormPageConstraintDefinitions stored procedure
___________________________________________________________________________________________________
Example: EXEC form.pr_PublishFormPageConstraintDefinitions 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-01-24		zbachore		Changed the join to RegistryElements instead of Project
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'FormPageConstraintDefinitions',
		@ColumnName VARCHAR(MAX) = 'FormPageConstraintDefinitionsID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;


BEGIN TRY
BEGIN TRAN;

--We need this for deletes
SELECT TOP 1 @RegistryVersionID = RegistryVersionID 
FROM UnifiedMetadata_Stage.dbo.Project 
WHERE ProjectID = @ProjectID;

WITH Source AS (
SELECT DISTINCT fpcd.FormPageConstraintDefinitionsID,
       fpcd.FormPageId,
       fpcd.ConstraintDefinitionId,
       fpcd.CreatedDate,
       fpcd.UpdatedDate
FROM UnifiedMetadata_Stage.form.Forms f
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re
ON f.RegistryVersionId = re.RegistryVersionId
    INNER JOIN UnifiedMetadata_Stage.form.FormPages fp
        ON fp.FormId = f.FormId
    INNER JOIN UnifiedMetadata_Stage.form.FormPageConstraintDefinitions fpcd
        ON fpcd.FormPageId = fp.FormPageId
WHERE f.RegistryVersionId = @RegistryVersionID
)	
MERGE INTO UnifiedMetadata.form.FormPageConstraintDefinitions WITH(TABLOCK) AS T
USING Source AS S
ON S.FormPageConstraintDefinitionsID = T.FormPageConstraintDefinitionsID

WHEN NOT MATCHED BY SOURCE
AND T.FormPageConstraintDefinitionsID IN
(
SELECT fpcd.FormPageConstraintDefinitionsID
FROM UnifiedMetadata.form.Forms f
INNER JOIN UnifiedMetadata.rdd.RegistryElements re
ON f.RegistryVersionId = re.RegistryVersionId
    INNER JOIN UnifiedMetadata.form.FormPages fp
        ON fp.FormId = f.FormId
    INNER JOIN UnifiedMetadata.form.FormPageConstraintDefinitions fpcd
        ON fpcd.FormPageId = fp.FormPageId
WHERE f.RegistryVersionId = @RegistryVersionID
)
THEN DELETE 

WHEN MATCHED AND NOT EXISTS
(SELECT 
S.FormPageId, 
S.ConstraintDefinitionId 
INTERSECT
SELECT		
T.FormPageId, 
T.ConstraintDefinitionId)
THEN UPDATE SET 
FormPageId				=	S.FormPageId, 
ConstraintDefinitionId	=	S.ConstraintDefinitionId ,
UpdatedDate				=	DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
FormPageConstraintDefinitionsID, 
FormPageId, 
ConstraintDefinitionId
) VALUES (
FormPageConstraintDefinitionsID, 
FormPageId, 
ConstraintDefinitionId)
OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.FormPageConstraintDefinitionsID,deleted.FormPageConstraintDefinitionsID), 
	CASE WHEN deleted.FormPageConstraintDefinitionsID IS NULL 
	AND Inserted.FormPageConstraintDefinitionsID IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.FormPageConstraintDefinitionsID IS NOT NULL 
	AND Inserted.FormPageConstraintDefinitionsID IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.FormPageConstraintDefinitionsID IS NOT NULL 
	AND Inserted.FormPageConstraintDefinitionsID IS NULL 
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
    SET @ErrorMessage = 'form.pr_PublishFormPageConstraintDefinitions:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
