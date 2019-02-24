CREATE TABLE [rdd].[RegistryVersions]
(
[RegistryVersionId] [int] NOT NULL,
[RegistryId] [int] NULL,
[RegistryVersion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorSpecReleaseDate] [datetime2] NULL,
[DataCollectionAsOfDate] [datetime2] NULL,
[IsActive] [bit] NOT NULL,
[StartDate] [datetime2] NOT NULL,
[EndDate] [datetime2] (3) NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] (3) NOT NULL CONSTRAINT [DF_RegistryVersions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryVersions_UpdatedDate] DEFAULT (sysdatetime()),
[ShortName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryVersions] ADD CONSTRAINT [PK_RegistryVersion] PRIMARY KEY NONCLUSTERED  ([RegistryVersionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryVersion_Registry] ON [rdd].[RegistryVersions] ([RegistryId]) ON [PRIMARY]
GO
