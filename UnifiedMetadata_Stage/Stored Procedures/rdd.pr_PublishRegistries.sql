SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistries] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines rdd.pr_PublishRegistries stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistries 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Registries',
		@ColumnName VARCHAR(MAX) = 'RegistryID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    r.RegistryId,
    r.ProductId,
    r.RegistryShortName,
    r.RegistryFullName,
    r.RegistryLogo,
    r.IsActive,
    r.UpdatedBy,
    r.CreatedDate,
    r.UpdatedDate
FROM UnifiedMetadata_Stage.rdd.Registries r
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersions rv 
ON rv.RegistryId = r.RegistryId 
INNER JOIN UnifiedMetadata_Stage.dbo.Project p ON p.RegistryVersionId = rv.RegistryVersionId
WHERE p.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.rdd.Registries WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryId = T.RegistryId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ProductId, 
S.RegistryShortName, 
S.RegistryFullName, 
S.RegistryLogo, 
S.IsActive, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.ProductId, 
T.RegistryShortName, 
T.RegistryFullName, 
T.RegistryLogo, 
T.IsActive, 
T.UpdatedBy)


THEN UPDATE SET 
ProductId						=	S.ProductId, 
RegistryShortName						=	S.RegistryShortName, 
RegistryFullName						=	S.RegistryFullName, 
RegistryLogo						=	S.RegistryLogo, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT


WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistryId, 
ProductId, 
RegistryShortName, 
RegistryFullName, 
RegistryLogo, 
IsActive, 
UpdatedBy
) VALUES (
RegistryId, 
ProductId, 
RegistryShortName, 
RegistryFullName, 
RegistryLogo, 
IsActive, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryID,deleted.RegistryID), 
	CASE WHEN deleted.RegistryID IS NULL AND Inserted.RegistryID IS NOT NULL THEN 'Inserted'
	WHEN deleted.RegistryID IS NOT NULL AND Inserted.RegistryID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistries:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END

GO
