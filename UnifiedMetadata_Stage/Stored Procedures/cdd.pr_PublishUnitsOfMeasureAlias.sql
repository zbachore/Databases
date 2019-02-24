SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishUnitsOfMeasureAlias] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-07-02
Description:	Defines cdd.pr_PublishUnitsOfMeasureAlias stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishUnitsOfMeasureAlias 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'UnitsOfMeasureAlias',
		@ColumnName VARCHAR(MAX) = 'UnitOfMeasureAliasId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT uma.UnitOfMeasureAliasId,
       uma.UnitOfMeasureId,
       uma.UnitOfMeasureAliasName,
       uma.UpdatedBy      
FROM UnifiedMetadata_Stage.dbo.ProjectValueSetMembers pvsm
    INNER JOIN UnifiedMetadata_Stage.cdd.ValueSetUnitOfMeasureMembers vsumm
        ON vsumm.ValueSetMemberId = pvsm.ReferenceID
	INNER JOIN UnifiedMetadata_Stage.cdd.UnitsOfMeasure um 
	ON um.UnitOfMeasureId = vsumm.UnitOfMeasureId
	INNER JOIN UnifiedMetadata_Stage.cdd.UnitsOfMeasureAlias uma 
	ON uma.UnitOfMeasureId = um.UnitOfMeasureId
WHERE pvsm.ProjectId = @ProjectID

UNION 

SELECT DISTINCT uma.UnitOfMeasureAliasId,
       uma.UnitOfMeasureId,
       uma.UnitOfMeasureAliasName,
       uma.UpdatedBy
FROM UnifiedMetadata_Stage.dbo.ProjectDataElements pde 
INNER JOIN UnifiedMetadata_Stage.cdd.DataElements de ON de.DataElementId = pde.ReferenceID
INNER JOIN UnifiedMetadata_Stage.cdd.UnitsOfMeasureAlias uma 
ON uma.UnitOfMeasureId = de.UnitOfMeasureId
WHERE pde.ProjectId = @ProjectID
)	
MERGE INTO UnifiedMetadata.cdd.UnitsOfMeasureAlias WITH(TABLOCK) AS T
USING Source AS S
ON S.UnitOfMeasureAliasId = T.UnitOfMeasureAliasId
WHEN MATCHED AND NOT EXISTS
(
SELECT 
S.UnitOfMeasureId, 
S.UnitOfMeasureAliasName
INTERSECT
SELECT		
T.UnitOfMeasureId, 
T.UnitOfMeasureAliasName
)
THEN UPDATE SET 
UnitOfMeasureId			=	S.UnitOfMeasureId, 
UnitOfMeasureAliasName	=	S.UnitOfMeasureAliasName, 
UpdatedBy				=	S.UpdatedBy ,
UpdatedDate			    =	DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
UnitOfMeasureAliasId, 
UnitOfMeasureId, 
UnitOfMeasureAliasName, 
UpdatedBy
) VALUES (
UnitOfMeasureAliasId, 
UnitOfMeasureId, 
UnitOfMeasureAliasName, 
UpdatedBy)
OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.UnitOfMeasureAliasId,deleted.UnitOfMeasureAliasId), 
	CASE WHEN deleted.UnitOfMeasureAliasId IS NULL AND Inserted.UnitOfMeasureAliasId IS NOT NULL THEN 'Inserted'
	WHEN deleted.UnitOfMeasureAliasId IS NOT NULL AND Inserted.UnitOfMeasureAliasId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishUnitsOfMeasureAlias:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
