CREATE TABLE [rdd].[RegistryDataSets_RegistryElements]
(
[RegistryElementId] [int] NOT NULL,
[RegistryDataSetId] [int] NOT NULL,
[RegistryDataSetsRegistryElementsID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryDataSets_RegistryElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryDataSets_RegistryElements_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryDataSets_RegistryElements] ADD CONSTRAINT [PK_RegistryDataSets_RegistryElements] PRIMARY KEY CLUSTERED  ([RegistryDataSetsRegistryElementsID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryDataSet_RegistryElements_RegistryDataSet] ON [rdd].[RegistryDataSets_RegistryElements] ([RegistryDataSetId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryDataSets_RegistryElements] ADD CONSTRAINT [U_RegistryDataSets_RegistryElements] UNIQUE NONCLUSTERED  ([RegistryDataSetId], [RegistryElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryDataSets_RegistryElements_RegistryElements] ON [rdd].[RegistryDataSets_RegistryElements] ([RegistryElementId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryDataSets_RegistryElements] ADD CONSTRAINT [FK_RegistryDataSet_RegistryElements_RegistryDataSet] FOREIGN KEY ([RegistryDataSetId]) REFERENCES [rdd].[RegistryDataSets] ([RegistryDataSetId])
GO
ALTER TABLE [rdd].[RegistryDataSets_RegistryElements] ADD CONSTRAINT [FK_RegistryDataSets_RegistryElements_RegistryElements] FOREIGN KEY ([RegistryElementId]) REFERENCES [rdd].[RegistryElements] ([RegistryElementId])
GO
