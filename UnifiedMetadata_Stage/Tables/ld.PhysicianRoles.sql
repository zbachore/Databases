CREATE TABLE [ld].[PhysicianRoles]
(
[PhysicianRoleId] [int] NOT NULL,
[PhysicianRolePhysicianAssignmentTypeId] [int] NOT NULL,
[PhysicianRolePhysicianTypeId] [int] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianRoles_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianRoles_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[PhysicianRoles] ADD CONSTRAINT [PK__Physicia__3F3C32EE71E7C201] PRIMARY KEY CLUSTERED  ([PhysicianRoleId]) ON [PRIMARY]
GO
