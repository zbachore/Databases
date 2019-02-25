CREATE TABLE [dbo].[ProjectConstraintDefinitionRelatedElementGroups]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectConstraintDefinitionRelatedElementGroups_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectConstraintDefinitionRelatedElementGroups_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConstraintDefinitionRelatedElementGroups] ADD CONSTRAINT [ProjectConstraintDefinitionRelatedElementGroupsId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConstraintDefinitionRelatedElementGroups] ADD CONSTRAINT [FK_ProjectConstraintDefinitionRelatedElementGroups_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectConstraintDefinitionRelatedElementGroups] WITH NOCHECK ADD CONSTRAINT [FK_ProjectConstraintDefinitionRelatedElementGroups_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [dd].[ConstraintDefinitionRelatedElementGroups] ([ConstraintDefinitionRelatedElementGroupId])
GO
ALTER TABLE [dbo].[ProjectConstraintDefinitionRelatedElementGroups] NOCHECK CONSTRAINT [FK_ProjectConstraintDefinitionRelatedElementGroups_ReferenceId]
GO
