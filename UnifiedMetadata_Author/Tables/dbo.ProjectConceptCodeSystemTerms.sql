CREATE TABLE [dbo].[ProjectConceptCodeSystemTerms]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectConceptCodeSystemTerms_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectConceptCodeSystemTerms_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConceptCodeSystemTerms] ADD CONSTRAINT [ProjectConceptCodeSystemTermsId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConceptCodeSystemTerms] ADD CONSTRAINT [FK_ProjectConceptCodeSystemTerms_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectConceptCodeSystemTerms] WITH NOCHECK ADD CONSTRAINT [FK_ProjectConceptCodeSystemTerms_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[Concepts_CodeSystemTerms] ([ConceptsCodeSystemTermsID])
GO
ALTER TABLE [dbo].[ProjectConceptCodeSystemTerms] NOCHECK CONSTRAINT [FK_ProjectConceptCodeSystemTerms_ReferenceId]
GO
