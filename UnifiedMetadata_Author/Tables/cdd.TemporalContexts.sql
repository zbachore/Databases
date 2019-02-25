CREATE TABLE [cdd].[TemporalContexts]
(
[TemporalContextId] [int] NOT NULL IDENTITY(1, 1),
[TemporalContextName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TemporalContextDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_TemporalContexts_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_TemporalContexts_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[TemporalContexts] ADD CONSTRAINT [PK_TemporalContext] PRIMARY KEY NONCLUSTERED  ([TemporalContextId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains the list of temporal context in which the data is collected. Example: Pre-Procedure, Prior to Admission, Post Discharge, Between Admission to Discharge etc. ', 'SCHEMA', N'cdd', 'TABLE', N'TemporalContexts', NULL, NULL
GO
