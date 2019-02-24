CREATE TABLE [cdd].[CodeSystemTerms]
(
[CodeSystemTermId] [int] NOT NULL,
[CodeSystemId] [int] NULL,
[CodeSystemTermCode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CodeSystemTermName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CodeSystemTermDefinition] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CodeSystemTermAdditionalNote] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_CodeSystemTerms_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_CodeSystemTerms_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[CodeSystemTerms] ADD CONSTRAINT [PK_CodeSystemTerm] PRIMARY KEY NONCLUSTERED  ([CodeSystemTermId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_CodeSystemTerm_CodeSystem] ON [cdd].[CodeSystemTerms] ([CodeSystemId]) ON [PRIMARY]
GO
