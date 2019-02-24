SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistryVersions] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines rdd.pr_PublishRegistryVersions stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryVersions 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryVersions',
		@ColumnName VARCHAR(MAX) = 'RegistryVersionID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    rv.RegistryVersionId,
    rv.RegistryId,
    rv.RegistryVersion,
    rv.VendorSpecReleaseDate,
    rv.DataCollectionAsOfDate,
    rv.IsActive,
    rv.StartDate,
    rv.EndDate,
    rv.UpdatedBy,
    rv.ShortName
FROM UnifiedMetadata_Stage.dbo.Project p
    INNER JOIN UnifiedMetadata_Stage.rdd.RegistryVersions rv 
	ON rv.RegistryVersionId = p.RegistryVersionId
	WHERE p.ProjectId = @ProjectID
)
	
MERGE INTO UnifiedMetadata.rdd.RegistryVersions WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryVersionId = T.RegistryVersionId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistryId, 
S.RegistryVersion, 
S.VendorSpecReleaseDate, 
S.DataCollectionAsOfDate, 
S.IsActive, 
S.StartDate, 
S.EndDate, 
S.UpdatedBy, 
S.ShortName 

INTERSECT

SELECT
 
		
T.RegistryId, 
T.RegistryVersion, 
T.VendorSpecReleaseDate, 
T.DataCollectionAsOfDate, 
T.IsActive, 
T.StartDate, 
T.EndDate, 
T.UpdatedBy, 
T.ShortName)


THEN UPDATE SET 
RegistryId						=	S.RegistryId, 
RegistryVersion						=	S.RegistryVersion, 
VendorSpecReleaseDate						=	S.VendorSpecReleaseDate, 
DataCollectionAsOfDate						=	S.DataCollectionAsOfDate, 
IsActive						=	S.IsActive, 
StartDate						=	S.StartDate, 
EndDate						=	S.EndDate, 
UpdatedBy						=	S.UpdatedBy, 
ShortName						=	S.ShortName ,
UpdatedDate			= DEFAULT


WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistryVersionId, 
RegistryId, 
RegistryVersion, 
VendorSpecReleaseDate, 
DataCollectionAsOfDate, 
IsActive, 
StartDate, 
EndDate, 
UpdatedBy, 
ShortName
) VALUES (
RegistryVersionId, 
RegistryId, 
RegistryVersion, 
VendorSpecReleaseDate, 
DataCollectionAsOfDate, 
IsActive, 
StartDate, 
EndDate, 
UpdatedBy, 
ShortName)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryVersionID,deleted.RegistryVersionID), 
	CASE WHEN deleted.RegistryVersionID IS NULL AND Inserted.RegistryVersionID IS NOT NULL THEN 'Inserted'
	WHEN deleted.RegistryVersionID IS NOT NULL AND Inserted.RegistryVersionID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistryVersions:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
