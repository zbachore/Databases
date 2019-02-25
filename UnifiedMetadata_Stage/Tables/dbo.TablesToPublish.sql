CREATE TABLE [dbo].[TablesToPublish]
(
[TablesToPublishID] [int] NOT NULL IDENTITY(1, 1),
[SchemaName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PublishProcedureName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_TablesToPublish_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_TablesToPublish_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TablesToPublish] ADD CONSTRAINT [PK_TablesToPublish] PRIMARY KEY CLUSTERED  ([TablesToPublishID]) ON [PRIMARY]
GO
