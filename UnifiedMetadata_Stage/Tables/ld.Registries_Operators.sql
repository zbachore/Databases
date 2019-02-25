CREATE TABLE [ld].[Registries_Operators]
(
[RegistriesOperatorsID] [int] NOT NULL,
[RegistryId] [int] NOT NULL,
[OperatorId] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Registries_Operators_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Registries_Operators_UpdatedDate] DEFAULT (sysdatetime())
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
