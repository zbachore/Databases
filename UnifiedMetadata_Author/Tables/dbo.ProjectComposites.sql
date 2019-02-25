CREATE TABLE [dbo].[ProjectComposites]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectComposites_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectComposites_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectComposites] ADD CONSTRAINT [ProjectComposites_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectComposites] ADD CONSTRAINT [FK_ProjectComposites_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectComposites] WITH NOCHECK ADD CONSTRAINT [FK_ProjectComposites_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [ld].[Composites] ([CompositeId])
GO
ALTER TABLE [dbo].[ProjectComposites] NOCHECK CONSTRAINT [FK_ProjectComposites_ReferenceId]
GO
