CREATE TABLE [cda].[EntryClasses]
(
[EntryClassId] [int] NOT NULL,
[EntryClassShortName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EntryClassDescription] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntryClasses_CreatedDate] DEFAULT (sysdatetime()),
[UpdatedDate] [datetime2] NOT NULL CONSTRAINT [DF_EntryClasses_UpdatedDate] DEFAULT (sysdatetime())
) ON [PRIMARY]
GO
ALTER TABLE [cda].[EntryClasses] ADD CONSTRAINT [PK_EntryClasses] PRIMARY KEY CLUSTERED  ([EntryClassId]) ON [PRIMARY]
GO
