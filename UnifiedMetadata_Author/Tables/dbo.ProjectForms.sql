CREATE TABLE [dbo].[ProjectForms]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectForms_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectForms_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectForms] ADD CONSTRAINT [ProjectForms_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectForms] ADD CONSTRAINT [FK_ProjectForms_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectForms] WITH NOCHECK ADD CONSTRAINT [FK_ProjectForms_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [form].[Forms] ([FormId])
GO
ALTER TABLE [dbo].[ProjectForms] NOCHECK CONSTRAINT [FK_ProjectForms_ReferenceId]
GO
