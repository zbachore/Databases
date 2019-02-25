CREATE TABLE [edw].[AlgorithmVersion]
(
[AlgorithmVersionID] [int] NOT NULL IDENTITY(1, 1),
[AlgorithmKey] [int] NOT NULL,
[AlgorithmVersion] [int] NOT NULL,
[StartTimeframeKey] [int] NULL,
[EndTimeframeKey] [int] NULL,
[NumeratorFilter] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DenominatorFilter] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumeratorSQL] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DenominatorSQL] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataSourceWorkflowConceptID] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[AlgorithmVersion] ADD CONSTRAINT [PK_AlgorithmVersion] PRIMARY KEY CLUSTERED  ([AlgorithmVersionID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AlgorithmVersion_Algorithm] ON [edw].[AlgorithmVersion] ([AlgorithmKey]) ON [PRIMARY]
GO
ALTER TABLE [edw].[AlgorithmVersion] ADD CONSTRAINT [UX_AlgorithmVersion] UNIQUE NONCLUSTERED  ([AlgorithmKey], [AlgorithmVersion]) ON [PRIMARY]
GO
ALTER TABLE [edw].[AlgorithmVersion] ADD CONSTRAINT [FK_AlgorithmVersion_Algorithm] FOREIGN KEY ([AlgorithmKey]) REFERENCES [edw].[Algorithm] ([AlgorithmKey])
GO
