CREATE TABLE [ld].[PhysicianTypes]
(
[PhysicianTypeId] [int] NOT NULL,
[PhysicianTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhysicianTypeIsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianTypes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[PhysicianTypes] ADD CONSTRAINT [PK_PhysicianTypes] PRIMARY KEY CLUSTERED  ([PhysicianTypeId]) ON [PRIMARY]
GO
