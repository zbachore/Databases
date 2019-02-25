CREATE TABLE [ld].[Registries_Operators]
(
[RegistryId] [int] NOT NULL,
[OperatorId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Registries_Operators_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Registries_Operators_UpdatedDate] DEFAULT (sysdatetime()),
[RegistriesOperatorsID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [ld].[Registries_Operators] ADD CONSTRAINT [PK_Registries_Operators] PRIMARY KEY CLUSTERED  ([RegistriesOperatorsID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Registries_Operators_Operators] ON [ld].[Registries_Operators] ([OperatorId]) ON [PRIMARY]
GO
ALTER TABLE [ld].[Registries_Operators] ADD CONSTRAINT [U_Registries_Operators] UNIQUE NONCLUSTERED  ([OperatorId], [RegistryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Registries_Operators_Registries] ON [ld].[Registries_Operators] ([RegistryId]) ON [PRIMARY]
GO
ALTER TABLE [ld].[Registries_Operators] ADD CONSTRAINT [FK_Registries_Operators_Operators] FOREIGN KEY ([OperatorId]) REFERENCES [ld].[Operators] ([OperatorId])
GO
ALTER TABLE [ld].[Registries_Operators] ADD CONSTRAINT [FK_Registries_Operators_Registries] FOREIGN KEY ([RegistryId]) REFERENCES [rdd].[Registries] ([RegistryId])
GO
