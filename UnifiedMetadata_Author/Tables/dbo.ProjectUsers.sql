CREATE TABLE [dbo].[ProjectUsers]
(
[ProjectUserId] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[UpdatedDate] [datetime] NULL,
[ProjectId] [int] NULL,
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectUsers] ADD CONSTRAINT [PK__ProjectU__4F7A49001BFD2C07] PRIMARY KEY CLUSTERED  ([ProjectUserId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectUsers] ADD CONSTRAINT [FK__ProjectUs__RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([RoleId])
GO
ALTER TABLE [dbo].[ProjectUsers] ADD CONSTRAINT [FK__ProjectUsers__ProjectId] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([ProjectId])
GO
