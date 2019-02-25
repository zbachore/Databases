CREATE TABLE [edw].[AnalyticModelVersion]
(
[AnalyticModelVersionID] [int] NOT NULL,
[AnalyticModelID] [int] NOT NULL,
[VersionNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VersionNote] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTimeframe] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndTimeframe] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DACClientID] [int] NULL,
[SiteLevelFileName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientLevelFileName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InformationFileName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ControlFileName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_AnalyticModelVersion_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_AnalyticModelVersion_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticModelVersion] ADD CONSTRAINT [PK_AnalyticModelVersion] PRIMARY KEY CLUSTERED  ([AnalyticModelVersionID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticModelVersion_AnalyticModel] ON [edw].[AnalyticModelVersion] ([AnalyticModelID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticModelVersion_DAC] ON [edw].[AnalyticModelVersion] ([DACClientID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[AnalyticModelVersion] ADD CONSTRAINT [FK_AnalyticModelVersion_AnalyticModel] FOREIGN KEY ([AnalyticModelID]) REFERENCES [edw].[AnalyticModel] ([AnalyticModelID])
GO
