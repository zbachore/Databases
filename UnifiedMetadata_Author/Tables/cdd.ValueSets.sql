CREATE TABLE [cdd].[ValueSets]
(
[ValueSetId] [int] NOT NULL IDENTITY(1, 1),
[ValueSetName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ValueSetOid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDynamicList] [bit] NOT NULL,
[IsPermissibleValueList] [bit] NOT NULL,
[IsActive] [bit] NOT NULL,
[StartDate] [datetime2] NOT NULL,
[EndDate] [datetime2] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSets_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ValueSets_UpdatedDate] DEFAULT (sysdatetime()),
[CodeSystemId] [int] NULL,
[Synonyms] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValueSetDiscriminator] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSets] ADD CONSTRAINT [PK_ValueSet] PRIMARY KEY NONCLUSTERED  ([ValueSetId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[ValueSets] ADD CONSTRAINT [FK__ValueSets__CodeS__3631FF56] FOREIGN KEY ([CodeSystemId]) REFERENCES [cdd].[CodeSystems] ([CodeSystemId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains a list of all the value sets defined as part of the consolidated data dictionary. The value list can either be associated with a data element for defining the permissible values for that element or can be used to define the list of data elements being collected (e.g. Problem Statement, Medication etc.)', 'SCHEMA', N'cdd', 'TABLE', N'ValueSets', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Is this value list a dynamic list', 'SCHEMA', N'cdd', 'TABLE', N'ValueSets', 'COLUMN', N'IsDynamicList'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Can this be used a selection list for a data element', 'SCHEMA', N'cdd', 'TABLE', N'ValueSets', 'COLUMN', N'IsPermissibleValueList'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OID based on implementation guide', 'SCHEMA', N'cdd', 'TABLE', N'ValueSets', 'COLUMN', N'ValueSetOid'
GO
