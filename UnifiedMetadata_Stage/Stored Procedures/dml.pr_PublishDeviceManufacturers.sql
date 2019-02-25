SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishDeviceManufacturers] 
@PublishQueueID int, @ValueSetID INT, @RegistryVersionID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-18
Description:	Defines dml.pr_PublishDeviceManufacturers stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishDeviceManufacturers 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DeviceManufacturers',
		@ColumnName VARCHAR(MAX) = 'DeviceManufacturerId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT dm.DeviceManufacturerId,
       dm.DeviceManufacturerName,
       dm.UpdatedBy,
       dm.CreatedDate,
       dm.UpdatedDate
FROM cdd.ValueSetMembers vsm
INNER JOIN cdd.ValueSetDeviceMembers vsdm
ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN UnifiedMetadata_Stage.ld.Devices d ON d.DeviceId = vsdm.DeviceId
INNER JOIN UnifiedMetadata_Stage.ld.DeviceManufacturers dm
ON dm.DeviceManufacturerId = d.DeviceManufacturerId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID

)	
MERGE INTO UnifiedMetadata.ld.DeviceManufacturers WITH(TABLOCK) AS T
USING Source AS S
ON S.DeviceManufacturerId = T.DeviceManufacturerId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.DeviceManufacturerName, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.DeviceManufacturerName, 
T.UpdatedBy)


THEN UPDATE SET 
DeviceManufacturerName	=	S.DeviceManufacturerName, 
UpdatedBy				=	S.UpdatedBy ,
UpdatedDate				=	DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DeviceManufacturerId, 
DeviceManufacturerName, 
UpdatedBy
) VALUES (
DeviceManufacturerId, 
DeviceManufacturerName, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(Inserted.DeviceManufacturerId,deleted.DeviceManufacturerId), 
	CASE WHEN deleted.DeviceManufacturerId IS NULL AND Inserted.DeviceManufacturerId IS NOT NULL THEN 'Inserted'
	WHEN deleted.DeviceManufacturerId IS NOT NULL AND Inserted.DeviceManufacturerId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dml.pr_PublishDeviceManufacturers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
