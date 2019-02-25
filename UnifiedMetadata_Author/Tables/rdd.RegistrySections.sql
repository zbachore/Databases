CREATE TABLE [rdd].[RegistrySections]
(
[RegistrySectionId] [int] NOT NULL IDENTITY(1, 1),
[RegistrySectionName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentRegistrySectionId] [int] NULL,
[DisplayOrder] [int] NULL CONSTRAINT [RegistrySections_DisplayOrder] DEFAULT ((0)),
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistrySections_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistrySections_UpdatedDate] DEFAULT (sysdatetime()),
[RegistrySectionContainerClassId] [int] NULL,
[RegistryVersionId] [int] NOT NULL,
[RegistrySectionCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegistrySectionCardinalityMin] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegistrySectionCodeInstruction] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegistrySectionCardinalityMax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isClinical] [bit] NOT NULL CONSTRAINT [DF__RegistryS__isCli__31233176] DEFAULT ((1)),
[ClinicalParentSectionId] [int] NULL,
[ClinicalDisplayOrder] [int] NOT NULL CONSTRAINT [DF__RegistryS__Clini__321755AF] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistrySections] ADD CONSTRAINT [PK_RegistrySection] PRIMARY KEY CLUSTERED  ([RegistrySectionId]) ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistrySections] ADD CONSTRAINT [FK_RegistryVersion_RegistrySection] FOREIGN KEY ([RegistryVersionId]) REFERENCES [rdd].[RegistryVersions] ([RegistryVersionId])
GO
