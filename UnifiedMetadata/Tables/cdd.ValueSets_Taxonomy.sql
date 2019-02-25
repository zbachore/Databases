CREATE TABLE [cdd].[ValueSets_Taxonomy]
(
[ValueSetsTaxonomyID] [int] NOT NULL,
[ValueSetId] [int] NOT NULL,
[TaxonId] [int] NOT NULL,
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
