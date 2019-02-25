CREATE TABLE [rdd].[RegistryElementThresholdRelatedElements]
(
[RegistryElementThresholdRelatedElementId] [int] NOT NULL,
[RegistryElementThresholdId] [int] NOT NULL,
[RegistryElementId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElementThresholdRelatedElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElementThresholdRelatedElements_UpdatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryElementThresholdRelatedElements] ADD CONSTRAINT [PK_RegistryElementThresholdRelatedElements] PRIMARY KEY CLUSTERED  ([RegistryElementThresholdRelatedElementId]) ON [PRIMARY]
GO
