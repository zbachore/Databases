CREATE TABLE [dbo].[ProjectFormPages]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectFormPages_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectFormPages_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectFormPages] ADD CONSTRAINT [ProjectFormPages_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectFormPages] ADD CONSTRAINT [FK_ProjectFormPages_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectFormPages] WITH NOCHECK ADD CONSTRAINT [FK_ProjectFormPages_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [form].[FormPages] ([FormPageId])
GO
ALTER TABLE [dbo].[ProjectFormPages] NOCHECK CONSTRAINT [FK_ProjectFormPages_ReferenceId]
GO
