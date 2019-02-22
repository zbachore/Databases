CREATE TABLE [ld].[PhysicianRegistries]
(
[PhysicianRegistryId] [int] NOT NULL,
[PhysicianId] [int] NULL,
[RegistryId] [int] NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianRegistries_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianRegistries_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[PhysicianRegistries] ADD CONSTRAINT [PK__Physicia__99AFC15479EE7551] PRIMARY KEY CLUSTERED  ([PhysicianRegistryId]) ON [PRIMARY]
GO
