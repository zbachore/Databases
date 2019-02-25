CREATE TABLE [rdd].[RegistryElementThresholds_ConstraintDefinitions]
(
[RegistryElementThresholdsConstraintDefinitionID] [int] NOT NULL IDENTITY(1, 1),
[RegistryElementThresholdId] [int] NOT NULL,
[ConstraintDefinitionId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElementThresholds_ConstraintDefinitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElementThresholds_ConstraintDefinitions_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryElementThresholds_ConstraintDefinitions] ADD CONSTRAINT [PK_RegistryElementThresholds_ConstraintDefinitions] PRIMARY KEY CLUSTERED  ([RegistryElementThresholdsConstraintDefinitionID]) ON [PRIMARY]
GO
