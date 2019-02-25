CREATE TABLE [dbo].[ProjectStatus]
(
[ProjectStatusId] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectStatusDesc] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectStatusCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectStatus_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectStatus_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectStatus] ADD CONSTRAINT [PK__ProjectS__F3B67D4D164452B1] PRIMARY KEY CLUSTERED  ([ProjectStatusId]) ON [PRIMARY]
GO
