CREATE TABLE [rdd].[Registries]
(
[RegistryId] [int] NOT NULL,
[ProductId] [int] NULL,
[RegistryShortName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegistryFullName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegistryLogo] [varbinary] (max) NULL,
[IsActive] [bit] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Registries_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Registries_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [rdd].[Registries] ADD CONSTRAINT [PK_Registry] PRIMARY KEY CLUSTERED  ([RegistryId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'References [NCommon].[tblProduct].[UidProduct]', 'SCHEMA', N'rdd', 'TABLE', N'Registries', 'COLUMN', N'ProductId'
GO
