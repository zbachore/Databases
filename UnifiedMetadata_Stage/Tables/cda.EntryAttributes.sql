CREATE TABLE [cda].[EntryAttributes]
(
[EntryAttributeId] [int] NOT NULL,
[EntryAttributeShortName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryAttributeDescription] [nchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntryAttributes_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntryAttributes_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cda].[EntryAttributes] ADD CONSTRAINT [PK_EntryAttributes] PRIMARY KEY CLUSTERED  ([EntryAttributeId]) ON [PRIMARY]
GO
