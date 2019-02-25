CREATE TABLE [dbo].[ServerEnvironment]
(
[ServerEnvironmentID] [int] NOT NULL IDENTITY(1, 1),
[ServerEnvironment] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InsertedDate] [datetime2] NULL CONSTRAINT [DF_ServerEnvironment_InsertedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ServerEnvironment_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServerEnvironment] ADD CONSTRAINT [PK_ServerEnvironment] PRIMARY KEY CLUSTERED  ([ServerEnvironmentID]) ON [PRIMARY]
GO
