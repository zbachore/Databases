CREATE TABLE [cda].[ProfileVersions]
(
[ProfileVersionId] [int] NOT NULL,
[ProfileId] [int] NOT NULL,
[ProfileVersionName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProfileVersionDescription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPublished] [bit] NULL,
[CDATemplateDefinitionXML] [xml] NULL,
[IsActive] [bit] NOT NULL,
[StartDate] [datetime2] NOT NULL,
[EndDate] [datetime2] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProfileVersions_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ProfileVersions_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [cda].[ProfileVersions] ADD CONSTRAINT [PK_ProfileVersions] PRIMARY KEY CLUSTERED  ([ProfileVersionId]) ON [PRIMARY]
GO
ALTER TABLE [cda].[ProfileVersions] ADD CONSTRAINT [FK_ProfileVersions_Profiles] FOREIGN KEY ([ProfileId]) REFERENCES [cda].[Profiles] ([ProfileId])
GO
