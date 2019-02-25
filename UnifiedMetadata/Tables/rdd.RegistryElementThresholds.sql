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
ALTER TABLE [rdd].[RegistryElementThresholds] ADD CONSTRAINT [FK_RegistryElementThresholds_Composites] FOREIGN KEY ([CompositeId]) REFERENCES [ld].[Composites] ([CompositeId])
GO
ALTER TABLE [rdd].[RegistryElementThresholds] ADD CONSTRAINT [FK_RegistryElementThresholds_FormPages] FOREIGN KEY ([FormPageId]) REFERENCES [form].[FormPages] ([FormPageId])
GO
ALTER TABLE [rdd].[RegistryElementThresholds] ADD CONSTRAINT [FK_RegistryElementThresholds_FormSections] FOREIGN KEY ([FormSectionId]) REFERENCES [form].[FormSections] ([FormSectionId])
GO
ALTER TABLE [rdd].[RegistryElementThresholds] ADD CONSTRAINT [FK_RegistryElementThresholds_RegistryElements] FOREIGN KEY ([RegistryElementId]) REFERENCES [rdd].[RegistryElements] ([RegistryElementId])
GO
ALTER TABLE [rdd].[RegistryElementThresholds] ADD CONSTRAINT [FK_RegistryElementThresholds_RegistryVersions] FOREIGN KEY ([RegistryVersionId]) REFERENCES [rdd].[RegistryVersions] ([RegistryVersionId])
GO
