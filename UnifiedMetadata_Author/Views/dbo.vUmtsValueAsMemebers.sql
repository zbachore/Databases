SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vUmtsValueAsMemebers]
AS
select ROW_NUMBER() Over(Order By RegistryVersionId, RegistryElementId, ConceptId, DeviceId) Id, * from(
/*returns Registry Element's ValueSet ConceptIds*/
	SELECT distinct
		re.RegistryElementId,
		c.ConceptId,
		null as DeviceId,
		re.RegistryVersionId,
		isnull(cs.CodeSystemOID, '') CodeSystemOID, 
		isnull(cst.CodeSystemTermCode,'') CodeSystemTermCode, 
		isnull(de.DataElementShortName,'') DataElementShortName,
		isnull(c.ConceptName,'') ConceptName
	FROM rdd.RegistryElements re
	inner join cdd.DataElements de on re.DataElementId = de.DataElementId 
	inner join cdd.ValueSets v on re.ValueSetId = v.ValueSetId
	inner join cdd.ValueSetMembers vsm on v.ValueSetId = vsm.ValueSetId
	inner join cdd.ValueSetConceptMembers vc on vc.ValueSetMemberId = vsm.ValueSetMemberId 
	inner join rdd.RegistryVersions_ValueSetMembers rvvsm on rvvsm.ValueSetMemberId = vc.ValueSetMemberId and re.RegistryVersionId = rvvsm.RegistryVersionId
	inner join cdd.Concepts c on vc.ConceptId = c.ConceptId
	inner join cdd.CodeSystemTerms cst on c.CodeSystemTermId = cst.CodeSystemTermId
	inner join cdd.CodeSystems cs on cst.CodeSystemId = cs.CodeSystemId where re.RegistryVersionId = 6
	Union
	/*returns Registry Element's Medication ConceptIds*/
	SELECT distinct
		re.RegistryElementId,
		c.ConceptId,
		null as DeviceId,
		re.RegistryVersionId,
		isnull(cs.CodeSystemOID,'') CodeSystemOID, 
		isnull(cst.CodeSystemTermCode,'') CodeSystemTermCode, 
		isnull(de.DataElementShortName, '') DataElementShortName,
		isnull(c.ConceptName,'') ConceptName
	FROM rdd.RegistryElements re 
	inner join cdd.DataElements de on re.DataElementId = de.DataElementId 
	inner join cdd.ValueSets v on re.ValueSetId = v.ValueSetId
	inner join cdd.ValueSetMembers vsm on v.ValueSetId = vsm.ValueSetId
	inner join cdd.ValueSetMedicationMembers vsmc on vsmc.ValueSetMemberId = vsm.ValueSetMemberId
	inner join rdd.RegistryVersions_ValueSetMembers rvvsm on rvvsm.ValueSetMemberId = vsmc.ValueSetMemberId AND re.RegistryVersionId = rvvsm.RegistryVersionId 
	inner join ld.Medications m on m.MedicationId = vsmc.MedicationId 
	inner join cdd.Concepts c on m.ConceptId = c.ConceptId 
	inner join cdd.CodeSystemTerms cst on c.CodeSystemTermId = cst.CodeSystemTermId 
	inner join cdd.CodeSystems cs on cst.CodeSystemId = cs.CodeSystemId where re.RegistryVersionId = 6
	Union  
	/*Select 3 returns device Ids*/
	SELECT distinct
		re.RegistryElementId,
		null  as ConceptId,
		dev.DeviceId,
		re.RegistryVersionId,
		'' As CodeSystemOID, 
		isnull(CAST(dev.DevicePublishedId AS Varchar(50)),'') CodeSystemTermCode, 
		isnull(de.DataElementShortName,'') DataElementShortName,
		'' ConceptName
	FROM rdd.RegistryElements re
	inner join cdd.DataElements de on re.DataElementId = de.DataElementId 
	inner join cdd.ValueSets v on re.ValueSetId = v.ValueSetId
	inner join cdd.ValueSetMembers vsm on v.ValueSetId = vsm.ValueSetId
	inner join cdd.ValueSetDeviceMembers  vsmd on vsmd.ValueSetMemberId = vsm.ValueSetMemberId
	inner join rdd.RegistryVersions_ValueSetMembers rvvsm on rvvsm.ValueSetMemberId = vsmd.ValueSetMemberId AND re.RegistryVersionId = rvvsm.RegistryVersionId 
	inner join ld.Devices dev on dev.DeviceId = vsmd.DeviceId
	union
	SELECT distinct
		re.RegistryElementId,
		c.ConceptId,
		null as DeviceId,
		re.RegistryVersionId,
		isnull(cs.CodeSystemOID,'') CodeSystemOID, 
		isnull(cst.CodeSystemTermCode, '') CodeSystemTermCode, 
		isnull(de.DataElementShortName,'') DataElementShortName,
		isnull(c.ConceptName,'') ConceptName
	FROM rdd.RegistryElements re
	inner join cdd.DataElements de on re.DataElementId = de.DataElementId 
	inner join cdd.Concepts c on de.ConceptId = c.ConceptId
	inner join cdd.CodeSystemTerms cst on (c.CodeSystemTermId = cst.CodeSystemTermId) 
	inner join cdd.CodeSystems cs on (cst.CodeSystemId = cs.CodeSystemId)
	WHERE c.ConceptId not in
	(SELECT vcm.ConceptId
	FROM rdd.RegistryElements re 
		inner join cdd.ValueSets v on v.ValueSetId = re.ValueSetId
		inner join cdd.ValueSetMembers vm on vm.ValueSetId = v.ValueSetId
		inner join cdd.ValueSetConceptMembers vcm on vm.ValueSetMemberId = vcm.ValueSetMemberId
		inner join rdd.RegistryVersions_ValueSetMembers rvvsm on rvvsm.ValueSetMemberId = vcm.ValueSetMemberId AND re.RegistryVersionId = rvvsm.RegistryVersionId
	UNION
	SELECT m.ConceptId
	FROM rdd.RegistryElements re 
		inner join cdd.ValueSets v on v.ValueSetId = re.ValueSetId
		inner join cdd.ValueSetMembers vm on vm.ValueSetId = v.ValueSetId
		inner join cdd.ValueSetMedicationMembers vmm on vm.ValueSetMemberId = vmm.ValueSetMemberId
		inner join rdd.RegistryVersions_ValueSetMembers rvvsm on rvvsm.ValueSetMemberId = vmm.ValueSetMemberId AND re.RegistryVersionId = rvvsm.RegistryVersionId
		inner join ld.Medications m on m.MedicationId = vmm.MedicationId
	)
) as x
GO
