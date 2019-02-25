SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishDataElementCodingInstructions] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines cdd.pr_PublishDataElementCodingInstructions stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishDataElementCodingInstructions 16,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DataElementCodingInstructions',
		@ColumnName VARCHAR(MAX) = 'DataElementCodingInstructionID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    deci.DataElementCodingInstructionId,
    deci.DataElementId,
    deci.CodingInstruction,
    deci.ValidStartDate,
    deci.ValidEndDate,
    deci.IsActive,
    deci.UpdatedBy
FROM UnifiedMetadata_Stage.dbo.Project p 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.RegistryVersionId = p.RegistryVersionId
INNER JOIN UnifiedMetadata_Stage.cdd.DataElementCodingInstructions deci
        ON re.DataElementId = deci.DataElementId
INNER JOIN UnifiedMetadata_Stage.dbo.ProjectDataElements pde 
ON pde.ProjectId = p.ProjectId
AND pde.ReferenceId = deci.DataElementId
WHERE p.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.cdd.DataElementCodingInstructions WITH(TABLOCK) AS T
USING Source AS S
ON S.DataElementCodingInstructionId = T.DataElementCodingInstructionId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.DataElementId, 
S.CodingInstruction, 
S.ValidStartDate, 
S.ValidEndDate, 
S.IsActive, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.DataElementId, 
T.CodingInstruction, 
T.ValidStartDate, 
T.ValidEndDate, 
T.IsActive, 
T.UpdatedBy)


THEN UPDATE SET 
DataElementId						=	S.DataElementId, 
CodingInstruction						=	S.CodingInstruction, 
ValidStartDate						=	S.ValidStartDate, 
ValidEndDate						=	S.ValidEndDate, 
IsActive						=	S.IsActive, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DataElementCodingInstructionId, 
DataElementId, 
CodingInstruction, 
ValidStartDate, 
ValidEndDate, 
IsActive, 
UpdatedBy
) VALUES (
DataElementCodingInstructionId, 
DataElementId, 
CodingInstruction, 
ValidStartDate, 
ValidEndDate, 
IsActive, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.DataElementCodingInstructionId,deleted.DataElementCodingInstructionId), 
	CASE WHEN deleted.DataElementCodingInstructionId IS NULL AND Inserted.DataElementCodingInstructionId IS NOT NULL THEN 'Inserted'
	WHEN deleted.DataElementCodingInstructionId IS NOT NULL AND Inserted.DataElementCodingInstructionId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishDataElementCodingInstructions:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
