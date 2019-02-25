CREATE TABLE [dbo].[ServerType]
(
[ServerTypeID] [int] NOT NULL IDENTITY(1, 1),
[ServerType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InsertedDate] [datetime2] NULL CONSTRAINT [DF_ServerType_InsertedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ServerType_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServerType] ADD CONSTRAINT [PK_ServerType] PRIMARY KEY CLUSTERED  ([ServerTypeID]) ON [PRIMARY]
GO
