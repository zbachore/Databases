CREATE TABLE [cdd].[CodeSystemTermCodes]
(
[CodeSystemTermCodeId] [bigint] NOT NULL IDENTITY(112000000000, 1),
[CreatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_CodeSystemTermCodes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_CodeSystemTermCodes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[CodeSystemTermCodes] ADD CONSTRAINT [PK__CodeSyst__8DBCA04704459E07] PRIMARY KEY CLUSTERED  ([CodeSystemTermCodeId]) ON [PRIMARY]
GO
