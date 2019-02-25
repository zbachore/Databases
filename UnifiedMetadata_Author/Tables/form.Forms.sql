CREATE TABLE [form].[Forms]
(
[FormId] [int] NOT NULL IDENTITY(1, 1),
[RegistryVersionId] [int] NOT NULL,
[FormTypeId] [int] NOT NULL,
[FormName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FormDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Forms_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_Forms_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [form].[Forms] ADD CONSTRAINT [PK_Forms] PRIMARY KEY CLUSTERED  ([FormId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Forms_RegistryFormTypes] ON [form].[Forms] ([FormTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_Forms_RegistryVersions] ON [form].[Forms] ([RegistryVersionId]) ON [PRIMARY]
GO
