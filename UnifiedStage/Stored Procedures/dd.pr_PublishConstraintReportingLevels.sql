SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dd].[pr_PublishConstraintReportingLevels] @ProjectID int, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Feb  2 2018 10:31AM
Description:	Defines dd.pr_PublishConstraintReportingLevels stored procedure
___________________________________________________________________________________________________
Example: EXEC dd.pr_PublishConstraintReportingLevels 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/21/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/21/2018     rkakani		Removed columns crl.CreatedDate,crl.UpdatedDate from the source as these fields are not required 

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ConstraintReportingLevels',
		@ColumnName VARCHAR(MAX) = 'ConstraintReportingLevelId',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT crl.ConstraintReportingLevelId,
				crl.ConstraintReportingLevelName,
				crl.ConstraintReportingLevelDescription,
				crl.UpdatedBy      
FROM UnifiedMetadata_Stage.dbo.ProjectDataElements pde
    INNER JOIN UnifiedMetadata_Stage.cdd.DataElementConstraintDefinitions decd
        ON decd.DataElementId = pde.ReferenceID
    INNER JOIN UnifiedMetadata_Stage.dd.ConstraintDefinitions cd
        ON cd.ConstraintDefinitionId = decd.ConstraintDefinitionId
    INNER JOIN UnifiedMetadata_Stage.dd.ConstraintReportingLevels crl
        ON crl.ConstraintReportingLevelId = cd.ConstraintReportingLevelId
WHERE pde.ProjectId = @ProjectID
)

MERGE INTO UnifiedMetadata.dd.ConstraintReportingLevels WITH(TABLOCK) AS T
USING Source AS S
ON S.ConstraintReportingLevelId = T.ConstraintReportingLevelId
WHEN MATCHED AND NOT EXISTS
(
	SELECT 
	S.ConstraintReportingLevelName, 
	S.ConstraintReportingLevelDescription, 
	S.UpdatedBy
 
	INTERSECT

	SELECT		
	T.ConstraintReportingLevelName, 
	T.ConstraintReportingLevelDescription, 
	T.UpdatedBy
)
THEN UPDATE SET 
ConstraintReportingLevelName		 =	S.ConstraintReportingLevelName, 
ConstraintReportingLevelDescription	 =	S.ConstraintReportingLevelDescription, 
UpdatedBy						     =	S.UpdatedBy ,
UpdatedDate			                 = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ConstraintReportingLevelId, 
ConstraintReportingLevelName, 
ConstraintReportingLevelDescription, 
UpdatedBy
) VALUES (
ConstraintReportingLevelId, 
ConstraintReportingLevelName, 
ConstraintReportingLevelDescription, 
UpdatedBy)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ConstraintReportingLevelId,deleted.ConstraintReportingLevelId), 
	CASE WHEN deleted.ConstraintReportingLevelId IS NULL AND Inserted.ConstraintReportingLevelId IS NOT NULL THEN 'Inserted'
	WHEN deleted.ConstraintReportingLevelId IS NOT NULL AND Inserted.ConstraintReportingLevelId IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'dd.pr_PublishConstraintReportingLevels:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
