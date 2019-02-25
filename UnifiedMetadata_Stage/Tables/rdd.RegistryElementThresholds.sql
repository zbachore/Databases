CREATE TABLE [rdd].[RegistryElementThresholds]
(
[RegistryElementThresholdId] [int] NOT NULL,
[RegistryElementId] [int] NOT NULL,
[Threshold] [int] NOT NULL,
[CompositeId] [int] NOT NULL,
[StartDate] [datetime2] NOT NULL,
[EndDate] [datetime2] NULL,
[RegistryVersionId] [int] NOT NULL,
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElementThresholds_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElementThresholds_UpdatedDate] DEFAULT (sysdatetime()),
[FormSectionId] [int] NULL,
[FormPageId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryElementThresholds] ADD CONSTRAINT [PK_RegistryElementThresholds] PRIMARY KEY CLUSTERED  ([RegistryElementThresholdId]) ON [PRIMARY]
GO
