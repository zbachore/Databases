CREATE TABLE [form].[FormSections_20180622_0126PM]
(
[FormSectionId] [int] NOT NULL IDENTITY(1, 1),
[FormPageId] [int] NOT NULL,
[ParentFormSectionId] [int] NULL,
[FormSectionTypeId] [int] NOT NULL,
[DynamicFormElementId] [int] NULL,
[FormSectionTitle] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FormSectionShortName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FormSectionDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UiProperties] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL,
[UpdatedDate] [datetime2] NOT NULL,
[DisplayOrder] [int] NOT NULL,
[IdentityFormElementId] [int] NULL,
[FormSectionHelpText] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
