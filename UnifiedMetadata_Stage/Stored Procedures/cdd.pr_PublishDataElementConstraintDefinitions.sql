SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishDataElementConstraintDefinitions] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 25 2018 10:16AM
Description:	Defines cdd.pr_PublishDataElementConstraintDefinitions stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishDataElementConstraintDefinitions 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-01-24		zbachore		Changed the join to RegistryElements instead of Project
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DataElementConstraintDefinitions',
		@ColumnName VARCHAR(MAX) = 'DataElementConstraintDefinitionsID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;


BEGIN TRY
BEGIN TRAN;

--We need this for deletes
SELECT TOP 1 @RegistryVersionID = RegistryVersionID 
FROM UnifiedMetadata_Stage.dbo.Project 
WHERE ProjectID = @ProjectID;

WITH Source AS (
SELECT DISTINCT decd.DataElementConstraintDefinitionsID,
				decd.DataElementId,
				decd.ConstraintDefinitionId				
FROM UnifiedMetadata_Stage.rdd.RegistryElements re
INNER JOIN UnifiedMetadata_Stage.cdd.DataElements de 
ON de.DataElementId = re.DataElementId 
INNER JOIN UnifiedMetadata_Stage.cdd.DataElementConstraintDefinitions decd 
ON decd.DataElementId = de.DataElementId
WHERE re.RegistryVersionId = @RegistryVersionID
)
	
MERGE INTO UnifiedMetadata.cdd.DataElementConstraintDefinitions WITH(TABLOCK) AS T
USING Source AS S
ON S.DataElementConstraintDefinitionsID = T.DataElementConstraintDefinitionsID

WHEN NOT MATCHED BY SOURCE
AND T.DataElementConstraintDefinitionsID IN
(
SELECT decd.DataElementConstraintDefinitionsID
FROM UnifiedMetadata.rdd.RegistryElements re
INNER JOIN UnifiedMetadata.cdd.DataElements de 
ON de.DataElementId = re.DataElementId 
INNER JOIN UnifiedMetadata.cdd.DataElementConstraintDefinitions decd 
ON decd.DataElementId = de.DataElementId
WHERE re.RegistryVersionId = @RegistryVersionID
AND decd.DataElementConstraintDefinitionsID NOT IN (
SELECT DISTINCT decd.DataElementConstraintDefinitionsID				
FROM UnifiedMetadata_Stage.rdd.RegistryElements re
INNER JOIN UnifiedMetadata_Stage.cdd.DataElements de 
ON de.DataElementId = re.DataElementId 
INNER JOIN UnifiedMetadata_Stage.cdd.DataElementConstraintDefinitions decd 
ON decd.DataElementId = de.DataElementId
WHERE re.RegistryVersionId = @RegistryVersionID
)
)
THEN DELETE

WHEN MATCHED AND NOT EXISTS
(
SELECT 
S.DataElementId, 
S.ConstraintDefinitionId 
INTERSECT
SELECT		
T.DataElementId, 
T.ConstraintDefinitionId
)
THEN UPDATE SET 
DataElementId			  =	S.DataElementId, 
ConstraintDefinitionId	  =	S.ConstraintDefinitionId ,
UpdatedDate			      = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DataElementConstraintDefinitionsID, 
DataElementId, 
ConstraintDefinitionId
) VALUES (
DataElementConstraintDefinitionsID, 
DataElementId, 
ConstraintDefinitionId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.DataElementConstraintDefinitionsID,deleted.DataElementConstraintDefinitionsID), 
	CASE WHEN deleted.DataElementConstraintDefinitionsID IS NULL 
	AND Inserted.DataElementConstraintDefinitionsID IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.DataElementConstraintDefinitionsID IS NOT NULL 
	AND Inserted.DataElementConstraintDefinitionsID IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.DataElementConstraintDefinitionsID IS NOT NULL 
	AND Inserted.DataElementConstraintDefinitionsID IS NULL 
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
    SET @ErrorMessage = 'cdd.pr_PublishDataElementConstraintDefinitions:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
