CREATE TABLE [dbo].[ProjectConstraintTypes]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectConstraintTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectConstraintTypes_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConstraintTypes] ADD CONSTRAINT [ProjectConstraintTypes_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConstraintTypes] ADD CONSTRAINT [FK_ProjectConstraintTypes_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectConstraintTypes] WITH NOCHECK ADD CONSTRAINT [FK_ProjectConstraintTypes_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [dd].[ConstraintTypes] ([ConstraintTypeId])
GO
ALTER TABLE [dbo].[ProjectConstraintTypes] NOCHECK CONSTRAINT [FK_ProjectConstraintTypes_ReferenceId]
GO
