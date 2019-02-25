CREATE TABLE [cdd].[DataElements_ValueSets]
(
[DataElementId] [int] NOT NULL,
[ValueSetId] [int] NOT NULL,
[DataElementsValueSetsID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElements_ValueSets_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElements_ValueSets_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElements_ValueSets] ADD CONSTRAINT [PK_DataElement_ValueSet] PRIMARY KEY CLUSTERED  ([DataElementsValueSetsID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_DataElement_ValueSet_DataElement] ON [cdd].[DataElements_ValueSets] ([DataElementId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElements_ValueSets] ADD CONSTRAINT [U_DataElements_ValueSets] UNIQUE NONCLUSTERED  ([DataElementId], [ValueSetId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_DataElementValueSet_ValueSet] ON [cdd].[DataElements_ValueSets] ([ValueSetId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElements_ValueSets] ADD CONSTRAINT [FK_DataElement_ValueSet_DataElement] FOREIGN KEY ([DataElementId]) REFERENCES [cdd].[DataElements] ([DataElementId])
GO
ALTER TABLE [cdd].[DataElements_ValueSets] ADD CONSTRAINT [FK_DataElementValueSet_ValueSet] FOREIGN KEY ([ValueSetId]) REFERENCES [cdd].[ValueSets] ([ValueSetId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains the value list(s) associated with a data element. The value list provides the list of permissible value (aka choice) for a data element. There might be multiple value list associated with any data element, this is done primarily to support different scenarios or may be to support a new version of the definition while keeping the historical one for reference.', 'SCHEMA', N'cdd', 'TABLE', N'DataElements_ValueSets', NULL, NULL
GO
