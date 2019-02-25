CREATE TABLE [edw].[ReportAttribute]
(
[ReportAttributeID] [int] NOT NULL IDENTITY(1, 1),
[ReportAttributeTypeID] [int] NULL,
[ReportAttributeName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportAttributeScope] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[ReportAttribute] ADD CONSTRAINT [PK_ReportAttribute] PRIMARY KEY CLUSTERED  ([ReportAttributeID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ReportAttribute_ReportAttributeType] ON [edw].[ReportAttribute] ([ReportAttributeTypeID]) ON [PRIMARY]
GO
ALTER TABLE [edw].[ReportAttribute] ADD CONSTRAINT [FK_ReportAttribute_ReportAttributeType] FOREIGN KEY ([ReportAttributeTypeID]) REFERENCES [edw].[ReportAttributeType] ([ReportAttributeTypeID])
GO
