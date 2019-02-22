CREATE TABLE [form].[FormPages]
(
[FormPageId] [int] NOT NULL,
[FormId] [int] NOT NULL,
[ParentFormPageId] [int] NULL,
[FormPageLocationId] [int] NOT NULL,
[FormPageTitle] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FormPageShortName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FormPageDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsRepeatable] [bit] NOT NULL,
[DisplayOrder] [int] NOT NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormPages_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_FormPages_UpdatedDate] DEFAULT (sysdatetime()),
[IdentityFormElementId] [int] NULL,
[UiProperties] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [form].[FormPages] ADD CONSTRAINT [PK_FormPages] PRIMARY KEY CLUSTERED  ([FormPageId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormPages_Forms] ON [form].[FormPages] ([FormId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormPages_FormPageLocations] ON [form].[FormPages] ([FormPageLocationId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_FormPages_FormPages] ON [form].[FormPages] ([ParentFormPageId]) ON [PRIMARY]
GO
