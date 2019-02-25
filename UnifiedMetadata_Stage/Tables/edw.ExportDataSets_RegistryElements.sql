CREATE TABLE [edw].[ExportDataSets_RegistryElements]
(
[ExportDataSetsRegistryElementsID] [int] NOT NULL,
[ExportDataSetId] [int] NOT NULL,
[RegistryElementId] [int] NOT NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ExportDataSets_RegistryElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ExportDataSets_RegistryElements_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [edw].[ExportDataSets_RegistryElements] ADD CONSTRAINT [PK_ExportDataSets_RegistryElements] PRIMARY KEY CLUSTERED  ([ExportDataSetsRegistryElementsID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[ExportDataSets_RegistryElements] ADD CONSTRAINT [U_ExportDataSets_RegistryElements] UNIQUE NONCLUSTERED  ([ExportDataSetId], [RegistryElementId]) ON [PRIMARY]
GO
