SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistryDataSets] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistryDataSets stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryDataSets 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryDataSets',
		@ColumnName VARCHAR(MAX) = 'RegistryDataSetId',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;

BEGIN TRY
BEGIN TRAN;

SELECT @RegistryVersionID = RegistryVersionID 
FROM dbo.Project 
WHERE ProjectID = @ProjectID;

WITH Source AS (
SELECT DISTINCT rds.RegistryDataSetId,
                rds.RegistryVersionId,
                rds.RegistryDataSetName,
                rds.IsActive,
                rds.UpdatedBy,
                rds.CreatedDate,
                rds.UpdatedDate,
                rds.Abbreviation,
                rds.RegistryDataSetDescription 
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryDataSets rds 
ON rds.RegistryVersionId = p.RegistryVersionId
WHERE p.RegistryVersionId = @RegistryVersionID
)	
MERGE INTO UnifiedMetadata.rdd.RegistryDataSets WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryDataSetId = T.RegistryDataSetId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistryVersionId, 
S.RegistryDataSetName, 
S.IsActive, 
S.UpdatedBy, 
S.Abbreviation, 
S.RegistryDataSetDescription 

INTERSECT

SELECT
 
		
T.RegistryVersionId, 
T.RegistryDataSetName, 
T.IsActive, 
T.UpdatedBy, 
T.Abbreviation, 
T.RegistryDataSetDescription)


THEN UPDATE SET 
RegistryVersionId						=	S.RegistryVersionId, 
RegistryDataSetName						=	S.RegistryDataSetName, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy, 
Abbreviation						=	S.Abbreviation, 
RegistryDataSetDescription						=	S.RegistryDataSetDescription ,
UpdatedDate			= DEFAULT

WHEN NOT MATCHED BY SOURCE 
AND T.RegistryDataSetId IN 
(
SELECT RegistryDataSetID 
FROM UnifiedMetadata.rdd.RegistryDataSets 
WHERE RegistryVersionId = @RegistryVersionID
)
THEN DELETE


WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistryDataSetId, 
RegistryVersionId, 
RegistryDataSetName, 
IsActive, 
UpdatedBy, 
Abbreviation, 
RegistryDataSetDescription
) VALUES (
RegistryDataSetId, 
RegistryVersionId, 
RegistryDataSetName, 
IsActive, 
UpdatedBy, 
Abbreviation, 
RegistryDataSetDescription)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryDataSetId,deleted.RegistryDataSetId), 
	CASE WHEN deleted.RegistryDataSetId IS NULL 
	AND Inserted.RegistryDataSetId IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.RegistryDataSetId IS NOT NULL 
	AND Inserted.RegistryDataSetId IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.RegistryDataSetId IS NOT NULL 
	AND Inserted.RegistryDataSetId IS NULL 
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistryDataSets:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
