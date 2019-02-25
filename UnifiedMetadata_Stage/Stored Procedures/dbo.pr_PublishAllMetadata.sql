SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[pr_PublishAllMetadata] @ProjectID INT, @PublishQueueID INT
AS 

BEGIN
SET XACT_ABORT ON

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			Jan 11 2018  8:24PM
Description:	Defines dbo.pr_PublishAllMetadata stored procedure
___________________________________________________________________________________________________
Example: EXEC dbo.pr_PublishAllMetadata 5,2318
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-07-02		zbachore		Added pr_PublishUnitsOfMeasure and pr_PublishUnitsOfMeasureAlias
2018-07-26		zbachore		Added SAS Model metadata publish stored procedures
2018-09-14		zbachore		Commented out SAS Metadata Stored procedures until they are needed
2018-12-14		zbachore		Added dd.pr_PublishConstraintDefinitionRelatedElementGroups to the list.
2019-02-06		zbachore		Reordered SPs
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max)

BEGIN TRAN;
BEGIN TRY 


IF EXISTS (SELECT name FROM UnifiedMetadata.sys.foreign_keys WHERE name = 'FK_FormElements_FormSections')
BEGIN
ALTER TABLE UnifiedMetadata.form.FormElements DROP CONSTRAINT FK_FormElements_FormSections
END
IF EXISTS (SELECT name FROM UnifiedMetadata.sys.foreign_keys WHERE name = 'FK_FormSections_FormElements')
BEGIN
ALTER TABLE UnifiedMetadata.form.FormSections DROP CONSTRAINT FK_FormSections_FormElements
END


EXEC UnifiedMetadata.sys.sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
EXEC dd.pr_PublishConstraintDefinitionRelatedElements @ProjectID, @PublishQueueID
EXEC dd.pr_PublishConstraintDefinitionRelatedElementGroups @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryElements_ConstraintDefinitions @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishDataElementConstraintDefinitions @ProjectID, @PublishQueueID
EXEC dd.pr_PublishConstraintDefinitions @ProjectID, @PublishQueueID
EXEC dbo.pr_CompareTableStructure @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishValueSets @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishConcepts @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishUnitsOfMeasure @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishCodeSystem_Taxonomy @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishTemporalContexts @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishCodeSystemTermCodes @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryVersions @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishCodeSystemTerms_Taxonomy @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistrySections @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryElementThresholds @ProjectID, @PublishQueueID
EXEC ld.pr_PublishComposites @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryElements @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishConcepts_CodeSystemTerms @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistries @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishConcepts_Taxonomy @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishDataTypes @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishConceptSynonyms @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishDataSources @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishDataElements @ProjectID, @PublishQueueID
EXEC dd.pr_PublishConstraintDefinitionScopes @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishDataElementCodingInstructions @ProjectID, @PublishQueueID
EXEC dd.pr_PublishConstraintReportingLevels @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishConceptDefinitions @ProjectID, @PublishQueueID
EXEC dd.pr_PublishConstraintTypes @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishCodeSystemTerms @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishContainmentTypes @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishCodeSystems @ProjectID, @PublishQueueID
EXEC ld.pr_PublishDeviceManufacturers @ProjectID, @PublishQueueID
EXEC ld.pr_PublishDevices @ProjectID, @PublishQueueID
EXEC ld.pr_PublishDeviceSubtypes @ProjectID, @PublishQueueID
EXEC ld.pr_PublishDeviceTypes @ProjectID, @PublishQueueID
EXEC edw.pr_PublishEntities @ProjectID, @PublishQueueID
EXEC edw.pr_PublishEntityColumns @ProjectID, @PublishQueueID
EXEC form.pr_PublishFormElements @ProjectID, @PublishQueueID
EXEC form.pr_PublishFormSectionConstraintDefintitions @ProjectID, @PublishQueueID
EXEC form.pr_PublishFormSections @ProjectID, @PublishQueueID
EXEC form.pr_PublishFormSectionTypes @ProjectID, @PublishQueueID
EXEC form.pr_PublishFormPageConstraintDefinitions @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishDataElements_ValueSets @ProjectID, @PublishQueueID
EXEC form.pr_PublishFormPageLocations @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishDataTypes_ConstraintTypes @ProjectID, @PublishQueueID
EXEC form.pr_PublishFormPages @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishConceptDefinitionTypes @ProjectID, @PublishQueueID
EXEC form.pr_PublishForms @ProjectID, @PublishQueueID
EXEC form.pr_PublishFormTypes @ProjectID, @PublishQueueID
EXEC ld.pr_PublishMedicationCategories @ProjectID, @PublishQueueID
EXEC ld.pr_PublishMedications @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishValueSets_Taxonomy @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryDataSets @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryDataSets_RegistryElements @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryElementThresholdRelatedElements @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistrySectionContainerClasses @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistrySectionTypes @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryVersionComposites @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryVersionConfigurations @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryVersions_ValueSetMembers @ProjectID, @PublishQueueID
EXEC dd.pr_PublishTaxonomy @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishUnitsOfMeasureAlias @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishValueSetConceptMembers @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishValueSetDeviceMembers @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishValueSetMedicationMembers @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishValueSetMembers @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishValueSetUnitOfMeasureMembers @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishUnitsOfMeasure @ProjectID, @PublishQueueID
EXEC cdd.pr_PublishUnitsOfMeasureAlias @ProjectID, @PublishQueueID
EXEC rdd.pr_PublishRegistryOperatorRole @ProjectID, @PublishQueueID


--SAS Metadata Stored Procedures
--EXEC edw.pr_PublishAnalyticModelVersion @ProjectID, @PublishQueueID
--EXEC edw.pr_PublishAnalyticModelVersionPopulation @ProjectID, @PublishQueueID
--EXEC edw.pr_PublishAnalyticOutcome @ProjectID, @PublishQueueID
--EXEC edw.pr_PublishAnalyticVariable @ProjectID, @PublishQueueID
--EXEC edw.pr_PublishMetric @ProjectID, @PublishQueueID
--EXEC edw.pr_PublishPopulation @ProjectID, @PublishQueueID
--EXEC edw.pr_PublishAnalyticMetricMapping @ProjectID, @PublishQueueID
--EXEC edw.pr_PublishAnalyticModel @ProjectID, @PublishQueueID



exec UnifiedMetadata.sys.sp_MSforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

ALTER TABLE UnifiedMetadata.form.FormElements  WITH CHECK ADD  CONSTRAINT FK_FormElements_FormSections 
FOREIGN KEY(FormSectionId)
REFERENCES UnifiedMetadata.form.FormSections (FormSectionId)
ALTER TABLE UnifiedMetadata.form.FormElements CHECK CONSTRAINT FK_FormElements_FormSections

ALTER TABLE UnifiedMetadata.form.FormSections  WITH CHECK ADD  CONSTRAINT FK_FormSections_FormElements 
FOREIGN KEY(DynamicFormElementId)
REFERENCES UnifiedMetadata.form.FormElements (FormElementId)


ALTER TABLE UnifiedMetadata.form.FormSections CHECK CONSTRAINT FK_FormSections_FormElements

COMMIT;

END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = 'dbo.pr_PublishAllMetadata:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
