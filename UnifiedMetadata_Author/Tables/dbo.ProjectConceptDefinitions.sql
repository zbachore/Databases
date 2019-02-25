CREATE TABLE [dbo].[ProjectConceptDefinitions]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectConceptDefinitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectConceptDefinitions_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConceptDefinitions] ADD CONSTRAINT [ProjectConceptDefinitions_PK] PRIMARY KEY NONCLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConceptDefinitions] ADD CONSTRAINT [FK_ProjectConceptDefinitions_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectConceptDefinitions] WITH NOCHECK ADD CONSTRAINT [FK_ProjectConceptDefinitions_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[ConceptDefinitions] ([ConceptDefinitionId])
GO
ALTER TABLE [dbo].[ProjectConceptDefinitions] NOCHECK CONSTRAINT [FK_ProjectConceptDefinitions_ReferenceId]
GO
