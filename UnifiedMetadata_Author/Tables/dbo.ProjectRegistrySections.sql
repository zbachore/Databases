CREATE TABLE [dbo].[ProjectRegistrySections]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistrySections_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistrySections_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistrySections] ADD CONSTRAINT [ProjectRegistrySections_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistrySections] ADD CONSTRAINT [FK_ProjectRegistrySections_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectRegistrySections] WITH NOCHECK ADD CONSTRAINT [FK_ProjectRegistrySections_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [rdd].[RegistrySections] ([RegistrySectionId])
GO
ALTER TABLE [dbo].[ProjectRegistrySections] NOCHECK CONSTRAINT [FK_ProjectRegistrySections_ReferenceId]
GO
