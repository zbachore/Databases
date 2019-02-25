SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/*This View will be moved to EDW database.There going to be replical of UnifiedMetadata database. */
CREATE VIEW [rdd].[vRegistryElementsValueSetConceptMembers]

AS
/*Select 1 returns Registry Element's ValueSetMember ConceptId*/
	SELECT cs.CodeSystemOID, 
	  cst.CodeSystemTermCode, 
	  r.RegistryElementId,
	  r.RegistryVersionId ,
	  de.DataElementShortName ,
	  c.ConceptId ,
	  -1 AS DeviceId
	FROM cdd.DataElements d 
	INNER JOIN rdd.RegistryElements r ON (d.DataElementId = r.DataElementId)
	INNER JOIN cdd.DataElements de ON r.DataElementId = de.DataElementId 
	INNER JOIN cdd.ValueSets v ON (r.ValueSetId = v.ValueSetId)
	INNER JOIN cdd.ValueSetMembers vsm ON (v.ValueSetId = vsm.ValueSetId)
	INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId AND r.RegistryVersionId = rvvsm.RegistryVersionId 
	INNER JOIN cdd.ValueSetConceptMembers vc ON (vc.ValueSetMemberId = vsm.ValueSetMemberId)
	INNER JOIN cdd.Concepts c ON (vc.ConceptId = c.ConceptId) 
	INNER JOIN cdd.CodeSystemTerms cst ON (c.CodeSystemTermId = cst.CodeSystemTermId) 
	INNER JOIN cdd.CodeSystems cs ON (cst.CodeSystemId = cs.CodeSystemId)

	UNION 
	/*Select 2 returns Registry Element ConceptId*/
	SELECT cs.CodeSystemOID, 
	  cst.CodeSystemTermCode, 
	  r.RegistryElementId,
	  r.RegistryVersionId ,
	  de.DataElementShortName ,
	  c.ConceptId ,
	  -1 AS DeviceId
	FROM cdd.DataElements d 
	INNER JOIN rdd.RegistryElements r ON (d.DataElementId = r.DataElementId)
	INNER JOIN cdd.DataElements de ON r.DataElementId = de.DataElementId 
	INNER JOIN cdd.Concepts c ON (d.ConceptId = c.ConceptId) 
	INNER JOIN cdd.CodeSystemTerms cst ON (c.CodeSystemTermId = cst.CodeSystemTermId) 
	INNER JOIN cdd.CodeSystems cs ON (cst.CodeSystemId = cs.CodeSystemId)

	UNION  
	/*Select 3 returns Medication ConceptId*/
	SELECT cs.CodeSystemOID, 
	  cst.CodeSystemTermCode, 
	  r.RegistryElementId,
	  r.RegistryVersionId ,
	  de.DataElementShortName ,
	  c.ConceptId ,
	  -1 AS DeviceId
	FROM cdd.DataElements d 
	INNER JOIN rdd.RegistryElements r ON (d.DataElementId = r.DataElementId) 
	INNER JOIN cdd.DataElements de ON r.DataElementId = de.DataElementId 
	INNER JOIN cdd.ValueSets v ON (r.ValueSetId = v.ValueSetId)
	INNER JOIN cdd.ValueSetMembers vsm ON (v.ValueSetId = vsm.ValueSetId)
	INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId AND r.RegistryVersionId = rvvsm.RegistryVersionId 
	INNER JOIN cdd.ValueSetMedicationMembers vsmc ON (vsmc.ValueSetMemberId = vsm.ValueSetMemberId)
	INNER JOIN ld.Medications m ON m.MedicationId = vsmc.MedicationId 
	INNER JOIN cdd.Concepts c ON (m.ConceptId = c.ConceptId) 
	INNER JOIN cdd.CodeSystemTerms cst ON (c.CodeSystemTermId = cst.CodeSystemTermId) 
	INNER JOIN cdd.CodeSystems cs ON (cst.CodeSystemId = cs.CodeSystemId)
	UNION  
	/*Select 4 returns device  Id*/
	SELECT NULL AS CodeSystemOID, 
	 CAST(dev.DevicePublishedId AS VARCHAR(50)) AS CodeSystemTermCode, 
	  r.RegistryElementId,
	  r.RegistryVersionId ,
	  de.DataElementShortName ,
	  NULL  AS ConceptId,
	  dev.DeviceId
	FROM cdd.DataElements d 
	INNER JOIN rdd.RegistryElements r ON (d.DataElementId = r.DataElementId) 
	INNER JOIN cdd.DataElements de ON r.DataElementId = de.DataElementId 
	INNER JOIN cdd.ValueSets v ON (r.ValueSetId = v.ValueSetId)
	INNER JOIN cdd.ValueSetMembers vsm ON (v.ValueSetId = vsm.ValueSetId)
	INNER JOIN rdd.RegistryVersions_ValueSetMembers rvvsm ON rvvsm.ValueSetMemberId = vsm.ValueSetMemberId AND r.RegistryVersionId = rvvsm.RegistryVersionId 
	INNER JOIN cdd.ValueSetDeviceMembers  vsmd ON (vsmd.ValueSetMemberId = vsm.ValueSetMemberId)
	INNER JOIN ld.Devices dev ON dev.DeviceId = vsmd.DeviceId 



GO
