CREATE TABLE [dbo].[AuditLogs]
(
[AuditLogId] [int] NOT NULL IDENTITY(1, 1),
[ChangeType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceTable] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceId] [int] NOT NULL,
[UserName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Date] [datetime] NOT NULL CONSTRAINT [DF_AuditLogs_Date] DEFAULT (getdate()),
[Object] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Details] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_AuditLogs_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_AuditLogs_UpdatedDate] DEFAULT (sysdatetime()),
[ProjectId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditLogs] ADD CONSTRAINT [PK__AuditLog__EB5F6CBD5C02A283] PRIMARY KEY CLUSTERED  ([AuditLogId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AuditLogs_SourceID_SourceTable_ChangeType] ON [dbo].[AuditLogs] ([SourceId], [SourceTable], [ChangeType]) INCLUDE ([Date]) ON [PRIMARY]
GO
