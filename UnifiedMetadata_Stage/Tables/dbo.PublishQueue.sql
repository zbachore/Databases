CREATE TABLE [dbo].[PublishQueue]
(
[PublishQueueID] [int] NOT NULL,
[PublishStatusID] [int] NOT NULL,
[ServerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectID] [int] NULL,
[RegistryVersionID] [int] NULL,
[ValueSetID] [int] NULL,
[PublishType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestedTime] [datetime2] NOT NULL,
[CompletedTime] [datetime2] NULL,
[Msg] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_PublishQueue_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_PublishQueue_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PublishQueue] ADD CONSTRAINT [PK_PublishQueue] PRIMARY KEY CLUSTERED  ([PublishQueueID] DESC) ON [PRIMARY]
GO
