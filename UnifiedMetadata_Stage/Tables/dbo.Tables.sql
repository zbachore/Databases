CREATE TABLE [dbo].[Tables]
(
[TableID] [int] NOT NULL IDENTITY(1, 1),
[TableSchema] [sys].[sysname] NOT NULL,
[TableName] [sys].[sysname] NOT NULL,
[TablePrimaryKey] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectTableName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceJoin] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TargetJoin] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Source] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MergeSource] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompareColumns] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdateColumns] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InsertColumns] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tables] ADD CONSTRAINT [PK_Tables] PRIMARY KEY CLUSTERED  ([TableID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tables] ADD CONSTRAINT [UIX_Tables] UNIQUE NONCLUSTERED  ([TableSchema], [TableName]) ON [PRIMARY]
GO
