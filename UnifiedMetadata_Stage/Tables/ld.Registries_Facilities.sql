CREATE TABLE [ld].[Registries_Facilities]
(
[RegistryFacilitiesID] [int] NOT NULL,
[RegistryId] [int] NOT NULL,
[CreatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Registries_Facilities_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Registries_Facilities_UpdatedDate] DEFAULT (sysdatetime()),
[CreatedById] [int] NOT NULL,
[UpdatedById] [int] NOT NULL,
[Active] [bit] NULL CONSTRAINT [RF_Active] DEFAULT ((1)),
[ParticipantId] [int] NOT NULL,
[FacilityId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ld].[Registries_Facilities] ADD CONSTRAINT [PK_Registries_Facilities] PRIMARY KEY CLUSTERED  ([RegistryFacilitiesID]) ON [PRIMARY]
GO
