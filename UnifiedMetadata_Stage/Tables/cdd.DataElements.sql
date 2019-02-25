CREATE TABLE [cdd].[DataElements]
(
[DataElementId] [int] NOT NULL,
[ConceptId] [int] NOT NULL,
[DataTypeId] [int] NOT NULL,
[DataElementSeq] [int] NOT NULL,
[TemporalContextId] [int] NULL,
[DataElementExternalRefId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataElementName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataElementShortName] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsMultiSelect] [bit] NOT NULL,
[UnitOfMeasureValueSetId] [int] NULL,
[UnitOfMeasureId] [int] NULL,
[IsActive] [bit] NOT NULL,
[StartDate] [datetime2] NOT NULL,
[EndDate] [datetime2] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_DataElements_UpdatedDate] DEFAULT (sysdatetime()),
[DataElementLabel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkflowConceptId] [int] NULL,
[ValueInstance] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferencedElementId] [int] NULL,
[ScopeId] [int] NULL
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
