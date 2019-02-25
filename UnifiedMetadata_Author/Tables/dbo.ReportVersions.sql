CREATE TABLE [dbo].[ReportVersions]
(
[ReportVersionId] [int] NOT NULL IDENTITY(1, 1),
[ReportVersionTypeId] [int] NOT NULL,
[RegistryVersionId] [int] NOT NULL,
[Version] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExcelReport] [varbinary] (max) NULL,
[PdfReport] [varbinary] (max) NULL,
[XmlReport] [varbinary] (max) NULL,
[TextReport] [varbinary] (max) NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ReportVersion_CreatedDate] DEFAULT (getdate()),
[UpdatedBy] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedDate] [datetime2] NOT NULL,
[ObjectId] [int] NULL,
[BinaryFormatValue] [varbinary] (max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportVersions] ADD CONSTRAINT [PK_ReportVersions] PRIMARY KEY CLUSTERED  ([ReportVersionId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportVersions] ADD CONSTRAINT [FK_ReportVersions_RegistryVersionId] FOREIGN KEY ([RegistryVersionId]) REFERENCES [rdd].[RegistryVersions] ([RegistryVersionId])
GO
ALTER TABLE [dbo].[ReportVersions] ADD CONSTRAINT [FK_ReportVersions_ReportTypeId] FOREIGN KEY ([ReportVersionTypeId]) REFERENCES [dbo].[ReportVersionTypes] ([ReportVersionTypeId])
GO
