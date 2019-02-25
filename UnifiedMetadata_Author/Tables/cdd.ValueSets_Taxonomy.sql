CREATE TABLE [cdd].[ValueSets_Taxonomy]
(
[ValueSetId] [int] NOT NULL,
[TaxonId] [int] NOT NULL,
[ValueSetsTaxonomyID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSets_Taxonomy_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSets_Taxonomy_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSets_Taxonomy] ADD CONSTRAINT [PK_ValueList_Taxonomy] PRIMARY KEY CLUSTERED  ([ValueSetsTaxonomyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueList_Taxonomy_Taxonomy] ON [cdd].[ValueSets_Taxonomy] ([TaxonId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSets_Taxonomy] ADD CONSTRAINT [U_ValueSets_Taxonomy] UNIQUE NONCLUSTERED  ([TaxonId], [ValueSetId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ValueList_Taxonomy_ValueSet] ON [cdd].[ValueSets_Taxonomy] ([ValueSetId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSets_Taxonomy] ADD CONSTRAINT [FK_ValueList_Taxonomy_Taxonomy] FOREIGN KEY ([TaxonId]) REFERENCES [dd].[Taxonomy] ([TaxonId])
GO
ALTER TABLE [cdd].[ValueSets_Taxonomy] ADD CONSTRAINT [FK_ValueSet_Taxonomy_ValueSet] FOREIGN KEY ([ValueSetId]) REFERENCES [cdd].[ValueSets] ([ValueSetId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table defines the Taxonomy of Value List. A Value List can potentially be associated with multiple classification.', 'SCHEMA', N'cdd', 'TABLE', N'ValueSets_Taxonomy', NULL, NULL
GO
