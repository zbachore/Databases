SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ld].[pr_PublishDeviceManufacturers] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines ld.pr_PublishDeviceManufacturers stored procedure
___________________________________________________________________________________________________
Example: EXEC ld.pr_PublishDeviceManufacturers 6,1
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
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pvsm
    INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetDeviceMembers vsdm
        ON vsdm.ValueSetMemberId = pvsm.ReferenceID
    INNER JOIN UnifiedMetadata_Stage.ld.Devices d
        ON d.DeviceId = vsdm.DeviceId
    INNER JOIN UnifiedMetadata_Stage.ld.DeviceManufacturers dm
        ON dm.DeviceManufacturerId = d.DeviceManufacturerId
WHERE pvsm.ProjectId = @ProjectID
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
	ISNULL(inserted.DeviceManufacturerId,deleted.DeviceManufacturerId), 
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
    SET @ErrorMessage = 'ld.pr_PublishDeviceManufacturers:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
