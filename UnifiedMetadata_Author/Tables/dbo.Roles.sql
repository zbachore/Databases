CREATE TABLE [dbo].[Roles]
(
[RoleId] [int] NOT NULL IDENTITY(1, 1),
[RoleName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RoleDescription] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Roles] ADD CONSTRAINT [PK__Roles__8AFACE1A1FCDBCEB] PRIMARY KEY CLUSTERED  ([RoleId]) ON [PRIMARY]
GO
