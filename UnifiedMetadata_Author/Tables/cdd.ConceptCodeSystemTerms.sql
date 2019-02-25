CREATE TABLE [cdd].[ConceptCodeSystemTerms]
(
[CodeSystemTermId] [int] NOT NULL,
[ConceptId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ConceptCodeSystemTerms] ADD CONSTRAINT [PK_ConceptCodeSystemTerms] PRIMARY KEY CLUSTERED  ([CodeSystemTermId], [ConceptId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ConceptCodeSystemTerms] ADD CONSTRAINT [FK_ConceptsCodeSystemTerms_CodeSystemTerm] FOREIGN KEY ([CodeSystemTermId]) REFERENCES [cdd].[CodeSystemTerms] ([CodeSystemTermId])
GO
ALTER TABLE [cdd].[ConceptCodeSystemTerms] ADD CONSTRAINT [FK_ConceptsCodeSystemTerms_Concept] FOREIGN KEY ([ConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
