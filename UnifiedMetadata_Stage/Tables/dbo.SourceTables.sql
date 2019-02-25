CREATE TABLE [dbo].[SourceTables]
(
[SourceTableID] [bigint] NOT NULL IDENTITY(1, 1),
[TABLE_CATALOG] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TABLE_SCHEMA] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TABLE_NAME] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COLUMN_NAME] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IS_NULLABLE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DATA_TYPE] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CHARACTER_MAXIMUM_LENGTH] [int] NULL,
[DATETIME_PRECISION] [smallint] NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_SourceTables_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_SourceTables_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SourceTables] ADD CONSTRAINT [PK_SourceTables] PRIMARY KEY CLUSTERED  ([SourceTableID]) ON [PRIMARY]
GO
