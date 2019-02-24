CREATE TABLE [ld].[PhysicianRoles]
(
[PhysicianRoleId] [int] NOT NULL IDENTITY(1, 1),
[PhysicianRolePhysicianTypeId] [int] NOT NULL,
[PhysicianRolePhysicianAssignmentTypeId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_PhysicianRoles_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_PhysicianRoles_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[PhysicianRoles] ADD CONSTRAINT [PK__PhysicianRoles] PRIMARY KEY CLUSTERED  ([PhysicianRoleId]) ON [PRIMARY]
GO
ALTER TABLE [ld].[PhysicianRoles] ADD CONSTRAINT [FK__PhysicianRole_PhysicianType] FOREIGN KEY ([PhysicianRolePhysicianTypeId]) REFERENCES [ld].[PhysicianTypes] ([PhysicianTypeId])
GO
ALTER TABLE [ld].[PhysicianRoles] ADD CONSTRAINT [FK__PhysicianRoleAssignmentType] FOREIGN KEY ([PhysicianRolePhysicianAssignmentTypeId]) REFERENCES [ld].[PhysicianAssignmentTypes] ([PhysicianAssignmentTypeId])
GO
