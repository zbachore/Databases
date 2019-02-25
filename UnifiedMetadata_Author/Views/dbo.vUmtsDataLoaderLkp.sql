SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vUmtsDataLoaderLkp]
AS
select
	re.RegistryElementId, 
	Isnull(re.RegistryElementLabel,'') RegistryElementLabel, 
	re.RegistryVersionId,
	Isnull(rs.RegistrySectionCode, '') RegistrySectionCode,
	Isnull(prs.RegistrySectionCode,'') ParentRegistrySectionCode, 
	rs.RegistrySectionCardinalityMin, 
	rs.RegistrySectionCardinalityMax,
	de.DataElementId, 
	de.DataElementSeq, 
	de.DataElementShortName, 
	de.DataElementName,
	de.WorkflowConceptId, 
	Isnull(wc.ConceptName,'') WorkflowConcept,
	c.ConceptId, c.ConceptName,
	dc.ConceptId DomainConceptId, 
	dc.ConceptName DomainConceptName,
	dt.DataTypeCode, 
	Isnull(dt.DataTypeShortName, '') DataTypeShortName,
	Isnull(ct.CodeSystemTermCode, '') CodeSystemTermCode, 
	Isnull(cs.CodeSystemOID,'') CodeSystemOID, 
	cs.CodeSystemName,
	re.EDWFlipElementInd FlipIndicator,
	re.ContainmentTypeId,
	con.ContainmentTypeName,
	re.ContainingRegistryElementId,
	conDE.DataElementId AS 'ContainingDataElementId',
	conDE.DataElementName AS 'ContainingDataElementName',
	conDT.DataTypeCode AS 'ContainingDataType',
	conDT.DataTypeShortName AS 'ContainingDataTypeShortName',
	conC.ConceptId  AS 'ContainingConceptId',
	conC.ConceptName AS 'ContainingConceptName',
	conCST.CodeSystemTermCode AS 'ContainingElementCode',
	conCS.CodeSystemOID AS 'ContainingElementCodeSystemOID', 
	conC.DomainConceptId AS 'ContainingDomainConceptId',
	conDomC.ConceptName AS 'ContainigDomainConceptName'
from rdd.RegistryElements re
	left join rdd.RegistrySections rs on re.RegistrySectionId = rs.RegistrySectionId
	left join rdd.RegistrySections prs on rs.ParentRegistrySectionId = prs.RegistrySectionId
	inner join cdd.DataElements de on re.DataElementId = de.DataElementId 
	inner join cdd.DataTypes dt on de.DataTypeId = dt.DataTypeId
	inner join cdd.Concepts c on de.ConceptId = c.ConceptId
	left join cdd.Concepts wc on de.WorkflowConceptId = wc.ConceptId
	inner join cdd.Concepts dc on c.DomainConceptId = dc.ConceptId
	inner join cdd.CodeSystemTerms ct on c.CodeSystemTermId = ct.CodeSystemTermId
	inner join cdd.CodeSystems cs on cs.CodeSystemId = ct.CodeSystemId
	left join rdd.ContainmentTypes con on re.ContainmentTypeId = con.ContainmentTypeId
	left join rdd.RegistryElements conRE on re.ContainingRegistryElementId = conRE.RegistryElementId
	left join cdd.DataElements conDE on conRE.DataElementId = conDE.DataElementId
	left join cdd.DataTypes conDT on conDE.DataTypeId = conDT.DataTypeId
	left join cdd.Concepts conC on conDE.ConceptId = conC.ConceptId
	left join cdd.CodeSystemTerms conCST on conC.CodeSystemTermId = conCST.CodeSystemTermId
	left join cdd.CodeSystems conCS on conCST.CodeSystemId = conCS.CodeSystemId 
	left join cdd.Concepts conDomC on conC.DomainConceptId  =  conDomC.ConceptId

GO
