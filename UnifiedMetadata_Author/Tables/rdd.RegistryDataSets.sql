CREATE TABLE [rdd].[RegistryDataSets]
(
[RegistryDataSetId] [int] NOT NULL IDENTITY(1, 1),
[RegistryVersionId] [int] NULL,
[RegistryDataSetName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NULL CONSTRAINT [DF_RegistryDataSets_IsActive] DEFAULT ((1)),
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryDataSets_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryDataSets_UpdatedDate] DEFAULT (sysdatetime()),
[Abbreviation] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegistryDataSetDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryDataSets] ADD CONSTRAINT [PK_RegistryDataSet] PRIMARY KEY CLUSTERED  ([RegistryDataSetId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryDataSet_RegistryVersion] ON [rdd].[RegistryDataSets] ([RegistryVersionId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryDataSets] ADD CONSTRAINT [UQ_RegistryVersion_Abbreviation] UNIQUE NONCLUSTERED  ([RegistryVersionId], [Abbreviation]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryDataSets] ADD CONSTRAINT [FK_RegistryDataSet_RegistryVersion] FOREIGN KEY ([RegistryVersionId]) REFERENCES [rdd].[RegistryVersions] ([RegistryVersionId])
GO
