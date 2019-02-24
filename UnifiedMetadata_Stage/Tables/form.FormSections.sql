CREATE TABLE [form].[FormSections]
(
[FormSectionId] [int] NOT NULL,
[FormPageId] [int] NOT NULL,
[ParentFormSectionId] [int] NULL,
[FormSectionTypeId] [int] NOT NULL,
[DynamicFormElementId] [int] NULL,
[FormSectionTitle] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FormSectionShortName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FormSectionDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UiProperties] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormSections_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormSections_UpdatedDate] DEFAULT (sysdatetime()),
[DisplayOrder] [int] NOT NULL,
[IdentityFormElementId] [int] NULL,
[FormSectionHelpText] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [form].[FormSections] ADD CONSTRAINT [PK_FormSections] PRIMARY KEY CLUSTERED  ([FormSectionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormSections_FormElements] ON [form].[FormSections] ([DynamicFormElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormSections_Pages] ON [form].[FormSections] ([FormPageId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormSections_FormSectionTypes] ON [form].[FormSections] ([FormSectionTypeId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormSections_FormSections] ON [form].[FormSections] ([ParentFormSectionId]) ON [PRIMARY]
GO
