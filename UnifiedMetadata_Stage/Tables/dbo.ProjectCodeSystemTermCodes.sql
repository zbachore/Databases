CREATE TABLE [dbo].[ProjectCodeSystemTermCodes]
(
[Id] [int] NOT NULL,
[ProjectId] [int] NULL,
[ReferenceId] [bigint] NOT NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectCodeSystemTermCodes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NULL CONSTRAINT [DF_ProjectCodeSystemTermCodes_UpdatedDate] DEFAULT (sysdatetime()),
[Action] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectCodeSystemTermCodes] ADD CONSTRAINT [ProjectCodeSystemTermCodeId_PK] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
