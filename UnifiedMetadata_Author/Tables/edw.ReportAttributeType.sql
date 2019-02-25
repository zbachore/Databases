CREATE TABLE [edw].[ReportAttributeType]
(
[ReportAttributeTypeID] [int] NOT NULL IDENTITY(1, 1),
[ReportAttributeTypeName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL,
[UpdatedDate] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [edw].[ReportAttributeType] ADD CONSTRAINT [PK_ReportAttributeType] PRIMARY KEY CLUSTERED  ([ReportAttributeTypeID]) ON [PRIMARY]
GO
