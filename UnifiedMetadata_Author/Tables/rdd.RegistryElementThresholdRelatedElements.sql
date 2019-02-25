CREATE TABLE [rdd].[RegistryElementThresholdRelatedElements]
(
[RegistryElementThresholdRelatedElementId] [int] NOT NULL IDENTITY(1, 1),
[RegistryElementThresholdId] [int] NOT NULL,
[RegistryElementId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElementThresholdRelatedElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElementThresholdRelatedElements_UpdatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryElementThresholdRelatedElements] ADD CONSTRAINT [PK_RegistryElementThresholdRelatedElements] PRIMARY KEY CLUSTERED  ([RegistryElementThresholdRelatedElementId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryElementThresholdRelatedElements] ADD CONSTRAINT [FK_RegistryElementThresholdRelatedElements_RegistryElements] FOREIGN KEY ([RegistryElementId]) REFERENCES [rdd].[RegistryElements] ([RegistryElementId])
GO
ALTER TABLE [rdd].[RegistryElementThresholdRelatedElements] ADD CONSTRAINT [FK_RegistryElementThresholdRelatedElements_RegistryElementThresholds] FOREIGN KEY ([RegistryElementThresholdId]) REFERENCES [rdd].[RegistryElementThresholds] ([RegistryElementThresholdId])
GO
