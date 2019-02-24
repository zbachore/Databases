CREATE TABLE [dbo].[ProjectStatus]
(
[ProjectStatusId] [int] NOT NULL,
[CreatedBy] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectStatus_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectStatus_UpdatedDate] DEFAULT (sysdatetime()),
[ProjectStatusDesc] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectStatusCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectStatus] ADD CONSTRAINT [PK__ProjectS__F3B67D4D5C18C418] PRIMARY KEY CLUSTERED  ([ProjectStatusId]) ON [PRIMARY]
GO
