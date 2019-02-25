CREATE TABLE [edw].[ReportAlternateCategory]
(
[AlternateCategoryKey] [int] NOT NULL IDENTITY(1, 1),
[AlternateCategoryTypeID] [int] NULL,
[AlternateCategoryCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternateCategorySubTypeID] [int] NULL,
[AlternateCategoryTitle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlternateCategoryDesc] [varchar] (7500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XAxisLabel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[YAxisLabel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductID] [int] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[ReportAlternateCategory] ADD CONSTRAINT [PK_ReportAlternateCategory] PRIMARY KEY CLUSTERED  ([AlternateCategoryKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ReportAlternateCategory_AlternateCategorySubTypeID] ON [edw].[ReportAlternateCategory] ([AlternateCategorySubTypeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ReportAlternateCategory_AlternateCategoryTypeID] ON [edw].[ReportAlternateCategory] ([AlternateCategoryTypeID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[ReportAlternateCategory] ADD CONSTRAINT [UX_ReportAlternateCategory] UNIQUE NONCLUSTERED  ([ProductID], [AlternateCategoryCode]) ON [PRIMARY]
GO
ALTER TABLE [edw].[ReportAlternateCategory] ADD CONSTRAINT [FK_ReportAlternateCategory_AlternateCategorySubType] FOREIGN KEY ([AlternateCategorySubTypeID]) REFERENCES [edw].[ReportAttribute] ([ReportAttributeID])
GO
