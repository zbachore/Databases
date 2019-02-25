SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistryElements_ConstraintDefinitions] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistryElements_ConstraintDefinitions stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryElements_ConstraintDefinitions 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-01-24		zbachore		Changed the join to RegistryElements instead of Project
2019-02-08		zbachore		Modified the delete logic
2019-02-15		zbachore		Added dbo.RegistryElements_ConstraintDefinitions to backup the rdd
								table because other stored procedures use the rows for delete
								logic.
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryElements_ConstraintDefinitions',
		@ColumnName VARCHAR(MAX) = 'RegistryElementsConstraintDefinitionsID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;


BEGIN TRY
BEGIN TRAN;

DROP TABLE IF EXISTS UnifiedMetadata.dbo.RegistryElements_ConstraintDefinitions

--this table is used in other stored procedures that join to
--rdd.RegistryElements_ConstraintDefinitions for delete logic:
SELECT * INTO UnifiedMetadata.dbo.RegistryElements_ConstraintDefinitions
FROM UnifiedMetadata.rdd.RegistryElements_ConstraintDefinitions

--We need this for deletes
SELECT @RegistryVersionID = RegistryVersionID 
FROM UnifiedMetadata_Stage.dbo.Project 
WHERE ProjectID = @ProjectID;

WITH Source AS (
SELECT DISTINCT recd.RegistryElementsConstraintDefinitionsID,
                recd.RegistryElementId,
                recd.ConstraintDefinitionId,
                recd.CreatedDate,
                recd.UpdatedDate 
FROM UnifiedMetadata_Stage.rdd.RegistryElements re 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements_ConstraintDefinitions recd
ON recd.RegistryElementId = re.RegistryElementId
WHERE re.RegistryVersionId = @RegistryVersionID

)
	
MERGE INTO UnifiedMetadata.rdd.RegistryElements_ConstraintDefinitions WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryElementsConstraintDefinitionsID = T.RegistryElementsConstraintDefinitionsID

WHEN NOT MATCHED BY SOURCE
AND T.RegistryElementsConstraintDefinitionsID IN
(
SELECT recd.RegistryElementsConstraintDefinitionsID
FROM UnifiedMetadata.rdd.RegistryElements re 
INNER JOIN UnifiedMetadata.rdd.RegistryElements_ConstraintDefinitions recd
ON recd.RegistryElementId = re.RegistryElementId
WHERE re.RegistryVersionId = @RegistryVersionID
EXCEPT
SELECT recd.RegistryElementsConstraintDefinitionsID
FROM UnifiedMetadata_Stage.rdd.RegistryElements_ConstraintDefinitions recd
)
THEN DELETE

WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistryElementId, 
S.ConstraintDefinitionId 
INTERSECT
SELECT	
T.RegistryElementId, 
T.ConstraintDefinitionId)


THEN UPDATE SET 
RegistryElementId		=	S.RegistryElementId, 
ConstraintDefinitionId	=	S.ConstraintDefinitionId ,
UpdatedDate				=	DEFAULT


WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistryElementsConstraintDefinitionsID, 
RegistryElementId, 
ConstraintDefinitionId
) VALUES (
RegistryElementsConstraintDefinitionsID, 
RegistryElementId, 
ConstraintDefinitionId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryElementsConstraintDefinitionsID,deleted.RegistryElementsConstraintDefinitionsID), 
	CASE WHEN deleted.RegistryElementsConstraintDefinitionsID IS NULL 
	AND Inserted.RegistryElementsConstraintDefinitionsID IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.RegistryElementsConstraintDefinitionsID IS NOT NULL 
	AND Inserted.RegistryElementsConstraintDefinitionsID IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.RegistryElementsConstraintDefinitionsID IS NOT NULL 
	AND Inserted.RegistryElementsConstraintDefinitionsID IS NULL 
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistryElements_ConstraintDefinitions:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
