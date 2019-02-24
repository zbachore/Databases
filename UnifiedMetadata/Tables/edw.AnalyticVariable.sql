CREATE TABLE [edw].[AnalyticVariable]
(
[AnalyticVariableID] [int] NOT NULL,
[AnalyticModelVersionID] [int] NULL,
[AnalyticVariableName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AnalyticVariableShortName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AnalyticVariableDesc] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsComputedVariable] [bit] NULL,
[DataTypeID] [int] NULL,
[DataElementID] [int] NULL,
[IsDPIField] [bit] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_AnalyticVariable_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_AnalyticVariable_UpdatedDate] DEFAULT (sysdatetime()),
[ValueSetID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticVariable] ADD CONSTRAINT [PK_AnalyticVariable] PRIMARY KEY CLUSTERED  ([AnalyticVariableID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticVariable_AnalyticModelVersion] ON [edw].[AnalyticVariable] ([AnalyticModelVersionID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticVariable_DataElements] ON [edw].[AnalyticVariable] ([DataElementID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticVariable_ValueSets] ON [edw].[AnalyticVariable] ([ValueSetID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticVariable] ADD CONSTRAINT [FK_AnalyticVariable_AnalyticModelVersion] FOREIGN KEY ([AnalyticModelVersionID]) REFERENCES [edw].[AnalyticModelVersion] ([AnalyticModelVersionID])
GO
ALTER TABLE [edw].[AnalyticVariable] ADD CONSTRAINT [FK_AnalyticVariable_ValueSets] FOREIGN KEY ([ValueSetID]) REFERENCES [cdd].[ValueSets] ([ValueSetId])
GO
