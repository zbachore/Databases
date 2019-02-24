CREATE TABLE [cda].[EntryTemplateProfileIds]
(
[EntryTemplateProfileIdId] [int] NOT NULL,
[ProfileIdId] [int] NOT NULL,
[EntryTemplateId] [int] NOT NULL,
[EntryTemplateProfileIdOrder] [int] NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntryTemplateProfileIds_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntryTemplateProfileIds_UpdatedDate] DEFAULT (sysdatetime()),
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [cda].[EntryTemplateProfileIds] ADD CONSTRAINT [PK__EntryTem__D9B37DCC6E414E4F] PRIMARY KEY CLUSTERED  ([EntryTemplateProfileIdId]) ON [PRIMARY]
GO
ALTER TABLE [cda].[EntryTemplateProfileIds] ADD CONSTRAINT [UC_EntryTemplateOrder] UNIQUE NONCLUSTERED  ([EntryTemplateId], [EntryTemplateProfileIdOrder]) ON [PRIMARY]
GO
ALTER TABLE [cda].[EntryTemplateProfileIds] ADD CONSTRAINT [FK__EntryTemp__Entry__7211DF33] FOREIGN KEY ([EntryTemplateId]) REFERENCES [cda].[EntryTemplates] ([EntryTemplateId])
GO
ALTER TABLE [cda].[EntryTemplateProfileIds] ADD CONSTRAINT [FK__EntryTemp__Profi__711DBAFA] FOREIGN KEY ([ProfileIdId]) REFERENCES [cda].[ProfileIds] ([ProfileIdId])
GO
