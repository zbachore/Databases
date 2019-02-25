CREATE TABLE [dbo].[ProjectValueSetTaxonomy]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectValueSetTaxonomy_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectValueSetTaxonomy_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectValueSetTaxonomy] ADD CONSTRAINT [ProjectValueSetTaxonomyId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectValueSetTaxonomy] ADD CONSTRAINT [FK_ProjectValueSetTaxonomy_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectValueSetTaxonomy] WITH NOCHECK ADD CONSTRAINT [FK_ProjectValueSetTaxonomy_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[ValueSets_Taxonomy] ([ValueSetsTaxonomyID])
GO
ALTER TABLE [dbo].[ProjectValueSetTaxonomy] NOCHECK CONSTRAINT [FK_ProjectValueSetTaxonomy_ReferenceId]
GO
