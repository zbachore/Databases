CREATE TABLE [cdd].[DataElements]
(
[DataElementId] [int] NOT NULL IDENTITY(1, 1),
[ConceptId] [int] NOT NULL,
[DataTypeId] [int] NOT NULL,
[DataElementSeq] [int] NOT NULL,
[TemporalContextId] [int] NULL,
[DataElementExternalRefId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataElementName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataElementShortName] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsMultiSelect] [bit] NOT NULL CONSTRAINT [DF_DataElements_IsMultiSelect] DEFAULT ((0)),
[UnitOfMeasureValueSetId] [int] NULL,
[UnitOfMeasureId] [int] NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF_DataElements_IsActive] DEFAULT ((1)),
[StartDate] [datetime2] NOT NULL,
[EndDate] [datetime2] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElements_UpdatedDate] DEFAULT (sysdatetime()),
[DataElementLabel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkflowConceptId] [int] NULL,
[ValueInstance] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferencedElementId] [int] NULL,
[ScopeId] [int] NULL,
[PHIIdentifier] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElements] ADD CONSTRAINT [PK_DataElements] PRIMARY KEY NONCLUSTERED  ([DataElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CONCEPTDATA_ELEMENT] ON [cdd].[DataElements] ([ConceptId]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [DATA_ELEMENT_UK] ON [cdd].[DataElements] ([ConceptId], [DataElementId], [DataElementSeq]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DATA_TYPE_ID] ON [cdd].[DataElements] ([DataTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DATA_TYPEDATA_ELEMENT] ON [cdd].[DataElements] ([DataTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TEMPORAL_CONTEXT_ID] ON [cdd].[DataElements] ([TemporalContextId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_DataElements_UnitsOfMeasure] ON [cdd].[DataElements] ([UnitOfMeasureId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_DataElements_ValueSets] ON [cdd].[DataElements] ([UnitOfMeasureValueSetId]) ON [PRIMARY]
GO
ALTER TABLE [cdd].[DataElements] ADD CONSTRAINT [FK_DataElements_Concepts] FOREIGN KEY ([ConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
ALTER TABLE [cdd].[DataElements] ADD CONSTRAINT [FK_DataElements_Concepts2] FOREIGN KEY ([WorkflowConceptId]) REFERENCES [cdd].[Concepts] ([ConceptId])
GO
ALTER TABLE [cdd].[DataElements] ADD CONSTRAINT [FK_DataElements_TemporalContexts] FOREIGN KEY ([TemporalContextId]) REFERENCES [cdd].[TemporalContexts] ([TemporalContextId])
GO
ALTER TABLE [cdd].[DataElements] ADD CONSTRAINT [FK_DataElements_UnitsOfMeasure] FOREIGN KEY ([UnitOfMeasureId]) REFERENCES [cdd].[UnitsOfMeasure] ([UnitOfMeasureId])
GO
ALTER TABLE [cdd].[DataElements] ADD CONSTRAINT [FK_DataElements_ValueSets] FOREIGN KEY ([UnitOfMeasureValueSetId]) REFERENCES [cdd].[ValueSets] ([ValueSetId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains the data elements to be collected for a Clinical Concept of interest. The table provides detail information about the data element such as data type, scale, precision, Unit of Measure besides the name, identifier, description, temporal context etc. ', 'SCHEMA', N'cdd', 'TABLE', N'DataElements', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'External reference ID used for publication purpose. For current implementation it would have the field value as DataElementSeq column which is a numeric value.', 'SCHEMA', N'cdd', 'TABLE', N'DataElements', 'COLUMN', N'DataElementExternalRefId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Element Short Name, provides a unique text reference to the element (used internally by DCT and export)', 'SCHEMA', N'cdd', 'TABLE', N'DataElements', 'COLUMN', N'DataElementShortName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If data type is a value list, does elemet allow multiple selection', 'SCHEMA', N'cdd', 'TABLE', N'DataElements', 'COLUMN', N'IsMultiSelect'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If UOM is a constant value then assign a member from UOM Value List as a constant value. If this column is left empty then UOM is considered a picklist and may contain any value from the UOM value list.', 'SCHEMA', N'cdd', 'TABLE', N'DataElements', 'COLUMN', N'UnitOfMeasureId'
GO
