CREATE TABLE [ld].[PhysicianAssignmentTypes]
(
[PhysicianAssignmentTypeId] [int] NOT NULL IDENTITY(1, 1),
[PhysicianAssignmentTypeParticipantId] [int] NOT NULL,
[PhysicianAssignmentTypePhysicianId] [int] NOT NULL,
[PhysicianAssignmentTypeRegistryId] [int] NOT NULL,
[PhysicianAssignmentTypeActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianAssignmentTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianAssignmentTypes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[PhysicianAssignmentTypes] ADD CONSTRAINT [PK__PhysicianAssignment] PRIMARY KEY CLUSTERED  ([PhysicianAssignmentTypeId]) ON [PRIMARY]
GO
ALTER TABLE [ld].[PhysicianAssignmentTypes] ADD CONSTRAINT [UQ_Physician] UNIQUE NONCLUSTERED  ([PhysicianAssignmentTypeParticipantId], [PhysicianAssignmentTypePhysicianId], [PhysicianAssignmentTypeRegistryId]) ON [PRIMARY]
GO
ALTER TABLE [ld].[PhysicianAssignmentTypes] ADD CONSTRAINT [FK_Physician_PhysicianAssignment] FOREIGN KEY ([PhysicianAssignmentTypePhysicianId]) REFERENCES [ld].[Physicians] ([PhysicianId])
GO
