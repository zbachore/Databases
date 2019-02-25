CREATE TABLE [edw].[Population]
(
[PopulationKey] [int] NOT NULL,
[PopulationDesc] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilterCriteria] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataSourceWorkflowConceptID] [int] NULL,
[AnalyticModelPopulationInd] [bit] NULL,
[ProductID] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[Population] ADD CONSTRAINT [PK_Population] PRIMARY KEY CLUSTERED  ([PopulationKey]) ON [PRIMARY]
GO
