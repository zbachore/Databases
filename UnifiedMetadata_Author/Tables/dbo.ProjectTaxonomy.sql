CREATE TABLE [dbo].[ProjectTaxonomy]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectTaxonomy_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectTaxonomy_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectTaxonomy] ADD CONSTRAINT [ProjectTaxonomyId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectTaxonomy] ADD CONSTRAINT [FK_ProjectTaxonomy_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectTaxonomy] WITH NOCHECK ADD CONSTRAINT [FK_ProjectTaxonomy_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [dd].[Taxonomy] ([TaxonId])
GO
ALTER TABLE [dbo].[ProjectTaxonomy] NOCHECK CONSTRAINT [FK_ProjectTaxonomy_ReferenceId]
GO
