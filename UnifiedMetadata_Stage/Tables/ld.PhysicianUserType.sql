CREATE TABLE [ld].[PhysicianUserType]
(
[uidPhysician] [int] NOT NULL,
[uidClient] [int] NULL,
[uidPhysicianType] [int] NULL,
[uidPhysicianSubType ] [int] NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianUserType_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianUserType_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[PhysicianUserType] ADD CONSTRAINT [PK_PhysicianUserType] PRIMARY KEY CLUSTERED  ([uidPhysician]) ON [PRIMARY]
GO
