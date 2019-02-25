CREATE TABLE [dbo].[PublishStatus]
(
[PublishStatusID] [int] NOT NULL,
[PublishStatusCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PublishStatus_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PublishStatus_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PublishStatus] ADD CONSTRAINT [PK_PublishStatus] PRIMARY KEY CLUSTERED  ([PublishStatusID]) ON [PRIMARY]
GO
