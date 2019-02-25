CREATE TABLE [edw].[ExportDataSets]
(
[ExportDataSetId] [int] NOT NULL,
[ExportDataSetShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExportDataSetName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExportDataSetDescription] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ExportDataSets_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ExportDataSets_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [edw].[ExportDataSets] ADD CONSTRAINT [PK_ExportDataSets] PRIMARY KEY CLUSTERED  ([ExportDataSetId]) ON [PRIMARY]
GO
