SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vTechincalDataDictionary]
AS
SELECT 
		re.RegistryElementId 
	,	de.DataElementId 
	,	de.DataElementSeq 
	,	de.DataElementName 
	,	rv.RegistryVersion 
	,	rv.RegistryVersionId 
	,	rv.VendorSpecReleaseDate 
	,	r.RegistryId 
	,	r.RegistryFullName  
	,	r.RegistryShortName 
	,	tc.TemporalContextDescription  as TargetValue  
	,	ci.CodingInstruction 

	--Selections
	--,	'' as SelectionName
	--,	'' as SelectionDefination
	--,	'' as CodeSystemName	
	--,	'' as Code
	, tblSelection.XMLText As SelectionXmlText -- this column contains SelectionName,SelectionDefination,CodeSystemName,Code in xml

	--SupportingDefinitions
	,	c.ConceptId 
	,	cd.ConceptDefinitionId 
	,   cd.ConceptDefinitionName as DefinitionTitle
	,	cd.ConceptDefinitionDescription as DefinitionText
	,   cd.ConceptDefinitionSource as DefinitionSource
	,   '' as DefinitionSordOrder

	--TechnicalSpecifications
	,   de.DataElementShortName as ShortName
	,	tbMissing.MissingData  as MissingData -- ex:Illegal

	,	re.IsHarvested  as Harvested  --ex: Yes (LDS),YES
	,	rds.RegistryDataSetName  as Scope -- ex: this text appears along with Harvested like (LDS)
	,	tbFormat.FormatText  
	,	uom.UnitOfMeasureName as UnitofMeasure
	,	de.IsMultiSelect as SelectionType
	,	re.DefaultValue as DefaultValue -- ex: ACC-NCDR-ICD ,Null
	,	CASE WHEN dt.DataTypeShortName = 'Counter' THEN 'Automatic' ELSE  'User'END as DataSource-- ex:User,Automatic

	--TechincalSpecification:Element Range
	,	tbUsualMin.UnitOfMeasureName as ERUnitofMeasure
	,	tbUsualMin.UsualMinValue as UsualRangeMin 
	,	tbUsualMax.UsualMaxValue as UsualRangeMax
	,	tbValidMin.ValidMinValue as ValidRangeMin
	,	tbValidMax.ValidMaxValue  as ValidRangeMax

	--TechincalSpecification:Parent Child Relationship
	--,	'' as ParentElementReference
	--,	'' as ParentElementName
	--,	'' as ParentElementSelectionName 
	,  tblParent.XMLText AS ParentXMlText  -- this column contains ParentElementReference,ParentElementName,ParentElementSelectionName in XML format
FROM rdd.RegistryElements re
inner join rdd.RegistryVersions  rv				on rv.RegistryVersionId  = re.RegistryVersionId 
inner join rdd.Registries r						on rv.RegistryId =r.RegistryId 
inner join cdd.DataElements de					on re.DataElementId  = de.DataElementId 
inner join cdd.Concepts c						on c.ConceptId = de.ConceptId 
left join cdd.TemporalContexts tc				on de.TemporalContextId = tc.TemporalContextId 
--left join cdd.ConceptDefinitions cd				on re.ConceptDefinitionId = cd.ConceptDefinitionId and cd.ConceptDefinitionTypeId = 2
left join cdd.ConceptDefinitions cd				on c.ConceptId  = cd.ConceptId and cd.ConceptDefinitionTypeId = 2
left join cdd.DataElementCodingInstructions ci	on re.DataElementCodingInstructionId  = ci.DataElementCodingInstructionId
left join cdd.CodeSystemTerms cst				on c.CodeSystemTermId = cst.CodeSystemTermId  
left join cdd.UnitsOfMeasure uom				on de.UnitOfMeasureId = uom.UnitOfMeasureId
left join cdd.DataTypes dt						on de.DataTypeId  = dt.DataTypeId 
left join rdd.RegistryDataSets_RegistryElements rdre on re.RegistryElementId = rdre.RegistryElementId 
left join rdd.RegistryDataSets rds				on rdre.RegistryDataSetId = rds.RegistryDataSetId 
left join
		(
		  select 
			 re01.DataElementId
			,re01.RegistryElementId 
			,(SELECT cst0.CodeSystemTermCode , cs0.CodeSystemName ,cst0.CodeSystemTermName  AS SelectionName ,cst0.CodeSystemTermDefinition 
				from rdd.RegistryElements re0
				inner join cdd.ValueSets vs0 on re0.ValueSetId = vs0.ValueSetId 
				inner join cdd.ValueSetMembers vsm0 on vs0.ValueSetId = vsm0.ValueSetId 
				inner join cdd.ValueSetConceptMembers vsc0 on vsm0.ValueSetMemberId = vsc0.ValueSetMemberId 
				inner join cdd.Concepts c0 on vsc0.ConceptId = c0.ConceptId 
				inner join cdd.CodeSystemTerms cst0 on c0.CodeSystemTermId  = cst0.CodeSystemTermId
				inner join cdd.CodeSystems cs0 on cst0.CodeSystemId = cs0.CodeSystemId  
			  WHERE re0.RegistryElementId = re01.RegistryElementId FOR XML RAW ('Selection'), ROOT
			)  AS XMLText 
		 FROM rdd.RegistryElements re01
		)tblSelection on re.RegistryElementId = tblSelection.RegistryElementId  
