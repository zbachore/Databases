CREATE TABLE [cdd].[TemporalContexts]
(
[TemporalContextId] [int] NOT NULL,
[TemporalContextName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TemporalContextDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_TemporalContexts_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_TemporalContexts_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[TemporalContexts] ADD CONSTRAINT [PK_TemporalContext] PRIMARY KEY NONCLUSTERED  ([TemporalContextId]) ON [PRIMARY]
GO
