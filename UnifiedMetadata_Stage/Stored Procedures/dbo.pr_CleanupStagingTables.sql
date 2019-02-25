SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[pr_CleanupStagingTables] @ProjectID INT, @PublishQueueID int AS 
BEGIN

/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2019-02-21
Description:	Defines dbo.pr_CleanupStagingTables stored procedure
___________________________________________________________________________________________________
Example: EXEC dbo.pr_CleanupStagingTables
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@TableName VARCHAR(MAX) = 'DataTypes',
		@ColumnName VARCHAR(MAX) = 'DataTypeID',
		@RequestedTime DATETIME2 = SYSDATETIME(),
		@Procedure VARCHAR(MAX) = OBJECT_NAME(@@PROCID);

BEGIN TRY
BEGIN TRAN;
TRUNCATE TABLE cdd.CodeSystem_Taxonomy
TRUNCATE TABLE cdd.CodeSystems
TRUNCATE TABLE cdd.CodeSystemTermCodes
TRUNCATE TABLE cdd.CodeSystemTerms
TRUNCATE TABLE cdd.CodeSystemTerms_Taxonomy
TRUNCATE TABLE cdd.Concepts_CodeSystemTerms
TRUNCATE TABLE cdd.ConceptDefinitions
TRUNCATE TABLE cdd.ConceptDefinitionTypes
TRUNCATE TABLE cdd.Concepts
TRUNCATE TABLE cdd.Concepts_CodeSystemTerms
TRUNCATE TABLE cdd.Concepts_Taxonomy
TRUNCATE TABLE cdd.ConceptSynonyms
TRUNCATE TABLE cdd.DataElementCodingInstructions
TRUNCATE TABLE cdd.DataElementConstraintDefinitions
TRUNCATE TABLE cdd.DataElements
TRUNCATE TABLE cdd.DataElements_ValueSets
TRUNCATE TABLE cdd.DataTypes
TRUNCATE TABLE cdd.DataTypes_ConstraintTypes
TRUNCATE TABLE cdd.TemporalContexts
TRUNCATE TABLE cdd.UnitsOfMeasure
TRUNCATE TABLE cdd.UnitsOfMeasureAlias
TRUNCATE TABLE cdd.ValueSetConceptMembers
TRUNCATE TABLE cdd.ValueSetDeviceMembers
TRUNCATE TABLE cdd.ValueSetMedicationMembers
TRUNCATE TABLE cdd.ValueSetMembers
TRUNCATE TABLE cdd.ValueSets
TRUNCATE TABLE cdd.ValueSets_Taxonomy
TRUNCATE TABLE cdd.ValueSetUnitOfMeasureMembers
TRUNCATE TABLE dd.ConstraintDefinitionRelatedElementGroups
TRUNCATE TABLE dd.ConstraintDefinitionRelatedElements
TRUNCATE TABLE dd.ConstraintDefinitions
TRUNCATE TABLE dd.ConstraintDefinitionScopes
TRUNCATE TABLE dd.ConstraintReportingLevels
TRUNCATE TABLE dd.ConstraintTypes
TRUNCATE TABLE dd.Taxonomy
TRUNCATE TABLE form.FormElements
TRUNCATE TABLE form.FormPageConstraintDefinitions
TRUNCATE TABLE form.FormPageLocations
TRUNCATE TABLE form.FormPages
TRUNCATE TABLE form.Forms
TRUNCATE TABLE form.FormSectionConstraintDefintitions
TRUNCATE TABLE form.FormSections
TRUNCATE TABLE form.FormSectionTypes
TRUNCATE TABLE form.FormTypes
TRUNCATE TABLE ld.Composites
TRUNCATE TABLE ld.DeviceManufacturers
TRUNCATE TABLE ld.Devices
TRUNCATE TABLE ld.DeviceSubtypes
TRUNCATE TABLE ld.DeviceTypes
TRUNCATE TABLE ld.MedicationCategories
TRUNCATE TABLE ld.Medications
TRUNCATE TABLE rdd.ContainmentTypes
TRUNCATE TABLE rdd.DataSources
TRUNCATE TABLE rdd.Registries
TRUNCATE TABLE rdd.RegistryDataSets
TRUNCATE TABLE rdd.RegistryDataSets_RegistryElements
TRUNCATE TABLE rdd.RegistryElements
TRUNCATE TABLE rdd.RegistryElements_ConstraintDefinitions
TRUNCATE TABLE rdd.RegistryElementThresholdRelatedElements
TRUNCATE TABLE rdd.RegistryElementThresholds
TRUNCATE TABLE rdd.RegistryOperatorRole
TRUNCATE TABLE rdd.RegistrySectionContainerClasses
TRUNCATE TABLE rdd.RegistrySections
TRUNCATE TABLE rdd.RegistrySectionTypes
TRUNCATE TABLE rdd.RegistryVersionComposites
TRUNCATE TABLE rdd.RegistryVersionConfigurations
TRUNCATE TABLE rdd.RegistryVersions
TRUNCATE TABLE rdd.RegistryVersions_ValueSetMembers

