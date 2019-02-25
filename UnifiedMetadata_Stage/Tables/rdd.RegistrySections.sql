CREATE TABLE [rdd].[RegistrySections]
(
[RegistrySectionId] [int] NOT NULL,
[RegistrySectionName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentRegistrySectionId] [int] NULL,
[DisplayOrder] [int] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistrySections_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistrySections_UpdatedDate] DEFAULT (sysdatetime()),
[RegistrySectionContainerClassId] [int] NULL,
[RegistryVersionId] [int] NOT NULL,
[RegistrySectionCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegistrySectionCardinalityMin] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegistrySectionCodeInstruction] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegistrySectionCardinalityMax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistrySections] ADD CONSTRAINT [PK_RegistrySection] PRIMARY KEY CLUSTERED  ([RegistrySectionId]) ON [PRIMARY]
GO
