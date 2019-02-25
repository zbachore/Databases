CREATE TABLE [dbo].[ProjectRegistryVersions]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectRegistryVersions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectRegistryVersions_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistryVersions] ADD CONSTRAINT [ProjectRegistryVersionId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistryVersions] ADD CONSTRAINT [FK_ProjectRegistryVersions_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectRegistryVersions] WITH NOCHECK ADD CONSTRAINT [FK_ProjectRegistryVersions_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [rdd].[RegistryVersions] ([RegistryVersionId])
GO
ALTER TABLE [dbo].[ProjectRegistryVersions] NOCHECK CONSTRAINT [FK_ProjectRegistryVersions_ReferenceId]
GO
