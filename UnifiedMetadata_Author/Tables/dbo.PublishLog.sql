CREATE TABLE [dbo].[PublishLog]
(
[PublishLogID] [bigint] NOT NULL IDENTITY(1, 1),
[PublishQueueID] [int] NULL,
[ServerName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableKeyName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableKeyValue] [bigint] NULL,
[Msg] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MsgType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestedTime] [datetime2] NULL,
[CompletedTime] [datetime2] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PublishLog] ADD CONSTRAINT [PK_PublishLog] PRIMARY KEY CLUSTERED  ([PublishLogID]) ON [PRIMARY]
GO
