CREATE TABLE [dbo].[ProjectConstraintReportingLevels]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ProjectId] [int] NOT NULL,
[ReferenceId] [int] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectConstraintReportingLevels_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectConstraintReportingLevels_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConstraintReportingLevels] ADD CONSTRAINT [ProjectConstraintReportingLevels_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectConstraintReportingLevels] ADD CONSTRAINT [FK_ProjectConstraintReportingLevels_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectConstraintReportingLevels] WITH NOCHECK ADD CONSTRAINT [FK_ProjectConstraintReportingLevels_ReferenceId] FOREIGN KEY ([ReferenceId]) REFERENCES [dd].[ConstraintReportingLevels] ([ConstraintReportingLevelId])
GO
ALTER TABLE [dbo].[ProjectConstraintReportingLevels] NOCHECK CONSTRAINT [FK_ProjectConstraintReportingLevels_ReferenceId]
GO
