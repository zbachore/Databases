CREATE TABLE [ld].[PhysicianType]
(
[PhysicianTypeID] [int] NOT NULL,
[PhysicianTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianType_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_PhysicianType_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[PhysicianType] ADD CONSTRAINT [PK_PhysicianType] PRIMARY KEY CLUSTERED  ([PhysicianTypeID]) ON [PRIMARY]
GO
