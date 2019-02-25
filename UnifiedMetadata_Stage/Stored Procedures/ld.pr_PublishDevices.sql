SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ld].[pr_PublishDevices] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines ld.pr_PublishDevices stored procedure
___________________________________________________________________________________________________
Example: EXEC ld.pr_PublishDevices 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/22/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/22/2018     rkakani		Removed columns d.CreatedDate,d.UpdatedDate from the source as these fields are not required 
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
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pvsm 
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetDeviceMembers vsdm ON vsdm.ValueSetMemberId = pvsm.ReferenceID
INNER JOIN UnifiedMetadata_Stage.ld.Devices d ON d.DeviceId = vsdm.DeviceId
WHERE pvsm.ProjectId = @ProjectID
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
    SET @ErrorMessage = 'ld.pr_PublishDevices:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;
END
GO
