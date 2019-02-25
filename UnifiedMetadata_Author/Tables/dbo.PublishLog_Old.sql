CREATE TABLE [dbo].[PublishLog_Old]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[StatusID] [int] NULL,
[ServerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_PublishLog_UpdatedDate] DEFAULT (sysdatetime()),
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_PublishLog_CreatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PublishLog_Old] ADD CONSTRAINT [PK__PublishL__5E5499A84DB4832C] PRIMARY KEY CLUSTERED  ([LogID]) ON [PRIMARY]
GO
