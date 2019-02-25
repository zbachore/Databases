SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [cdd].[pr_PublishDataElements] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines cdd.pr_PublishDataElements stored procedure
___________________________________________________________________________________________________
Example: EXEC cdd.pr_PublishDataElements 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
02/21/2018     rkakani		Added DISTINCT keyword to removed duplicates from Source
02/21/2018     rkakani		Removed columns de.CreatedDate,de.UpdatedDate from the source as these fields are not required 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DataElements',
		@ColumnName VARCHAR(MAX) = 'DataElementID',
		@RequestedTime DATETIME2 = SYSDATETIME();

BEGIN TRY
BEGIN TRAN;

WITH Source AS (
SELECT DISTINCT de.DataElementId,
				de.ConceptId,
				de.DataTypeId,
				de.DataElementSeq,
				de.TemporalContextId,
				de.DataElementExternalRefId,
				de.DataElementName,
				de.DataElementShortName,
				de.IsMultiSelect,
				de.UnitOfMeasureValueSetId,
				de.UnitOfMeasureId,
				de.IsActive,
				de.StartDate,
				de.EndDate,
				de.UpdatedBy,
				de.DataElementLabel,
				de.WorkflowConceptId,
				de.ValueInstance,
				de.ReferencedElementId,
				de.ScopeId
FROM UnifiedMetadata_Stage.cdd.DataElements de
INNER JOIN UnifiedMetadata_Stage.dbo.ProjectDataElements pde 
ON pde.ReferenceID = de.DataElementId
WHERE pde.ProjectId = @ProjectID
)
MERGE INTO UnifiedMetadata.cdd.DataElements WITH(TABLOCK) AS T
USING Source AS S
ON S.DataElementId = T.DataElementId
WHEN MATCHED AND NOT EXISTS
(
	SELECT 
	S.ConceptId, 
	S.DataTypeId, 
	S.DataElementSeq, 
	S.TemporalContextId, 
	S.DataElementExternalRefId, 
	S.DataElementName, 
	S.DataElementShortName, 
	S.IsMultiSelect, 
	S.UnitOfMeasureValueSetId, 
	S.UnitOfMeasureId, 
	S.IsActive, 
	S.StartDate, 
	S.EndDate, 
	S.UpdatedBy, 
	S.DataElementLabel, 
	S.WorkflowConceptId, 
	S.ValueInstance, 
	S.ReferencedElementId, 
	S.ScopeId 

	INTERSECT

	SELECT		
	T.ConceptId, 
	T.DataTypeId, 
	T.DataElementSeq, 
	T.TemporalContextId, 
	T.DataElementExternalRefId, 
	T.DataElementName, 
	T.DataElementShortName, 
	T.IsMultiSelect, 
	T.UnitOfMeasureValueSetId, 
	T.UnitOfMeasureId, 
	T.IsActive, 
	T.StartDate, 
	T.EndDate, 
	T.UpdatedBy, 
	T.DataElementLabel, 
	T.WorkflowConceptId, 
	T.ValueInstance, 
	T.ReferencedElementId, 
	T.ScopeId
)

THEN UPDATE SET 
ConceptId						=	S.ConceptId, 
DataTypeId						=	S.DataTypeId, 
DataElementSeq					=	S.DataElementSeq, 
TemporalContextId				=	S.TemporalContextId, 
DataElementExternalRefId		=	S.DataElementExternalRefId, 
DataElementName					=	S.DataElementName, 
DataElementShortName			=	S.DataElementShortName, 
IsMultiSelect					=	S.IsMultiSelect, 
UnitOfMeasureValueSetId			=	S.UnitOfMeasureValueSetId, 
UnitOfMeasureId					=	S.UnitOfMeasureId, 
IsActive						=	S.IsActive, 
StartDate						=	S.StartDate, 
EndDate						    =	S.EndDate, 
UpdatedBy						=	S.UpdatedBy, 
DataElementLabel				=	S.DataElementLabel, 
WorkflowConceptId				=	S.WorkflowConceptId, 
ValueInstance					=	S.ValueInstance, 
ReferencedElementId				=	S.ReferencedElementId, 
ScopeId						    =	S.ScopeId ,
UpdatedDate			            = DEFAULT

WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
DataElementId, 
ConceptId, 
DataTypeId, 
DataElementSeq, 
TemporalContextId, 
DataElementExternalRefId, 
DataElementName, 
DataElementShortName, 
IsMultiSelect, 
UnitOfMeasureValueSetId, 
UnitOfMeasureId, 
IsActive, 
StartDate, 
EndDate, 
UpdatedBy, 
DataElementLabel, 
WorkflowConceptId, 
ValueInstance, 
ReferencedElementId, 
ScopeId
) VALUES (
DataElementId, 
ConceptId, 
DataTypeId, 
DataElementSeq, 
TemporalContextId, 
DataElementExternalRefId, 
DataElementName, 
DataElementShortName, 
IsMultiSelect, 
UnitOfMeasureValueSetId, 
UnitOfMeasureId, 
IsActive, 
StartDate, 
EndDate, 
UpdatedBy, 
DataElementLabel, 
WorkflowConceptId, 
ValueInstance, 
ReferencedElementId, 
ScopeId)

OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.DataElementID,deleted.DataElementID), 
	CASE WHEN deleted.DataElementID IS NULL AND Inserted.DataElementID IS NOT NULL THEN 'Inserted'
	WHEN deleted.DataElementID IS NOT NULL AND Inserted.DataElementID IS NOT NULL THEN 'Updated'
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
    SET @ErrorMessage = 'cdd.pr_PublishDataElements:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
