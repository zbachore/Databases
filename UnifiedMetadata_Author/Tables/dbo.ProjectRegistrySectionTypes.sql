CREATE TABLE [dbo].[ProjectRegistrySectionTypes]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistrySectionTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistrySectionTypes_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistrySectionTypes] ADD CONSTRAINT [ProjectRegistrySectionTypes_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistrySectionTypes] ADD CONSTRAINT [FK_ProjectRegistrySectionTypes_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectRegistrySectionTypes] WITH NOCHECK ADD CONSTRAINT [FK_ProjectRegistrySectionTypes_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [rdd].[RegistrySectionTypes] ([RegistrySectionTypeId])
GO
ALTER TABLE [dbo].[ProjectRegistrySectionTypes] NOCHECK CONSTRAINT [FK_ProjectRegistrySectionTypes_ReferenceId]
GO
