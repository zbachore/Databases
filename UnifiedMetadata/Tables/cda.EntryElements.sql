CREATE TABLE [cda].[EntryElements]
(
[EntryTemplateId] [int] NOT NULL,
[RegistryElementId] [int] NOT NULL,
[ElementMapEntryAttributeId] [int] NULL,
[ValueMapEntryAttributeId] [int] NULL,
[ProfileConceptId] [int] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntryElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntryElements_UpdatedDate] DEFAULT (sysdatetime()),
[PseudoSectionShortName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryElementId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [cda].[EntryElements] ADD CONSTRAINT [PK__EntryEle__B48FBA754356F04A] PRIMARY KEY CLUSTERED  ([EntryElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_IGEntryTemplates_RegistryElements_EntryAttributeTypes] ON [cda].[EntryElements] ([ElementMapEntryAttributeId]) ON [PRIMARY]
GO
ALTER TABLE [cda].[EntryElements] ADD CONSTRAINT [UC_EntryTemplate_RegistryElement] UNIQUE NONCLUSTERED  ([EntryTemplateId], [RegistryElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_IGEntryTemplates_RegistryElements_Concepts] ON [cda].[EntryElements] ([ProfileConceptId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_IGEntryTemplates_RegistryElements_RegistryElements] ON [cda].[EntryElements] ([RegistryElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_IGEntryTemplates_RegistryElements_EntryAttributeTypes_02] ON [cda].[EntryElements] ([ValueMapEntryAttributeId]) ON [PRIMARY]
GO
ALTER TABLE [cda].[EntryElements] ADD CONSTRAINT [FK_EntryElements_Concepts] FOREIGN KEY ([ProfileConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
ALTER TABLE [cda].[EntryElements] ADD CONSTRAINT [FK_EntryElements_EntryAttributes2] FOREIGN KEY ([ValueMapEntryAttributeId]) REFERENCES [cda].[EntryAttributes] ([EntryAttributeId])
GO
ALTER TABLE [cda].[EntryElements] ADD CONSTRAINT [FK_EntryElements_EntryTemplates] FOREIGN KEY ([EntryTemplateId]) REFERENCES [cda].[EntryTemplates] ([EntryTemplateId])
GO
ALTER TABLE [cda].[EntryElements] ADD CONSTRAINT [FK_EntryElements_RegistryElements] FOREIGN KEY ([RegistryElementId]) REFERENCES [rdd].[RegistryElements] ([RegistryElementId])
GO
ALTER TABLE [cda].[EntryElements] ADD CONSTRAINT [FK_EntryElementss_EntryAttributes] FOREIGN KEY ([ElementMapEntryAttributeId]) REFERENCES [cda].[EntryAttributes] ([EntryAttributeId])
GO
