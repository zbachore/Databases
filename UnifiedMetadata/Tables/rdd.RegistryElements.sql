CREATE TABLE [rdd].[RegistryElements]
(
[RegistryElementId] [int] NOT NULL,
[DataElementId] [int] NOT NULL,
[RegistryVersionId] [int] NOT NULL,
[DataElementCodingInstructionId] [int] NULL,
[ConceptDefinitionId] [int] NULL,
[ValueSetId] [int] NULL,
[DefaultValueSetMemberId] [int] NULL,
[DefaultValue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPublished] [bit] NOT NULL,
[IsHarvested] [bit] NOT NULL,
[PrevVersionReferenceNote] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElements_UpdatedDate] DEFAULT (sysdatetime()),
[ContainingRegistryElementId] [int] NULL,
[DataSourceId] [int] NOT NULL,
[IsDPIField] [bit] NOT NULL,
[RegistrySectionId] [int] NULL,
[IsBase] [bit] NOT NULL,
[IsFollowup] [bit] NOT NULL,
[VendorInstruction] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsSupportingDefinitionPublished] [bit] NOT NULL,
[IsContainerId] [bit] NOT NULL,
[MissingData] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NOT NULL,
[EDWTimePartEntityColumnID] [int] NULL,
[EDWFlipElementInd] [bit] NOT NULL,
[EDWMappingInstruction] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegistryElementLabel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDWEntityColumnId] [int] NULL,
[ContainmentTypeId] [int] NULL,
[UseInComputedConcept] [bit] NOT NULL CONSTRAINT [DF_UseInComputedConcept] DEFAULT ((0)),
[ClinicalRegistrySectionId] [int] NULL,
[ClinicalDisplayOrder] [int] NOT NULL CONSTRAINT [DF__RegistryE__Clini__55808D7D] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [PK_RegistryElements] PRIMARY KEY CLUSTERED  ([RegistryElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryElements_ConceptDefinitions] ON [rdd].[RegistryElements] ([ConceptDefinitionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryElements_DataElementCodingInstructions] ON [rdd].[RegistryElements] ([DataElementCodingInstructionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryElements_DataElements] ON [rdd].[RegistryElements] ([DataElementId]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IXU_RegistryElements] ON [rdd].[RegistryElements] ([DataElementId], [RegistryVersionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryElements_RegistryVersion] ON [rdd].[RegistryElements] ([RegistryVersionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryElements_ValueSet] ON [rdd].[RegistryElements] ([ValueSetId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK__RegistryE__DataS__222B06A9] FOREIGN KEY ([DataSourceId]) REFERENCES [rdd].[DataSources] ([DataSourceId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_ConceptDefinitions] FOREIGN KEY ([ConceptDefinitionId]) REFERENCES [cdd].[ConceptDefinitions] ([ConceptDefinitionId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_ContainmentTypeId] FOREIGN KEY ([ContainmentTypeId]) REFERENCES [rdd].[ContainmentTypes] ([ContainmentTypeId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_DataElementCodingInstructions] FOREIGN KEY ([DataElementCodingInstructionId]) REFERENCES [cdd].[DataElementCodingInstructions] ([DataElementCodingInstructionId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_DataElements] FOREIGN KEY ([DataElementId]) REFERENCES [cdd].[DataElements] ([DataElementId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_EDWTimepartEntityColumnID] FOREIGN KEY ([EDWTimePartEntityColumnID]) REFERENCES [edw].[EntityColumns] ([EntityColumnId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_RegistrySection] FOREIGN KEY ([RegistrySectionId]) REFERENCES [rdd].[RegistrySections] ([RegistrySectionId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_RegistrySection2] FOREIGN KEY ([ClinicalRegistrySectionId]) REFERENCES [rdd].[RegistrySections] ([RegistrySectionId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_ValueSets] FOREIGN KEY ([ValueSetId]) REFERENCES [cdd].[ValueSets] ([ValueSetId])
GO
