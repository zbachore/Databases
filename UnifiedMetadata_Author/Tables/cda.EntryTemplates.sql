CREATE TABLE [cda].[EntryTemplates]
(
[EntryTemplateId] [int] NOT NULL IDENTITY(1, 1),
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
ALTER TABLE [cda].[EntryTemplates] ADD CONSTRAINT [FK_EntryTemplates_EntryClasses] FOREIGN KEY ([EntryClassId]) REFERENCES [cda].[EntryClasses] ([EntryClassId])
GO
ALTER TABLE [cda].[EntryTemplates] ADD CONSTRAINT [FK_EntryTemplates_ProfileVersions] FOREIGN KEY ([ProfileVersionId]) REFERENCES [cda].[ProfileVersions] ([ProfileVersionId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains all the entry templates defined in a specific version of a Implementation Guide. ', 'SCHEMA', N'cda', 'TABLE', N'EntryTemplates', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column contains the extension to a template OID (Unique Identifier). Extensions are generally used to refer to the version of a template or release date. This is how it is represented within a CDA. <templateId extension="2014-06-09" root="2.16.840.1.113883.10.20.22.4.4"/>', 'SCHEMA', N'cda', 'TABLE', N'EntryTemplates', 'COLUMN', N'EntryTemplateIdExtension_1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column contains the extension to the secondary template OID (Unique Identifier). Extensions are generally used to refer to the version of a template or release date. ', 'SCHEMA', N'cda', 'TABLE', N'EntryTemplates', 'COLUMN', N'EntryTemplateIdExtension_2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column contains the OID (Unique Identifier) for a template. This is how it is represented within a CDA. <templateId root="1.3.6.1.4.1.19376.1.4.1.7.4.44000"/> ', 'SCHEMA', N'cda', 'TABLE', N'EntryTemplates', 'COLUMN', N'EntryTemplateIdRoot_1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column contains the secondary OID, when present it is used to refer to the parent template from which this entry template was derived. This is how it is represented within a CDA. <templateId root="1.3.6.1.4.1.19376.1.4.1.7.4.44000"/>  <templateId extension="2014-06-09" root="2.16.840.1.113883.10.20.22.4.4"/>', 'SCHEMA', N'cda', 'TABLE', N'EntryTemplates', 'COLUMN', N'EntryTemplateIdRoot_2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column contains the CDA document type identifier extension value. This is represented in CDA as follows: Example: <typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>', 'SCHEMA', N'cda', 'TABLE', N'EntryTemplates', 'COLUMN', N'EntryTemplateTypeIdExtension'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column contains the CDA document type identifier value. This is represented in CDA as follows: Example: <typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>', 'SCHEMA', N'cda', 'TABLE', N'EntryTemplates', 'COLUMN', N'EntryTemplateTypeIdRoot'
GO
