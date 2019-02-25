CREATE TABLE [dbo].[ReportVersionTypes]
(
[ReportVersionTypeId] [int] NOT NULL IDENTITY(1, 1),
[ReportVersionTypeName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ReportVersionType_CreatedDate] DEFAULT (getdate()),
[UpdatedBy] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedDate] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportVersionTypes] ADD CONSTRAINT [PK_ReportType] PRIMARY KEY CLUSTERED  ([ReportVersionTypeId]) ON [PRIMARY]
GO
