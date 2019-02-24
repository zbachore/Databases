SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistrySections] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines rdd.pr_PublishRegistrySections stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistrySections 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistrySections',
		@ColumnName VARCHAR(MAX) = 'RegistrySectionID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryVersionID INT;

BEGIN TRY
BEGIN TRAN;

SELECT @RegistryVersionID = RegistryVersionID 
FROM dbo.Project 
WHERE ProjectId = @ProjectID;


WITH Source AS (
SELECT DISTINCT
    rs.RegistrySectionId,
    rs.RegistrySectionName,
    rs.ParentRegistrySectionId,
    rs.DisplayOrder,
    rs.UpdatedBy,
    rs.CreatedDate,
    rs.UpdatedDate,
    rs.RegistrySectionContainerClassId,
    rs.RegistryVersionId,
    rs.RegistrySectionCode,
    rs.RegistrySectionCardinalityMin,
    rs.RegistrySectionCodeInstruction,
    rs.RegistrySectionCardinalityMax
FROM UnifiedMetadata_Stage.dbo.Project p
    INNER JOIN UnifiedMetadata_Stage.rdd.RegistrySections rs
        ON rs.RegistryVersionId = p.RegistryVersionId
WHERE rs.RegistryVersionId = @RegistryVersionID
)
	
MERGE INTO UnifiedMetadata.rdd.RegistrySections WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistrySectionId = T.RegistrySectionId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistrySectionName, 
S.ParentRegistrySectionId, 
S.DisplayOrder, 
S.UpdatedBy, 
S.RegistrySectionContainerClassId, 
S.RegistryVersionId, 
S.RegistrySectionCode, 
S.RegistrySectionCardinalityMin, 
S.RegistrySectionCodeInstruction, 
S.RegistrySectionCardinalityMax 

INTERSECT

SELECT
 
		
T.RegistrySectionName, 
T.ParentRegistrySectionId, 
T.DisplayOrder, 
T.UpdatedBy, 
T.RegistrySectionContainerClassId, 
T.RegistryVersionId, 
T.RegistrySectionCode, 
T.RegistrySectionCardinalityMin, 
T.RegistrySectionCodeInstruction, 
T.RegistrySectionCardinalityMax)


THEN UPDATE SET 
RegistrySectionName						=	S.RegistrySectionName, 
ParentRegistrySectionId						=	S.ParentRegistrySectionId, 
DisplayOrder						=	S.DisplayOrder, 
UpdatedBy						=	S.UpdatedBy, 
RegistrySectionContainerClassId						=	S.RegistrySectionContainerClassId, 
RegistryVersionId						=	S.RegistryVersionId, 
RegistrySectionCode						=	S.RegistrySectionCode, 
RegistrySectionCardinalityMin						=	S.RegistrySectionCardinalityMin, 
RegistrySectionCodeInstruction						=	S.RegistrySectionCodeInstruction, 
RegistrySectionCardinalityMax						=	S.RegistrySectionCardinalityMax ,
UpdatedDate			= DEFAULT

WHEN NOT MATCHED BY SOURCE
AND T.RegistrySectionId IN 
(
SELECT RegistrySectionID 
FROM UnifiedMetadata.rdd.RegistrySections
WHERE RegistryVersionID = @RegistryVersionID
)
THEN DELETE

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistrySectionId, 
RegistrySectionName, 
ParentRegistrySectionId, 
DisplayOrder, 
UpdatedBy, 
RegistrySectionContainerClassId, 
RegistryVersionId, 
RegistrySectionCode, 
RegistrySectionCardinalityMin, 
RegistrySectionCodeInstruction, 
RegistrySectionCardinalityMax
) VALUES (
RegistrySectionId, 
RegistrySectionName, 
ParentRegistrySectionId, 
DisplayOrder, 
UpdatedBy, 
RegistrySectionContainerClassId, 
RegistryVersionId, 
RegistrySectionCode, 
RegistrySectionCardinalityMin, 
RegistrySectionCodeInstruction, 
RegistrySectionCardinalityMax)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistrySectionID,deleted.RegistrySectionID), 
	CASE WHEN deleted.RegistrySectionID IS NULL AND Inserted.RegistrySectionID IS NOT NULL THEN 'Inserted'
	WHEN deleted.RegistrySectionID IS NOT NULL AND Inserted.RegistrySectionID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistrySections:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
