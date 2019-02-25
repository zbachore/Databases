CREATE TABLE [dbo].[ProjectRegistrySectionContainerClasses]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistrySectionContainerClasses_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectRegistrySectionContainerClasses_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistrySectionContainerClasses] ADD CONSTRAINT [ProjectRegistrySectionContainerClasses_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectRegistrySectionContainerClasses] ADD CONSTRAINT [FK_ProjectRegistrySectionContainerClasses_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectRegistrySectionContainerClasses] WITH NOCHECK ADD CONSTRAINT [FK_ProjectRegistrySectionContainerClasses_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [rdd].[RegistrySectionContainerClasses] ([RegistrySectionContainerClassId])
GO
ALTER TABLE [dbo].[ProjectRegistrySectionContainerClasses] NOCHECK CONSTRAINT [FK_ProjectRegistrySectionContainerClasses_ReferenceId]
GO
