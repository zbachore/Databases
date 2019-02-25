CREATE TABLE [edw].[AnalyticModel]
(
[AnalyticModelID] [int] NOT NULL,
[AnalyticModelName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AnalyticModelShortName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AnalyticModelDesc] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegistryID] [int] NULL,
[PatientLevelWorkflowConceptID] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_AnalyticModel_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_AnalyticModel_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticModel] ADD CONSTRAINT [PK_AnalyticModel] PRIMARY KEY CLUSTERED  ([AnalyticModelID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticModel_Registries] ON [edw].[AnalyticModel] ([RegistryID]) ON [PRIMARY]
GO
