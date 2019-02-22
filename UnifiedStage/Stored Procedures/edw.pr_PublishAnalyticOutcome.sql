SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [edw].[pr_PublishAnalyticOutcome]
@ProjectID INT, @PublishQueueID int AS 
BEGIN
/**************************************************************************************************
Project:		EP-ICD v2-2 AUC and Complication Model
JIRA:			[Ticket # here]
Developer:		zbachore
Date:			2018-07-15
Description:	This procedure loads data to the target table incrementally
___________________________________________________________________________________________________
Example: SELECT Top 10 * from UnifiedMetadata.edw.AnalyticOutcome
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'AnalyticOutcome',
		@ColumnName VARCHAR(MAX) = 'AnalyticOutcomeID',
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
SELECT ao.AnalyticOutcomeID,
       ao.AnalyticModelVersionID,
       ao.AnalyticOutcomeName,
       ao.AnalyticOutcomeDesc,
       ao.IsNumerator,
       ao.IsDenominator,
       ao.IsRate,
       ao.IsObservedEventRate,
       ao.IsExpectedOutcome,
       ao.IsStandardizedRate,
       ao.IsStandardizedRatio,
       ao.IsUpperCI,
       ao.IsLowerCI,
       ao.IsDenominatorExclusionCount,
	   ao.IsOERatio,
       ao.UpdatedBy
FROM edw.AnalyticOutcome ao
INNER JOIN edw.AnalyticModelVersion amv 
	ON amv.AnalyticModelVersionID = ao.AnalyticModelVersionID
INNER JOIN edw.AnalyticModel am 
	ON am.AnalyticModelID = amv.AnalyticModelID
WHERE am.RegistryID = @RegistryID
) 
MERGE INTO UnifiedMetadata.edw.AnalyticOutcome WITH(TABLOCK) AS T 
USING Source AS S ON S.AnalyticOutcomeID = T.AnalyticOutcomeID

WHEN MATCHED AND NOT EXISTS (
SELECT S.AnalyticModelVersionID,
       S.AnalyticOutcomeName,
       S.AnalyticOutcomeDesc,
       S.IsNumerator,
       S.IsDenominator,
       S.IsRate,
       S.IsObservedEventRate,
       S.IsExpectedOutcome,
       S.IsStandardizedRate,
       S.IsStandardizedRatio,
       S.IsUpperCI,
       S.IsLowerCI,
       S.IsDenominatorExclusionCount,
	   S.IsOERatio
	   INTERSECT
SELECT T.AnalyticModelVersionID,
       T.AnalyticOutcomeName,
       T.AnalyticOutcomeDesc,
       T.IsNumerator,
       T.IsDenominator,
       T.IsRate,
       T.IsObservedEventRate,
       T.IsExpectedOutcome,
       T.IsStandardizedRate,
       T.IsStandardizedRatio,
       T.IsUpperCI,
       T.IsLowerCI,
       T.IsDenominatorExclusionCount,
	   T.IsOERatio
	   )
THEN UPDATE SET 
	   AnalyticModelVersionID			=	S.AnalyticModelVersionID,
       AnalyticOutcomeName				=	S.AnalyticOutcomeName,
       AnalyticOutcomeDesc				=	S.AnalyticOutcomeDesc,
       IsNumerator						=	S.IsNumerator,
       IsDenominator					=	S.IsDenominator,
       IsRate							=	S.IsRate,
       IsObservedEventRate				=	S.IsObservedEventRate,
       IsExpectedOutcome				=	S.IsExpectedOutcome,
       IsStandardizedRate				=	S.IsStandardizedRate,
       IsStandardizedRatio				=	S.IsStandardizedRatio,
       IsUpperCI						=	S.IsUpperCI,
       IsLowerCI						=	S.IsLowerCI,
       IsDenominatorExclusionCount		=	S.IsDenominatorExclusionCount,
	   IsOERatio							=	S.IsOERatio,
	   UpdatedBy						=	S.UpdatedBy,
	   UpdatedDate						=	DEFAULT

WHEN NOT MATCHED BY TARGET
THEN INSERT
(	   AnalyticOutcomeID,
       AnalyticModelVersionID,
       AnalyticOutcomeName,
       AnalyticOutcomeDesc,
       IsNumerator,
       IsDenominator,
       IsRate,
       IsObservedEventRate,
       IsExpectedOutcome,
       IsStandardizedRate,
       IsStandardizedRatio,
       IsUpperCI,
       IsLowerCI,
       IsDenominatorExclusionCount,
	   IsOERatio,
       UpdatedBy
	   ) VALUES (
	   AnalyticOutcomeID,
       AnalyticModelVersionID,
       AnalyticOutcomeName,
       AnalyticOutcomeDesc,
       IsNumerator,
       IsDenominator,
       IsRate,
       IsObservedEventRate,
       IsExpectedOutcome,
       IsStandardizedRate,
       IsStandardizedRatio,
       IsUpperCI,
       IsLowerCI,
       IsDenominatorExclusionCount,
	   IsOERatio,
       UpdatedBy
	   )
OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.AnalyticOutcomeID,deleted.AnalyticOutcomeID), 
	CASE WHEN deleted.AnalyticOutcomeID IS NULL AND Inserted.AnalyticOutcomeID IS NOT NULL THEN 'Inserted'
	WHEN deleted.AnalyticOutcomeID IS NOT NULL AND Inserted.AnalyticOutcomeID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'edw.pr_PublishAnalyticOutcome:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
