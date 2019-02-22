SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rdd].[pr_PublishRegistryElements] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines rdd.pr_PublishRegistryElements stored procedure
___________________________________________________________________________________________________
Example: EXEC rdd.pr_PublishRegistryElements 3,1
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for 
2018-05-29		zbachore		Added Delete logic to delete rows deleted from author.
2018-07-11		zbachore		Added logic to delete only if the RegistryElement
								belongs to Registries whose startDate is in the future.
2018-11-27		zbachore		Made the delete statement to happen first
2019-02-06		zbachore		Removed logic to delete registryelements based on startDate
2019-02-06		zbachore		Modified a bug that Sanjit identified
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'RegistryElements',
		@ColumnName VARCHAR(MAX) = 'RegistryElementID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@StartDate DATETIME,
		@RegistryVersionID INT;


BEGIN TRY
BEGIN TRAN;

DROP TABLE IF EXISTS UnifiedMetadata.dbo.RegistryElements
SELECT * INTO UnifiedMetadata.dbo.RegistryElements 
FROM UnifiedMetadata.rdd.RegistryElements 

SELECT @RegistryVersionID = RegistryVersionID 
FROM dbo.Project 
WHERE ProjectID = @ProjectID;

WITH Source AS ( 
SELECT DISTINCT re.RegistryElementId,
				re.DataElementId,
				re.RegistryVersionId,
				re.DataElementCodingInstructionId,
				re.ConceptDefinitionId,
				re.ValueSetId,
				re.DefaultValueSetMemberId,
				re.DefaultValue,
				re.IsPublished,
				re.IsHarvested,
				re.PrevVersionReferenceNote,
				re.IsActive,
				re.UpdatedBy,
				re.ContainingRegistryElementId,
				re.DataSourceId,
				re.IsDPIField,
				re.RegistrySectionId,
				re.IsBase,
				re.IsFollowup,
				re.VendorInstruction,
				re.IsSupportingDefinitionPublished,
				re.IsContainerId,
				re.MissingData,
				re.DisplayOrder,
				re.EDWTimePartEntityColumnID,
				re.EDWFlipElementInd,
				re.EDWMappingInstruction,
				re.RegistryElementLabel,
				re.EDWEntityColumnId,
				re.ContainmentTypeId,
				re.UseInComputedConcept,
				re.ClinicalRegistrySectionId
FROM UnifiedMetadata_Stage.dbo.Project p
    INNER JOIN UnifiedMetadata_Stage.rdd.RegistryElements re
        ON re.RegistryVersionId = p.RegistryVersionId
WHERE p.ProjectId = @ProjectID
	)		
MERGE INTO UnifiedMetadata.rdd.RegistryElements WITH(TABLOCK) AS T
USING Source AS S
ON S.RegistryElementId = T.RegistryElementId


WHEN NOT MATCHED BY SOURCE 
AND T.RegistryElementID IN 
(
SELECT RegistryElementId 
FROM UnifiedMetadata.rdd.RegistryElements 
WHERE RegistryVersionId = @RegistryVersionID
)
THEN DELETE

WHEN MATCHED AND NOT EXISTS(
	SELECT 
	S.DataElementId, 
	S.RegistryVersionId, 
	S.DataElementCodingInstructionId, 
	S.ConceptDefinitionId, 
	S.ValueSetId, 
	S.DefaultValueSetMemberId, 
	S.DefaultValue, 
	S.IsPublished, 
	S.IsHarvested, 
	S.PrevVersionReferenceNote, 
	S.IsActive, 
	S.UpdatedBy, 
	S.ContainingRegistryElementId, 
	S.DataSourceId, 
	S.IsDPIField, 
	S.RegistrySectionId, 
	S.IsBase, 
	S.IsFollowup, 
	S.VendorInstruction, 
	S.IsSupportingDefinitionPublished, 
	S.IsContainerId, 
	S.MissingData, 
	S.DisplayOrder, 
	S.EDWTimePartEntityColumnID, 
	S.EDWFlipElementInd, 
	S.EDWMappingInstruction, 
	S.RegistryElementLabel, 
	S.EDWEntityColumnId, 
	S.ContainmentTypeId,
	S.UseInComputedConcept,
	S.ClinicalRegistrySectionId
INTERSECT
	SELECT		
	T.DataElementId, 
	T.RegistryVersionId, 
	T.DataElementCodingInstructionId, 
	T.ConceptDefinitionId, 
	T.ValueSetId, 
	T.DefaultValueSetMemberId, 
	T.DefaultValue, 
	T.IsPublished, 
	T.IsHarvested, 
	T.PrevVersionReferenceNote, 
	T.IsActive, 
	T.UpdatedBy, 
	T.ContainingRegistryElementId, 
	T.DataSourceId, 
	T.IsDPIField, 
	T.RegistrySectionId, 
	T.IsBase, 
	T.IsFollowup, 
	T.VendorInstruction, 
	T.IsSupportingDefinitionPublished, 
	T.IsContainerId, 
	T.MissingData, 
	T.DisplayOrder, 
	T.EDWTimePartEntityColumnID, 
	T.EDWFlipElementInd, 
	T.EDWMappingInstruction, 
	T.RegistryElementLabel, 
	T.EDWEntityColumnId, 
	T.ContainmentTypeId,
	T.UseInComputedConcept,
	T.ClinicalRegistrySectionID
	)
