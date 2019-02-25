SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dbo].[UMTS_Export]
AS

SELECT DISTINCT
		igetre.RegistryElementId AS RegistryElementId
	,	COALESCE(re.ContainingRegistryElementId,re.RegistryElementID) AS GroupDataId --used for grouping data(ex. parent/Child)
	,	CAST(CASE WHEN ISNULL(re.ContainingRegistryElementId,'') = '' THEN 1 ELSE 0 END AS BIT)  AS IsParentElement
	,	rv.RegistryVersionId AS RegistryVersionId
	,	rv.RegistryId AS RegistryId
	,   rv.RegistryVersion AS RegistryVersion
	,	re.ValueSetId AS ValueSetId
	,	re.IsDPIField AS IsDPIField
	,	de.DataElementId AS DataElementId
	,	de.DataElementSeq AS DataElementSeq
	,	de.DataElementName AS DataElementName
	,	de.DataElementLabel AS DataElementLabel
	,	de.DataElementShortName AS DataElementShortName
	,	iget.EntryTemplateName AS EntryTemplateName
	,	ect.EntryClassShortName AS EntryClassShortName
	,	CASE
			WHEN proid1.ProfileIdExtension IS NULL THEN ''
			ELSE proid1.ProfileIdExtension
		END AS EntryTemplateIdExtension_1
	,	CASE
			WHEN proid2.ProfileIdExtension IS NULL THEN ''
			ELSE proid2.ProfileIdExtension
		END AS EntryTemplateIdExtension_2
	,	CASE
			WHEN proid1.ProfileIdRoot IS NULL THEN ''
			ELSE proid1.ProfileIdRoot
		END AS EntryTemplateIdRoot_1
	,	CASE
			WHEN proid2.ProfileIdRoot IS NULL THEN ''
			ELSE proid2.ProfileIdRoot
		END AS EntryTemplateIdRoot_2
	,	iget.EntryTemplateTypeIdRoot AS EntryTemplateTypeIdRoot
	,	iget.EntryTemplateTypeIdExtension AS EntryTemplateTypeIdExtension
	,	iget.StatusCode AS StatusCode
	,	elmtAtrb.EntryAttributeShortName AS ElementMapEntryAttributeShortName
	,	valAttrb.EntryAttributeShortName AS ValueMapEntryAttributeTypeShortName
	,	c.ConceptId AS ElementConceptId
	,	cst.CodeSystemTermCode AS ElementCode
	,	cst.CodeSystemTermName AS ElementCodeDisplayName
	,	cs.CodeSystemOID AS ElementCodeSystemOID
	,	cs.CodeSystemName AS ElementCodeSystemName
	,	dt.DataTypeShortName AS DataTypeShortName
	,	dt.DataTypeCode AS DataTypeCode
	,	uom.UnitOfMeasureName AS UnitOfMeasureName
	,	de.UnitOfMeasureValueSetId AS UnitOfMeasureValueSetId
	,	igcst2.CodeSystemTermCode AS IGDefinedCode
	,	igcst2.CodeSystemTermName AS IGDefinedCodeDisplayName
	,	igcs2.CodeSystemOID AS IGDefinedCodeSystemOID
	,	igcs2.CodeSystemName AS IGDefinedCodeSystemName 
	,	igetre.PseudoSectionShortName AS PseudoSectionShortName
	,	c.DomainConceptId AS DomainConceptId
FROM	   rdd.RegistryVersions rv 
INNER JOIN cda.ProfileVersions_RegistryVersions igvr ON rv.RegistryVersionId = igvr.RegistryVersionId --and rv.RegistryVersionId =3
INNER JOIN cda.ProfileVersions igv ON  igvr.ProfileVersionId = igv.ProfileVersionId 
INNER JOIN cda.EntryTemplates iget ON igvr.ProfileVersionId = iget.ProfileVersionId 
LEFT OUTER JOIN cda.EntryTemplateProfileIds AS etpi1
	ON etpi1.EntryTemplateId = iget.EntryTemplateId
	AND etpi1.EntryTemplateProfileIdOrder = 1
LEFT OUTER JOIN cda.EntryTemplateProfileIds AS etpi2
	ON etpi2.EntryTemplateId = iget.EntryTemplateId
	AND etpi2.EntryTemplateProfileIdOrder = 2
LEFT OUTER JOIN cda.ProfileIds AS proid1
	ON proid1.ProfileIdId = etpi1.ProfileIdId
LEFT OUTER JOIN cda.ProfileIds AS proid2
	ON proid2.ProfileIdId = etpi2.ProfileIdId
INNER JOIN cda.EntryClasses ect ON iget.EntryClassId = ect.EntryClassId 
INNER JOIN cda.EntryElements igetre ON iget.EntryTemplateId = igetre.EntryTemplateId 
-- Elements
INNER JOIN rdd.RegistryElements  re ON igetre.RegistryElementId = re.RegistryElementId  AND rv.RegistryVersionId = re.RegistryVersionId 
INNER JOIN cdd.DataElements de ON  re.DataElementId = de.DataElementId

INNER JOIN cdd.Concepts c ON de.ConceptId = c.ConceptId 
LEFT JOIN cdd.CodeSystemTerms cst ON c.CodeSystemTermId = cst.CodeSystemTermId 
LEFT JOIN cdd.CodeSystems cs ON cst.CodeSystemId = cs.CodeSystemId   
LEFT JOIN cdd.DataTypes dt ON de.DataTypeId = dt.DataTypeId 
LEFT JOIN cdd.UnitsOfMeasure uom ON de.UnitOfMeasureId = uom.UnitOfMeasureId
LEFT JOIN cda.EntryAttributes elmtAtrb ON igetre.ElementMapEntryAttributeId = elmtAtrb.EntryAttributeId 
LEFT JOIN cda.EntryAttributes valAttrb ON igetre.ValueMapEntryAttributeId = valAttrb.EntryAttributeId 

-- IGDefined
LEFT JOIN cdd.Concepts igc2 ON igetre.ProfileConceptId = igc2.ConceptId 
LEFT JOIN cdd.CodeSystemTerms igcst2 ON igc2.CodeSystemTermId = igcst2.CodeSystemTermId 
LEFT JOIN cdd.CodeSystems igcs2 ON igcst2.CodeSystemId = igcs2.CodeSystemId 
  

GO
