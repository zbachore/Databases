SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishValueSets] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines cdd.pr_PublishValueSets stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishValueSets 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-10-05		zbachore		Added ValueSetDiscriminator
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'ValueSets',
		@ColumnName VARCHAR(MAX) = 'ValueSetID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT
    vs.ValueSetId,
    vs.ValueSetName,
    vs.ValueSetOid,
    vs.IsDynamicList,
    vs.IsPermissibleValueList,
    vs.IsActive,
    vs.StartDate,
    vs.EndDate,
    vs.UpdatedBy,
    vs.CodeSystemId, 
    vs.Synonyms,
	vs.ValueSetDiscriminator
FROM UnifiedMetadata_Stage.dbo.ProjectValueSets pvs
    INNER JOIN UnifiedMetadata_Stage.cdd.ValueSets vs ON vs.ValueSetId = pvs.ReferenceID
WHERE pvs.ProjectId = @ProjectID

)

MERGE INTO UnifiedMetadata.cdd.ValueSets WITH(TABLOCK) AS T
USING Source AS S
ON S.ValueSetId = T.ValueSetId
WHEN MATCHED AND NOT EXISTS
(SELECT 
S.ValueSetName, 
S.ValueSetOid, 
S.IsDynamicList, 
S.IsPermissibleValueList, 
S.IsActive, 
S.StartDate, 
S.EndDate, 
S.UpdatedBy,
S.CodeSystemId,
S.Synonyms,
S.ValueSetDiscriminator

INTERSECT

SELECT
 
		
T.ValueSetName, 
T.ValueSetOid, 
T.IsDynamicList, 
T.IsPermissibleValueList, 
T.IsActive, 
T.StartDate, 
T.EndDate, 
T.UpdatedBy,
T.CodeSystemId,
T.Synonyms,
T.ValueSetDiscriminator)


THEN UPDATE SET 
ValueSetName				=	S.ValueSetName, 
ValueSetOid					=	S.ValueSetOid, 
IsDynamicList				=	S.IsDynamicList, 
IsPermissibleValueList		=	S.IsPermissibleValueList, 
IsActive					=	S.IsActive, 
StartDate					=	S.StartDate, 
EndDate						=	S.EndDate, 
UpdatedBy					=	S.UpdatedBy ,
CodeSystemID				=	S.CodeSystemId,
Synonyms					=	S.Synonyms,
ValueSetDiscriminator		=	S.ValueSetDiscriminator,
UpdatedDate					=	DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
ValueSetId, 
ValueSetName, 
ValueSetOid, 
IsDynamicList, 
IsPermissibleValueList, 
IsActive, 
StartDate, 
EndDate, 
UpdatedBy,
CodeSystemID, 
Synonyms,
ValueSetDiscriminator
) VALUES (
ValueSetId, 
ValueSetName, 
ValueSetOid, 
IsDynamicList, 
IsPermissibleValueList, 
IsActive, 
StartDate, 
EndDate, 
UpdatedBy,
CodeSystemID,
Synonyms,
ValueSetDiscriminator )

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.ValueSetID,deleted.ValueSetID), 
	CASE WHEN deleted.ValueSetID IS NULL AND Inserted.ValueSetID IS NOT NULL THEN 'Inserted'
	WHEN deleted.ValueSetID IS NOT NULL AND Inserted.ValueSetID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishValueSets:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
