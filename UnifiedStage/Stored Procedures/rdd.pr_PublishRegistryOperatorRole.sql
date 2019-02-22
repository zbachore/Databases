SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [rdd].[pr_PublishRegistryOperatorRole] @ProjectID INT, @PublishQueueID INT 
AS
BEGIN
/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistryOperatorRole stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryOperatorRole 12,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryOperatorRole',
		@ColumnName VARCHAR(MAX) = 'RegistryOperatorRoleID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT Distinct
	ror.RegistryOperatorRoleID,
	ror.RegistryID,
	ror.OperatorRoleConceptID,
	ror.UpdatedBy
FROM UnifiedMetadata_Stage.rdd.RegistryOperatorRole ror
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersions rv ON ror.RegistryID = rv.RegistryID
INNER JOIN UnifiedMetadata_Stage.dbo.Project p ON p.RegistryVersionId = rv.RegistryVersionId
WHERE p.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.rdd.RegistryOperatorRole WITH(TABLOCK) AS T 
USING Source AS S ON S.RegistryOperatorRoleID = T.RegistryOperatorRoleID

WHEN MATCHED AND NOT EXISTS 
(SELECT 
	S.RegistryID,
	S.OperatorRoleConceptID,
	S.UpdatedBy
	INTERSECT
SELECT 
	T.RegistryID,
	T.OperatorRoleConceptID,
	T.UpdatedBy
	)
THEN UPDATE SET 
	RegistryID = S.RegistryID,
	OperatorRoleConceptID = S.OperatorRoleConceptID,
	UpdatedBy = S.UpdatedBy

WHEN NOT MATCHED BY TARGET 
THEN INSERT
(	RegistryOperatorRoleID,
	RegistryID,
	OperatorRoleConceptID,
	UpdatedBy
	) VALUES (
	RegistryOperatorRoleID,
	RegistryID,
	OperatorRoleConceptID,
	UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryOperatorRoleID,deleted.RegistryOperatorRoleID), 
	CASE WHEN deleted.RegistryOperatorRoleID IS NULL AND Inserted.RegistryOperatorRoleID IS NOT NULL THEN 'Inserted'
	WHEN deleted.RegistryOperatorRoleID IS NOT NULL AND Inserted.RegistryOperatorRoleID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistryOperatorRole:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
