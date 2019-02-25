CREATE TABLE [edw].[Metric]
(
[MetricKey] [int] NOT NULL IDENTITY(1, 1),
[AlgorithmKey] [int] NULL,
[PopulationKey] [int] NULL,
[MetricName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[Metric] ADD CONSTRAINT [PK_Metric] PRIMARY KEY CLUSTERED  ([MetricKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Metric_Algorithm] ON [edw].[Metric] ([AlgorithmKey]) ON [PRIMARY]
GO
ALTER TABLE [edw].[Metric] ADD CONSTRAINT [UX_Metric] UNIQUE NONCLUSTERED  ([AlgorithmKey], [PopulationKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Metric_Population] ON [edw].[Metric] ([PopulationKey]) ON [PRIMARY]
GO
