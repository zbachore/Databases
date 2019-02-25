CREATE TABLE [dbo].[ProjectRegistryDataSets]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistryDataSets_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistryDataSets_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistryDataSets] ADD CONSTRAINT [ProjectRegistryDataSets_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistryDataSets] ADD CONSTRAINT [FK_ProjectRegistryDataSets_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectRegistryDataSets] WITH NOCHECK ADD CONSTRAINT [FK_ProjectRegistryDataSets_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [rdd].[RegistryDataSets] ([RegistryDataSetId])
GO
ALTER TABLE [dbo].[ProjectRegistryDataSets] NOCHECK CONSTRAINT [FK_ProjectRegistryDataSets_ReferenceId]
GO
