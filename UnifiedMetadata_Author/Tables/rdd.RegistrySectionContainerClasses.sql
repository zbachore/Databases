CREATE TABLE [rdd].[RegistrySectionContainerClasses]
(
[RegistrySectionContainerClassId] [int] NOT NULL IDENTITY(1, 1),
[RegistrySectionContainerClassName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegistrySectionContainerClassDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistrySectionContainerClasses_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistrySectionContainerClasses_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistrySectionContainerClasses] ADD CONSTRAINT [PK_RegistrySectionContainerClass] PRIMARY KEY CLUSTERED  ([RegistrySectionContainerClassId]) ON [PRIMARY]
GO
