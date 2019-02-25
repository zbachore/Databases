CREATE TABLE [dbo].[ProjectFormElements]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectFormElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectFormElements_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectFormElements] ADD CONSTRAINT [ProjectFormElements_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectFormElements] ADD CONSTRAINT [FK_ProjectFormElements_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectFormElements] WITH NOCHECK ADD CONSTRAINT [FK_ProjectFormElements_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [form].[FormElements] ([FormElementId])
GO
ALTER TABLE [dbo].[ProjectFormElements] NOCHECK CONSTRAINT [FK_ProjectFormElements_ReferenceId]
GO
