CREATE TABLE [rdd].[RegistrySectionTypes]
(
[RegistrySectionTypeId] [int] NOT NULL IDENTITY(1, 1),
[RegistrySectionTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegistrySectionTypeDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistrySectionTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistrySectionTypes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistrySectionTypes] ADD CONSTRAINT [PK_RegistrySectionType] PRIMARY KEY CLUSTERED  ([RegistrySectionTypeId]) ON [PRIMARY]
GO
