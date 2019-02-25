SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishDevices] 
@PublishQueueID int, @ValueSetID INT, @RegistryVersionID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-18
Description:	Defines dml.pr_PublishDevices stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishDevices 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Devices',
		@ColumnName VARCHAR(MAX) = 'DeviceID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;
WITH Source AS (
SELECT DISTINCT d.DeviceId,
       d.DeviceManufacturerId,
       d.DeviceTypeId,
       d.DeviceSubtypeId,
       d.DeviceName,
       d.DeviceModelNumber,
       d.UpdatedBy,
       d.StartDate,
       d.EndDate,
       d.DevicePublishedId 
FROM cdd.ValueSetMembers vsm
INNER JOIN cdd.ValueSetDeviceMembers vsdm
ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN UnifiedMetadata_Stage.ld.Devices d ON d.DeviceId = vsdm.DeviceId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
)	
MERGE INTO UnifiedMetadata.ld.Devices WITH(TABLOCK) AS T
USING Source AS S
ON S.DeviceId = T.DeviceId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.DeviceManufacturerId, 
S.DeviceTypeId, 
S.DeviceSubtypeId, 
S.DeviceName, 
S.DeviceModelNumber, 
S.UpdatedBy, 
S.StartDate, 
S.EndDate, 
S.DevicePublishedId 
INTERSECT
SELECT		
T.DeviceManufacturerId, 
T.DeviceTypeId, 
T.DeviceSubtypeId, 
T.DeviceName, 
T.DeviceModelNumber, 
T.UpdatedBy, 
T.StartDate, 
T.EndDate, 
T.DevicePublishedId)
THEN UPDATE SET 
DeviceManufacturerId =	S.DeviceManufacturerId, 
DeviceTypeId		 =	S.DeviceTypeId, 
DeviceSubtypeId		 =	S.DeviceSubtypeId, 
DeviceName			 =	S.DeviceName, 
DeviceModelNumber	 =	S.DeviceModelNumber, 
UpdatedBy			 =	S.UpdatedBy, 
StartDate			 =	S.StartDate, 
EndDate				 =	S.EndDate, 
DevicePublishedId	 =	S.DevicePublishedId ,
UpdatedDate			 = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DeviceId, 
DeviceManufacturerId, 
DeviceTypeId, 
DeviceSubtypeId, 
DeviceName, 
DeviceModelNumber, 
UpdatedBy, 
StartDate, 
EndDate, 
DevicePublishedId
) VALUES (
DeviceId, 
DeviceManufacturerId, 
DeviceTypeId, 
DeviceSubtypeId, 
DeviceName, 
DeviceModelNumber, 
UpdatedBy, 
StartDate, 
EndDate, 
DevicePublishedId)
OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.DeviceID,deleted.DeviceID), 
	CASE WHEN deleted.DeviceID IS NULL AND Inserted.DeviceID IS NOT NULL THEN 'Inserted'
	WHEN deleted.DeviceID IS NOT NULL AND Inserted.DeviceID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dml.pr_PublishDevices:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
