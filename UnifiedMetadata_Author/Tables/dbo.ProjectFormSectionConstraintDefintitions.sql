CREATE TABLE [dbo].[ProjectFormSectionConstraintDefintitions]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectFormSectionConstraintDefintitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectFormSectionConstraintDefintitions_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectFormSectionConstraintDefintitions] ADD CONSTRAINT [ProjectFormSectionConstraintDefintitions_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectFormSectionConstraintDefintitions] ADD CONSTRAINT [FK_ProjectFormSectionConstraintDefintitions_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectFormSectionConstraintDefintitions] WITH NOCHECK ADD CONSTRAINT [FK_ProjectFormSectionConstraintDefintitions_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [form].[FormSectionConstraintDefintitions] ([FormSectionConstraintDefintitionsID])
GO
ALTER TABLE [dbo].[ProjectFormSectionConstraintDefintitions] NOCHECK CONSTRAINT [FK_ProjectFormSectionConstraintDefintitions_ReferenceId]
GO
