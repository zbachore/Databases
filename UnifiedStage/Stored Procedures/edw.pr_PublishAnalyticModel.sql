SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [edw].[pr_PublishAnalyticModel]
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
EXEC edw.pr_PublishAnalyticModel 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'AnalyticModel',
		@ColumnName VARCHAR(MAX) = 'AnalyticModelID',
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
SELECT AnalyticModelID,
       AnalyticModelName,
       AnalyticModelShortName,
       AnalyticModelDesc,
       RegistryID,
       PatientLevelWorkflowConceptID,
       UpdatedBy
FROM edw.AnalyticModel
WHERE RegistryID = @RegistryID 
)
MERGE INTO UnifiedMetadata.edw.AnalyticModel WITH(TABLOCK) AS T 
USING Source AS S ON S.AnalyticModelID = T.AnalyticModelID

WHEN MATCHED AND NOT EXISTS (
SELECT S.AnalyticModelName,
       S.AnalyticModelShortName,
       S.AnalyticModelDesc,
       S.RegistryID,
       S.PatientLevelWorkflowConceptID
	   INTERSECT 
SELECT T.AnalyticModelName,
       T.AnalyticModelShortName,
       T.AnalyticModelDesc,
       T.RegistryID,
       T.PatientLevelWorkflowConceptID
)
THEN UPDATE SET 
	   AnalyticModelName			=	S.AnalyticModelName,
       AnalyticModelShortName		=	S.AnalyticModelShortName,
       AnalyticModelDesc			=	S.AnalyticModelDesc,
       RegistryID					=	S.RegistryID,
       PatientLevelWorkflowConceptID=	S.PatientLevelWorkflowConceptID,
       UpdatedBy					=	S.UpdatedBy,
	   UpdatedDate					=	DEFAULT 

WHEN NOT MATCHED BY TARGET
THEN INSERT (
		AnalyticModelID,
		AnalyticModelName,
		AnalyticModelShortName,
		AnalyticModelDesc,
		RegistryID,
		PatientLevelWorkflowConceptID,
		UpdatedBy
		) VALUES (
		AnalyticModelID,
		AnalyticModelName,
		AnalyticModelShortName,
		AnalyticModelDesc,
		RegistryID,
		PatientLevelWorkflowConceptID,
		UpdatedBy
)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.AnalyticModelID,deleted.AnalyticModelID), 
	CASE WHEN deleted.AnalyticModelID IS NULL AND Inserted.AnalyticModelID IS NOT NULL THEN 'Inserted'
	WHEN deleted.AnalyticModelID IS NOT NULL AND Inserted.AnalyticModelID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'edw.pr_PublishAnalyticModel:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
