CREATE TABLE [dbo].[ProjectRegistries]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectRegistries_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectRegistries_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistries] ADD CONSTRAINT [ProjectRegistryId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistries] ADD CONSTRAINT [FK_ProjectRegistries_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectRegistries] WITH NOCHECK ADD CONSTRAINT [FK_ProjectRegistries_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [rdd].[Registries] ([RegistryId])
GO
ALTER TABLE [dbo].[ProjectRegistries] NOCHECK CONSTRAINT [FK_ProjectRegistries_ReferenceId]
GO
