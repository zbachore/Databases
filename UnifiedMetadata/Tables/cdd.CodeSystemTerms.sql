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
ALTER TABLE [cdd].[CodeSystemTerms] ADD CONSTRAINT [FK_CodeSystemTerm_CodeSystem] FOREIGN KEY ([CodeSystemId]) REFERENCES [cdd].[CodeSystems] ([CodeSystemId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains all the terminology codes used across various systems within consolidated data dictionary(CDD). The terminology codes generally comes from standard vocabularies such as SNOMED, LOINC, RxNorm etc. For clinical definitions that are not available in standard vocabularies, ACC might create its own definition providing an ACC code to reference that definition.', 'SCHEMA', N'cdd', 'TABLE', N'CodeSystemTerms', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code from the coding system used to identify a terminology concept', 'SCHEMA', N'cdd', 'TABLE', N'CodeSystemTerms', 'COLUMN', N'CodeSystemTermCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Preferred name for the terminology code', 'SCHEMA', N'cdd', 'TABLE', N'CodeSystemTerms', 'COLUMN', N'CodeSystemTermName'
GO
