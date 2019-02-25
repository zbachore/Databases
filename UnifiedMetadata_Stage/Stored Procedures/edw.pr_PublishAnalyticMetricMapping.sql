SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [edw].[pr_PublishAnalyticMetricMapping]
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
EXEC edw.pr_PublishAnalyticMetricMapping 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'AnalyticMetricMapping',
		@ColumnName VARCHAR(MAX) = 'AnalyticMetricMappingID',
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
SELECT amm.AnalyticMetricMappingID,
       amm.AnalyticOutcomeID,
       amm.MetricKey,
       amm.NumeratorEntityColumnID,
       amm.DenominatorEntityColumnID,
       amm.PercentageEntityColumnID,
       amm.UpdatedBy
FROM edw.AnalyticMetricMapping amm
INNER JOIN edw.AnalyticOutcome ao 
	ON ao.AnalyticOutcomeID = amm.AnalyticOutcomeID
INNER JOIN edw.AnalyticModelVersion amv 
	ON amv.AnalyticModelVersionID = ao.AnalyticModelVersionID
INNER JOIN edw.AnalyticModel am ON am.AnalyticModelID = amv.AnalyticModelID
WHERE am.RegistryID = @RegistryID
)
MERGE INTO UnifiedMetadata.edw.AnalyticMetricMapping WITH(TABLOCK) AS T
USING Source AS S ON s.AnalyticMetricMappingID = T.AnalyticMetricMappingID

WHEN MATCHED AND NOT EXISTS(
SELECT	S.AnalyticOutcomeID,
		S.MetricKey,
		S.NumeratorEntityColumnID,
		S.DenominatorEntityColumnID,
		S.PercentageEntityColumnID
		INTERSECT
SELECT	T.AnalyticOutcomeID,
		T.MetricKey,
		T.NumeratorEntityColumnID,
		T.DenominatorEntityColumnID,
		T.PercentageEntityColumnID
)
THEN UPDATE SET 
		AnalyticOutcomeID			=	S.AnalyticOutcomeID,
		MetricKey					=	S.MetricKey,
		NumeratorEntityColumnID		=	S.NumeratorEntityColumnID,
		DenominatorEntityColumnID	=	S.DenominatorEntityColumnID,
		PercentageEntityColumnID	=	S.PercentageEntityColumnID,
		UpdatedBy					=	S.UpdatedBy,
		UpdatedDate					=	DEFAULT 


WHEN NOT MATCHED BY TARGET
THEN INSERT 
(		AnalyticMetricMappingID,
		AnalyticOutcomeID,
		MetricKey,
		NumeratorEntityColumnID,
		DenominatorEntityColumnID,
		PercentageEntityColumnID,
		UpdatedBy
		) VALUES (
		AnalyticMetricMappingID,
		AnalyticOutcomeID,
		MetricKey,
		NumeratorEntityColumnID,
		DenominatorEntityColumnID,
		PercentageEntityColumnID,
		UpdatedBy
)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.AnalyticMetricMappingID,deleted.AnalyticMetricMappingID), 
	CASE WHEN deleted.AnalyticMetricMappingID IS NULL AND Inserted.AnalyticMetricMappingID IS NOT NULL THEN 'Inserted'
	WHEN deleted.AnalyticMetricMappingID IS NOT NULL AND Inserted.AnalyticMetricMappingID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'edw.pr_PublishAnalyticMetricMapping:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
