SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishDataTypes] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines cdd.pr_PublishDataTypes stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishDataTypes 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DataTypes',
		@ColumnName VARCHAR(MAX) = 'DataTypeID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    dt.*
FROM UnifiedMetadata_Stage.dbo.ProjectDataElements pde 
INNER JOIN UnifiedMetadata_Stage.cdd.DataElements de ON de.DataElementId = pde.ReferenceID
    LEFT JOIN UnifiedMetadata_Stage.cdd.DataTypes dt
        ON dt.DataTypeId = de.DataTypeId
	WHERE pde.ProjectId = @ProjectID
)
	
MERGE INTO UnifiedMetadata.cdd.DataTypes WITH(TABLOCK) AS T
USING Source AS S
ON S.DataTypeId = T.DataTypeId

WHEN MATCHED AND NOT EXISTS
(SELECT 
S.DataTypeCode, 
S.DataTypeSource, 
S.DataTypeName, 
S.DataTypeShortName, 
S.DataTypeNetType, 
S.IsActive, 
S.UpdatedBy, 
S.DataTypeAlternateName 

INTERSECT

SELECT
 
		
T.DataTypeCode, 
T.DataTypeSource, 
T.DataTypeName, 
T.DataTypeShortName, 
T.DataTypeNetType, 
T.IsActive, 
T.UpdatedBy, 
T.DataTypeAlternateName)


THEN UPDATE SET 
DataTypeCode						=	S.DataTypeCode, 
DataTypeSource						=	S.DataTypeSource, 
DataTypeName						=	S.DataTypeName, 
DataTypeShortName						=	S.DataTypeShortName, 
DataTypeNetType						=	S.DataTypeNetType, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy, 
DataTypeAlternateName				=	S.DataTypeAlternateName ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DataTypeId, 
DataTypeCode, 
DataTypeSource, 
DataTypeName, 
DataTypeShortName, 
DataTypeNetType, 
IsActive, 
UpdatedBy, 
DataTypeAlternateName
) VALUES (
DataTypeId, 
DataTypeCode, 
DataTypeSource, 
DataTypeName, 
DataTypeShortName, 
DataTypeNetType, 
IsActive, 
UpdatedBy, 
DataTypeAlternateName)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.DataTypeID,deleted.DataTypeID), 
	CASE WHEN deleted.DataTypeID IS NULL AND Inserted.DataTypeID IS NOT NULL THEN 'Inserted'
	WHEN deleted.DataTypeID IS NOT NULL AND Inserted.DataTypeID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishDataTypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
