SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishValueSetMembers] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines cdd.pr_PublishValueSetMembers stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishValueSetMembers 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns vsm.CreatedDate,vsm.UpdatedDate from the source as these fields are not required 
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
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pvsm 
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetMembers vsm 
ON vsm.ValueSetMemberId = pvsm.ReferenceID
WHERE pvsm.ProjectId = @ProjectID
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
UpdatedDate			            = DEFAULT

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
    SET @ErrorMessage = 'cdd.pr_PublishValueSetMembers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
