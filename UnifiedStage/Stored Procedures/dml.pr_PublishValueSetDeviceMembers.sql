SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dml].[pr_PublishValueSetDeviceMembers] 
@PublishQueueID int, @ValueSetID INT, @RegistryVersionID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-18
Description:	Defines dml.pr_PublishValueSetDeviceMembers stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishValueSetDeviceMembers 1,244,3
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ValueSetDeviceMembers',
		@ColumnName VARCHAR(MAX) = 'ValueSetMemberId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT vsdm.ValueSetMemberId,
				vsdm.DeviceId				
FROM cdd.ValueSetMembers vsm
INNER JOIN cdd.ValueSetDeviceMembers vsdm
ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
)

MERGE INTO UnifiedMetadata.cdd.ValueSetDeviceMembers WITH(TABLOCK) AS T
USING Source AS S
ON S.ValueSetMemberId = T.ValueSetMemberId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.DeviceId 
INTERSECT
SELECT		
T.DeviceId)
THEN UPDATE SET 
DeviceId			=	S.DeviceId ,
UpdatedDate			=	DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ValueSetMemberId, 
DeviceId
) VALUES (
ValueSetMemberId, 
DeviceId)
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
    SET @ErrorMessage = 'dml.pr_PublishValueSetDeviceMembers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
