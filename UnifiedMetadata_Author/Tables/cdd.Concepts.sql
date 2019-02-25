CREATE TABLE [cdd].[Concepts]
(
[ConceptId] [int] NOT NULL IDENTITY(1, 1),
[CodeSystemTermId] [int] NULL,
[ConceptName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DomainConceptId] [int] NULL,
[IsActive] [bit] NOT NULL,
[StartDate] [datetime2] NOT NULL,
[EndDate] [datetime2] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Concepts_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Concepts_UpdatedDate] DEFAULT (sysdatetime()),
[Synonyms] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[Concepts] ADD CONSTRAINT [PK_Concept] PRIMARY KEY NONCLUSTERED  ([ConceptId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Concept_CodeSystemTerm] ON [cdd].[Concepts] ([CodeSystemTermId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[Concepts] ADD CONSTRAINT [FK_Concept_CodeSystemTerm] FOREIGN KEY ([CodeSystemTermId]) REFERENCES [cdd].[CodeSystemTerms] ([CodeSystemTermId])
GO
ALTER TABLE [cdd].[Concepts] ADD CONSTRAINT [FK_Concepts_Concepts] FOREIGN KEY ([DomainConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains all Clinical Concepts across domains, including the name (description), their identifier (called Code System Term).', 'SCHEMA', N'cdd', 'TABLE', N'Concepts', NULL, NULL
GO
