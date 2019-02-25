CREATE TABLE [rdd].[RegistryElements_ConstraintDefinitions]
(
[RegistryElementId] [int] NOT NULL,
[ConstraintDefinitionId] [int] NOT NULL,
[RegistryElementsConstraintDefinitionsID] [int] NOT NULL IDENTITY(1, 1),
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
ALTER TABLE [rdd].[RegistryElements_ConstraintDefinitions] ADD CONSTRAINT [FK_RegistryElements_ConstraintDefinitions_ConstraintDefinitions] FOREIGN KEY ([ConstraintDefinitionId]) REFERENCES [dd].[ConstraintDefinitions] ([ConstraintDefinitionId])
GO
ALTER TABLE [rdd].[RegistryElements_ConstraintDefinitions] ADD CONSTRAINT [FK_RegistryElements_ConstraintDefinitions_RegistryElements] FOREIGN KEY ([RegistryElementId]) REFERENCES [rdd].[RegistryElements] ([RegistryElementId])
GO
