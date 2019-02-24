CREATE TABLE [rdd].[RegistryOperatorRole]
(
[RegistryOperatorRoleID] [int] NOT NULL,
[RegistryID] [int] NOT NULL,
[OperatorRoleConceptID] [int] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryOperatorRole_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryOperatorRole_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryOperatorRole] ADD CONSTRAINT [PK_RegistryOperatorRole] PRIMARY KEY CLUSTERED  ([RegistryOperatorRoleID]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryOperatorRole] ADD CONSTRAINT [UX_RegistryOperatorRole] UNIQUE NONCLUSTERED  ([RegistryID], [OperatorRoleConceptID]) ON [PRIMARY]
GO
