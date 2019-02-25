CREATE TABLE [cda].[EntryTemplates]
(
[EntryTemplateId] [int] NOT NULL,
[ProfileVersionId] [int] NOT NULL,
[EntryTemplateName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EntryClassId] [int] NOT NULL,
[EntryTemplateIdRoot_1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryTemplateIdExtension_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryTemplateIdRoot_2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryTemplateIdExtension_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryTemplateTypeIdRoot] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryTemplateTypeIdExtension] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntryTemplates_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntryTemplates_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cda].[EntryTemplates] ADD CONSTRAINT [PK_EntryTemplates] PRIMARY KEY NONCLUSTERED  ([EntryTemplateId]) ON [PRIMARY]
GO
ALTER TABLE [cda].[EntryTemplates] ADD CONSTRAINT [UK_EntryTemplates] UNIQUE NONCLUSTERED  ([EntryTemplateName], [ProfileVersionId]) ON [PRIMARY]
GO
