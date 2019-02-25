SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishDataSources] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines rdd.pr_PublishDataSources stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishDataSources 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DataSources',
		@ColumnName VARCHAR(MAX) = 'DataSourceID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    ds.*
FROM UnifiedMetadata_Stage.dbo.ProjectDataElements pde
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re ON re.DataElementId = pde.ReferenceID
INNER JOIN UnifiedMetadata_Stage.rdd.DataSources ds ON ds.DataSourceId = re.DataSourceId
WHERE pde.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.rdd.DataSources WITH(TABLOCK) AS T
USING Source AS S
ON S.DataSourceId = T.DataSourceId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.DataSourceName, 
S.CreatedBy, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.DataSourceName, 
T.CreatedBy, 
T.UpdatedBy)


THEN UPDATE SET 
DataSourceName						=	S.DataSourceName, 
CreatedBy						=	S.CreatedBy, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DataSourceId, 
DataSourceName, 
CreatedBy, 
UpdatedBy
) VALUES (
DataSourceId, 
DataSourceName, 
CreatedBy, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.DataSourceID,deleted.DataSourceID), 
	CASE WHEN deleted.DataSourceID IS NULL AND Inserted.DataSourceID IS NOT NULL THEN 'Inserted'
	WHEN deleted.DataSourceID IS NOT NULL AND Inserted.DataSourceID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'rdd.pr_PublishDataSources:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
