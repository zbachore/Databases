SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishUnitsOfMeasure] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-07-02
Description:	Defines cdd.pr_PublishUnitsOfMeasure stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishUnitsOfMeasure 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'UnitsOfMeasure',
		@ColumnName VARCHAR(MAX) = 'UnitOfMeasureID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    um.UnitOfMeasureId,
    um.UnitOfMeasureName,
	um.UnitOfMeasureDescription,
	um.ConceptID,
	um.UpdatedBy
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pvsm
    INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetUnitOfMeasureMembers vsumm
        ON vsumm.ValueSetMemberId = pvsm.ReferenceID
	INNER JOIN UnifiedMetadata_Stage.cdd.UnitsOfMeasure um 
	ON um.UnitOfMeasureId = vsumm.UnitOfMeasureId
WHERE pvsm.ProjectId = @ProjectID

UNION 

SELECT DISTINCT
    um.UnitOfMeasureId,
    um.UnitOfMeasureName,
	um.UnitOfMeasureDescription,
	um.ConceptID,
	um.UpdatedBy
FROM UnifiedMetadata_Stage.dbo.ProjectDataElements pde 
INNER JOIN UnifiedMetadata_Stage.cdd.DataElements de ON de.DataElementId = pde.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.UnitsOfMeasure um ON um.UnitOfMeasureId = de.UnitOfMeasureId
WHERE pde.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.cdd.UnitsOfMeasure WITH(TABLOCK) AS T
USING Source AS S
ON S.UnitOfMeasureId = T.UnitOfMeasureId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.UnitOfMeasureName, 
S.UnitOfMeasureDescription, 
S.ConceptID 

INTERSECT

SELECT
 
	
T.UnitOfMeasureName, 
T.UnitOfMeasureDescription, 
T.ConceptID)


THEN UPDATE SET 
UnitOfMeasureName				=	S.UnitOfMeasureName, 
UnitOfMeasureDescription		=	S.UnitOfMeasureDescription, 
UpdatedBy						=	S.UpdatedBy, 
ConceptID						=	S.ConceptID ,
UpdatedDate						=	DEFAULT

WHEN NOT MATCHED BY SOURCE
AND T.UnitOfMeasureId IN (
SELECT UnitOfMeasureId
FROM UnifiedMetadata.cdd.UnitsOfMeasure
WHERE UnitOfMeasureID NOT IN (
SELECT UnitOfMeasureID FROM UnifiedMetadata_Stage.cdd.UnitsOfMeasure)
)
THEN DELETE

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
UnitOfMeasureId, 
UnitOfMeasureName, 
UnitOfMeasureDescription, 
UpdatedBy, 
ConceptID
) VALUES (
UnitOfMeasureId, 
UnitOfMeasureName, 
UnitOfMeasureDescription, 
UpdatedBy, 
ConceptID)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.UnitOfMeasureID,deleted.UnitOfMeasureID), 
	CASE WHEN deleted.UnitOfMeasureID IS NULL AND Inserted.UnitOfMeasureID IS NOT NULL THEN 'Inserted'
	WHEN deleted.UnitOfMeasureID IS NOT NULL AND Inserted.UnitOfMeasureID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishUnitsOfMeasure:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
