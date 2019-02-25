CREATE TABLE [edw].[ReportDetail]
(
[ReportDetailKey] [int] NOT NULL IDENTITY(1, 1),
[MetricKey] [int] NULL,
[LineText] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineDescription] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DetailLineNum] [int] NULL,
[ReportSectionID] [int] NULL,
[ReportMajorCategoryID] [int] NULL,
[ReportMinorCategoryID] [int] NULL,
[ReportMajorCategorySortOrder] [int] NULL,
[ReportMinorCategorySortOrder] [int] NULL,
[DetailLineNumSortOrder] [int] NULL,
[BoldInd] [bit] NULL,
[GrayInd] [bit] NULL,
[IndentNum] [int] NULL,
[DetailLineNumRef] [int] NULL,
[ReportKey] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[ReportDetail] ADD CONSTRAINT [PK_ReportDetail] PRIMARY KEY CLUSTERED  ([ReportDetailKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ReportDetail_Report] ON [edw].[ReportDetail] ([ReportKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ReportDetail_ReportMajorCategory] ON [edw].[ReportDetail] ([ReportMajorCategoryID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ReportDetail_ReportMinorCategory] ON [edw].[ReportDetail] ([ReportMinorCategoryID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ReportDetail_ReportSectionID] ON [edw].[ReportDetail] ([ReportSectionID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[ReportDetail] ADD CONSTRAINT [FK_ReportDetail_Report] FOREIGN KEY ([ReportKey]) REFERENCES [edw].[Report] ([ReportKey])
GO
ALTER TABLE [edw].[ReportDetail] ADD CONSTRAINT [FK_ReportDetail_ReportMajorCategory] FOREIGN KEY ([ReportMajorCategoryID]) REFERENCES [edw].[ReportAttribute] ([ReportAttributeID])
GO
ALTER TABLE [edw].[ReportDetail] ADD CONSTRAINT [FK_ReportDetail_ReportMinorCategory] FOREIGN KEY ([ReportMinorCategoryID]) REFERENCES [edw].[ReportAttribute] ([ReportAttributeID])
GO
ALTER TABLE [edw].[ReportDetail] ADD CONSTRAINT [FK_ReportDetail_ReportSection] FOREIGN KEY ([ReportSectionID]) REFERENCES [edw].[ReportAttribute] ([ReportAttributeID])
GO
