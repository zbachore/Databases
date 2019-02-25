SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [edw].[pr_PublishAnalyticModelVersionPopulation]
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
EXEC edw.pr_PublishAnalyticModelVersionPopulation 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'AnalyticModelVersionPopulation',
		@ColumnName VARCHAR(MAX) = 'AnalyticModelVersionPopulationID',
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
SELECT amvp.AnalyticModelVersionPopulationID,
       amvp.AnalyticModelVersionID,
       amvp.PopulationKey,
       amvp.AnalyticPopulationName,
       amvp.UpdatedBy
FROM edw.AnalyticModelVersionPopulation amvp
INNER JOIN edw.AnalyticModelVersion amv
	ON amv.AnalyticModelVersionID = amvp.AnalyticModelVersionID
INNER JOIN edw.AnalyticModel am 
	ON am.AnalyticModelID = amv.AnalyticModelID
WHERE am.RegistryID = @RegistryID
)
MERGE INTO UnifiedMetadata.edw.AnalyticModelVersionPopulation WITH(TABLOCK) AS T
USING Source AS S ON S.AnalyticModelVersionPopulationID = T.AnalyticModelVersionPopulationID

WHEN MATCHED AND NOT EXISTS(
SELECT S.AnalyticModelVersionID,
       S.PopulationKey,
       S.AnalyticPopulationName
	   INTERSECT
SELECT S.AnalyticModelVersionID,
       S.PopulationKey,
       S.AnalyticPopulationName
	   )
THEN UPDATE SET 
	   AnalyticModelVersionID	=	S.AnalyticModelVersionID,
       PopulationKey			=	S.PopulationKey,
       AnalyticPopulationName			=	S.AnalyticPopulationName,
	   UpdatedBy				=	S.UpdatedBy,
	   UpdatedDate				=	DEFAULT

WHEN NOT MATCHED BY TARGET
THEN INSERT
(	   AnalyticModelVersionPopulationID,
       AnalyticModelVersionID,
       PopulationKey,
       AnalyticPopulationName,
       UpdatedBy
	   ) VALUES (
	   AnalyticModelVersionPopulationID,
       AnalyticModelVersionID,
       PopulationKey,
       AnalyticPopulationName,
       UpdatedBy
)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.AnalyticModelVersionPopulationID,deleted.AnalyticModelVersionPopulationID), 
	CASE WHEN deleted.AnalyticModelVersionPopulationID IS NULL AND Inserted.AnalyticModelVersionPopulationID IS NOT NULL THEN 'Inserted'
	WHEN deleted.AnalyticModelVersionPopulationID IS NOT NULL AND Inserted.AnalyticModelVersionPopulationID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'edw.pr_PublishAnalyticModelVersionPopulation:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
