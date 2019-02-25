CREATE TABLE [rdd].[RegistryElements]
(
[RegistryElementId] [int] NOT NULL IDENTITY(1, 1),
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
[DataSourceId] [int] NOT NULL CONSTRAINT [DF_RegistryElements_DataSourceId] DEFAULT ((1)),
[IsDPIField] [bit] NOT NULL CONSTRAINT [DF_RegistryElements_IsDPIField] DEFAULT ((0)),
[RegistrySectionId] [int] NULL,
[IsBase] [bit] NOT NULL CONSTRAINT [DF_RegistryElement_IsBase] DEFAULT ((0)),
[IsFollowup] [bit] NOT NULL CONSTRAINT [DF_RegistryElement_IsFollowup] DEFAULT ((0)),
[VendorInstruction] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsSupportingDefinitionPublished] [bit] NOT NULL CONSTRAINT [DF_RegistryElement_IsSupportingDefinitionPublished] DEFAULT ((0)),
[IsContainerId] [bit] NOT NULL CONSTRAINT [DF_RegistryElement_IsContainerId] DEFAULT ((0)),
[MissingData] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NOT NULL CONSTRAINT [RegistryElements_DisplayOrder] DEFAULT ((0)),
[EDWTimePartEntityColumnID] [int] NULL,
[EDWFlipElementInd] [bit] NOT NULL CONSTRAINT [DF_RegistryElement_EDWFlipElementInd] DEFAULT ((0)),
[EDWMappingInstruction] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegistryElementLabel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDWEntityColumnId] [int] NULL,
[ContainmentTypeId] [int] NULL,
[UseInComputedConcept] [bit] NOT NULL CONSTRAINT [DF_UseInComputedConcept] DEFAULT ((0)),
[ClinicalRegistrySectionId] [int] NULL,
[ClinicalDisplayOrder] [int] NOT NULL CONSTRAINT [DF__RegistryE__Clini__330B79E8] DEFAULT ((0)),
[CDAContainingRegistryElementId] [int] NULL
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
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_RegistryElement_CDAContainingRegistryElement] FOREIGN KEY ([CDAContainingRegistryElementId]) REFERENCES [rdd].[RegistryElements] ([RegistryElementId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_RegistrySection] FOREIGN KEY ([RegistrySectionId]) REFERENCES [rdd].[RegistrySections] ([RegistrySectionId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK_RegistryElements_ValueSets] FOREIGN KEY ([ValueSetId]) REFERENCES [cdd].[ValueSets] ([ValueSetId])
GO
ALTER TABLE [rdd].[RegistryElements] ADD CONSTRAINT [FK__RegistryE__Clini__33FF9E21] FOREIGN KEY ([ClinicalRegistrySectionId]) REFERENCES [rdd].[RegistrySections] ([RegistrySectionId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Concept definition to use with this registry version', 'SCHEMA', N'rdd', 'TABLE', N'RegistryElements', 'COLUMN', N'ConceptDefinitionId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Coding Instruction to use with this registry version', 'SCHEMA', N'rdd', 'TABLE', N'RegistryElements', 'COLUMN', N'DataElementCodingInstructionId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default value for this column.', 'SCHEMA', N'rdd', 'TABLE', N'RegistryElements', 'COLUMN', N'DefaultValueSetMemberId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Are we collecting data for this field or is only for display purpose on DCT', 'SCHEMA', N'rdd', 'TABLE', N'RegistryElements', 'COLUMN', N'IsHarvested'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates whether the element is published (not published is generally for internal use)', 'SCHEMA', N'rdd', 'TABLE', N'RegistryElements', 'COLUMN', N'IsPublished'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Note providing information about prior version of this element if one exist. Useful during version upgrades.', 'SCHEMA', N'rdd', 'TABLE', N'RegistryElements', 'COLUMN', N'PrevVersionReferenceNote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'There may be multiple value set assigned for this element, registry will have to choose one of the allowed list for implementation', 'SCHEMA', N'rdd', 'TABLE', N'RegistryElements', 'COLUMN', N'ValueSetId'
GO