left join 
		(select re1.DataElementId 
		, re1.RegistryElementId 
		,CAST(COALESCE(cd1.DecimalValue,cd1.IntValue) AS VARCHAR(50)) as ValidMinValue
		, uom1.UnitOfMeasureName  
		from rdd.RegistryElements re1
		inner join cdd.DataElementConstraintDefinitions decd1 on re1.DataElementId = decd1.DataElementId 
		left join dd.ConstraintDefinitions cd1 on decd1.ConstraintDefinitionId = cd1.ConstraintDefinitionId 
		--left join dd.ConstraintTypes ct1 on cd1.ConstraintTypeId = ct1.ConstraintTypeId 
		left join cdd.UnitsOfMeasure uom1 on cd1.UnitOfMeasureId = uom1.UnitOfMeasureId 
		where cd1.ConstraintTypeId  = 4 --'ValidMin'
	   )tbValidMin on re.RegistryElementId = tbValidMin.RegistryElementId 
left join 
		(select decd2.DataElementId 
		, re2.RegistryElementId
		,CAST(COALESCE(cd2.DecimalValue,cd2.IntValue) AS VARCHAR(50)) as ValidMaxValue
		,  uom2.UnitOfMeasureName   
		from rdd.RegistryElements re2
		inner join cdd.DataElementConstraintDefinitions decd2 on re2.DataElementId = decd2.DataElementId
		left join dd.ConstraintDefinitions cd2 on decd2.ConstraintDefinitionId = cd2.ConstraintDefinitionId 
		--left join dd.ConstraintTypes ct2 on cd2.ConstraintTypeId = ct2.ConstraintTypeId 
		left join cdd.UnitsOfMeasure uom2 on cd2.UnitOfMeasureId = uom2.UnitOfMeasureId 
		where cd2.ConstraintTypeId = 5 --'ValidMax'
	   )tbValidMax on re.RegistryElementId = tbValidMax.RegistryElementId
left join 
		(select decd3.DataElementId as Id
		,re3.RegistryElementId
		,CAST(COALESCE(cd3.DecimalValue,cd3.IntValue) AS VARCHAR(50)) as UsualMinValue
		,uom3.UnitOfMeasureName
		from rdd.RegistryElements re3
		inner join cdd.DataElementConstraintDefinitions decd3 on re3.DataElementId = decd3.DataElementId
		left join dd.ConstraintDefinitions cd3 on decd3.ConstraintDefinitionId = cd3.ConstraintDefinitionId 
		--left join dd.ConstraintTypes ct3 on cd3.ConstraintTypeId = ct3.ConstraintTypeId 
		left join cdd.UnitsOfMeasure uom3 on cd3.UnitOfMeasureId = uom3.UnitOfMeasureId 
		where cd3.ConstraintTypeId = 6 -- 'UsualMin'
	   )tbUsualMin on re.RegistryElementId = tbUsualMin.RegistryElementId
left join 
		(select decd4.DataElementId 
		,re4.RegistryElementId
		,CAST(COALESCE(cd4.DecimalValue,cd4.IntValue) AS  VARCHAR(50)) as UsualMaxValue
		,uom4.UnitOfMeasureName 
		from rdd.RegistryElements re4
		inner join cdd.DataElementConstraintDefinitions decd4 on re4.DataElementId = decd4.DataElementId
		left join dd.ConstraintDefinitions cd4 on decd4.ConstraintDefinitionId = cd4.ConstraintDefinitionId 
		--left join dd.ConstraintTypes ct4 on cd4.ConstraintTypeId = ct4.ConstraintTypeId 
		left join cdd.UnitsOfMeasure uom4 on cd4.UnitOfMeasureId = uom4.UnitOfMeasureId 
		where cd4.ConstraintTypeId = 7-- 'UsualMax'
	   )tbUsualMax on re.RegistryElementId = tbUsualMax.RegistryElementId
