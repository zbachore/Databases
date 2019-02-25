CREATE TABLE [dbo].[PublishQueueBackup]
(
[PublishQueueID] [int] NOT NULL IDENTITY(1, 1),
[PublishStatusID] [int] NOT NULL,
[ServerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectID] [int] NOT NULL,
[RequestedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestedTime] [datetime2] NOT NULL,
[CompletedTime] [datetime2] NULL,
[Msg] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
