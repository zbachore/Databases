CREATE TABLE [cdd].[CodeSystemTerms_Taxonomy]
(
[CodeSystemTermsTaxonomyID] [int] NOT NULL,
[CodeSystemTermId] [int] NOT NULL,
[TaxonId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_CodeSystemTerms_Taxonomy_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_CodeSystemTerms_Taxonomy_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[CodeSystemTerms_Taxonomy] ADD CONSTRAINT [PK_CodeSystemTerm_Taxonomy] PRIMARY KEY CLUSTERED  ([CodeSystemTermsTaxonomyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_CodeSystemTerm_Taxonomy_CodeSystemTerm] ON [cdd].[CodeSystemTerms_Taxonomy] ([CodeSystemTermId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[CodeSystemTerms_Taxonomy] ADD CONSTRAINT [U_CodeSystemTerms_Taxonomy] UNIQUE NONCLUSTERED  ([CodeSystemTermId], [TaxonId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_CodeSystemTerm_Taxonomy_Taxonomy] ON [cdd].[CodeSystemTerms_Taxonomy] ([TaxonId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[CodeSystemTerms_Taxonomy] ADD CONSTRAINT [FK_CodeSystemTerm_Taxonomy_CodeSystemTerm] FOREIGN KEY ([CodeSystemTermId]) REFERENCES [cdd].[CodeSystemTerms] ([CodeSystemTermId])
GO
ALTER TABLE [cdd].[CodeSystemTerms_Taxonomy] ADD CONSTRAINT [FK_CodeSystemTerm_Taxonomy_Taxonomy] FOREIGN KEY ([TaxonId]) REFERENCES [dd].[Taxonomy] ([TaxonId])
GO
