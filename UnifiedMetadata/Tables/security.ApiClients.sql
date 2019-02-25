CREATE TABLE [security].[ApiClients]
(
[ApiClientId] [int] NOT NULL IDENTITY(1, 1),
[ClientId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[Secret] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AllowedScopes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AllowedGrantTypes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ApiClient_CreateDate] DEFAULT (getdate()),
[CreatedBy] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ApiClient_UpdateDate] DEFAULT (getdate()),
[UpdatedBy] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [security].[ApiClients] ADD CONSTRAINT [PK_ApiClients_Id] PRIMARY KEY CLUSTERED  ([ApiClientId]) ON [PRIMARY]
GO
ALTER TABLE [security].[ApiClients] ADD CONSTRAINT [UQ_ApiClients_ClientId] UNIQUE NONCLUSTERED  ([ClientId]) ON [PRIMARY]
GO
