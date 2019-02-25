CREATE TABLE [dd].[ConstraintReportingLevels]
(
[ConstraintReportingLevelId] [int] NOT NULL IDENTITY(1, 1),
[ConstraintReportingLevelName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConstraintReportingLevelDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintReportingLevels_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ConstraintReportingLevels_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dd].[ConstraintReportingLevels] ADD CONSTRAINT [PK_ConstraintReportingLevels] PRIMARY KEY CLUSTERED  ([ConstraintReportingLevelId]) ON [PRIMARY]
GO
