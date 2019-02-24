CREATE TABLE [dbo].[TableList]
(
[TableListID] [int] NOT NULL IDENTITY(1, 1),
[TableSchema] [sys].[sysname] NOT NULL,
[TableName] [sys].[sysname] NOT NULL,
[TablePrimaryKey] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProjectTableName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceJoin] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TargetJoin] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BeginTran] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TableList__Begin__0FE2393C] DEFAULT ('DECLARE @ErrorMessage varchar(max),
	@RequestedTime DATETIME2 = SYSDATETIME(); BEGIN TRY BEGIN TRAN;'),
[Source] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MergeSource] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Deletes] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TableList__Delet__10D65D75] DEFAULT ('PlaceHolder'),
[CompareColumns] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdateColumns] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InsertColumns] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Audit] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TableList_Audit] DEFAULT ('PlaceHolder'),
[CatchBlock] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_TableList_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_TableList_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TableList] ADD CONSTRAINT [PK_TableList] PRIMARY KEY CLUSTERED  ([TableListID]) ON [PRIMARY]
GO
