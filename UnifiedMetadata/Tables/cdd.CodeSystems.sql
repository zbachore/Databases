CREATE TABLE [cdd].[CodeSystems]
(
[CodeSystemId] [int] NOT NULL,
[CodeSystemName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CodeSystemOID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CodeSystemDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_CodeSystems_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_CodeSystems_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[CodeSystems] ADD CONSTRAINT [CodeSystem_PK] PRIMARY KEY NONCLUSTERED  ([CodeSystemId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains the list of Code Systems (SNOMED, LOINC etc.) used to define the terminology codes used in consolidated data dictionary.', 'SCHEMA', N'cdd', 'TABLE', N'CodeSystems', NULL, NULL
GO
