SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishValueSetMembers] @PublishQueueID INT, @ValueSetID INT, @RegistryVersionID INT AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-12
Description:	Defines dml.pr_PublishValueSetMembers stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishValueSetMembers 1,165,3
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ValueSetMembers',
		@ColumnName VARCHAR(MAX) = 'ValueSetMemberId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;
WITH Source AS (
SELECT DISTINCT vsm.ValueSetMemberId,
				vsm.ValueSetId,
				vsm.DisplayOrder,
				vsm.UpdatedBy,
				vsm.ValueSetMemberLabel,
				vsm.StartDate,
				vsm.EndDate
FROM cdd.ValueSetMembers vsm
INNER JOIN cdd.ValueSets vs
ON vs.ValueSetId = vsm.ValueSetId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
)
	
MERGE INTO UnifiedMetadata.cdd.ValueSetMembers WITH(TABLOCK) AS T
USING Source AS S
ON S.ValueSetMemberId = T.ValueSetMemberId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ValueSetId, 
S.DisplayOrder, 
S.UpdatedBy, 
S.ValueSetMemberLabel, 
S.StartDate, 
S.EndDate 
INTERSECT
SELECT		
T.ValueSetId, 
T.DisplayOrder, 
T.UpdatedBy, 
T.ValueSetMemberLabel, 
T.StartDate, 
T.EndDate)
THEN UPDATE SET 
ValueSetId						=	S.ValueSetId, 
DisplayOrder					=	S.DisplayOrder, 
UpdatedBy						=	S.UpdatedBy, 
ValueSetMemberLabel				=	S.ValueSetMemberLabel, 
StartDate						=	S.StartDate, 
EndDate					     	=	S.EndDate ,
UpdatedDate			            =	DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ValueSetMemberId, 
ValueSetId, 
DisplayOrder, 
UpdatedBy, 
ValueSetMemberLabel, 
StartDate, 
EndDate
) VALUES (
ValueSetMemberId, 
ValueSetId, 
DisplayOrder, 
UpdatedBy, 
ValueSetMemberLabel, 
StartDate, 
EndDate)

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
    SET @ErrorMessage = 'dml.pr_PublishValueSetMembers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
