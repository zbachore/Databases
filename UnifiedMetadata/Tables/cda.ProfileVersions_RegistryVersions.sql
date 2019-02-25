CREATE TABLE [cda].[ProfileVersions_RegistryVersions]
(
[ProfileVersionsRegistryVersionsID] [int] NOT NULL,
[ProfileVersionId] [int] NOT NULL,
[RegistryVersionId] [int] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProfileVersions_RegistryVersions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProfileVersions_RegistryVersions_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cda].[ProfileVersions_RegistryVersions] ADD CONSTRAINT [PK_ProfileVersions_RegistryVersions] PRIMARY KEY CLUSTERED  ([ProfileVersionsRegistryVersionsID]) ON [PRIMARY]
GO
ALTER TABLE [cda].[ProfileVersions_RegistryVersions] ADD CONSTRAINT [U_ProfileVersions_RegistryVersions] UNIQUE NONCLUSTERED  ([ProfileVersionId], [RegistryVersionId]) ON [PRIMARY]
GO
ALTER TABLE [cda].[ProfileVersions_RegistryVersions] ADD CONSTRAINT [FK_ProfileVersions_RegistryVersions_ProfileVersions] FOREIGN KEY ([ProfileVersionId]) REFERENCES [cda].[ProfileVersions] ([ProfileVersionId])
GO
ALTER TABLE [cda].[ProfileVersions_RegistryVersions] ADD CONSTRAINT [FK_ProfileVersions_RegistryVersions_RegistryVersions] FOREIGN KEY ([RegistryVersionId]) REFERENCES [rdd].[RegistryVersions] ([RegistryVersionId])
GO
