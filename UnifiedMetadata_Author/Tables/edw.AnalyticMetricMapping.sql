CREATE TABLE [edw].[AnalyticMetricMapping]
(
[AnalyticMetricMappingID] [int] NOT NULL,
[AnalyticOutcomeID] [int] NULL,
[MetricKey] [int] NOT NULL,
[NumeratorEntityColumnID] [int] NULL,
[DenominatorEntityColumnID] [int] NULL,
[PercentageEntityColumnID] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticMetricMapping] ADD CONSTRAINT [PK_AnalyticMetricMapping] PRIMARY KEY CLUSTERED  ([AnalyticMetricMappingID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticMetricMapping_AnalyticOutcome] ON [edw].[AnalyticMetricMapping] ([AnalyticOutcomeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticMetricMapping_EntityColumns_02] ON [edw].[AnalyticMetricMapping] ([DenominatorEntityColumnID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticMetricMapping_Metric] ON [edw].[AnalyticMetricMapping] ([MetricKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticMetricMapping_EntityColumns] ON [edw].[AnalyticMetricMapping] ([NumeratorEntityColumnID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticMetricMapping_EntityColumns_03] ON [edw].[AnalyticMetricMapping] ([PercentageEntityColumnID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticMetricMapping] ADD CONSTRAINT [FK_AnalyticMetricMapping_AnalyticOutcome] FOREIGN KEY ([AnalyticOutcomeID]) REFERENCES [edw].[AnalyticOutcome] ([AnalyticOutcomeID])
GO
