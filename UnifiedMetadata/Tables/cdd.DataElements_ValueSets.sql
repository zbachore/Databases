CREATE TABLE [cdd].[DataElements_ValueSets]
(
[DataElementsValueSetsID] [int] NOT NULL,
[DataElementId] [int] NOT NULL,
[ValueSetId] [int] NOT NULL,
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
