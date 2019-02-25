CREATE TABLE [rdd].[RegistryElements_ConstraintDefinitions]
(
[RegistryElementsConstraintDefinitionsID] [int] NOT NULL,
[RegistryElementId] [int] NOT NULL,
[ConstraintDefinitionId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElements_ConstraintDefinitions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryElements_ConstraintDefinitions_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryElements_ConstraintDefinitions] ADD CONSTRAINT [PK_RegistryElements_ConstraintDefinitions] PRIMARY KEY CLUSTERED  ([RegistryElementsConstraintDefinitionsID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryElements_ConstraintDefinitions_ConstraintDefinitions] ON [rdd].[RegistryElements_ConstraintDefinitions] ([ConstraintDefinitionId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryElements_ConstraintDefinitions] ADD CONSTRAINT [U_RegistryElements_ConstraintDefinitions] UNIQUE NONCLUSTERED  ([ConstraintDefinitionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryElements_ConstraintDefinitions_RegistryElements] ON [rdd].[RegistryElements_ConstraintDefinitions] ([RegistryElementId]) ON [PRIMARY]
GO
