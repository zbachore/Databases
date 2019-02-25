SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [edw].[pr_PublishPopulation]
@ProjectID INT, @PublishQueueID int AS 
BEGIN
/**************************************************************************************************
Project:		EP-ICD v2-2 AUC and Complication Model
JIRA:			[Ticket # here]
Developer:		zbachore
Date:			2018-07-15
Description:	This procedure loads data to the target table incrementally
___________________________________________________________________________________________________
Example:
EXEC edw.pr_PublishPopulation 6,1

___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Population',
		@ColumnName VARCHAR(MAX) = 'PopulationKey',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@RegistryID INT;


SELECT TOP 1 @RegistryID = rv.RegistryId
FROM dbo.Project p
INNER JOIN rdd.RegistryVersions rv
        ON rv.RegistryVersionId = p.RegistryVersionId
WHERE p.ProjectId = @ProjectID;

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT p.PopulationKey
FROM edw.Population p
INNER JOIN edw.AnalyticModelVersionPopulation amvp 
	ON amvp.PopulationKey = p.PopulationKey
INNER JOIN edw.AnalyticModelVersion amv 
	ON amv.AnalyticModelVersionID = amvp.AnalyticModelVersionID
INNER JOIN edw.AnalyticModel am
	ON am.AnalyticModelID = amv.AnalyticModelID
WHERE am.RegistryID = @RegistryID
)
MERGE INTO UnifiedMetadata.edw.Population WITH(TABLOCK) AS T 
USING Source AS S ON S.PopulationKey = T.PopulationKey

WHEN NOT MATCHED BY TARGET 
THEN INSERT 
(PopulationKey) VALUES (S.PopulationKey)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.PopulationKey,deleted.PopulationKey), 
	CASE WHEN deleted.PopulationKey IS NULL AND Inserted.PopulationKey IS NOT NULL THEN 'Inserted'
	WHEN deleted.PopulationKey IS NOT NULL AND Inserted.PopulationKey IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'edw.pr_PublishPopulation:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
