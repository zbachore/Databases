CREATE TABLE [edw].[EDWDefaultMappings]
(
[EDWDefaultMappingId] [int] NOT NULL IDENTITY(1, 1),
[EntityName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataTypeId] [int] NOT NULL,
[EDWColumnNameMap] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDWTimePartMap] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EDWDefaultMappings_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EDWDefaultMappings_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [edw].[EDWDefaultMappings] ADD CONSTRAINT [PK_EDWDefaultMappings] PRIMARY KEY CLUSTERED  ([EDWDefaultMappingId]) ON [PRIMARY]
GO
ALTER TABLE [edw].[EDWDefaultMappings] ADD CONSTRAINT [FK_EDWDefaultMappings_DataTypeId] FOREIGN KEY ([DataTypeId]) REFERENCES [cdd].[DataTypes] ([DataTypeId])
GO
