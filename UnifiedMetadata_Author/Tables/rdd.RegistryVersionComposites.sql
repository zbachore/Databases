CREATE TABLE [rdd].[RegistryVersionComposites]
(
[RegistryVersionCompositeId] [int] NOT NULL IDENTITY(1, 1),
[CompositeId] [int] NOT NULL,
[RegistryVersionId] [int] NOT NULL,
[Threshold] [int] NOT NULL,
[StartDate] [datetime2] NULL,
[EndDate] [datetime2] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryVersionComposites_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryVersionComposites_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryVersionComposites] ADD CONSTRAINT [PK_RegistryVersionComposites] PRIMARY KEY CLUSTERED  ([RegistryVersionCompositeId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryVersionComposites] ADD CONSTRAINT [FK_RegistryVersionComposites_Composites] FOREIGN KEY ([CompositeId]) REFERENCES [ld].[Composites] ([CompositeId])
GO
ALTER TABLE [rdd].[RegistryVersionComposites] ADD CONSTRAINT [FK_RegistryVersionComposites_RegistryVersions] FOREIGN KEY ([RegistryVersionId]) REFERENCES [rdd].[RegistryVersions] ([RegistryVersionId])
GO
