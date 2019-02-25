CREATE TABLE [dbo].[ProjectRegistryDataSetRegistryElements]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistryDataSetRegistryElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistryDataSetRegistryElements_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistryDataSetRegistryElements] ADD CONSTRAINT [ProjectRegistryDataSetRegistryElements_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistryDataSetRegistryElements] ADD CONSTRAINT [FK_ProjectRegistryDataSetRegistryElements_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectRegistryDataSetRegistryElements] WITH NOCHECK ADD CONSTRAINT [FK_ProjectRegistryDataSetRegistryElements_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [rdd].[RegistryDataSets_RegistryElements] ([RegistryDataSetsRegistryElementsID])
GO
ALTER TABLE [dbo].[ProjectRegistryDataSetRegistryElements] NOCHECK CONSTRAINT [FK_ProjectRegistryDataSetRegistryElements_ReferenceId]
GO
