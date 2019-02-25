CREATE TABLE [edw].[ReportAlternateCategoryDetail]
(
[ReportAlternateCategoryDetailID] [int] NOT NULL IDENTITY(1, 1),
[AlternateCategoryKey] [int] NULL,
[ReportDetailKey] [int] NULL,
[ReportKey] [int] NULL,
[ShortCategoryLabel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LongCategoryLabel] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[ReportAlternateCategoryDetail] ADD CONSTRAINT [PK_ReportAlternateCategoryDetail] PRIMARY KEY CLUSTERED  ([ReportAlternateCategoryDetailID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ReportAlternateCategoryDetail_AlternateCategoryKey] ON [edw].[ReportAlternateCategoryDetail] ([AlternateCategoryKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ReportAlternateCategoryDetail_ReportDetailKey] ON [edw].[ReportAlternateCategoryDetail] ([ReportDetailKey]) ON [PRIMARY]
GO
ALTER TABLE [edw].[ReportAlternateCategoryDetail] ADD CONSTRAINT [FK_ReportAlternateCategoryDetail_AlternateCategoryKey] FOREIGN KEY ([AlternateCategoryKey]) REFERENCES [edw].[ReportAlternateCategory] ([AlternateCategoryKey])
GO
ALTER TABLE [edw].[ReportAlternateCategoryDetail] ADD CONSTRAINT [FK_ReportAlternateCategoryDetail_ReportDetailKey] FOREIGN KEY ([ReportDetailKey]) REFERENCES [edw].[ReportDetail] ([ReportDetailKey])
GO
