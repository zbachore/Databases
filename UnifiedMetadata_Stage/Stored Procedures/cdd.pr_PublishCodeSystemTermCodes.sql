SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishCodeSystemTermCodes] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines cdd.pr_PublishCodeSystemTermCodes stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishCodeSystemTermCodes 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-02-20		zbachore		Added DISTINCT to avoid potential duplicates failing the load.

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'CodeSystemTermCodes',
		@ColumnName VARCHAR(MAX) = 'CodeSystemTermCodeId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT cstc.CodeSystemTermCodeId,
       cstc.CreatedBy
FROM UnifiedMetadata_Stage.cdd.CodeSystemTermCodes cstc 
)
	
MERGE INTO UnifiedMetadata.cdd.CodeSystemTermCodes WITH(TABLOCK) AS T
USING Source AS S
ON S.CodeSystemTermCodeId = T.CodeSystemTermCodeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.CreatedBy 

INTERSECT

SELECT
 
		
T.CreatedBy)


THEN UPDATE SET 
CreatedBy			=	S.CreatedBy ,
UpdatedDate			=	DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
CodeSystemTermCodeId, 
CreatedBy
) VALUES (
CodeSystemTermCodeId, 
CreatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.CodeSystemTermCodeId,deleted.CodeSystemTermCodeId), 
	CASE WHEN deleted.CodeSystemTermCodeId IS NULL AND Inserted.CodeSystemTermCodeId IS NOT NULL THEN 'Inserted'
	WHEN deleted.CodeSystemTermCodeId IS NOT NULL AND Inserted.CodeSystemTermCodeId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishCodeSystemTermCodes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
