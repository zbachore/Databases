CREATE TABLE [dbo].[PublishQueue]
(
[PublishQueueID] [int] NOT NULL IDENTITY(1, 1),
[PublishStatusID] [int] NOT NULL CONSTRAINT [DF_PublishQueue_PublishStatusID] DEFAULT ((1)),
[ServerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectID] [int] NULL CONSTRAINT [DF_PublishQueue_ProjectID] DEFAULT ((0)),
[RegistryVersionID] [int] NULL,
[ValueSetID] [int] NULL,
[PublishType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PublishQueue_RequestedBy] DEFAULT (suser_name()),
[RequestedTime] [datetime2] NOT NULL CONSTRAINT [DF_PublishQueue_RequestedTime] DEFAULT (sysdatetime()),
[CompletedTime] [datetime2] NULL,
[Msg] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorMessage] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_PublishQueue_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_PublishQueue_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PublishQueue] ADD CONSTRAINT [PK_PublishQueue] PRIMARY KEY CLUSTERED  ([PublishQueueID] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PublishQueue] ADD CONSTRAINT [FK_PublishQueue_PublishStatus] FOREIGN KEY ([PublishStatusID]) REFERENCES [dbo].[PublishStatus] ([PublishStatusID])
GO
