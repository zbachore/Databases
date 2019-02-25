SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishContainmentTypes] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishContainmentTypes stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishContainmentTypes 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ContainmentTypes',
		@ColumnName VARCHAR(MAX) = 'ContainmentTypeId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT ct.ContainmentTypeId,
                ct.ContainmentTypeName,
                ct.ContainmentTypeDescription,
                ct.UpdatedBy,
                ct.CreatedDate,
                ct.UpdatedDate 
FROM UnifiedMetadata_Stage.dbo.Project p 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.RegistryVersionId = p.RegistryVersionId
INNER JOIN UnifiedMetadata_Stage.rdd.ContainmentTypes ct 
ON ct.ContainmentTypeId = re.ContainmentTypeId
WHERE p.ProjectId = @ProjectID
)
	
MERGE INTO UnifiedMetadata.rdd.ContainmentTypes WITH(TABLOCK) AS T
USING Source AS S
ON S.ContainmentTypeId = T.ContainmentTypeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ContainmentTypeName, 
S.ContainmentTypeDescription, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.ContainmentTypeName, 
T.ContainmentTypeDescription, 
T.UpdatedBy)


THEN UPDATE SET 
ContainmentTypeName						=	S.ContainmentTypeName, 
ContainmentTypeDescription						=	S.ContainmentTypeDescription, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ContainmentTypeId, 
ContainmentTypeName, 
ContainmentTypeDescription, 
UpdatedBy
) VALUES (
ContainmentTypeId, 
ContainmentTypeName, 
ContainmentTypeDescription, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ContainmentTypeId,deleted.ContainmentTypeId), 
	CASE WHEN deleted.ContainmentTypeId IS NULL AND Inserted.ContainmentTypeId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ContainmentTypeId IS NOT NULL AND Inserted.ContainmentTypeId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'rdd.pr_PublishContainmentTypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
