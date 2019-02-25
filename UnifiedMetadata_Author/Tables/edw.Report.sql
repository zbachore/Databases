CREATE TABLE [edw].[Report]
(
[ReportKey] [int] NOT NULL,
[ProductID] [int] NULL,
[ReportTypeID] [int] NULL,
[ReportName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportRevision] [int] NULL,
[ReportRevisionTimestamp] [datetime2] NULL,
[StartTimeframeKey] [int] NULL,
[EndTimeframeKey] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[Report] ADD CONSTRAINT [PK_Report] PRIMARY KEY CLUSTERED  ([ReportKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Report_ReportAttribute] ON [edw].[Report] ([ReportTypeID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[Report] ADD CONSTRAINT [FK_Report_ReportType] FOREIGN KEY ([ReportTypeID]) REFERENCES [edw].[ReportAttribute] ([ReportAttributeID])
GO
