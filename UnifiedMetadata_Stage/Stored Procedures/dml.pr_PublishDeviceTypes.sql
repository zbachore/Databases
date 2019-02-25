SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishDeviceTypes] 
@PublishQueueID int, @ValueSetID INT, @RegistryVersionID int AS  
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2014-04-18
Description:	Defines dml.pr_PublishDeviceTypes stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishDeviceTypes 1,244,3
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DeviceTypes',
		@ColumnName VARCHAR(MAX) = 'DeviceTypeID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT dt.DeviceTypeId,
                dt.DeviceTypeName,
                dt.UpdatedBy,
                dt.CreatedDate,
                dt.UpdatedDate
FROM cdd.ValueSetMembers vsm
INNER JOIN cdd.ValueSetDeviceMembers vsdm
ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN UnifiedMetadata_Stage.ld.Devices d ON d.DeviceId = vsdm.DeviceId
INNER JOIN UnifiedMetadata_Stage.ld.DeviceTypes dt ON dt.DeviceTypeId = d.DeviceTypeId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
)

MERGE INTO UnifiedMetadata.ld.DeviceTypes WITH(TABLOCK) AS T
USING Source AS S
ON S.DeviceTypeId = T.DeviceTypeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.DeviceTypeName, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.DeviceTypeName, 
T.UpdatedBy)


THEN UPDATE SET 
DeviceTypeName		=	S.DeviceTypeName, 
UpdatedBy			=	S.UpdatedBy ,
UpdatedDate			=	DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DeviceTypeId, 
DeviceTypeName, 
UpdatedBy
) VALUES (
DeviceTypeId, 
DeviceTypeName, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.DeviceTypeID,deleted.DeviceTypeID), 
	CASE WHEN deleted.DeviceTypeID IS NULL AND Inserted.DeviceTypeID IS NOT NULL THEN 'Inserted'
	WHEN deleted.DeviceTypeID IS NOT NULL AND Inserted.DeviceTypeID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dml.pr_PublishDeviceTypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
