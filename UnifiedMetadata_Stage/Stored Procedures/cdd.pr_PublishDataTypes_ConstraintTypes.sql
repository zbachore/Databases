SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishDataTypes_ConstraintTypes] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 25 2018 10:16AM
Description:	Defines cdd.pr_PublishDataTypes_ConstraintTypes stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishDataTypes_ConstraintTypes 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DataTypes_ConstraintTypes',
		@ColumnName VARCHAR(MAX) = 'DataTypesConstraintTypesID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT dtct.DataTypesConstraintTypesID,
       dtct.DataTypeId,
       dtct.ConstraintTypeId,
       dtct.CreatedDate,
       dtct.UpdatedDate 
FROM UnifiedMetadata_Stage.dbo.ProjectDataElements pde 
INNER JOIN UnifiedMetadata_Stage.cdd.DataElements de ON de.DataElementId = pde.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.DataTypes dt ON dt.DataTypeId = de.DataTypeId
INNER JOIN UnifiedMetadata_Stage.cdd.DataTypes_ConstraintTypes dtct ON dtct.DataTypeId = dt.DataTypeId
WHERE pde.ProjectId = @ProjectID
)
	
MERGE INTO UnifiedMetadata.cdd.DataTypes_ConstraintTypes WITH(TABLOCK) AS T
USING Source AS S
ON S.DataTypesConstraintTypesID = T.DataTypesConstraintTypesID

WHEN MATCHED AND NOT EXISTS
(SELECT 
S.DataTypeId, 
S.ConstraintTypeId 

INTERSECT

SELECT
 
		
T.DataTypeId, 
T.ConstraintTypeId)


THEN UPDATE SET 
DataTypeId			=	S.DataTypeId, 
ConstraintTypeId	=	S.ConstraintTypeId ,
UpdatedDate			=	DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DataTypesConstraintTypesID, 
DataTypeId, 
ConstraintTypeId
) VALUES (
DataTypesConstraintTypesID, 
DataTypeId, 
ConstraintTypeId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.DataTypesConstraintTypesID,deleted.DataTypesConstraintTypesID), 
	CASE WHEN deleted.DataTypesConstraintTypesID IS NULL AND Inserted.DataTypesConstraintTypesID IS NOT NULL THEN 'Inserted'
	WHEN deleted.DataTypesConstraintTypesID IS NOT NULL AND Inserted.DataTypesConstraintTypesID IS NOT NULL THEN 'Updated'
	ELSE NULL END,
	'Publish',
	@RequestedTime, 
	SYSDATETIME()
INTO dbo.PublishLog;

MERGE INTO UnifiedMetadata.cdd.DataTypes_ConstraintTypes WITH(TABLOCK) AS T
USING UnifiedMetadata_Stage.cdd.DataTypes_ConstraintTypes AS S
ON S.DataTypesConstraintTypesID = T.DataTypesConstraintTypesID

WHEN NOT MATCHED BY SOURCE
THEN DELETE

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	deleted.DataTypesConstraintTypesID, 
	CASE WHEN deleted.DataTypesConstraintTypesID IS NOT NULL AND Inserted.DataTypesConstraintTypesID IS NULL 
	THEN 'Deleted'
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
    SET @ErrorMessage = 'cdd.pr_PublishDataTypes_ConstraintTypes:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
