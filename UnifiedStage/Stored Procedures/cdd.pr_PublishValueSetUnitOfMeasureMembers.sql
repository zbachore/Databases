SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishValueSetUnitOfMeasureMembers] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines cdd.pr_PublishValueSetUnitOfMeasureMembers stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishValueSetUnitOfMeasureMembers 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ValueSetUnitOfMeasureMembers',
		@ColumnName VARCHAR(MAX) = 'ValueSetMemberId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT vsumm.ValueSetMemberId,
				vsumm.UnitOfMeasureId
      
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pvsm  
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetUnitOfMeasureMembers vsumm 
ON vsumm.ValueSetMemberId = pvsm.ReferenceID
WHERE pvsm.ProjectId = @ProjectID
)
	
MERGE INTO UnifiedMetadata.cdd.ValueSetUnitOfMeasureMembers WITH(TABLOCK) AS T
USING Source AS S
ON S.ValueSetMemberId = T.ValueSetMemberId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.UnitOfMeasureId 
INTERSECT
SELECT		
T.UnitOfMeasureId)
THEN UPDATE SET 
UnitOfMeasureId		=	S.UnitOfMeasureId ,
UpdatedDate			=	DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ValueSetMemberId, 
UnitOfMeasureId
) VALUES (
ValueSetMemberId, 
UnitOfMeasureId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ValueSetMemberId,deleted.ValueSetMemberId), 
	CASE WHEN deleted.ValueSetMemberId IS NULL AND Inserted.ValueSetMemberId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ValueSetMemberId IS NOT NULL AND Inserted.ValueSetMemberId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishValueSetUnitOfMeasureMembers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
