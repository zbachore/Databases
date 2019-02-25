CREATE TABLE [dbo].[AllTables]
(
[TableSchema] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TablePrimaryKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProjectTableName] [nvarchar] (135) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceJoin] [nvarchar] (144) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TargetJoin] [nvarchar] (261) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPublished] [bit] NULL,
[Notes] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
