CREATE TABLE [dbo].[ProjectFormSections]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectFormSections_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectFormSections_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectFormSections] ADD CONSTRAINT [ProjectFormSections_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectFormSections] ADD CONSTRAINT [FK_ProjectFormSections_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectFormSections] WITH NOCHECK ADD CONSTRAINT [FK_ProjectFormSections_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [form].[FormSections] ([FormSectionId])
GO
ALTER TABLE [dbo].[ProjectFormSections] NOCHECK CONSTRAINT [FK_ProjectFormSections_ReferenceId]
GO
