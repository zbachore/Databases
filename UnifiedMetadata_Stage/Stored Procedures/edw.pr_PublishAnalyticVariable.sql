SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [edw].[pr_PublishAnalyticVariable]
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
EXEC edw.pr_PublishAnalyticVariable 6,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'AnalyticVariable',
		@ColumnName VARCHAR(MAX) = 'AnalyticVariableID',
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
SELECT av.AnalyticVariableID,
       av.AnalyticModelVersionID,
       av.AnalyticVariableName,
       av.DataElementID,
       av.UpdatedBy
FROM edw.AnalyticVariable av
INNER JOIN edw.AnalyticModelVersion amv
	ON amv.AnalyticModelVersionID = av.AnalyticModelVersionID
INNER JOIN edw.AnalyticModel am 
	ON am.AnalyticModelID = amv.AnalyticModelID
WHERE am.RegistryID = @RegistryID
)
MERGE INTO UnifiedMetadata.edw.AnalyticVariable WITH(TABLOCK) AS T
USING Source AS S ON S.AnalyticVariableID = T.AnalyticVariableID

WHEN MATCHED AND NOT EXISTS(
SELECT S.AnalyticModelVersionID,
       S.AnalyticVariableName,
       S.DataElementID
	   INTERSECT
SELECT T.AnalyticModelVersionID,
	   T.AnalyticVariableName,
	   T.DataElementID
)
THEN UPDATE SET 
	   AnalyticModelVersionID		=	S.AnalyticModelVersionID,
       AnalyticVariableName			=	S.AnalyticVariableName,
       DataElementID				=	S.DataElementID,
	   UpdatedBy					=	S.UpdatedBy,
	   UpdatedDate					=	DEFAULT

WHEN NOT MATCHED BY TARGET
THEN INSERT
(	   AnalyticVariableID,
       AnalyticModelVersionID,
       AnalyticVariableName,
       DataElementID,
       UpdatedBy
	   ) VALUES (
	   AnalyticVariableID,
       AnalyticModelVersionID,
       AnalyticVariableName,
       DataElementID,
       UpdatedBy
)


OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.AnalyticVariableID,deleted.AnalyticVariableID), 
	CASE WHEN deleted.AnalyticVariableID IS NULL AND Inserted.AnalyticVariableID IS NOT NULL THEN 'Inserted'
	WHEN deleted.AnalyticVariableID IS NOT NULL AND Inserted.AnalyticVariableID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'edw.pr_PublishAnalyticVariable:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
