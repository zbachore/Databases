CREATE TABLE [dbo].[ProjectEntityColumnsRegistryElements]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectEntityColumnsRegistryElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectEntityColumnsRegistryElements_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectEntityColumnsRegistryElements] ADD CONSTRAINT [ProjectEntityColumnsRegistryElements_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectEntityColumnsRegistryElements] ADD CONSTRAINT [FK_ProjectEntityColumnsRegistryElements_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectEntityColumnsRegistryElements] WITH NOCHECK ADD CONSTRAINT [FK_ProjectEntityColumnsRegistryElements_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [edw].[EntityColumns_RegistryElements] ([EntityColumnsRegistryElementsID])
GO
ALTER TABLE [dbo].[ProjectEntityColumnsRegistryElements] NOCHECK CONSTRAINT [FK_ProjectEntityColumnsRegistryElements_ReferenceId]
GO
