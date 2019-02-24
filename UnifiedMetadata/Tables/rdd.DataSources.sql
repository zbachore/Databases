CREATE TABLE [rdd].[DataSources]
(
[DataSourceId] [int] NOT NULL,
[DataSourceName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataSources_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataSources_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[DataSources] ADD CONSTRAINT [PK__DataSour__28EECD6C01BE3717] PRIMARY KEY CLUSTERED  ([DataSourceId]) ON [PRIMARY]
GO
