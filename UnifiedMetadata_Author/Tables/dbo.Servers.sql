CREATE TABLE [dbo].[Servers]
(
[ServerID] [int] NOT NULL IDENTITY(1, 1),
[ServerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ServerAlias] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ServerTypeID] [int] NOT NULL,
[ServerEnvironmentID] [int] NOT NULL,
[InsertedDate] [datetime2] NULL CONSTRAINT [DF_Servers_InsertedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_Servers_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Servers] ADD CONSTRAINT [PK_Servers] PRIMARY KEY CLUSTERED  ([ServerID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Servers] ADD CONSTRAINT [FK_Servers_ServerEnvironment] FOREIGN KEY ([ServerEnvironmentID]) REFERENCES [dbo].[ServerEnvironment] ([ServerEnvironmentID])
GO
ALTER TABLE [dbo].[Servers] ADD CONSTRAINT [FK_Servers_ServerType] FOREIGN KEY ([ServerTypeID]) REFERENCES [dbo].[ServerType] ([ServerTypeID])
GO
