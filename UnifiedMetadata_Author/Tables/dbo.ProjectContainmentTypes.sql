CREATE TABLE [dbo].[ProjectContainmentTypes]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectContainmentTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectContainmentTypes_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectContainmentTypes] ADD CONSTRAINT [ProjectContainmentTypes_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectContainmentTypes] ADD CONSTRAINT [FK_ProjectContainmentTypes_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectContainmentTypes] WITH NOCHECK ADD CONSTRAINT [FK_ProjectContainmentTypes_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [rdd].[ContainmentTypes] ([ContainmentTypeId])
GO
ALTER TABLE [dbo].[ProjectContainmentTypes] NOCHECK CONSTRAINT [FK_ProjectContainmentTypes_ReferenceId]
GO
