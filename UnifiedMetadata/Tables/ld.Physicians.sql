CREATE TABLE [ld].[Physicians]
(
[PhysicianId] [int] NOT NULL IDENTITY(1, 1),
[PhysicianFirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhysicianMiddleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhysicianLastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhysicianNpi] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Physicians_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_Physicians_UpdatedDate] DEFAULT (sysdatetime()),
[PhysicianSuffix] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [ld].[Physicians] ADD CONSTRAINT [PK_Physicians] PRIMARY KEY CLUSTERED  ([PhysicianId]) ON [PRIMARY]
GO
