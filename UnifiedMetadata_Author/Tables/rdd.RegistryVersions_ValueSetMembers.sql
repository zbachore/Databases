CREATE TABLE [rdd].[RegistryVersions_ValueSetMembers]
(
[ValueSetMemberId] [int] NOT NULL,
[RegistryVersionId] [int] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryVersions_ValueSetMembers_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistryVersions_ValueSetMembers_UpdatedDate] DEFAULT (sysdatetime()),
[RegistryVersionValueSetMemberId] [int] NOT NULL IDENTITY(1, 1),
[Label] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConceptDefinitionId] [int] NULL,
[DisplayOrder] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryVersions_ValueSetMembers] ADD CONSTRAINT [PK_RegistryVersions_ValueSetMembers] PRIMARY KEY CLUSTERED  ([RegistryVersionValueSetMemberId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryVersions_ValueSetMembers_RegistryVersions] ON [rdd].[RegistryVersions_ValueSetMembers] ([RegistryVersionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_RegistryVersions_ValueSetMembers_ValueSetMembers] ON [rdd].[RegistryVersions_ValueSetMembers] ([ValueSetMemberId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistryVersions_ValueSetMembers] ADD CONSTRAINT [FK_RegistryVersions_ValueSetMembers_RegistryVersions] FOREIGN KEY ([RegistryVersionId]) REFERENCES [rdd].[RegistryVersions] ([RegistryVersionId])
GO
ALTER TABLE [rdd].[RegistryVersions_ValueSetMembers] ADD CONSTRAINT [FK_RegistryVersions_ValueSetMembers_ValueSetMembers] FOREIGN KEY ([ValueSetMemberId]) REFERENCES [cdd].[ValueSetMembers] ([ValueSetMemberId])
GO
