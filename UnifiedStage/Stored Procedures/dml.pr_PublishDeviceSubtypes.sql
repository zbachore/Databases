SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishDeviceSubtypes] 
@PublishQueueID int, @ValueSetID INT, @RegistryVersionID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-18
Description:	Defines dml.pr_PublishDeviceSubtypes stored procedure
___________________________________________________________________________________________________
Example: EXEC dml.pr_PublishDeviceSubtypes 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DeviceSubtypes',
		@ColumnName VARCHAR(MAX) = 'DeviceSubTypeID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT dst.DeviceSubtypeId,
                dst.DeviceTypeId,
                dst.DeviceSubtypeName,
                dst.UpdatedBy,
                dst.CreatedDate,
                dst.UpdatedDate
FROM cdd.ValueSetMembers vsm
INNER JOIN cdd.ValueSetDeviceMembers vsdm
ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm
ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId
INNER JOIN UnifiedMetadata_Stage.ld.Devices d ON d.DeviceId = vsdm.DeviceId
INNER JOIN UnifiedMetadata_Stage.ld.DeviceSubtypes dst ON dst.DeviceSubtypeId = d.DeviceSubtypeId
WHERE vsm.ValueSetID = @ValueSetID
AND rvvsm.RegistryVersionId = @RegistryVersionID
)

MERGE INTO UnifiedMetadata.ld.DeviceSubtypes WITH(TABLOCK) AS T
USING Source AS S
ON S.DeviceSubtypeId = T.DeviceSubtypeId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.DeviceTypeId, 
S.DeviceSubtypeName, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.DeviceTypeId, 
T.DeviceSubtypeName, 
T.UpdatedBy)


THEN UPDATE SET 
DeviceTypeId		=	S.DeviceTypeId, 
DeviceSubtypeName	=	S.DeviceSubtypeName, 
UpdatedBy			=	S.UpdatedBy ,
UpdatedDate			=	DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DeviceSubtypeId, 
DeviceTypeId, 
DeviceSubtypeName, 
UpdatedBy
) VALUES (
DeviceSubtypeId, 
DeviceTypeId, 
DeviceSubtypeName, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.DeviceSubTypeID,deleted.DeviceSubTypeID), 
	CASE WHEN deleted.DeviceSubTypeID IS NULL AND Inserted.DeviceSubTypeID IS NOT NULL THEN 'Inserted'
	WHEN deleted.DeviceSubTypeID IS NOT NULL AND Inserted.DeviceSubTypeID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dml.pr_PublishDeviceSubtypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
