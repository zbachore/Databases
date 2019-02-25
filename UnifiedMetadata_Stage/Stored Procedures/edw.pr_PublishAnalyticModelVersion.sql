SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [edw].[pr_PublishAnalyticModelVersion]
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
EXEC edw.pr_PublishAnalyticModelVersion 6,1 
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'AnalyticModelVersion',
		@ColumnName VARCHAR(MAX) = 'AnalyticModelVersionID',
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
SELECT amv.AnalyticModelVersionID,
       amv.AnalyticModelID,
       amv.VersionNumber,
       amv.VersionNote,
       amv.StartTimeframe,
       amv.EndTimeframe,
       amv.DACClientID,
       amv.SiteLevelFileName,
       amv.PatientLevelFileName,
       amv.InformationFileName,
       amv.ControlFileName,
       amv.UpdatedBy
FROM edw.AnalyticModelVersion amv
INNER JOIN edw.AnalyticModel am 
	ON am.AnalyticModelID = amv.AnalyticModelID 
WHERE am.RegistryID = @RegistryID
)
MERGE INTO UnifiedMetadata.edw.AnalyticModelVersion WITH(TABLOCK) AS T
USING Source AS S ON S.AnalyticModelVersionID = T.AnalyticModelVersionID

WHEN MATCHED AND NOT EXISTS (
SELECT S.AnalyticModelID,
       S.VersionNumber,
       S.VersionNote,
       S.StartTimeframe,
       S.EndTimeframe,
       S.DACClientID,
       S.SiteLevelFileName,
       S.PatientLevelFileName,
       S.InformationFileName,
       S.ControlFileName
	   INTERSECT 
SELECT T.AnalyticModelID,
       T.VersionNumber,
       T.VersionNote,
       T.StartTimeframe,
       T.EndTimeframe,
       T.DACClientID,
       T.SiteLevelFileName,
       T.PatientLevelFileName,
       T.InformationFileName,
       T.ControlFileName
)
THEN UPDATE SET 
	   AnalyticModelID			=	S.AnalyticModelID,
       VersionNumber			=	S.VersionNumber,
       VersionNote				=	S.VersionNote,
       StartTimeframe			=	S.StartTimeframe,
       EndTimeframe				=	S.EndTimeframe,
       DACClientID				=	S.DACClientID,
       SiteLevelFileName		=	S.SiteLevelFileName,
       PatientLevelFileName		=	S.PatientLevelFileName,
       InformationFileName		=	S.InformationFileName,
       ControlFileName			=	S.ControlFileName,
	   UpdatedBy				=	S.UpdatedBy,
	   UpdatedDate				=	DEFAULT
WHEN NOT MATCHED BY TARGET
THEN INSERT 
(      AnalyticModelVersionID,
       AnalyticModelID,
       VersionNumber,
       VersionNote,
       StartTimeframe,
       EndTimeframe,
       DACClientID,
       SiteLevelFileName,
       PatientLevelFileName,
       InformationFileName,
       ControlFileName,
       UpdatedBy
	   ) VALUES (
	   AnalyticModelVersionID,
       AnalyticModelID,
       VersionNumber,
       VersionNote,
       StartTimeframe,
       EndTimeframe,
       DACClientID,
       SiteLevelFileName,
       PatientLevelFileName,
       InformationFileName,
       ControlFileName,
       UpdatedBy
)
OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.AnalyticModelVersionID,deleted.AnalyticModelVersionID), 
	CASE WHEN deleted.AnalyticModelVersionID IS NULL AND Inserted.AnalyticModelVersionID IS NOT NULL THEN 'Inserted'
	WHEN deleted.AnalyticModelVersionID IS NOT NULL AND Inserted.AnalyticModelVersionID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'edw.pr_PublishAnalyticModelVersion:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
