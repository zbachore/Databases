CREATE TABLE [cdd].[Concepts_Taxonomy]
(
[ConceptId] [int] NOT NULL,
[TaxonId] [int] NOT NULL,
[ConceptsTaxonomyID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Concepts_Taxonomy_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Concepts_Taxonomy_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[Concepts_Taxonomy] ADD CONSTRAINT [PK_Concept_Taxonomy] PRIMARY KEY CLUSTERED  ([ConceptsTaxonomyID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Concept_Taxonomy_Concept] ON [cdd].[Concepts_Taxonomy] ([ConceptId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[Concepts_Taxonomy] ADD CONSTRAINT [U_Concepts_Taxonomy] UNIQUE NONCLUSTERED  ([ConceptId], [TaxonId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Concept_Taxonomy_Taxonomy] ON [cdd].[Concepts_Taxonomy] ([TaxonId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[Concepts_Taxonomy] ADD CONSTRAINT [FK_Concept_Taxonomy_Concept] FOREIGN KEY ([ConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
ALTER TABLE [cdd].[Concepts_Taxonomy] ADD CONSTRAINT [FK_Concept_Taxonomy_Taxonomy] FOREIGN KEY ([TaxonId]) REFERENCES [dd].[Taxonomy] ([TaxonId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table defines the Taxonomy of Clinical Concepts. A Concept can potentially be associated with multiple classification.', 'SCHEMA', N'cdd', 'TABLE', N'Concepts_Taxonomy', NULL, NULL
GO
