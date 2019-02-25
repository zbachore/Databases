CREATE TABLE [form].[FormSectionTypes]
(
[FormSectionTypeId] [int] NOT NULL IDENTITY(1, 1),
[FormSectionTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FormSectionTypeShortName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FormSectionTypeDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsRepeatable] [bit] NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormSectionTypes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormSectionTypes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [form].[FormSectionTypes] ADD CONSTRAINT [PK_FormSectionTypes] PRIMARY KEY CLUSTERED  ([FormSectionTypeId]) ON [PRIMARY]
GO
