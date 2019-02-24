CREATE TABLE [cdd].[Concepts_CodeSystemTerms]
(
[ConceptsCodeSystemTermsID] [int] NOT NULL,
[ConceptId] [int] NOT NULL,
[CodeSystemTermId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Concepts_CodeSystemTerms_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Concepts_CodeSystemTerms_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[Concepts_CodeSystemTerms] ADD CONSTRAINT [PK_Concepts_CodeSystemTerms] PRIMARY KEY CLUSTERED  ([ConceptsCodeSystemTermsID]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[Concepts_CodeSystemTerms] ADD CONSTRAINT [U_Concepts_CodeSystemTerms] UNIQUE NONCLUSTERED  ([CodeSystemTermId], [ConceptId]) ON [PRIMARY]
GO
