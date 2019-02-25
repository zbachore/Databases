CREATE TABLE [dbo].[ProjectConcepts]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectConcepts_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectConcepts_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConcepts] ADD CONSTRAINT [ProjectConceptId_PK] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConcepts] ADD CONSTRAINT [FK_ProjectConcepts_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectConcepts] WITH NOCHECK ADD CONSTRAINT [FK_ProjectConcepts_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
ALTER TABLE [dbo].[ProjectConcepts] NOCHECK CONSTRAINT [FK_ProjectConcepts_ReferenceId]
GO
