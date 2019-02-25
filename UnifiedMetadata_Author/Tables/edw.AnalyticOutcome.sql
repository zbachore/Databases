CREATE TABLE [edw].[AnalyticOutcome]
(
[AnalyticOutcomeID] [int] NOT NULL,
[AnalyticModelVersionID] [int] NULL,
[AnalyticOutcomeName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AnalyticOutcomeDesc] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsNumerator] [bit] NULL,
[IsDenominator] [bit] NULL,
[IsRate] [bit] NULL,
[IsRiskAdjustedRate] [bit] NULL,
[IsObservedEvent] [bit] NULL,
[IsExpectedOutcome] [bit] NULL,
[IsOERatio] [bit] NULL,
[IsStandardizedRate] [bit] NULL,
[IsStandardizedRatio] [bit] NULL,
[IsUpperCI] [bit] NULL,
[IsLowerCI] [bit] NULL,
[IsDenominatorExclusionCount] [bit] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticOutcome] ADD CONSTRAINT [PK_AnalyticOutcome] PRIMARY KEY CLUSTERED  ([AnalyticOutcomeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticOutcome_AnalyticModelVersion] ON [edw].[AnalyticOutcome] ([AnalyticModelVersionID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticOutcome] ADD CONSTRAINT [FK_AnalyticOutcome_AnalyticModelVersion] FOREIGN KEY ([AnalyticModelVersionID]) REFERENCES [edw].[AnalyticModelVersion] ([AnalyticModelVersionID])
GO
