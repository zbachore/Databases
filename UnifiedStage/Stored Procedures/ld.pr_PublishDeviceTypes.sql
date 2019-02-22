SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [ld].[pr_PublishDeviceTypes] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines ld.pr_PublishDeviceTypes stored procedure
___________________________________________________________________________________________________
Example: EXEC ld.pr_PublishDeviceTypes 3,1
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
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pvsm 
INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetDeviceMembers vsdm ON vsdm.ValueSetMemberId = pvsm.ReferenceID
INNER JOIN UnifiedMetadata_Stage.ld.Devices d ON d.DeviceId = vsdm.DeviceId
INNER JOIN UnifiedMetadata_Stage.ld.DeviceTypes dt ON dt.DeviceTypeId = d.DeviceTypeId
WHERE pvsm.ProjectId = @ProjectID
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
DeviceTypeName						=	S.DeviceTypeName, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




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
    SET @ErrorMessage = 'ld.pr_PublishDeviceTypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
