SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dd].[pr_PublishConstraintTypes] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines dd.pr_PublishConstraintTypes stored procedure
___________________________________________________________________________________________________
Example: EXEC dd.pr_PublishConstraintTypes 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ConstraintTypes',
		@ColumnName VARCHAR(MAX) = 'ConstraintTypeId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT ct.ConstraintTypeId,
       ct.ConstraintTypeName,
       ct.ConstraintTypeDescription,
       ct.IsRequired,
       ct.UpdatedBy,
       ct.CreatedDate,
       ct.UpdatedDate,
       ct.ConstraintTypeMessage
FROM UnifiedMetadata_Stage.dd.ConstraintTypes ct
)

MERGE INTO UnifiedMetadata.dd.ConstraintTypes  AS T
USING Source AS S
ON S.ConstraintTypeId = T.ConstraintTypeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ConstraintTypeName, 
S.ConstraintTypeDescription, 
S.IsRequired, 
S.UpdatedBy, 
S.ConstraintTypeMessage 

INTERSECT

SELECT
 
		
T.ConstraintTypeName, 
T.ConstraintTypeDescription, 
T.IsRequired, 
T.UpdatedBy, 
T.ConstraintTypeMessage)


THEN UPDATE SET 
ConstraintTypeName				=	S.ConstraintTypeName, 
ConstraintTypeDescription		=	S.ConstraintTypeDescription, 
IsRequired						=	S.IsRequired, 
UpdatedBy						=	S.UpdatedBy, 
ConstraintTypeMessage			=	S.ConstraintTypeMessage ,
UpdatedDate						= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConstraintTypeId, 
ConstraintTypeName, 
ConstraintTypeDescription, 
IsRequired, 
UpdatedBy, 
ConstraintTypeMessage
) VALUES (
ConstraintTypeId, 
ConstraintTypeName, 
ConstraintTypeDescription, 
IsRequired, 
UpdatedBy, 
ConstraintTypeMessage)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConstraintTypeId,deleted.ConstraintTypeId), 
	CASE WHEN deleted.ConstraintTypeId IS NULL AND Inserted.ConstraintTypeId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConstraintTypeId IS NOT NULL AND Inserted.ConstraintTypeId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dd.pr_PublishConstraintTypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
