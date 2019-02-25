CREATE TABLE [edw].[AnalyticModelVersionPopulation]
(
[AnalyticModelVersionPopulationID] [int] NOT NULL,
[AnalyticModelVersionID] [int] NULL,
[PopulationKey] [int] NULL,
[AnalyticPopulationName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_AnalyticModelVersionPopulation_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_AnalyticModelVersionPopulation_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticModelVersionPopulation] ADD CONSTRAINT [PK_AnalyticModelVersionPopulation] PRIMARY KEY CLUSTERED  ([AnalyticModelVersionPopulationID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticModelVersionPopulation_AnalyticModelVersion] ON [edw].[AnalyticModelVersionPopulation] ([AnalyticModelVersionID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticModelVersionPopulation] ADD CONSTRAINT [UX_AnalyticModelVersionPopulation] UNIQUE NONCLUSTERED  ([AnalyticModelVersionID], [PopulationKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticModelVersionPopulation_Population] ON [edw].[AnalyticModelVersionPopulation] ([PopulationKey]) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticModelVersionPopulation] ADD CONSTRAINT [FK_AnalyticModelVersionPopulation_AnalyticModelVersion] FOREIGN KEY ([AnalyticModelVersionID]) REFERENCES [edw].[AnalyticModelVersion] ([AnalyticModelVersionID])
GO
ALTER TABLE [edw].[AnalyticModelVersionPopulation] ADD CONSTRAINT [FK_AnalyticModelVersionPopulation_Population] FOREIGN KEY ([PopulationKey]) REFERENCES [edw].[Population] ([PopulationKey])
GO
