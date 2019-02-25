CREATE TABLE [dbo].[ProjectDataSources]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDataSources_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectDataSources_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataSources] ADD CONSTRAINT [ProjectDataSources_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectDataSources] ADD CONSTRAINT [FK_ProjectDataSources_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectDataSources] WITH NOCHECK ADD CONSTRAINT [FK_ProjectDataSources_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [rdd].[DataSources] ([DataSourceId])
GO
ALTER TABLE [dbo].[ProjectDataSources] NOCHECK CONSTRAINT [FK_ProjectDataSources_ReferenceId]
GO
