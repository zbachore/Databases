CREATE TABLE [rdd].[RegistrySectionCardinalities]
(
[RegistrySectionCardinalityId] [int] NOT NULL IDENTITY(1, 1),
[RegistrySectionCardinalityName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegistrySectionCardinalityDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistrySectionCardinalities_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_RegistrySectionCardinalities_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [rdd].[RegistrySectionCardinalities] ADD CONSTRAINT [PK_RegistrySectionCardinality] PRIMARY KEY CLUSTERED  ([RegistrySectionCardinalityId]) ON [PRIMARY]
GO
