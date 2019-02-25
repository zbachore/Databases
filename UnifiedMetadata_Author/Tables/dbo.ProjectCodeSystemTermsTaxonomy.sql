CREATE TABLE [dbo].[ProjectCodeSystemTermsTaxonomy]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectCodeSystemTermsTaxonomy_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectCodeSystemTermsTaxonomy_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectCodeSystemTermsTaxonomy] ADD CONSTRAINT [ProjectCodeSystemTermsTaxonomyId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectCodeSystemTermsTaxonomy] ADD CONSTRAINT [FK_ProjectCodeSystemTermsTaxonomy_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectCodeSystemTermsTaxonomy] WITH NOCHECK ADD CONSTRAINT [FK_ProjectCodeSystemTermsTaxonomy_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[CodeSystemTerms_Taxonomy] ([CodeSystemTermsTaxonomyID])
GO
ALTER TABLE [dbo].[ProjectCodeSystemTermsTaxonomy] NOCHECK CONSTRAINT [FK_ProjectCodeSystemTermsTaxonomy_ReferenceId]
GO
