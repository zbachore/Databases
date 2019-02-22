SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dml].[pr_PublishDynamicList] 
@PublishQueueID INT, @ValueSetID INT, @RegistryVersionID INT AS 
BEGIN
/**************************************************************************************************
Project:		UMTS Metadata Tool
JIRA:			?
Developer:		zbachore
Date:			2018-04-18
Description:	Defines dml.pr_PublishDynamicList stored procedure
___________________________________________________________________________________________________
Examples:
--EXEC dml.pr_publishDynamicList 1,3,3 --Concept
--EXEC dml.pr_publishDynamicList 1,244,3 --Device
--EXEC dml.pr_publishDynamicList 1,165,3 --Medication
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2018-11-02		zbachore		UMDT-4692
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ErrorMessage VARCHAR(max),
		@DynamicListType VARCHAR(MAX);


BEGIN TRY
BEGIN TRAN;

EXEC UnifiedMetadata.sys.sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
--Identify the Dynamic List type using the ValueSetID:
SELECT @DynamicListType = COALESCE((
--Devices
SELECT TOP 1 DynamicListType = 'Device'
FROM cdd.ValueSetMembers vsm
INNER JOIN cdd.ValueSetDeviceMembers vsdm ON vsdm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID),(

--Medications
SELECT TOP 1  DynamicListType = 'Medication'
FROM cdd.ValueSetMembers vsm
INNER JOIN cdd.ValueSetMedicationMembers vsmm ON vsmm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID),(

--Concepts 
SELECT TOP 1  DynamicListType = 'Concept'
FROM cdd.ValueSetMembers vsm
INNER JOIN cdd.ValueSetConceptMembers vscm ON vscm.ValueSetMemberId = vsm.ValueSetMemberId
WHERE vsm.ValueSetID = @ValueSetID))

--Begin Publishing:
IF @DynamicListType = 'Device'
BEGIN 
PRINT 'Publishing Devices...'
EXEC dml.pr_PublishCodeSystems @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishValueSets @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishDeviceManufacturers @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishDeviceSubTypes @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishDeviceTypes @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishDevices @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishValueSetMembers @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishRegistryVersions_ValueSetMembers @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishValueSetDeviceMembers @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishConstraintDefinitions @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishConstraintDefinitionRelatedElements @PublishQueueID, @ValueSetID, @RegistryVersionID
	PRINT 'Publishing Devices completed!'
END

ELSE IF @DynamicListType = 'Concept'
BEGIN 
PRINT 'Publishing Concepts...'
EXEC dml.pr_PublishCodeSystems @PublishQueueID, @ValueSetID, @RegistryVersionID
EXEC dml.pr_PublishCodeSystemTerms @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishValueSets @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishConcepts @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishValueSetMembers @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishRegistryVersions_ValueSetMembers @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishValueSetConceptMembers @PublishQueueID, @ValueSetID, @RegistryVersionID
PRINT 'Publishing Concepts completed!'
END

ELSE IF @DynamicListType = 'Medication'
BEGIN 
PRINT 'Publishing Medications...'
	EXEC dml.pr_PublishCodeSystems @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishCodeSystemTerms @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishConcepts @PublishQueueID, @ValueSetID, @RegistryVersionID 
	EXEC dml.pr_PublishMedicationCategories @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishValueSets @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishMedications @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishValueSetMembers @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishRegistryVersions_ValueSetMembers @PublishQueueID, @ValueSetID, @RegistryVersionID
	EXEC dml.pr_PublishValueSetMedicationMembers @PublishQueueID, @ValueSetID, @RegistryVersionID
PRINT 'Publishing Medications completed!'
END
exec UnifiedMetadata.sys.sp_MSforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
COMMIT;
END TRY
BEGIN CATCH
    IF ( @@TRANCOUNT > 0 )
            ROLLBACK TRANSACTION;
    SET @ErrorMessage = 'dml.pr_PublishDynamicList:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;


END

GO
