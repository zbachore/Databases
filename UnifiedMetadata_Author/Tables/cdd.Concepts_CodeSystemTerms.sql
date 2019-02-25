CREATE TABLE [cdd].[Concepts_CodeSystemTerms]
(
[ConceptId] [int] NOT NULL,
[CodeSystemTermId] [int] NOT NULL,
[ConceptsCodeSystemTermsID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Concepts_CodeSystemTerms_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Concepts_CodeSystemTerms_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[Concepts_CodeSystemTerms] ADD CONSTRAINT [PK_Concepts_CodeSystemTerms] PRIMARY KEY CLUSTERED  ([ConceptsCodeSystemTermsID]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[Concepts_CodeSystemTerms] ADD CONSTRAINT [U_Concepts_CodeSystemTerms] UNIQUE NONCLUSTERED  ([CodeSystemTermId], [ConceptId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[Concepts_CodeSystemTerms] ADD CONSTRAINT [FK__Concepts_CodeSystemTerms_CodeSystemTerms] FOREIGN KEY ([CodeSystemTermId]) REFERENCES [cdd].[CodeSystemTerms] ([CodeSystemTermId])
GO
ALTER TABLE [cdd].[Concepts_CodeSystemTerms] ADD CONSTRAINT [FK__Concepts_CodeSystemTerms_Concepts] FOREIGN KEY ([ConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
