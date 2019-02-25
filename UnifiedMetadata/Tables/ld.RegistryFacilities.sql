CREATE TABLE [ld].[RegistryFacilities]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[RegistryId] [int] NOT NULL,
[ParticipantId] [int] NOT NULL,
[FacilityId] [int] NOT NULL,
[Active] [bit] NULL CONSTRAINT [RF_Active] DEFAULT ((1)),
[CreatedById] [int] NULL,
[CreatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Registries_Facilities_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedById] [int] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Registries_Facilities_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [ld].[RegistryFacilities] ADD CONSTRAINT [PK__Registry__3214EC07236D9A8D] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [ld].[RegistryFacilities] ADD CONSTRAINT [FK_Registries_Facilities_Facilities] FOREIGN KEY ([FacilityId]) REFERENCES [ld].[Facilities] ([FacilityId])
GO
