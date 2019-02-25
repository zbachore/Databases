CREATE TABLE [dbo].[ProjectCodeSystems]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectCodeSystems_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectCodeSystems_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectCodeSystems] ADD CONSTRAINT [ProjectCodeSystemId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectCodeSystems] ADD CONSTRAINT [FK_ProjectCodeSystems_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectCodeSystems] WITH NOCHECK ADD CONSTRAINT [FK_ProjectCodeSystems_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [cdd].[CodeSystems] ([CodeSystemId])
GO
ALTER TABLE [dbo].[ProjectCodeSystems] NOCHECK CONSTRAINT [FK_ProjectCodeSystems_ReferenceId]
GO
