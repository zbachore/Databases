SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ld].[pr_PublishComposites] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines ld.pr_PublishComposites stored procedure
___________________________________________________________________________________________________
Example: EXEC ld.pr_PublishComposites 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Composites',
		@ColumnName VARCHAR(MAX) = 'CompositeId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT c.CompositeId,
       c.CompositeName,
       c.CompositeDescription,
       c.UpdatedBy
FROM UnifiedMetadata_Stage.dbo.Project p 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersionComposites rvc 
ON rvc.RegistryVersionId = p.RegistryVersionId 
INNER JOIN UnifiedMetadata_Stage.ld.Composites c ON c.CompositeId = rvc.CompositeId
WHERE p.ProjectId = @ProjectID
)
MERGE INTO UnifiedMetadata.ld.Composites WITH(TABLOCK) AS T
USING Source AS S
ON S.CompositeId = T.CompositeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CompositeName, 
S.CompositeDescription, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.CompositeName, 
T.CompositeDescription, 
T.UpdatedBy)


THEN UPDATE SET 
CompositeName			=	S.CompositeName, 
CompositeDescription	=	S.CompositeDescription, 
UpdatedBy				=	S.UpdatedBy ,
UpdatedDate				=	DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
CompositeId, 
CompositeName, 
CompositeDescription, 
UpdatedBy
) VALUES (
CompositeId, 
CompositeName, 
CompositeDescription, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.CompositeId,deleted.CompositeId), 
	CASE WHEN deleted.CompositeId IS NULL AND Inserted.CompositeId IS NOT NULL THEN 'Inserted'
	WHEN deleted.CompositeId IS NOT NULL AND Inserted.CompositeId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'ld.pr_PublishComposites:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
