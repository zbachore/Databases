CREATE TABLE [rdd].[RegistryVersionConfigurations]
(
[RegistryVersionConfigurationId] [int] NOT NULL,
[RegistryVersionConfigurationName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegistryVersionConfigurationValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegistryVersionId] [int] NOT NULL,
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryVersionConfigurations_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryVersionConfigurations_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryVersionConfigurations] ADD CONSTRAINT [PK_RegistryVersionConfigurations] PRIMARY KEY CLUSTERED  ([RegistryVersionConfigurationId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryVersionConfigurations] ADD CONSTRAINT [FK_RegistryVersionConfigurations_RegistryVersions] FOREIGN KEY ([RegistryVersionId]) REFERENCES [rdd].[RegistryVersions] ([RegistryVersionId])
GO