--Project Tables:
TRUNCATE TABLE dbo.ProjectCodeSystems
TRUNCATE TABLE dbo.ProjectCodeSystemTaxonomy
TRUNCATE TABLE dbo.ProjectCodeSystemTermCodes
TRUNCATE TABLE dbo.ProjectCodeSystemTerms
TRUNCATE TABLE dbo.ProjectCodeSystemTermsTaxonomy
TRUNCATE TABLE dbo.ProjectComposites
TRUNCATE TABLE dbo.ProjectConceptCodeSystemTerms
TRUNCATE TABLE dbo.ProjectConceptCodeSystemTerms
TRUNCATE TABLE dbo.ProjectConceptDefinitions
TRUNCATE TABLE dbo.ProjectConceptDefinitionTypes
TRUNCATE TABLE dbo.ProjectConcepts
TRUNCATE TABLE dbo.ProjectConceptSynonyms
TRUNCATE TABLE dbo.ProjectConceptTaxonomy
TRUNCATE TABLE dbo.ProjectConstraintDefinitionRelatedElementGroups
TRUNCATE TABLE dbo.ProjectConstraintDefinitionRelatedElements
TRUNCATE TABLE dbo.ProjectConstraintDefinitions
TRUNCATE TABLE dbo.ProjectConstraintDefinitionScopes
TRUNCATE TABLE dbo.ProjectConstraintReportingLevels
TRUNCATE TABLE dbo.ProjectConstraintTypes
TRUNCATE TABLE dbo.ProjectContainmentTypes
TRUNCATE TABLE dbo.ProjectDataElementCodingInstructions
TRUNCATE TABLE dbo.ProjectDataElementConstraintDefinitions
TRUNCATE TABLE dbo.ProjectDataElements
TRUNCATE TABLE dbo.ProjectDataElementValueSets
TRUNCATE TABLE dbo.ProjectDataSources
TRUNCATE TABLE dbo.ProjectDataTypes
TRUNCATE TABLE dbo.ProjectDataTypesConstraintTypes
TRUNCATE TABLE dbo.ProjectDeviceManufacturers
TRUNCATE TABLE dbo.ProjectDevices
TRUNCATE TABLE dbo.ProjectDeviceSubtypes
TRUNCATE TABLE dbo.ProjectDeviceTypes
TRUNCATE TABLE dbo.ProjectFormElements
TRUNCATE TABLE dbo.ProjectFormPageConstraintDefinitions
TRUNCATE TABLE dbo.ProjectFormPageLocations
TRUNCATE TABLE dbo.ProjectFormPages
TRUNCATE TABLE dbo.ProjectForms
TRUNCATE TABLE dbo.ProjectFormSectionConstraintDefintitions
TRUNCATE TABLE dbo.ProjectFormSections
TRUNCATE TABLE dbo.ProjectFormSectionTypes
TRUNCATE TABLE dbo.ProjectFormTypes
TRUNCATE TABLE dbo.ProjectMedicationCategories
TRUNCATE TABLE dbo.ProjectMedications
TRUNCATE TABLE dbo.ProjectRegistries
TRUNCATE TABLE dbo.ProjectRegistryDataSetRegistryElements
TRUNCATE TABLE dbo.ProjectRegistryDataSets
TRUNCATE TABLE dbo.ProjectRegistryElementConstraintDefinitions
TRUNCATE TABLE dbo.ProjectRegistryElements
TRUNCATE TABLE dbo.ProjectRegistryElementThresholdRelatedElements
TRUNCATE TABLE dbo.ProjectRegistryElementThresholds
TRUNCATE TABLE dbo.ProjectRegistrySectionContainerClasses
TRUNCATE TABLE dbo.ProjectRegistrySections
TRUNCATE TABLE dbo.ProjectRegistrySectionTypes
TRUNCATE TABLE dbo.ProjectRegistryVersionComposites
TRUNCATE TABLE dbo.ProjectRegistryVersionConfigurations
TRUNCATE TABLE dbo.ProjectRegistryVersions
TRUNCATE TABLE dbo.ProjectRegistryVersionValueSetMembers
TRUNCATE TABLE dbo.ProjectTaxonomy
TRUNCATE TABLE dbo.ProjectTemporalContexts
TRUNCATE TABLE dbo.ProjectUnitsOfMeasureAlias
TRUNCATE TABLE dbo.ProjectValueSetConceptMembers
TRUNCATE TABLE dbo.ProjectValueSetDeviceMembers
TRUNCATE TABLE dbo.ProjectValueSetMedicationMembers
TRUNCATE TABLE dbo.ProjectValueSetMembers
TRUNCATE TABLE dbo.ProjectValueSets
TRUNCATE TABLE dbo.ProjectValueSetTaxonomy
TRUNCATE TABLE dbo.ProjectValueSetUnitOfMeasureMembers
TRUNCATE TABLE dbo.RegistryOperatorRole
TRUNCATE TABLE ProjectUnitOfMeasures

COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = @Procedure + ':' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END
GO