THEN UPDATE SET 
		DataElementId						=	S.DataElementId, 
		RegistryVersionId					=	S.RegistryVersionId, 
		DataElementCodingInstructionId		=	S.DataElementCodingInstructionId, 
		ConceptDefinitionId					=	S.ConceptDefinitionId, 
		ValueSetId						    =	S.ValueSetId, 
		DefaultValueSetMemberId				=	S.DefaultValueSetMemberId, 
		DefaultValue						=	S.DefaultValue, 
		IsPublished						    =	S.IsPublished, 
		IsHarvested						    =	S.IsHarvested, 
		PrevVersionReferenceNote			=	S.PrevVersionReferenceNote, 
		IsActive						    =	S.IsActive, 
		UpdatedBy						    =	S.UpdatedBy, 
		ContainingRegistryElementId			=	S.ContainingRegistryElementId, 
		DataSourceId						=	S.DataSourceId, 
		IsDPIField						    =	S.IsDPIField, 
		RegistrySectionId					=	S.RegistrySectionId, 
		IsBase						        =	S.IsBase, 
		IsFollowup						    =	S.IsFollowup, 
		VendorInstruction					=	S.VendorInstruction, 
		IsSupportingDefinitionPublished		=	S.IsSupportingDefinitionPublished, 
		IsContainerId						=	S.IsContainerId, 
		MissingData						    =	S.MissingData, 
		DisplayOrder						=	S.DisplayOrder, 
		EDWTimePartEntityColumnID			=	S.EDWTimePartEntityColumnID, 
		EDWFlipElementInd					=	S.EDWFlipElementInd, 
		EDWMappingInstruction				=	S.EDWMappingInstruction, 
		RegistryElementLabel				=	S.RegistryElementLabel, 
		EDWEntityColumnId					=	S.EDWEntityColumnId, 
		ContainmentTypeId					=	S.ContainmentTypeId ,
		UseInComputedConcept				=	S.UseInComputedConcept,
		ClinicalRegistrySectionID			=	S.ClinicalRegistrySectionID,
		UpdatedDate			                = DEFAULT
WHEN NOT MATCHED BY TARGET 
THEN INSERT ( 
	RegistryElementId, 
	DataElementId, 
	RegistryVersionId, 
	DataElementCodingInstructionId, 
	ConceptDefinitionId, 
	ValueSetId, 
	DefaultValueSetMemberId, 
	DefaultValue, 
	IsPublished, 
	IsHarvested, 
	PrevVersionReferenceNote, 
	IsActive, 
	UpdatedBy, 
	ContainingRegistryElementId, 
	DataSourceId, 
	IsDPIField, 
	RegistrySectionId, 
	IsBase, 
	IsFollowup, 
	VendorInstruction, 
	IsSupportingDefinitionPublished, 
	IsContainerId, 
	MissingData, 
	DisplayOrder, 
	EDWTimePartEntityColumnID, 
	EDWFlipElementInd, 
	EDWMappingInstruction, 
	RegistryElementLabel, 
	EDWEntityColumnId, 
	ContainmentTypeId,
	UseInComputedConcept,
	ClinicalRegistrySectionID
) VALUES (
	RegistryElementId, 
	DataElementId, 
	RegistryVersionId, 
	DataElementCodingInstructionId, 
	ConceptDefinitionId, 
	ValueSetId, 
	DefaultValueSetMemberId, 
	DefaultValue, 
	IsPublished, 
	IsHarvested, 
	PrevVersionReferenceNote, 
	IsActive, 
	UpdatedBy, 
	ContainingRegistryElementId, 
	DataSourceId, 
	IsDPIField, 
	RegistrySectionId, 
	IsBase, 
	IsFollowup, 
	VendorInstruction, 
	IsSupportingDefinitionPublished, 
	IsContainerId, 
	MissingData, 
	DisplayOrder, 
	EDWTimePartEntityColumnID, 
	EDWFlipElementInd, 
	EDWMappingInstruction, 
	RegistryElementLabel, 
	EDWEntityColumnId, 
	ContainmentTypeId,
	UseInComputedConcept,
	ClinicalRegistrySectionID
)
OUTPUT  
	@PublishQueueID,
	@@SERVERNAME, 
	@TableName, 
	@ColumnName, 
	ISNULL(inserted.RegistryElementID,deleted.RegistryElementID), 
	CASE WHEN deleted.RegistryElementID IS NULL 
	AND Inserted.RegistryElementID IS NOT NULL 
	THEN 'Inserted'
	WHEN deleted.RegistryElementID IS NOT NULL 
	AND Inserted.RegistryElementID IS NOT NULL 
	THEN 'Updated'
	WHEN deleted.RegistryElementID IS NOT NULL 
	AND Inserted.RegistryElementID IS NULL 
	THEN 'Deleted'
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
    SET @ErrorMessage = 'rdd.pr_PublishRegistryElements:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
