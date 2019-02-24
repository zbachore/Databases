SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [edw].[pr_PublishMetric]
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
EXEC edw.pr_PublishMetric 6,1

___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'Metric',
		@ColumnName VARCHAR(MAX) = 'MetricKey',
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
SELECT m.MetricKey,
       m.AlgorithmKey,
       m.PopulationKey
FROM edw.Metric m
INNER JOIN edw.AnalyticMetricMapping amm 
	ON amm.MetricKey = m.MetricKey
INNER JOIN edw.AnalyticOutcome ao 
	ON ao.AnalyticOutcomeID = amm.AnalyticOutcomeID
INNER JOIN edw.AnalyticModelVersion amv
	ON amv.AnalyticModelVersionID = ao.AnalyticModelVersionID
INNER JOIN edw.AnalyticModel am 
	ON am.AnalyticModelID = amv.AnalyticModelID
WHERE am.RegistryID = @RegistryID
)
MERGE INTO UnifiedMetadata.edw.Metric WITH(TABLOCK) AS T 
USING Source AS S ON S.MetricKey = T.MetricKey

WHEN MATCHED AND NOt EXISTS (
SELECT S.AlgorithmKey,
       S.PopulationKey
	   INTERSECT
SELECT T.AlgorithmKey,
       T.PopulationKey
	   )
THEN UPDATE SET
		AlgorithmKey = S.AlgorithmKey,
		PopulationKey = S.PopulationKey,
		UpdatedDate = DEFAULT

WHEN NOT MATCHED BY TARGET
THEN INSERT 
(MetricKey, AlgorithmKey, PopulationKey) 
VALUES 
(MetricKey, AlgorithmKey, PopulationKey)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.MetricKey,deleted.MetricKey), 
	CASE WHEN deleted.MetricKey IS NULL AND Inserted.MetricKey IS NOT NULL THEN 'Inserted'
	WHEN deleted.MetricKey IS NOT NULL AND Inserted.MetricKey IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'edw.pr_PublishMetric:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
