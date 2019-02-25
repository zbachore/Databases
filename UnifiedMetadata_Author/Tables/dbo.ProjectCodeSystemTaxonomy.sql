CREATE TABLE [dbo].[ProjectCodeSystemTaxonomy]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectCodeSystemTaxonomy_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectCodeSystemTaxonomy_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectCodeSystemTaxonomy] ADD CONSTRAINT [ProjectCodeSystemTaxonomyId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectCodeSystemTaxonomy] ADD CONSTRAINT [FK_ProjectCodeSystemTaxonomy_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectCodeSystemTaxonomy] WITH NOCHECK ADD CONSTRAINT [FK_ProjectCodeSystemTaxonomy_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[CodeSystem_Taxonomy] ([CodeSystemTaxonomyID])
GO
ALTER TABLE [dbo].[ProjectCodeSystemTaxonomy] NOCHECK CONSTRAINT [FK_ProjectCodeSystemTaxonomy_ReferenceId]
GO
