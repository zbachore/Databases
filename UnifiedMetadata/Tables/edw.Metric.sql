CREATE TABLE [edw].[Metric]
(
[MetricKey] [int] NOT NULL,
[AlgorithmKey] [int] NULL,
[PopulationKey] [int] NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Metric_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Metric_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [edw].[Metric] ADD CONSTRAINT [PK_MetricMey] PRIMARY KEY CLUSTERED  ([MetricKey]) ON [PRIMARY]
GO
