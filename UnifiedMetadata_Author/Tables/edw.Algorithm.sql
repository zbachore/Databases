CREATE TABLE [edw].[Algorithm]
(
[AlgorithmKey] [int] NOT NULL,
[AlgorithmName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlgorithmCategoryID] [int] NULL,
[AlgorithmDesc] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CalculationTypeID] [int] NULL,
[NumeratorDecimalPrecision] [smallint] NULL,
[RankOrderID] [int] NULL,
[PercentageDecimalPrecision] [smallint] NULL,
[DrilldownInd] [bit] NULL,
[SiteLevelInd] [bit] NULL,
[PhysicianLevelInd] [bit] NULL,
[CalculationLevelConceptID] [int] NULL,
[UnitOfMeasureConceptID] [int] NULL,
[AnalyticModelAlgorithmInd] [bit] NULL,
[DenominatorNAInd] [bit] NULL,
[ProductID] [int] NULL,
[Notes] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[Algorithm] ADD CONSTRAINT [PK_AlgorithmKey] PRIMARY KEY CLUSTERED  ([AlgorithmKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Algorithm_ReportAttribute] ON [edw].[Algorithm] ([AlgorithmCategoryID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Algorithm_ReportAttribute_02] ON [edw].[Algorithm] ([CalculationTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Algorithm_ReportAttribute_03] ON [edw].[Algorithm] ([RankOrderID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[Algorithm] ADD CONSTRAINT [FK_Algorithm_AlgorithmCategory] FOREIGN KEY ([AlgorithmCategoryID]) REFERENCES [edw].[ReportAttribute] ([ReportAttributeID])
GO
ALTER TABLE [edw].[Algorithm] ADD CONSTRAINT [FK_Algorithm_CalculationType] FOREIGN KEY ([CalculationTypeID]) REFERENCES [edw].[ReportAttribute] ([ReportAttributeID])
GO
ALTER TABLE [edw].[Algorithm] ADD CONSTRAINT [FK_Algorithm_RankOrderID] FOREIGN KEY ([RankOrderID]) REFERENCES [edw].[ReportAttribute] ([ReportAttributeID])
GO
