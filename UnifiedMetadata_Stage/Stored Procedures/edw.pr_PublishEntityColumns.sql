SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [edw].[pr_PublishEntityColumns] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines edw.pr_PublishEntityColumns stored procedure
___________________________________________________________________________________________________
Example: EXEC edw.pr_PublishEntityColumns 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns ec.CreatedDate,ec.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'EntityColumns',
		@ColumnName VARCHAR(MAX) = 'EntityColumnID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT ec.EntityColumnId,
				ec.EntityId,
				ec.EntityColumnName,
				ec.EntityColumnDescription,
				ec.DataType,
				ec.IsActive,
				ec.UpdatedBy				 
FROM UnifiedMetadata_Stage.edw.EntityColumns ec
)
MERGE INTO UnifiedMetadata.edw.EntityColumns WITH(TABLOCK) AS T
USING Source AS S
ON S.EntityColumnId = T.EntityColumnId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.EntityId, 
S.EntityColumnName, 
S.EntityColumnDescription, 
S.DataType, 
S.IsActive, 
S.UpdatedBy 
INTERSECT
SELECT		
T.EntityId, 
T.EntityColumnName, 
T.EntityColumnDescription, 
T.DataType, 
T.IsActive, 
T.UpdatedBy)
THEN UPDATE SET 
EntityId						=	S.EntityId, 
EntityColumnName						=	S.EntityColumnName, 
EntityColumnDescription						=	S.EntityColumnDescription, 
DataType						=	S.DataType, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
EntityColumnId, 
EntityId, 
EntityColumnName, 
EntityColumnDescription, 
DataType, 
IsActive, 
UpdatedBy
) VALUES (
EntityColumnId, 
EntityId, 
EntityColumnName, 
EntityColumnDescription, 
DataType, 
IsActive, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.EntityColumnID,deleted.EntityColumnID), 
	CASE WHEN deleted.EntityColumnID IS NULL AND Inserted.EntityColumnID IS NOT NULL THEN 'Inserted'
	WHEN deleted.EntityColumnID IS NOT NULL AND Inserted.EntityColumnID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'edw.pr_PublishEntityColumns:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
