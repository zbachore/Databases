SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishTemporalContexts] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines cdd.pr_PublishTemporalContexts stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishTemporalContexts 3, 1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'TemporalContexts',
		@ColumnName VARCHAR(MAX) = 'TemporalContextID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    tc.*
FROM UnifiedMetadata_Stage.dbo.ProjectDataElements pde
INNER JOIN UnifiedMetadata_Stage.cdd.DataElements de
        ON pde.ReferenceID = de.DataElementId
    INNER JOIN UnifiedMetadata_Stage.cdd.TemporalContexts tc
        ON tc.TemporalContextId = de.TemporalContextId
		WHERE pde.ProjectId = @ProjectID

)

MERGE INTO UnifiedMetadata.cdd.TemporalContexts WITH(TABLOCK) AS T
USING Source AS S
ON S.TemporalContextId = T.TemporalContextId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.TemporalContextName, 
S.TemporalContextDescription, 
S.UpdatedBy 

INTERSECT

SELECT
 
		
T.TemporalContextName, 
T.TemporalContextDescription, 
T.UpdatedBy)


THEN UPDATE SET 
TemporalContextName						=	S.TemporalContextName, 
TemporalContextDescription						=	S.TemporalContextDescription, 
UpdatedBy						=	S.UpdatedBy ,
UpdatedDate			= DEFAULT




WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
TemporalContextId, 
TemporalContextName, 
TemporalContextDescription, 
UpdatedBy
) VALUES (
TemporalContextId, 
TemporalContextName, 
TemporalContextDescription, 
UpdatedBy)
OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.TemporalContextID,deleted.TemporalContextID), 
	CASE WHEN deleted.TemporalContextID IS NULL AND Inserted.TemporalContextID IS NOT NULL THEN 'Inserted'
	WHEN deleted.TemporalContextID IS NOT NULL AND Inserted.TemporalContextID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishTemporalContexts:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
