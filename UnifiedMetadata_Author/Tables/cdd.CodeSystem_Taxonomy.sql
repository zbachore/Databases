CREATE TABLE [cdd].[CodeSystem_Taxonomy]
(
[CodeSystemId] [int] NOT NULL,
[TaxonId] [int] NOT NULL,
[CodeSystemTaxonomyID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_CodeSystem_Taxonomy_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_CodeSystem_Taxonomy_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[CodeSystem_Taxonomy] ADD CONSTRAINT [PK_CodeSystem_Taxonomy] PRIMARY KEY CLUSTERED  ([CodeSystemTaxonomyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_CodeSystem_Taxonomy_CodeSystem] ON [cdd].[CodeSystem_Taxonomy] ([CodeSystemId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[CodeSystem_Taxonomy] ADD CONSTRAINT [U_CodeSystem_Taxonomy] UNIQUE NONCLUSTERED  ([CodeSystemId], [TaxonId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_CodeSystem_Taxonomy_Taxonomy] ON [cdd].[CodeSystem_Taxonomy] ([TaxonId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[CodeSystem_Taxonomy] ADD CONSTRAINT [FK_CodeSystem_Taxonomy_CodeSystem] FOREIGN KEY ([CodeSystemId]) REFERENCES [cdd].[CodeSystems] ([CodeSystemId])
GO
ALTER TABLE [cdd].[CodeSystem_Taxonomy] ADD CONSTRAINT [FK_CodeSystem_Taxonomy_Taxonomy] FOREIGN KEY ([TaxonId]) REFERENCES [dd].[Taxonomy] ([TaxonId])
GO
