CREATE TABLE [dbo].[ProjectUsers]
(
[ProjectUserId] [int] NOT NULL,
[RoleId] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectUsers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProjectUsers_UpdatedDate] DEFAULT (sysdatetime()),
[ProjectId] [int] NULL,
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectUsers] ADD CONSTRAINT [PK__ProjectU__4F7A4900B13BAA6D] PRIMARY KEY CLUSTERED  ([ProjectUserId]) ON [PRIMARY]
GO
