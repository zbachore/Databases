SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*This View will be moved to EDW database.There going to be replical of UnifiedMetadata database. */
CREATE view [rdd].[vRegistryElementsValueSetConceptMembers]

AS
/*Select 1 returns Registry Element's ValueSetMember ConceptId*/
	SELECT cs.CodeSystemOID, 
	  cst.CodeSystemTermCode, 
	  r.RegistryElementId,
	  r.RegistryVersionId ,
	  de.DataElementShortName ,
	  c.ConceptId ,
	  -1 as DeviceId
	FROM cdd.DataElements d 
	inner join rdd.RegistryElements r on (d.DataElementId = r.DataElementId)
	inner join cdd.DataElements de on r.DataElementId = de.DataElementId 
	inner join cdd.ValueSets v on (r.ValueSetId = v.ValueSetId)
	inner join cdd.ValueSetMembers vsm on (v.ValueSetId = vsm.ValueSetId)
	inner join rdd.RegistryVersions_ValueSetMembers rvvsm on rvvsm.ValueSetMemberId = vsm.ValueSetMemberId AND r.RegistryVersionId = rvvsm.RegistryVersionId 
	inner join cdd.ValueSetConceptMembers vc on (vc.ValueSetMemberId = vsm.ValueSetMemberId)
	inner join cdd.Concepts c on (vc.ConceptId = c.ConceptId) 
	inner join cdd.CodeSystemTerms cst on (c.CodeSystemTermId = cst.CodeSystemTermId) 
	inner join cdd.CodeSystems cs on (cst.CodeSystemId = cs.CodeSystemId)

	Union 
	/*Select 2 returns Registry Element ConceptId*/
	SELECT cs.CodeSystemOID, 
	  cst.CodeSystemTermCode, 
	  r.RegistryElementId,
	  r.RegistryVersionId ,
	  de.DataElementShortName ,
	  c.ConceptId ,
	  -1 as DeviceId
	FROM cdd.DataElements d 
	inner join rdd.RegistryElements r on (d.DataElementId = r.DataElementId)
	inner join cdd.DataElements de on r.DataElementId = de.DataElementId 
	inner join cdd.Concepts c on (d.ConceptId = c.ConceptId) 
	inner join cdd.CodeSystemTerms cst on (c.CodeSystemTermId = cst.CodeSystemTermId) 
	inner join cdd.CodeSystems cs on (cst.CodeSystemId = cs.CodeSystemId)

	Union  
	/*Select 3 returns Medication ConceptId*/
	SELECT cs.CodeSystemOID, 
	  cst.CodeSystemTermCode, 
	  r.RegistryElementId,
	  r.RegistryVersionId ,
	  de.DataElementShortName ,
	  c.ConceptId ,
	  -1 as DeviceId
	FROM cdd.DataElements d 
	inner join rdd.RegistryElements r on (d.DataElementId = r.DataElementId) 
	inner join cdd.DataElements de on r.DataElementId = de.DataElementId 
	inner join cdd.ValueSets v on (r.ValueSetId = v.ValueSetId)
	inner join cdd.ValueSetMembers vsm on (v.ValueSetId = vsm.ValueSetId)
	inner join rdd.RegistryVersions_ValueSetMembers rvvsm on rvvsm.ValueSetMemberId = vsm.ValueSetMemberId AND r.RegistryVersionId = rvvsm.RegistryVersionId 
	inner join cdd.ValueSetMedicationMembers vsmc on (vsmc.ValueSetMemberId = vsm.ValueSetMemberId)
	inner join ld.Medications m on m.MedicationId = vsmc.MedicationId 
	inner join cdd.Concepts c on (m.ConceptId = c.ConceptId) 
	inner join cdd.CodeSystemTerms cst on (c.CodeSystemTermId = cst.CodeSystemTermId) 
	inner join cdd.CodeSystems cs on (cst.CodeSystemId = cs.CodeSystemId)
	Union  
	/*Select 4 returns device  Id*/
	SELECT null As CodeSystemOID, 
	 CAST(dev.DevicePublishedId AS Varchar(50)) as CodeSystemTermCode, 
	  r.RegistryElementId,
	  r.RegistryVersionId ,
	  de.DataElementShortName ,
	  null  as ConceptId,
	  dev.DeviceId
	FROM cdd.DataElements d 
	inner join rdd.RegistryElements r on (d.DataElementId = r.DataElementId) 
	inner join cdd.DataElements de on r.DataElementId = de.DataElementId 
	inner join cdd.ValueSets v on (r.ValueSetId = v.ValueSetId)
	inner join cdd.ValueSetMembers vsm on (v.ValueSetId = vsm.ValueSetId)
	inner join rdd.RegistryVersions_ValueSetMembers rvvsm on rvvsm.ValueSetMemberId = vsm.ValueSetMemberId AND r.RegistryVersionId = rvvsm.RegistryVersionId 
	inner join cdd.ValueSetDeviceMembers  vsmd on (vsmd.ValueSetMemberId = vsm.ValueSetMemberId)
	inner join ld.Devices dev on dev.DeviceId = vsmd.DeviceId 



GO
