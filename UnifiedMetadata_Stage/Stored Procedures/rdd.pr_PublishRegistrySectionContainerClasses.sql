SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistrySectionContainerClasses] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines rdd.pr_PublishRegistrySectionContainerClasses stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistrySectionContainerClasses 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistrySectionContainerClasses',
		@ColumnName VARCHAR(MAX) = 'RegistrySectionContainerClassId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT rscc.RegistrySectionContainerClassId,
                rscc.RegistrySectionContainerClassName,
                rscc.UpdatedBy,
                rscc.CreatedDate,
                rscc.UpdatedDate,
                rscc.RegistrySectionContainerClassDescription 
FROM UnifiedMetadata_Stage.dbo.Project p
INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re 
ON re.RegistryVersionId = p.RegistryVersionId 
INNER JOIN UnifiedMetadata_Stage.rdd.RegistrySections rs 
ON rs.RegistrySectionId = re.RegistrySectionId
INNER JOIN UnifiedMetadata_Stage.rdd.RegistrySectionContainerClasses rscc 
ON rscc.RegistrySectionContainerClassId = rs.RegistrySectionContainerClassId
WHERE p.ProjectId = @ProjectID
)	
MERGE INTO UnifiedMetadata.rdd.RegistrySectionContainerClasses WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistrySectionContainerClassId = T.RegistrySectionContainerClassId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.RegistrySectionContainerClassName, 
S.UpdatedBy, 
S.RegistrySectionContainerClassDescription 

INTERSECT

SELECT
 
		
T.RegistrySectionContainerClassName, 
T.UpdatedBy, 
T.RegistrySectionContainerClassDescription)


THEN UPDATE SET 
RegistrySectionContainerClassName						=	S.RegistrySectionContainerClassName, 
UpdatedBy						=	S.UpdatedBy, 
RegistrySectionContainerClassDescription						=	S.RegistrySectionContainerClassDescription ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
RegistrySectionContainerClassId, 
RegistrySectionContainerClassName, 
UpdatedBy, 
RegistrySectionContainerClassDescription
) VALUES (
RegistrySectionContainerClassId, 
RegistrySectionContainerClassName, 
UpdatedBy, 
RegistrySectionContainerClassDescription)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistrySectionContainerClassId,deleted.RegistrySectionContainerClassId), 
	CASE WHEN deleted.RegistrySectionContainerClassId IS NULL AND Inserted.RegistrySectionContainerClassId IS NOT NULL THEN 'Inserted'
	WHEN deleted.RegistrySectionContainerClassId IS NOT NULL AND Inserted.RegistrySectionContainerClassId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistrySectionContainerClasses:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
