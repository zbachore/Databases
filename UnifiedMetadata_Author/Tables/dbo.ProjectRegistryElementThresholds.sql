CREATE TABLE [dbo].[ProjectRegistryElementThresholds]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistryElementThresholds_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistryElementThresholds_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistryElementThresholds] ADD CONSTRAINT [ProjectRegistryElementThresholds_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistryElementThresholds] ADD CONSTRAINT [FK_ProjectRegistryElementThresholds_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectRegistryElementThresholds] WITH NOCHECK ADD CONSTRAINT [FK_ProjectRegistryElementThresholds_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [rdd].[RegistryElementThresholds] ([RegistryElementThresholdId])
GO
ALTER TABLE [dbo].[ProjectRegistryElementThresholds] NOCHECK CONSTRAINT [FK_ProjectRegistryElementThresholds_ReferenceId]
GO
