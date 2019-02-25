CREATE TABLE [form].[FormElements]
(
[FormElementId] [int] NOT NULL,
[RegistryElementId] [int] NULL,
[FormSectionId] [int] NOT NULL,
[DynamicFormElementId] [int] NULL,
[DynamicFormElementProperty] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UiProperties] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormElements_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormElements_UpdatedDate] DEFAULT (sysdatetime()),
[FormElementHelpText] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsHidden] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [form].[FormElements] ADD CONSTRAINT [PK_FormElements] PRIMARY KEY CLUSTERED  ([FormElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormElements_FormElements] ON [form].[FormElements] ([DynamicFormElementId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormElements_FormSections] ON [form].[FormElements] ([FormSectionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormElements_RegistryElements] ON [form].[FormElements] ([RegistryElementId]) ON [PRIMARY]
GO
