SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistrySectionTypes] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistrySectionTypes stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistrySectionTypes 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns rst.CreatedDate,rst.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistrySectionTypes',
		@ColumnName VARCHAR(MAX) = 'RegistrySectionTypeId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT rst.RegistrySectionTypeId,
				rst.RegistrySectionTypeName,
				rst.RegistrySectionTypeDescription,
				rst.UpdatedBy				
FROM UnifiedMetadata_Stage.rdd.RegistrySectionTypes rst 
)	
MERGE INTO UnifiedMetadata.rdd.RegistrySectionTypes WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistrySectionTypeId = T.RegistrySectionTypeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistrySectionTypeName, 
S.RegistrySectionTypeDescription, 
S.UpdatedBy 
INTERSECT
SELECT	
T.RegistrySectionTypeName, 
T.RegistrySectionTypeDescription, 
T.UpdatedBy)
THEN UPDATE SET 
RegistrySectionTypeName			   =	S.RegistrySectionTypeName, 
RegistrySectionTypeDescription	   =	S.RegistrySectionTypeDescription, 
UpdatedBy						   =	S.UpdatedBy ,
UpdatedDate			               = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistrySectionTypeId, 
RegistrySectionTypeName, 
RegistrySectionTypeDescription, 
UpdatedBy
) VALUES (
RegistrySectionTypeId, 
RegistrySectionTypeName, 
RegistrySectionTypeDescription, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistrySectionTypeId,deleted.RegistrySectionTypeId), 
	CASE WHEN deleted.RegistrySectionTypeId IS NULL AND Inserted.RegistrySectionTypeId IS NOT NULL THEN 'Inserted'
	WHEN deleted.RegistrySectionTypeId IS NOT NULL AND Inserted.RegistrySectionTypeId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistrySectionTypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
