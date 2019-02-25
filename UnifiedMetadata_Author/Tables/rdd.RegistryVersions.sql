CREATE TABLE [rdd].[RegistryVersions]
(
[RegistryVersionId] [int] NOT NULL IDENTITY(1, 1),
[RegistryId] [int] NULL,
[RegistryVersion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorSpecReleaseDate] [datetime2] NULL,
[DataCollectionAsOfDate] [datetime2] NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF_RegistryVersions_IsActive] DEFAULT ((1)),
[StartDate] [datetime2] (3) NOT NULL CONSTRAINT [DF_RegistryVersions_StartDate] DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))),
[EndDate] [datetime2] (3) NOT NULL CONSTRAINT [DF_RegistryVersions_EndDate] DEFAULT ('12/31/9999'),
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_RegistryVersions_UpdatedBy] DEFAULT ('ACCESS DB'),
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryVersions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryVersions_UpdatedDate] DEFAULT (sysdatetime()),
[ShortName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryVersions] ADD CONSTRAINT [PK_RegistryVersion] PRIMARY KEY NONCLUSTERED  ([RegistryVersionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryVersion_Registry] ON [rdd].[RegistryVersions] ([RegistryId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryVersions] ADD CONSTRAINT [FK_RegistryVersion_Registry] FOREIGN KEY ([RegistryId]) REFERENCES [rdd].[Registries] ([RegistryId]) ON UPDATE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data collection will begin as of this patient discharge date', 'SCHEMA', N'rdd', 'TABLE', N'RegistryVersions', 'COLUMN', N'DataCollectionAsOfDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Specifies the initial release date of the specification to the vendor', 'SCHEMA', N'rdd', 'TABLE', N'RegistryVersions', 'COLUMN', N'VendorSpecReleaseDate'
GO