left join 
		(SELECT 
			re5.RegistryElementId,
			re5.RegistryVersionId,
			de5.DataElementId,
			de5.DataElementName,
			de5.DataElementShortName,
			dt5.DataTypeId,
			Max(case when dt5.DataTypeId in (2,3) and cd5.ConstraintTypeId = 1 then dt5.DataTypeName + ' (' + CONVERT(varchar,IntValue) + ')' 
			 when dt5.DataTypeId in (7,9)  and cd5.ConstraintTypeId = 2 then dt5.DataTypeName + ' (' + CONVERT(varchar,IntValue)
			else dt5.DataTypeName
			end) + 
			 case when dt5.DataTypeId in (7,9) then 
				  IsNull(Max(case when dt5.DataTypeId in (7,9)   and cd5.ConstraintTypeId = 3  then ',' + CONVERT(varchar,IntValue) +')'
			end),',0)') else ' ' end+ 
			 Max (case when vs5.IsDynamicList = 1 then '(Dynamic List)' else '' end)  As FormatText
			FROM  rdd.RegistryElements re5 
			inner join cdd.DataElements de5 on  re5.DataElementId = de5.DataElementId 
			left join cdd.DataElementConstraintDefinitions decd5 on de5.DataElementId = decd5.DataElementId 
			left join dd.ConstraintDefinitions cd5 on decd5.ConstraintDefinitionId = cd5.ConstraintDefinitionId and cd5.ConstraintTypeId in (1,2,3) --Length, Precision, Scale 
			left join cdd.DataTypes dt5 on de5.DataTypeId = dt5.DataTypeId 
			left join cdd.ValueSets vs5 on re5.ValueSetId = vs5.ValueSetId  
			GROUP BY re5.RegistryElementId,
			re5.RegistryVersionId,
			de5.DataElementId,
			de5.DataElementName,
			de5.DataElementShortName,
			dt5.DataTypeId
	   )tbFormat on re.RegistryElementId = tbFormat.RegistryElementId
left join
	  (
		 select 
			re6.DataElementId,
			re6.RegistryElementId,
			Case 
				When cd6.ConstraintReportingLevelId = 1 Then
					'Report'
				When cd6.ConstraintReportingLevelId = 2 Then
					'Illegal'
				else ''
			END  As MissingData
			from rdd.RegistryElements re6
			inner join rdd.RegistryElements_ConstraintDefinitions recd6 on re6.RegistryElementId  = recd6.RegistryElementId 
			inner join dd.ConstraintDefinitions cd6 on recd6.ConstraintDefinitionId = cd6.ConstraintDefinitionId 
			Where cd6.ConstraintTypeId = 8 -- 'Required'
		)tbMissing on re.RegistryElementId = tbMissing.RegistryElementId  
left join
		(
		  Select 
				 re07.RegistryElementId 
				,re07.DataElementId	   
				, (select
					 ISNULL(pde7.DataElementSeq,'')  AS ParentElementReference
					,COALESCE(pde7.DataElementLabel,pde7.DataElementName)  AS ParentElementName			
					,ISNULL(CASE 
						WHEN cdre7.StringValue = 'true' Then
							'Yes'
						WHEN cdre7.StringValue = 'false' Then 
							'No'
						When ISNULL(cdre7.StringValue,'') <> '' Then
							dbo.fn_getParentStringValue(cdre7.StringValue)
						ELSE
							''				
					 END,'')	AS  ParentElementSelectionName
					from rdd.RegistryElements re7 
					inner join rdd.RegistryElements_ConstraintDefinitions recd7 on re7.RegistryElementId = recd7.RegistryElementId 
					inner join dd.ConstraintDefinitions cd7 on recd7.ConstraintDefinitionId = cd7.ConstraintDefinitionId 
					inner join dd.ConstraintDefinitionRelatedElements cdre7 on cd7.ConstraintDefinitionId = cdre7.ConstraintDefinitionId 
					inner join rdd.RegistryElements pre7 on cdre7.RegistryElementId = pre7.RegistryElementId
					inner join cdd.DataElements pde7 on pre7.DataElementId = pde7.DataElementId 
					where cd7.ConstraintTypeId = 14 
					AND  re7.RegistryElementId = re07.RegistryElementId
					FOR XML RAW ('Parent'), ROOT
				) AS XMLText 
			FROM rdd.RegistryElements re07 
		)tblParent on re.RegistryElementId = tblParent.RegistryElementId  


--Where re.RegistryVersionId = 3
 


GO
